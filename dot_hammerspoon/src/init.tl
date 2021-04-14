global __cfg_reloader = require('teal_config_reloader')
global __localCliPort = require('hs.ipc').__default

global p = require('hs.inspect')

-- function printglobals()
--   for k, _v in pairs(_G as {string: any}) do
--     print(k)
--   end
-- end
