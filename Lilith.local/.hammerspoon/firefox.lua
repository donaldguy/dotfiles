
local firefox = {
  appName = 'Firefox Developer Edition',

  keystrokeDelay = 200000,
  zoomAdjustSnippetF = 'Cc["@mozilla.org/content-pref/service;1"].getService(Ci.nsIContentPrefService2).setGlobal(window.browsingContext.topChromeWindow.FullZoom.name, %.1f, Cu.createLoadContext())'
}

-- ----------------------------------------------------------------------------

-- This console is only interactive if `devtools.chrome.enabled` is set to true
-- in about:config / prefs.js
local BrowserConsole = {}

function BrowserConsole:new()
  local app = hs.application.get(firefox.appName)
  local bc = {}

  app:activate()

  -- we need an activate browser window to get a console;
  -- if e.g. all windows are minimzed, we need a new one
  if not app:focusedWindow() then
    assert(app:selectMenuItem("New Window"), "Couldn't spawn Firefox window to summon console")

    local i = 0
    repeat
      app:activate()
      bc.spawnedBrowser = app:focusedWindow()

      hs.timer.usleep(firefox.keystrokeDelay)
      i = i + 1
    until bc.spawnedBrowser or i > 5

    assert(bc.spawnedBrowser)
  end

  hs.eventtap.event.newKeyEvent({"cmd", "shift"}, "j",  true):post(app)
  hs.timer.usleep(firefox.keystrokeDelay)
  hs.eventtap.event.newKeyEvent({"cmd", "shift"}, "j", false):post(app)

  bc.window = app:focusedWindow()
  assert(bc.window:title() == "Browser Console")

  self.__index = self
  return setmetatable(bc, self)
end

function BrowserConsole:application()
  return self.window:application()
end

function BrowserConsole:focus()
  return self:application():activate(true) and self.window:focus()
end

function BrowserConsole:close()
  if self.spawnedBrowser then
    return self.window:close() and self.spawnedBrowser:close()
  else
    return self.window:close()
  end
end

-- ----------------------------------------------------------------------------

function firefox:setDefaultZoom(zoomLevel)
  local browserConsole = BrowserConsole:new()
  local clipboardToRestore = hs.pasteboard.getContents()

  hs.pasteboard.callbackWhenChanged(function(_changed)
    browserConsole:focus()

    hs.eventtap.event.newKeyEvent({"cmd"}, "v",  true):post(browserConsole:application())
    -- hs.timer.usleep(0)
    hs.eventtap.event.newKeyEvent({"cmd"}, "v",  false):post(browserConsole:application())

    hs.eventtap.event.newKeyEvent("return",  true):post(browserConsole:application())
    -- hs.timer.usleep(0)
    hs.eventtap.event.newKeyEvent("return", false):post(browserConsole:application())

    browserConsole:close()
    hs.pasteboard.setContents(clipboardToRestore)
  end)
  hs.pasteboard.setContents(string.format(self.zoomAdjustSnippetF, zoomLevel))
end

return firefox
