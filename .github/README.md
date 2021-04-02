# `donaldguy`'s Dotfiles

Its 2021 and being funemployed has re-awakened some of my nerd heart and I've been moving back towards playing around with more silly power tooling.

## Shell

Have played with [kitty](https://sw.kovidgoyal.net/kitty/) but for now still an iTerm2 user

### `.zshrc`

I'm rocking a pretty vanilla macOS zsh with [Pure](https://github.com/sindresorhus/pure)-style [Powerlevel10k](https://github.com/romkatv/powerlevel10k) in which notably `typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=same-dir` (something I don't believe the config wizard offers still). I am waffling about trying going back to [starship](https://starship.rs/) now that I don't use [`asdf`](https://asdf-vm.com/#/) so much. `p10k` is very fast, but its so closely tied to zsh with all its caching – I might wanna branch out.

I've taken on pretty much _all_ of @zaiste's recommendations from his popular "Rewritten in Rust" [blog post](https://zaiste.net/posts/shell-commands-rust/) and let:

- [`bat`](https://github.com/sharkdp/bat) take over for `cat`
- [`batman`](https://github.com/eth-p/bat-extras#batman) take over for `man` (but leaving `\man` at reach)
- [`lsd`](https://github.com/Peltoche/lsd) (not `exa` ) take over for `ls` – with directories first , `-F` (indicators), and `date: relative` ; I also committed heresy and dropped user and group from default `ls -l`

### `.gitconfig`

I am a supporter of @tesseralis's school of [thought](https://twitter.com/tesseralis/status/1271197776886370305) on naming initial/trunk branches as `canon` 

I am a firm believer that  `pull.rebase`  should always be `true` (or `merges` I guess) and rebase.autoStash ` should always be `true`

I carry one alias in my normal `.zshrc ` and it's 

```bash
groot() {
  cd "$(git rev-parse --show-toplevel)"
}
```

Going off bat-extras, I picked up [`delta`](https://github.com/dandavison/delta) as a differ and its pretty neat. 

When I want to do messy `add -p`'s or `restore -p`'s (or just like a big old `diff --cached` before pushing) I use [Fork.app](https://git-fork.com/). It's also a good merge tool.



## :rainbow: :hammer: :spoon: :rainbow:

I have started playing with pushing out `Dock.app` , and  `Finder.app` for [uBar](https://brawersoftware.com/products/ubar) , [Path Finder](https://cocoatech.com/#/) and [Contexts](https://contexts.co/)

Much of this is leveraged to the end of having Maximum Rainbows unperturbed by pesky defaults like a trashcan!.

[Hammerspoon](https://www.hammerspoon.org/) is leveraged currently to the task of maintaining good rainbows and appropriate allocation of work space when my primary machine moves between behaving like a laptop and being connected to my absurd (and honestly kinda low res in practice, cause non HiDPI is painful actually) 49" widescreen [monitor](https://www.lg.com/us/monitors/lg-49WL95C-W-ultrawide-monitor)

### Laptop 💻 Mode 

When the internal display is detected (or in principle another 16:9 shaped monitor) things are arranged like this:

<img width="720" alt="How things are laid out on 16:9 internal monitor" src="https://user-images.githubusercontent.com/43136/113379415-67e5b300-9347-11eb-82c1-e03fcfbe7066.png">

### Workstation 🖥️ Mode

When plugged into the B.A.M. things get kicked around by Lua to look like this instead:
<img width="752" alt="How things are laid out on 32:9 external monitor" src="https://user-images.githubusercontent.com/43136/113379722-42a57480-9348-11eb-9b10-da4e53b00737.png">

I also wrote some keyboard.io firmware that tries to match the wallpaper with the LEDs. You can also find [that](https://github.com/donaldguy/dotfiles/blob/canon/Code/Kaleidoscope/plugins/Kaleidoscope-LEDEffect-RainbowSwoop/src/kaleidoscope/plugin/LEDEffect-RainbowSwoop.cpp) in this repo
:

<img width="752" alt="Rainbow swoop keyboard.io Model 01 LEDs" src="https://user-images.githubusercontent.com/43136/113380098-4be31100-9349-11eb-86a9-8e8b67885505.jpg">
