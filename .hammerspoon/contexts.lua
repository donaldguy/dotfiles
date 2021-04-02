--[[

  Control the https://contexts.co/ alternative Cmd+Tab window switcher

  Issues mouse clicks to adjust the sidebar "when cursor not over" setting.

  This is preferable to doing a plist and restart update (as we did for uBar) not only cause its faster
  but because running /Application/Contexts.app opens the preferences pane (even if we kill the program first
  – I'm not sure why/how this is avoided when its started on boot)

]]--

local contexts = {
  inactiveSidebarWidths = { hide = 0, icons = 1, iconsAndTitleStart = 2, keepExpanded = 3 }
}

function contexts:setInactiveSidebarWidth(width)
  local sb = hs.appfinder.appFromName('Contexts'):findWindow('Sidebar')
  local sbw = hs.axuielement.windowElement(sb)
  local sbwMenuButtonPosition = sbw[2].AXPosition

  local mouseRestorePosition  = hs.mouse.absolutePosition()

  -- click on initial position of button, which should bring it on screen
  hs.eventtap.leftClick(sbwMenuButtonPosition, 50000)

  -- focus the window and click the menu button on screen
  sb:focus()
  hs.eventtap.leftClick(sbw[2].AXPosition, 100)

  hs.timer.waitWhile(
    function() return #sbw == 2 end,
    function()
      local startFrom
      if #sbw[3] == 5 then -- as when is currently hidden and the menu lacks the hiding instructions
        startFrom = 2
      elseif #sbw[3] == 12 then
        startFrom = 6
      end

      -- click our choice on the menu
      hs.eventtap.leftClick(sbw[3][startFrom + width].AXPosition, 100)


      -- restore mouse postion
      hs.mouse.absolutePosition(mouseRestorePosition)
    end, 0.0001)
end

return contexts
