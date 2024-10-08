# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# p10k configure -- to configure key elements
ZSH_THEME="powerlevel10k/powerlevel10k" 

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="tru# 

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(git pip vi-mode web-search sudo wd zsh-autosuggestions virtualenv fasd)

source $ZSH/oh-my-zsh.sh

# LS REPLACEMENTS
alias ls=lsd # lsd is better cuz icons
# alias ls='/home/zion/.exa/exa' # Exa
# alias ls=colorls

# User configuration
export DEFAULT_USER="kastan"


function mygrep { grep -rni $1; }
function kms { echo "It's going to be okay, today is only one day"}
alias wut=google
alias fg="find . | grep "
alias f/g="find / | grep "
alias c=code-insiders
alias code=code-insiders
alias o=xdg-open 
alias e=exit
alias size="ls -lh"
alias p=python3

alias file="nautilus" # open in file explorer. eg "file ."
alias files="nautilus" # open in file explorer. eg "file ."
alias cat=batcat # for ubuntu
alias cat=bat # for non-ubuntu
alias file="open" # for mac

# disable zsh warning cuz these functions are being called. 
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

#####
## Open github repos from CLI ##
# https://gist.github.com/igrigorik/6666860?permalink_comment_id=2693081#gistcomment-2693081
#####
ggh() {
  open "$(git config remote.origin.url | sed "s/git@\(.*\):\(.*\).git/https:\/\/\1\/\2/")/$1$2"
}

#####
## Auto install the mamba version of Conda (Mambaforge) ##
# Usage: simply run on cmdline: install_miniconda 
#####
install_miniconda () {
mkdir -p ~/utils/miniconda3
wget https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh -O ~/utils/miniconda3/miniconda.sh
bash ~/utils/miniconda3/miniconda.sh -b -u -p ~/utils/miniconda3
rm -rf ~/utils/miniconda3/miniconda.sh
~/utils/miniconda3/bin/mamba init zsh
source ~/.zshrc
}


# Open current branch -- must use single quotes!! http://mywiki.wooledge.org/Quotes 
alias ghb='gh tree/$(git symbolic-ref --quiet --short HEAD )'
# Open current directory/file in current branch
alias ghbf='gh tree/$(git symbolic-ref --quiet --short HEAD )/$(git rev-parse --show-prefix)'


########################## FZF WITH GIT ##########################
# USAGE
# CTRL-GCTRL-F for files
# CTRL-GCTRL-B for branches
# CTRL-GCTRL-T for tags
# CTRL-GCTRL-R for remotes
# CTRL-GCTRL-H for commit hashes

# alias ff="cd **"
# alias pre="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"

# GIT heart FZF

# USAGE
# option (alt) + C -- fuzzy cd (always from home dir)
# ctrl + T         -- fancy file preview
# ctrl + R         -- fancy command history search

# t                -- for tree view (with preview)
# z                -- for fzf with common dirs
# os               -- (better ag) interative in-file search (bad: doesn’t highlight the line!!)

# Usage
# ALT-C - cd into the selected directory
# Set FZF_ALT_C_COMMAND to override the default command
# Set FZF_ALT_C_OPTS to pass additional options
# -------------

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

fzf-down() {
  fzf --height 65% --min-height 20 --border --color 'fg:#bbccdd,fg+:#ddeeff,bg:#334455,preview-bg:#223344,border:#778899' --bind ctrl-/:toggle-preview "$@" 
}

_gf() {
  is_in_git_repo || return
  git -c color.status=always status --short |
  fzf-down -m --ansi --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1})' |
  cut -c4- | sed 's/.* -> //'
}

_gb() {
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
  fzf-down --ansi --multi --tac --preview-window right:50% \
    --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1)' |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##'
}

_gt() {
  is_in_git_repo || return
  git tag --sort -version:refname |
  fzf-down --multi --preview-window right:70% \
    --preview 'git show --color=always {}'
}

_gh() {
  is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
  fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always' |
  grep -o "[a-f0-9]\{7,\}"
}

_gr() {
  is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
  fzf-down --tac \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1}' |
  cut -d$'\t' -f1
}

_gs() {
  is_in_git_repo || return
  git stash list | fzf-down --reverse -d: --preview 'git show --color=always {1}' |
  cut -d: -f1
}

join-lines() {
  local item
  while read item; do
    echo -n "${(q)item} "
  done
}

() {
  local c
  for c in $@; do
    eval "fzf-g$c-widget() { local result=\$(_g$c | join-lines); zle reset-prompt; LBUFFER+=\$result }"
    eval "zle -N fzf-g$c-widget"
    eval "bindkey '^g^$c' fzf-g$c-widget"
  done
} f b t r h s

# This requires ripgrep-all (rga) installed: https://github.com/phiresky/ripgrep-all
# This implementation below makes use of "open" on macOS, which can be replaced by other commands if needed.
# allows to search in PDFs, E-Books, Office documents, zip, tar.gz, etc. (see https://github.com/phiresky/ripgrep-all)
# find-in-file - usage: fif <searchTerm> or fif "string with spaces" or fif "regex"
fif() {
    if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
    local file
    file="$(rga --max-count=1 --ignore-case --files-with-matches --no-messages "$*" | fzf-tmux +m --preview="rga --ignore-case --pretty --context 10 '"$*"' {}")" && echo "opening $file" && open "$file" || return 1;
}


# fasd & fzf change directory - jump using `fasd` if given argument, filter output of `fasd` using `fzf` else
unalias z
z() {
    [ $# -gt 0 ] && fasd_cd -d "$*" && return
    local dir
    dir="$(fasd -Rdl "$1" | fzf -1 -0 --no-sort +m)" && cd "${dir}" && echo "cd ${dir}" || return 1
}

# ctrl + T == fancy preview
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"
export FZF_CTRL_T_COMMAND='rg --files --hidden --smart-case --glob "!.git/*"'

# ctrl + R == full command on preview window. '?' to toggle preview window
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window up:3:border-horizontal:wrap --bind '?:toggle-preview'"

# option (alt) + C == cd command!! So good.
# https://github.com/kitagry/gtree
# export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200' --height 80%"
# go install https://github.com/kitagry/gtree (and creat gopath AND add to path)
export FZF_ALT_C_OPTS="--preview 'gtree --level 2 {} | head -200' --height 80%"
# export FZF_ALT_C_COMMAND='rg --hidden --smart-case --glob "!.git/*"' #  ~/code
export FZF_ALT_C_COMMAND='fd --type d . --search-path ~/code'  
# Could maybe improve formatting this way.....  --base-directory ~/code --exec ~/code' #  --relative-path

alias t="gtree | fzf --ansi"

# --exclude '*.pyc'
# --exclude node_modules

# color examples: https://github.com/junegunn/fzf/wiki/Color-schemes
# color builder: https://minsw.github.io/fzf-color-picker/
export FZF_DEFAULT_OPTS="--height 90% --layout reverse --info inline --border --color 'fg:#bbccdd,fg+:#ddeeff,bg:#334455,preview-bg:#223344,border:#778899'"  \
# Fzf color
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--color=fg:#cbccc6,bg:#1f2430,hl:#f1ff5c 
--color=fg+:#707a8c,bg+:#191e2a,hl+:#ffcc66
--color=info:#73d0ff,prompt:#707a8c,pointer:#cbccc6
--color=marker:#73d0ff,spinner:#73d0ff,header:#d4bfff'

# brew install ripgrep
export FZF_DEFAULT_COMMAND='rg --files --hidden --smart-case --glob "!.git/*" ~/'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# enable fzf keybindings for Zsh:
source /usr/share/doc/fzf/examples/key-bindings.zsh
# enable fuzzy auto-completion for Zsh:
source /usr/share/doc/fzf/examples/completion.zsh
##########################################


LS_COLORS=$LS_COLORS:'di=1;34:' ; export LS_COLORS

# Prompt elements
# Look here for more ideas : https://github.com/tonylambiris/dotfiles/blob/master/dot.zshrc
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir_writable dir vcs) #vcs -- adds git, but slow. # icons_test to see all icons
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time virtualenv time battery)

POWERLEVEL9K_MODE='awesome-patched'

# Advanced `vi_mode` color customization
POWERLEVEL9K_VI_MODE_INSERT_FOREGROUND='teal'
POWERLEVEL9K_VI_MODE_INSERT_BACKGROUND='red'

#POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND="black"
POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND="blue"
POWERLEVEL9K_EXECUTION_TIME_ICON="s \uf253"  # nf-fa-hourglass_half = f253 .. stopwatch = 23F1

# ICONS
# Discovery ship = f197
# dollar sign f155
# folder = e5fe
# home   = f015
# sqrt   = fc82
# heart  = f004
# user   = f007
# hex-zoid = F20E
# snapchat = f2ac
# slack  = f198
#❗=  \u2757 
# ⁉️ = \u2049

# Prompt icons
POWERLEVEL9K_HOME_ICON='\uf197'

# Status // Fail indicator
# elim checkmark, and exit codes 
POWERLEVEL9K_STATUS_VERBOSE=false
POWERLEVEL9K_FAIL_ICON='\u2718 \u2718 \u2718 \u2718 ⁉️ ⁉️' # ❗=  \u2757 ⁉️ = \u2049
# change color on fail. Doesn't work.
# POWERLEVEL9K_STATUS_ERROR_FOREGROUND='green' # yellow background on error 
# POWERLEVEL9K_STATUS_ERROR_FOREGROUND='red'  # red x on error


#POWERLEVEL9K_DIR_HOME_FOREGROUND="white" # home dir colors
#POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="red" # root dir colors
POWERLEVEL9K_FOLDER_ICON='\ufc82'   # root folder icon
POWERLEVEL9K_HOME_SUB_ICON="\ue5fe" # folder icon
# POWERLEVEL9K_ROOT_ICON=$'\uf004'  # unknown icon
# POWERLEVEL9K_USER_ICON="\uf007"   # unknown icon
# POWERLEVEL9K_SUB_ICON='\uf004'    # unknown icon

# VCS (git) icons
POWERLEVEL9K_VCS_GIT_ICON=$''
POWERLEVEL9K_VCS_GIT_GITHUB_ICON=$''
POWERLEVEL9K_VCS_STAGED_ICON=$'\uf055'
POWERLEVEL9K_VCS_UNSTAGED_ICON=$'\uf421'
POWERLEVEL9K_VCS_UNTRACKED_ICON=$'\uf00d'
POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON=$'\uf0ab '
POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON=$'\uf0aa '

# Prompt settings
POWERLEVEL9K_PROMPT_ON_NEWLINE=true # two line prompt
POWERLEVEL9K_RPROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=false
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%K{white}%k" # add whatever to front of first line
# $ dollar sign on bottom prompt
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%K{black}%F{green} \uf155%f%F{black} %k\ue0b0%f"

# Command execution time stamp shown in the history command output.
HIST_STAMPS="mm/dd/yyyy"

# Time
POWERLEVEL9K_TIME_FORMAT="%F{black}\uf017 %D{%I:%M}%f"  # %F{black}\uf017 had to take this out bc no font!!
POWERLEVEL9K_TIME_BACKGROUND='green'

POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=1

# ctrl + shift to auto-execute the current ZSH suggestion 
bindkey '^j' autosuggest-execute
bindkey '^k' autosuggest-accept

#if [ $PWD = '/home/kastan' ]
#then
#    echo "THIS WORKD"
#    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(root_indicator context dir_writable vcs ) 
#    POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX='\uf197'
#fi 

# To use: Make sure the version number is correct!!
# Below works for cuda 10.2
# export CUDA_HOME=/usr/local/cuda
# export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
# export PATH=/usr/local/cuda-10.2/bin${PATH:+:${PATH}}
# export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/cuda/lib64
# export LD_LIBRARY_PATH=/usr/local/cuda-10.2/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
# export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
# export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64"

# Add RVM to PATH for scripting. -- this was for colorLS I believe. 
# [[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" 

# Syntax highlighting from https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
source $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# mdv (in-terminal markdown viewer) themeing
export MDV_THEME=884.0134
export MDV_THEME_CODE=528.9419

# fasd (terminal movement) - https://github.com/clvv/fasd
eval "$(fasd --init auto)" 
alias a='fasd -a'        # any
alias s='fasd -si'       # show / search / select
alias d='fasd -d'        # directory
alias f='fasd -f'        # file
alias sd='fasd -sid'     # interactive directory selection
alias sf='fasd -sif'     # interactive file selection
alias z='fasd_cd -d'     # cd, same functionality as j in autojump
alias zz='fasd_cd -d -i' # cd with interactive selection

# FASD EXAMPLES:
# f foo           # list frecent files matching foo
# a foo bar       # list frecent files and directories matching foo and bar
# f js$           # list frecent files that ends in js
# f -e vim foo    # run vim on the most frecent file matching foo
# mplayer `f bar` # run mplayer on the most frecent file matching bar
# z foo           # cd into the most frecent directory matching foo
# open `sf pdf`   # interactively select a file matching pdf and launch `open`


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
