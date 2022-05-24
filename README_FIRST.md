## Manual ZSH settings

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)", Installing OhMyZsh]

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k, Installing Powerlevel 10k]
```

Nice to remember:
p10k configure -- if you want want something new

## Karabiner

You need to open this link in safari, accept all permissions including kernel extension

1. Install Karabiner

```
OPEN THIS LINK IN SAFARI!!!!

karabiner://karabiner/assets/complex_modifications/import?url=https://raw.githubusercontent.com/Vonng/Capslock/master/mac_v3/capslock.json"]
```

2. Make room for the config

```
# to make room for the symblink
mv ~/.config/karabiner/karabiner.json ~/.config/karabiner/karabiner.json_OLD
```

## Iterm2

Go to profiles -> more actions (bottom left) -> import json.

## Typintaor

Just drag and drop those configs. You can also highlight them in finder and do cmd + O.

## Better Touch tool (BTT)

Import via in "Presets" in top right, not settings. All of mine are for TRACKPAD (top dropdown menu).
