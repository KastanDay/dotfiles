## Current `.zshrc` file requres this setup:
- Emulator: Hyper Terminal www.hyper.is
	
	- Config is in default location (rn at …../kasta/)
	- `~/.hyper.js`
    	- Hyper keyboard shortcuts here: https://hyper.is/#keymaps and https://github.com/zeit/hyper/blob/master/app/keymaps/linux.json
- Use ZSH and Oh-My-Zsh
    - Install zsh: `sudo apt-get install zsh`
	- Install Oh-My-Zsh: `sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"`
- Use PowerLevel9k  - https://github.com/bhilburn/powerlevel9k/wiki/Install-Instructions#step-2-install-a-powerline-font
	- Only install step: `$ git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k`
- Use NerdFonts - http://nerdfonts.com/ 
	- All fonts downloaded from here have the full nerdfont icon packs.
	- Must add font to `~/.hyper.js` config file. Make sure use name listed on install file.
	- Use "Windows compatible" fonts
	- Source Code Pro font:
		- On Windows & WSL it's called: "SauceCodePro NF"
		- On Ubuntu it's called: "SauceCodePro Nerd Font"
- Use [ZHS-Autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
	- Make sure to do the `Oh My Zsh` setup (not defautl)!
	- Only install step: `git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions`
	- `ctrl + space` to accept and execute suggestion
	- `ctrl + j` to accept suggestion, and edit.
- Terminal syntax highlighting
    - Syntax highlighting from https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
    - Only install step: `git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting`
- [color-ls](https://github.com/athityakumar/colorls#installation) makes your ls call beautiful
	- in `.zshrc` add: `alias ls=colorls`
	- Must install Ruby, I followed [this guide](https://www.digitalocean.com/community/tutorials/how-to-install-ruby-and-set-up-a-local-programming-environment-on-ubuntu-16-04)
    - After ruby installed: `gem install colorls`
    - Ensure in .zshrc: `[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"`
- [fasd](https://github.com/clvv/fasd) fuzy jump and open
    - In .zshrc for Oh-My-Zsh plugins: plugins=(fasd)
    - Then install: 
``` 
$ sudo add-apt-repository ppa:aacebedo/fasd
$ sudo apt-get update
$ sudo apt-get install fasd
```

## Ubuntu Beautification

* indicator-multiload (for taskbar system resources stats)
	* Add the following to a **single line** in the `preferences` -> `indicator items`

	`CPU $(percent(cpu.inuse))     Net $(speed(net.down)) down    $(speed(net.up)) up     Mem $(size(mem.user)) / $(size(mem.total))  =  $(percent(size(mem.user)/size(mem.total))) usage`
* clipboard manager (more info here if repo isn't found https://itsfoss.com/best-indicator-applets-ubunt): 
	`sudo apt install copyq`

* Unity Tweak Tool - Ubuntu Store

* Theme: Arc-dark
    `sudo add-apt-repository ppa:noobslab/themes`
    `sudo apt-get update && sudo apt-get install arc-theme`
* Arc Icon Pack 
    `sudo add-apt-repository ppa:noobslab/icons`
    `sudo apt-get update && sudo apt-get install arc-icons`
* Icons: Papirus-dark - My favorite
    `sudo add-apt-repository ppa:papirus/papirus`
    `sudo apt update && sudo apt install papirus-icon-theme`
* Disable caps lock, (pushing both SHIFT keys at once will toggle it)
    * `sudo apt-get install dconf-tools`
    * `setxkbmap -option "caps:none"` && `setxkbmap -option "shift:both_capslock"`

http://blog.manugarri.com/note-to-self-disable-caps-lock-in-ubuntu-16-04/

## Awesome _____
- https://terminalsare.sexy/

## Useful terminal applications
- Beyond `grep`: `ag`
	- `sudo apt-get install silversearcher-ag`
	- Usage: `ag foo` searches inside files for 'foo'. `ag -g file` serches for filename 'file'.
- [In-terminal markdown viewer](https://github.com/axiros/terminal_markdown_viewer) `mdv`
    - This is the best of several I considered: 
- [bro man pages](http://bropages.org/)
	- tldr is another option
## Visual Studeio Code config

- `settings.json` - This is the only settings file for VS Code
	 - It is stored in `~/.config/Code/User/`
	 - Easymotion bindings: s + char_to_search
	 - Todo-tree extension, makes todos easy to track
	 - [Code snippits generator -- SO LIT](https://snippet-generator.app/?description=Try+Catch+Sentry+Log&tabtrigger=TrySentryCatch&snippet=try+%7B%0A%7D+catch+%28error%29+%7B%0A++++Sentry.captureException%28error%29%0A%7D&mode=vscode)
	    - `ctr+shift+p` 'configure user snippits' —> 'create global snippit'

**Extensions** 
- Vim, Relative Line Numbers (by extr0py), C/C++

- Remember to keep using Vim's EasyMotion commands (remapped to s<char>) to do movements! 


CAUTION:

Be careful with the `.bashrc` and `.zshrc` files - **THEY MAY CONTAIN WEIRD THINGS AT THE BOTTOM.** The branches are an effort to isolate weirdness.

Great tutorial on setting up WSL (to be good - with X server and good fonts)
https://joshpeng.github.io/post/wsl/#1-optional-install-cmder


# New Ideas

This is a AI python co-piolot for coding. Looks really cool, should try it.

https://kite.com/

# Keylogging 

* [Logkeys is the best one to use for Linux](https://github.com/kernc/logkeys/blob/master/docs/Documentation.md)
  * Need to clone repo and install it. 
  * Put this in /etc/rc.local the startup run file: `logkeys -s -o /home/memento/env/keylogging/keylog.log -m /home/memento/env/keylogging/logkeys/keymaps/en_US_ubuntu_1204.map`
  * Need to set keyboard to special one (default is busted) "en_US_ubuntu1204.map`
* ConnectorDB is works on Windows, but DOESN'T LOG SPECIFIC KEYS, only keypress occurances. Major flaw, not okay. 


