
hs.loadSpoon("ReloadConfiguration")

uBar = require("uBar")
contexts = require("contexts")
firefox = require("firefox")

local ScreenState = {}

function ScreenState:new()
  local o = {
    screen = hs.screen.primaryScreen()
  }
  o.mode = o.screen:currentMode()

  local aR = o.mode.w / o.mode.h
  if aR >= 1.6 and aR < 1.8 then
    o.aspectRatio = "16:9"
  elseif aR >= 3.4 and aR < 3.6 then
    o.aspectRatio = "32:9"
  end

  o.scale = o.mode.scale

  self.__index = self
  return setmetatable(o, self)
end

lastScreenState = ScreenState:new()

handleAspectRatio = {
  ["16:9"] = (function(screen)
    print("Swapped to 16:9 screen")
    screen:desktopImageURL('file:///Users/donald/Pictures/wallpapers/16-9/rainbowswoop.png')

    uBar:setSize(uBar.sizes.large)
    uBar:setPosition(uBar.positions.centerFloat)
    uBar:setRimless(false)
    uBar:relaunch()

    contexts:setInactiveSidebarWidth(contexts.inactiveSidebarWidths.iconsAndTitleStart)
  end),
  ["32:9"] = (function(screen)
    print("Swapped to 32:9 screen")
    screen:desktopImageURL('file:///Users/donald/Pictures/wallpapers/32-9/rainbowswoop.png')

    uBar:setSize(uBar.sizes.auto)
    uBar:setPosition(uBar.positions.lowerLeft)
    uBar:setRimless(true)
    uBar:relaunch()

    contexts:setInactiveSidebarWidth(contexts.inactiveSidebarWidths.keepExpanded)
  end)
}

function handleNewScale(aspectRatio, scale)
  if aspectRatio == "16:9" and scale == 2.0 then
    firefox:setDefaultZoom(0.9)
  elseif aspectRatio == "32:9" and scale == 1.0 then
    firefox:setDefaultZoom(1.0)
  elseif aspectRatio == "32:9" and scale == 2.0 then
    firefox:setDefaultZoom(0.8)
  end
end

screenWatcher = hs.screen.watcher.new(function()
  local old = lastScreenState
  local new = ScreenState:new()

  if old.aspectRatio ~= new.aspectRatio then
    handleAspectRatio[new.aspectRatio](new.screen)
  end

  if old.aspectRatio ~= new.aspectRatio or old.scale ~= new.scale then
    handleNewScale(new.aspectRatio, new.scale)
  end

  lastScreenState = new
end)

screenWatcher:start()
spoon.ReloadConfiguration:start()

hs.application = require('hs.application')
hs.axuielement = require('hs.axuielement')
hs.eventtap    = require('hs.eventtap')
hs.keycodes    = require('hs.keycodes')
hs.mouse       = require('hs.mouse')
hs.pasteboard  = require('hs.pasteboard')
hs.timer       = require('hs.timer')
hs.window      = require('hs.window')

hs.application.enableSpotlightForNameSearches(true)

i = hs.inspect

hs.console.setConsole("Config reloaded\n")
