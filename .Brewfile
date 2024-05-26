#0 _meta:
%w[bundle services].each { |hbt| tap "homebrew/#{hbt}"}
brew 'mas' # Mac App Store command-line interface
# add  brew_from_tap(), setapp()
require_relative '.brew_bundle_additions.rb'

#===================================================
# OS / Environment setup
#===================================================

# Hardware management:
## display
cask 'betterdisplay' # for adaptive resolution & quick access
cask 'flux'          # for eyestrain reduction

## mouse:
cask 'scroll-reverser'

## iDevices:
cask 'imazing'

# OS Feature Augmentation:
## menu bar
### _meta
cask   'bartender'               # for filtering / layout management
mas    'Spaced', id: 1666327168  # for sort of visual seperation I prefer
### left to right on my ultrawide:
cask   'istat-menus'  # for active resource monitoring widgets
                      # cpu, memory, network, disk
#below 'Fantastical'  # shows day of week and day of month
mas    'Day Progress', id: 6450280202 # clock replacement
setapp 'Moment'                       # for next key date countdown / year countup

setapp 'Forecast Bar'           # for weather info (without iStat Menu's subscription)
mas    'Pandan', id: 1569600264 # for count-up of recent computer use
setapp 'Time Out'               # for count-down †o "take a break no really"
# then theres a gap, then iStat battery widget (for bluetooth accessories), then various app icons

## finder / etc. improvements
brew 'iconsur'                   # for custom app icon injection
mas  'Command X', id: 6448461551 # support cut and paste for files & dirs
mas  'Shareful', id: 1522267256  # various share widgets
### Quick Look plugins
cask 'syntax-highlight',
args: { no_quarantine: true }  # syntax highlighting for source files
cask 'suspicious-package'      # .pkg installers
cask 'qlmarkdown'              # rendered markdown files


## global hotkey responders:
cask   'contexts'    # for improved ⌘-Tab, ⌘-` experience + sidebar

#cask 'alfred'     # for better-than-Spotlight launchbar experience (A)
cask 'raycast'     # for better-than-Spotlight launchbar experience (B)

setapp 'Paste'         # clipboard history syncing with iOS devices
setapp 'Rocket Typist' # auto-replament / text expansion + snippet management

# Nerdy window management / decoration:
brew_from_tap 'yabai',   'koekeishiya/formulae'
brew_from_tap 'borders', 'FelixKratz/formulae' # aka "JankyBorders"

## and related automation
cask 'hammerspoon'

#===================================================
# Interactive Applications
#===================================================
# _Essential utilities:
cask   '1password'
setapp 'CleanShot X' #for vastly better screenshot experiences

# Browsers:
mas "Velja", id: 1607635845
cask 'arc'
cask 'firefox'
# Safari Extensions:
  mas '1Password for Safari', id: 1569813296
  mas 'Noir', id: 1592917505 # for "Dark mode" ~injection
  #v  'Ominivore' # see "Social"
  mas 'Save to Raindrop.io', id: 1549370672

#---------------------------------------------------
# CLI (Dev) Tools:
#---------------------------------------------------
# _terminal(s)
cask 'iterm2'
mas  'Prompt', id: 1594420480
# _shells & shell-extensions
brew 'atuin' # for cross-device shell history syncing and serch

# all/text files:
## search
brew 'ripgrep'
brew 'fd'
brew 'fzf'

## stream-filter
brew 'sd'

## viewing
brew 'bat'

# data formats & network protocols
## http(s)
brew 'wget'
brew 'xh'

## json
brew 'jq'
brew 'jless'

# programming languages & source code
## _toolchain version management
brew 'mise'

## build tools
brew 'autoconf'
brew 'pkg-config'

## git helpers
brew 'gh'

#---------------------------------------------------
# Dev tools (GUI):
#---------------------------------------------------
#  specific
mas  'Developer',  id: 640199958
cask 'sf-symbols'
mas  'TestFlight', id: 899247664
mas  'Xcode',      id: 497799835

# documentation
setapp 'Dash'

# editors
cask 'visual-studio-code'
  vscode 'oderwat.indent-rainbow'
  vscode 'vscodevim.vim'

  %w[python debugpy vscode-pylance].each { |m| vscode "ms-python.#{m}"}
  vscode 'tamasfe.even-better-toml'
cask 'zed'

# file management
cask 'transmit'

# gui evaluation
setapp 'Sip'        # for color sampling and pallete composition
setapp 'PixelSnap'  # for on-screen measurement

#---------------------------------------------------
# General Audiences
#---------------------------------------------------
# Productivity:
## calendaring
mas 'Fantastical', id: 975937182 # best calendar
mas 'Parcel', id: 639968404      # package tracking

## planning
setapp 'GoodTask' # enhanced Reminders task workflows
setapp 'MindNode' # "mind map" diagraming
setapp 'NotePlan' # bullet journaling etc.

## Time-management
setapp 'Timing'   # active application/file monitoring
setapp 'Time Out' # agressive break timer/reminder/enforcer

# Media
cask 'pocket-casts'

# Reading:
mas 'Omnivore', id: 1564031042

# Social:
cask 'signal'
mas 'Ivory', id: 6444602274

# Utilities:
# app management
setapp 'CleanMyMac X'
cask   'latest'

#===================================================
# Assets & Support
#===================================================
# Fonts:
cask 'font-lilex-nerd-font'

# Libraries:
## installed explicitly to serve mise's ruby(s)
brew 'libyaml'
brew 'openssl@3'
