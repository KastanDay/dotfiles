# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
  export ZSH=/home/kastan/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="robbyrussell" #this is the default one
#ZSH_THEME="agnoster"
ZSH_THEME="powerlevel9k/powerlevel9k"

# ZSH_THEME="random" # gives you a random theme each terminal


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

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git pip vi-mode web-search sudo wd zsh-autosuggestions )

source $ZSH/oh-my-zsh.sh

# User configuration
export DEFAULT_USER="kastan"

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

source ~/catkin_ws/devel/setup.zsh

function mygrep { grep -rni $1; }
alias wut=google
alias fg="find . | grep "
alias f/g="find / | grep "
alias c=code 
alias o=xdg-open 
alias e=exit


function kms { echo "It's going to be okay, today is only one day"}

LS_COLORS=$LS_COLORS:'di=1;34:' ; export LS_COLORS


# Prompt elements
# Look here for more ideas : https://github.com/tonylambiris/dotfiles/blob/master/dot.zshrc
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(root_indicator context dir_writable dir vcs ) #vcs -- adds git, but slow. # icons_test to see all icons
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time status time battery)

POWERLEVEL9K_MODE='awesome-patched'

# Advanced `vi_mode` color customization
POWERLEVEL9K_VI_MODE_INSERT_FOREGROUND='teal'
POWERLEVEL9K_VI_MODE_INSERT_BACKGROUND='red'

#POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND="$DEFAULT_BACKGROUND"
POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND="black"
POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND="blue"
POWERLEVEL9K_EXECUTION_TIME_ICON="\uf253"  # nf-fa-hourglass_half = f253 .. stopwatch = 23F1
# elim checkmark, and exit codes 
POWERLEVEL9K_STATUS_VERBOSE=false 

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

# Prompt icons
POWERLEVEL9K_HOME_ICON='\uf197'
#POWERLEVEL9K_DIR_HOME_FOREGROUND="white" # home dir colors
#POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="red" # root dir colors
POWERLEVEL9K_FOLDER_ICON='\ufc82'   # root folder icon
POWERLEVEL9K_HOME_SUB_ICON="\ue5fe" # folder icon
# POWERLEVEL9K_ROOT_ICON=$'\uf004'  # unknown icon
# POWERLEVEL9K_USER_ICON="\uf007"   # unknown icon
# POWERLEVEL9K_SUB_ICON='\uf004'    # unknown icon

# VCS icons
POWERLEVEL9K_VCS_GIT_ICON=$''
POWERLEVEL9K_VCS_GIT_GITHUB_ICON=$''
POWERLEVEL9K_VCS_STAGED_ICON=$'\uf055'
POWERLEVEL9K_VCS_UNSTAGED_ICON=$'\uf421'
POWERLEVEL9K_VCS_UNTRACKED_ICON=$'\uf00d'
POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON=$'\uf0ab '
POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON=$'\uf0aa '

# Prompt settings
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_RPROMPT_ON_NEWLINE=true
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%K{white}%k" # add whatever to front of first line
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%K{black}%F{green} \uf155%f%F{black} %k\ue0b0%f "

# Command execution time stamp shown in the history command output.
HIST_STAMPS="mm/dd/yyyy"

# Time
POWERLEVEL9K_TIME_FORMAT="%F{black}\uf017 %D{%I:%M}%f"  # %F{black}\uf017 had to take this out bc no font!!
POWERLEVEL9K_TIME_BACKGROUND='green'

# ctrl + shift to auto-execute the current ZSH suggestion
bindkey '^ ' autosuggest-execute
bindkey '^J' autosuggest-accept

#if [ $PWD = '/home/kastan' ]
#then
#    echo "THIS WORKD"
#    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(root_indicator context dir_writable vcs ) 
#    POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX='\uf197'
#fi 


#export ROS_MASTER_URI=http://192.168.15.60:11311

export CUDA_HOME=/usr/local/cuda
export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
#export PATH=/usr/local/cuda-9.2/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-9.2/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
#export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64"

export PYTHONPATH=$PYTHONPATH:/usr/lib/python2.7/dist-packages
# Syntax highlighting from https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
source /home/kastan/Downloads/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
