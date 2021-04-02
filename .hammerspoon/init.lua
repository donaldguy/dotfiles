
hs.loadSpoon("ReloadConfiguration")

uBar = require("uBar")
contexts = require("contexts")

screenWatcher = hs.screen.watcher.new(function()
  s = hs.screen.primaryScreen()
  aspectRatio = (function(mode) return  mode.w / mode.h end)(s:currentMode())

  if aspectRatio >= 1.6 and aspectRatio < 1.8  then  -- 16:9 ish
    s:desktopImageURL('file:///Users/donald/Pictures/wallpapers/16-9/rainbowswoop.png')

    uBar:setSize(uBar.sizes.medium)
    uBar:setPosition(uBar.positions.centerFloat)
    uBar:setRimless(false)
    uBar:relaunch()

    contexts:setInactiveSidebarWidth(contexts.inactiveSidebarWidths.iconsAndTitleStart)
  elseif aspectRatio >= 3.4 and aspectRatio < 3.6 then -- 32:9 ish
    s:desktopImageURL('file:///Users/donald/Pictures/wallpapers/32-9/rainbowswoop.png')

    uBar:setSize(uBar.sizes.auto)
    uBar:setPosition(uBar.positions.lowerLeft)
    uBar:setRimless(true)
    uBar:relaunch()

    contexts:setInactiveSidebarWidth(contexts.inactiveSidebarWidths.keepExpanded)
  end
end)

screenWatcher:start()
spoon.ReloadConfiguration:start()

i = hs.inspect

--hs.console.clearConsole()
