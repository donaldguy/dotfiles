-- preload needed modules:
hs.network = require('hs.network')
hs.network.configuration = require('hs.network.configuration')
hs.wifi = require('hs.wifi')
networkConf = hs.network.configuration.open()

--
hs.settings = require('hs.settings')
hs.timer = require('hs.timer')
Lilith = {
  _presenceSetting = "LilithPresent",
  ethernetIPv4 = "192.168.2.1"
}

function Lilith:present()
  return hs.settings.get(self._presenceSetting)
end

Lilith.pingTimer = (function(callback)
  Lilith.pinger = hs.network.ping(Lilith.ethernetIPv4):setCallback(callback)

  return hs.timer.waitWhile(
    function() return Lilith.pinger:isRunning() end,
    function(t)
      Lilith.pinger = hs.network.ping(Lilith.ethernetIPv4):setCallback(callback)
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
    hs.settings.set(Lilith._presenceSetting, false)
  else
    hs.settings.set(Lilith._presenceSetting, true)
  end
end)

hs.settings.watchKey("LilithReactor", Lilith._presenceSetting, function()
  local LilithPresent = Lilith:present()

  Lilith.pinger:pause()
  local pings_already_sent = Lilith.pinger:sent()
  local total_pings_in_check_when_paused = Lilith.pinger:count()
  if pings_already_sent >= 0.5 * total_pings_in_check_when_paused then
    Lilith.pinger:count(math.min(total_pings_in_check_when_paused * 3, 100)) -- paranoid: don't want bad series of timings growing unbound
  end

  if LilithPresent then
    print("Lilith appeared! ^_^")

    -- The M1 Air (which is sharing internet) has a better wifi radio anyway, but mostly we just wanna
    -- make sure that we are more easily callable over ethernet
    hs.wifi.setPower(false)
    networkConf:setLocation("Lilith Present")
  else
    print("Lilith dipped! :-(")

    networkConf:setLocation("Lilith Absent")
    -- todo: go to TV mode?
  end

  hs.timer.waitUntil(
    function() return hs.network.primaryInterfaces() end,
    function()
       Lilith.pinger:resume()
    end
  )
end)
