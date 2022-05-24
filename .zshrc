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

#####
## Open github repos from CLI ##
# https://gist.github.com/igrigorik/6666860?permalink_comment_id=2693081#gistcomment-2693081
#####
gh(){
  open $(git config remote.origin.url | sed "s/git@\(.*\):\(.*\).git/https:\/\/\1\/\2/")/$1$2
}

# Open current branch
alias ghb='gh tree/$(git symbolic-ref --quiet --short HEAD )'
# Open current directory/file in current branch
alias ghbf="gh tree/$(git symbolic-ref --quiet --short HEAD )/$(git rev-parse --show-prefix)"

# Kastan's custom-made bash function to open a specfic directory in Github. ON CURRENT BRANCH :))
ghf(){
    url=`echo $(git config remote.origin.url)`
    folder=`echo $(git rev-parse --show-prefix)`
    branch=`echo $(git symbolic-ref --quiet --short HEAD )`
    url=$(sed 's/.\{4\}$//' <<< "$url")
    open $url'/tree/'$branch'/'$folder
}

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

# These actually work great, just make sure the version number is correct!!
# Works for cuda 10.2
export CUDA_HOME=/usr/local/cuda
export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
# export PATH=/usr/local/cuda-10.2/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/cuda/lib64
# export LD_LIBRARY_PATH=/usr/local/cuda-10.2/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
# export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
# export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64"

export PYTHONPATH=$PYTHONPATH:/usr/lib/python3.6/dist-packages

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


# Pyenv -- better virtual environments
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
# Load pyenv-virtualenv automatically by adding the following to ~/.bashrc:
eval "$(pyenv virtualenv-init -)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/kastanday/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/kastanday/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/Users/kastanday/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/kastanday/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
