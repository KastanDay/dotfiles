## Current `.zshrc` file requres this setup:
- Emulator: Hyper Terminal www.hyper.is
	
	- Config is in default location (rn at …../kasta/)
	- `~/.hyper.js`
    	- Hyper keyboard shortcuts here: https://hyper.is/#keymaps and https://github.com/zeit/hyper/blob/master/app/keymaps/linux.json
- Use ZSH and Oh-My-Zsh
- Use PowerLevel9k  - https://github.com/bhilburn/powerlevel9k/wiki/Install-Instructions#step-2-install-a-powerline-font
- Use NerdFonts - http://nerdfonts.com/ 
	- All fonts downloaded from here have the full nerdfont icon packs.
	- Must add font to `~/.hyper.js` config file. Make sure use name listed on install file.
	- Use "Windows compatible" fonts
	- Source Code Pro font:
		- On Windows & WSL it's called: "SauceCodePro NF"
		- On Ubuntu it's called: "SauceCodePro Nerd Font"
<<<<<<< HEAD
- Use [ZHS-Autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
	- Make sure to do the `Oh My Zsh` setup (not defautl)!
	- `ctrl + space` to accept and execute suggestion
	- `ctrl + j` to accept suggestion, and edit.
=======
- Terminal syntax highlighting
    - Syntax highlighting from https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
>>>>>>> 8a40e13a2161abc93e70499aa1c5e1d4c4b4e099

## Visual Studeio Code config

- `settings.json` - This is the only settings file for VS Code
	 - It is stored in `~/.config/Code/User/`

**Extensions** 
- Vim, Relative Line Numbers (by extr0py), C/C++

- Remember to keep using Vim's EasyMotion commands (remapped to s<char>) to do movements! 


CAUTION:

Be careful with the `.bashrc` and `.zshrc` files - **THEY MAY CONTAIN WEIRD THINGS AT THE BOTTOM.** The branches are an effort to isolate weirdness.

Great tutorial on setting up WSL (to be good - with X server and good fonts)
https://joshpeng.github.io/post/wsl/#1-optional-install-cmder
