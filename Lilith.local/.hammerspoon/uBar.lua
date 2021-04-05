local defaults = require('defaults')

local uBar = {
  positions = { lowerLeft = 1, centerFloat = 2 },
  sizes = {auto = 0, medium = 2, large = 3},
  defaultsDomain = "ca.brawer.uBar-setapp.plist"
}

function uBar:relaunch()
  -- TODO: use an application.watcher to make sure the relaunch happens
  local app = hs.application.get("uBar")
  if app then
    local appPath = app:path()
    app:kill()
    hs.timer.waitWhile(function() return hs.application.get("uBar") end, function()
      hs.application.launchOrFocus(appPath)
    end, 0.0001)
  end
end

function uBar:setPosition(position)
  if position == self.positions.lowerLeft then
    defaults:write(self.defaultsDomain, "position", 0)
    defaults:write(self.defaultsDomain, "pinLeft", true)
    defaults:write(self.defaultsDomain, "pinBottom", true)
    defaults:write(self.defaultsDomain, "pinRight", false)
  elseif position == self.positions.centerFloat then
    defaults:write(self.defaultsDomain, "position", 0)
    defaults:write(self.defaultsDomain, "pinLeft", false)
    defaults:write(self.defaultsDomain, "pinBottom", false)
    defaults:write(self.defaultsDomain, "pinRight", false)
  end
end

function uBar:setSize(size)
  defaults:write(self.defaultsDomain, "size", size)
end

function uBar:setRimless(bRimless)
  defaults:write(self.defaultsDomain, "rimless", bRimless)
end

return uBar
