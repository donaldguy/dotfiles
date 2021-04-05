-- preload needed modules:
hs.network = require('hs.network')
hs.network.configuration = require('hs.network.configuration')
hs.wifi = require('hs.wifi')
networkConf = hs.network.configuration.open()

--
hs.settings = require('hs.settings')
hs.timer = require('hs.timer')
lilith = {
  _presenceSetting = "LilithPresent",
  ethernetIPv6 = "fe80::1c8b:ac07:57b1:8cf6"
}

function lilith:present()
  return hs.settings.get(self._presenceSetting)
end

function interfaceNameFromIPv6Address(targetAddr)
  for _i, iface in ipairs(hs.network.interfaces()) do
    adresses =  ((hs.network.interfaceDetails(iface).IPv6 or {}).Addresses or {})
    for _j, addr in ipairs(adresses) do
      if addr == targetAddr then
        return iface
      end
    end
  end

  return nil
end


lilith.pingTimer = (function(resultFn)

  local ts3EthernetInterface = interfaceNameFromIPv6Address("fe80::c13:9999:ab26:fccc")

  local makePinger = function()
    lilith.pinger = hs.task.new("/usr/local/bin/timeout", resultFn, function(...) return true end, {
      "5s", --the timeout
      "/sbin/ping6",
      "-I", ts3EthernetInterface,
      "-c", "1",
      "-n",
      lilith.ethernetIPv6
    }):start()
  end
  makePinger()

  return hs.timer.waitWhile(
    function() return lilith.pinger:isRunning() end,
    function(t)
      makePinger()
      t:start()
    end)
end)(function(exitCode, ...)
  hs.settings.set(lilith._presenceSetting, exitCode == 0)
end)

hs.settings.watchKey("LilithReactor", lilith._presenceSetting, function()
  local lilithPresent = lilith:present()

  lilith.pinger:pause()

  if lilithPresent then
    print("Lilith appeared! ^_^")

    -- The M1 Air (which is sharing internet) has a better wifi radio anyway, but mostly we just wanna
    -- make sure that we are more easily callable over ethernet
    hs.wifi.setPower(false)
    networkConf:setLocation("Lilith Present")
  else
    print("Lilith dipped! :-(")

    networkConf:setLocation("Lilith Absent")
    hs.wifi.setPower(true)

    -- assert(hs.network.primaryInterfaces()[hs.wifi.interfaces()[1]], "Wifi isn't primary!")
    -- todo: go to TV mode?
  end

  hs.timer.waitUntil(
    function() return hs.network.primaryInterfaces() end,
    function()
       lilith.pinger:resume()
    end
  )
end)
