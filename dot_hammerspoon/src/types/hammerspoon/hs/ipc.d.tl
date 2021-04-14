local type ansiColorEscape = string

local record colors
  initial: ansiColorEscape
  input:   ansiColorEscape
  output:  ansiColorEscape
  error:   ansiColorEscape
end

local record ipc
  -- NOTE: omitted deprecated aliases of overloaded cliColors()

  cliColors: function():       colors --get current colors
  cliColors: function(nil):    colors --reset to defaults
  cliColors: function(colors): colors --set colors

  cliInstall: function(--[[ path = "/usr/local", silent = false ]]): boolean
  cliInstall: function(     path: string    --[[ silent = false ]]): boolean
  cliInstall: function(     path: string,        silent: boolean):   boolean

  cliSaveHistory: function():        boolean -- getter
  cliSaveHistory: function(boolean): boolean -- setter

  cliSaveHistorySize: function():        integer -- getter
  cliSaveHistorySize: function(nil):     integer -- reset to default
  cliSaveHistorySize: function(integer): integer -- setter

  cliStatus: function(--[[ path = "/usr/local", silent = false ]]): boolean
  cliStatus: function(     path: string    --[[ silent = false ]]): boolean
  cliStatus: function(     path: string,        silent: boolean):   boolean

  cliUninstall: function(--[[ path = "/usr/local", silent = false ]]): boolean
  cliUninstall: function(     path: string    --[[ silent = false ]]): boolean
  cliUninstall: function(     path: string,        silent: boolean):   boolean

  record ipcObject
    userdata

    delete: function(self: ipcObject)
    isRemote: function(self: ipcObject): boolean
    isValid: function(self: ipcObject): boolean
    name: function(self: ipcObject): string

    sendMessage: function(self: ipcObject, data: any, msgId: integer,     waitTimeout: number,    oneWay: boolean):   boolean, string
    sendMessage: function(self: ipcObject, data: any, msgId: integer,     waitTimeout: number --[[oneWay = false ]]): boolean, string
    sendMessage: function(self: ipcObject, data: any, msgId: integer --[[ waitTimeout = 2.0,      oneWay = false ]]): boolean, string

    metamethod __eq: function(self: ipcObject, any): boolean
    __tostring: function(self: ipcObject): string
  end

  type msgHandler = function(any, msgId: integer, msg: string): string

  localPort: function(name: string, msgHandler): ipcObject
  remotePort: function(name: string): ipcObject

  __defaultHandler: msgHandler -- sets up communication with local cli
  __default: ipcObject -- localPort("Hammerspoon", __defaultHandler)
end

return ipc
