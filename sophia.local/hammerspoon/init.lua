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
  bridgeIPv6 = "fd9b:e191:f52e:8e49:ce3:f4c9:adfd:1e0d"
}

function lilith:present()
  return hs.settings.get(self._presenceSetting)
end

lilith.pingTimer = (function(callback)
  lilith.pinger = hs.network.ping(lilith.bridgeIPv6):setCallback(callback)

  return hs.timer.waitWhile(
    function() return lilith.pinger:isRunning() end,
    function(t)
      lilith.pinger = hs.network.ping(lilith.bridgeIPv6):setCallback(callback)
      t:start()
    end)

end)(function(o, msg, ...)
  if msg == "didStart" or msg == "receivedPacket" then
    return
  elseif msg == "sendPacketFailed" or msg == "didFail" then
    o:cancel()
    return
  end
  assert(msg == "didFinish")

  local mia = 0
  for i, packet in ipairs(o:packets()) do
    if not packet.recv then
      mia = mia + 1
    end
  end

  if mia/o:sent() >= 0.5 then
    hs.settings.set(lilith._presenceSetting, false)
  else
    hs.settings.set(lilith._presenceSetting, true)
  end
end)

hs.settings.watchKey("LilithReactor", lilith._presenceSetting, function()
  local lilithPresent = lilith:present()

  lilith.pinger:pause()
  print("pinger paused")
  local pings_already_sent = lilith.pinger:sent()
  local total_pings_in_check_when_paused = lilith.pinger:count()
  if pings_already_sent >= 0.5 * total_pings_in_check_when_paused then
    lilith.pinger:count(math.min(total_pings_in_check_when_paused * 3, 100)) -- paranoid: don't want bad series of timings growing unbound
  end

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
      print("pinger resuming")
       lilith.pinger:resume()
    end
  )
end)
