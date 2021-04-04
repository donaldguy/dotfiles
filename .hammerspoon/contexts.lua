--[[

  Control the https://contexts.co/ alternative Cmd+Tab window switcher

  Issues mouse clicks to adjust the sidebar "when cursor not over" setting.

  This is preferable to doing a plist and restart update (as we did for uBar) not only cause its faster
  but because running /Application/Contexts.app opens the preferences pane (even if we kill the program first
  – I'm not sure why/how this is avoided when its started on boot)

]]--

local contexts = {
  inactiveSidebarWidths = { hide = 0, icons = 1, iconsAndTitleStart = 2, keepExpanded = 3 },
  activeTimer = nil
}

function contexts:setInactiveSidebarWidth(width)
  local app = hs.application.get('Contexts')
  local sbw = hs.axuielement.windowElement(app:findWindow('Sidebar'))
  local sbwMenuButtonPosition = sbw[2].AXPosition

  -- -1. cancel an old timer if there is one (because e.g. our menu button click missed and the menu never drew)
  if self.activeTimer and self.activeTimer:running() then
    self.activeTimer:stop()
  end

  -- 0. save initial mouse position so we can restore it later
  local mouseRestorePosition  = hs.mouse.absolutePosition()

  -- 1. move toward initial position of button (offscreen), which should bring th menu button on screen
  hs.mouse.absolutePosition(sbwMenuButtonPosition)

  self.activeTimer = hs.timer.waitUntil(function()
  -- 2. wait for the sidebar animation if any (as it moves the button making it hard to click)
    local lastSbwMenuButtonPosition = sbwMenuButtonPosition
    sbwMenuButtonPosition = sbw[2].AXPosition

    -- for this to work as written we need the checkInterval to be long enough that it doesn't
    -- manage to run twice in the same animation frame. 50ms seems to work okay

    return sbwMenuButtonPosition.x == lastSbwMenuButtonPosition.x
  end,
  function()

  -- 3. focus the sidebar and click the menu button
    app:activate()
    hs.mouse.absolutePosition(sbwMenuButtonPosition)
    hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseDown, sbwMenuButtonPosition):post()
    hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseUp, sbwMenuButtonPosition):post()

  -- 4. wait for the menu to be drawn
    self.activeTimer = hs.timer.waitWhile(
      function() return #sbw == 2 end,
      function()
        local offset
        if #sbw[3] == 5 then -- when is currently set to hidden
          offset = 2 -- we only need to skip the header
        elseif #sbw[3] == 12 then -- otherwise
          offset = 6 -- we need to skip the temp-hiding stuff as well
        end

  -- 5. click our choice
        local menuItemPosition = sbw[3][offset + width].AXPosition
        hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseDown, menuItemPosition):post(app)
        hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseUp, menuItemPosition):post(app)

  -- 6. finally, restore mouse postion to where it was before we took over
        hs.mouse.absolutePosition(mouseRestorePosition)
    end, 0.0001)
  end, 0.05)
end

return contexts
