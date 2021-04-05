local defaults = { path = "/usr/bin/defaults"}

function defaults:write(domain, key, value)
  local args = {"write", domain, key}


  local value_t = type(value)
  if value_t == "string" then
    table.insert(args, "-string")
    table.insert(args, value)
  elseif value_t == "boolean" then
    table.insert(args, "-bool")
    table.insert(args, string.upper(tostring(value)))
  elseif value_t == "number" and math.type(value) == "integer" then
    table.insert(args, "-int")
    table.insert(args, tostring(value))
  else
    error("Unsupported value type in defaultsWrite" .. type(value))
  end

  callBackFn = function(exitCode, stdOut, stdErr)
    if exitCode ~= 0 then
      error(
        "defaults write "
        .. domain ..
        table.concat(args, " ")
      .. "failed with exitCode: " .. tostring(exitCode) .. "\n"
      .. "stdOut: " .. stdOut .. "\n"
      .. "stdErr: " .. stdErr)
    end
  end

  local defaultsTask = hs.task.new(self.path, callBackFn, function() return true end, args)
  return defaultsTask
    :start()
    :waitUntilExit()
end

return defaults
