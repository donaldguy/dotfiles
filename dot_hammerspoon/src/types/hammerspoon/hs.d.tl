global record hs
  -- these are constants
  configdir: string
  docstrings_json_file: string
  type ProcessInfo = record
    build: string
    buildTime: string
    bundleID: string
    bundlePath: string
    debugBuild: boolean
    executablePath: string
    processID: integer
    resourcePath: string
    version: string
  end
  processInfo: ProcessInfo

  --: users callback functions designed as mutable / overrideable
  accessibilityStateCallback: function()

  completionsForInputString: function(string): {string} -- on console '\t' input

  dockIconClickCallback: function()
  fileDroppedToDockIconCallback: function(path: string)
  textDroppedToDockIconCallback: function(text: string)

  showError: function(string)
  shutdownCallback: function()

  ------------  rest aren't supposed to be mutable ------------

  --: show (and sometimes hide) native UI modals
  focus: function()

  hsdocs: function(string)
  hsdocs: function() -- loads table of contents

  openAbout: function()

  openConsole: function()
  closeConsole: function()
  toggleConsole: function()

  openPreferences: function()
  closePreferences: function()

  --: toggle preferences

  --:: as presented in preferences modal
  autoLaunch: function():        boolean --getter
  autoLaunch: function(boolean): boolean --setter

  automaticallyCheckForUpdates: function():        boolean --getter
  automaticallyCheckForUpdates: function(boolean): boolean --setter

  dockIcon: function():              boolean --getter
  dockIcon: function(show: boolean): boolean --setter
  menuIcon: function():              boolean --getter
  menuIcon: function(show: boolean): boolean --setter

  consoleOnTop: function():        boolean --getter
  consoleOnTop: function(boolean): boolean --setter

  uploadCrashData: function():        boolean --getter
  uploadCrashData: function(boolean): boolean --setter; requires relaunch to take effect

  accessibilityState: function(shouldPromptUserNow: boolean): boolean

  --:: "hidden" preferences

  allowAppleScript: function():        boolean --getter
  allowAppleScript: function(boolean): boolean --setter

  openConsoleOnDockClick: function():        boolean --getter
  openConsoleOnDockClick: function(boolean): boolean --setter

  cameraState: function(     shouldPromptUserNow: boolean):   boolean
  cameraState: function(--[[ shouldPromptUserNow = false ]]): boolean
  microphoneState: function(     shouldPromptUserNow: boolean):   boolean
  microphoneState: function(--[[ shouldPromptUserNow = false ]]): boolean
  screenRecordingState: function(     shouldPromptUserNow: boolean):   boolean
  screenRecordingState: function(--[[ shouldPromptUserNow = false ]]): boolean

  preferencesDarkMode: function():        boolean --getter
  preferencesDarkMode: function(boolean): boolean --setter


  --: software updates

  canCheckForUpdates: function(): boolean

  type stringOrFalse = string | boolean

  updateAvaliable: function(): stringOrFalse, string

  checkForUpdates: function(     silent: boolean):   boolean
  checkForUpdates: function(--[[ silent = false ]]): boolean


  --: general helpers

  coroutineApplicationYield: function(     delay: number)
  coroutineApplicationYield: function(--[[ delay = hs.math.minFloat ]])

  getObjectMetatable: function(string): table

  enum exitType
    "exit"
    "signal"
  end
  type trueOrNil = boolean
  execute: function(command: string,     with_user_env: boolean):   string, trueOrNil, exitType, integer
  execute: function(command: string --[[ with_user_env = false ]]): string, trueOrNil, exitType, integer

  open: function(path: string)

  rawprint: function(string) -- this is lua's print(), which is overriden to print to console

  --: console helpers

  assert: function(boolean, string) -- handles assert() failures by printing to console, possibly via self.showError

  cleanUTF8forConsole: function(string): string
--completionsForInputString: above

  help:  function(string)

--also print: function(any) -- but as a global, vs hs.printf()
  printf: function(string, ... : any)

  --: config manipulation
  loadSpoon: function(name: string,     globalize: boolean):  any
  loadSpoon: function(name: string --[[ globalize = true ]]): any

  reload: function() -- reloads config

  -- fully quit and restart the .app
  relaunch: function()
end
