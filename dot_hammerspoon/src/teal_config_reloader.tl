local pathwatcher = require('hs.pathwatcher')

local contentChanged = function(f: pathwatcher.flags) : boolean
  return f.itemModified or f.itemRenamed or f.itemCreated
end

local config_watcher = pathwatcher.new(hs.configdir, function(paths: {string}, flags: {pathwatcher.flags})
  local luaModified = false
  local tealModified = false

  for i, path in ipairs(paths) do
    if string.match(path, '%.tl$', -3) then
      if contentChanged(flags[i]) then
        tealModified = true
        break
      end
      -- TODO?: delete foo.lua if foo.tl is deleted
    end
  end

  if tealModified then
    local output, success, _exitType, rc =  hs.execute("cd " .. hs.configdir .." && cyan build", true)
    if not success then
      error("cyan build on config failed with rc = " .. rc .. "and output:\n" .. output)
    else
      luaModified = true
    end
  else
    for i, path in ipairs(paths) do
      if string.match(path, '%.lua$', -4) and contentChanged(flags[i]) then
        luaModified = true
        break
      end
    end
  end

  if luaModified then
    hs.reload()
  end
end)

config_watcher:start()

return config_watcher
