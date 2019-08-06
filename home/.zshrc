export ZSH="$HOME/.oh-my-zsh"

plugins=(gitfast z per-directory-history dirhistory)

typeset -g POWERLEVEL9K_MODE='nerdfont-complete'
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir)
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status vcs kubecontext root_indicator background_jobs time)

typeset -g POWERLEVEL9K_VCS_GIT_HOOKS=(vcs-detect-changes git-untracked git-aheadbehind)
typeset -g POWERLEVEL9K_VCS_{CLEAN,LOADING}_BACKGROUND='green'
typeset -g POWERLEVEL9K_VCS_{UNTRACKED,MODIFIED}_BACKGROUND='yellow'
typeset -g POWERLEVEL9K_VCS_{GIT,GIT_GITHUB,GIT_BITBUCKET,GIT_GITLAB}_ICON=
#typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON=
#typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON=
#typeset -g POWERLEVEL9K_VCS_STAGED_ICON=

typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND='black'
typeset -g POWERLEVEL9K_STATUS_OK_BACKGROUND='#263137'

typeset -g POWERLEVEL9K_DIR_{HOME,HOME_SUBFOLDER,ETC,DEFAULT}_BACKGROUND='253'
typeset -g POWERLEVEL9K_DIR_{HOME,HOME_SUBFOLDER,ETC,DEFAULT}_FOREGROUND='#000000'

typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
typeset -g POWERLEVEL9K_TIME_BACKGROUND='253'
typeset -g POWERLEVEL9K_TIME_FOREGROUND='#000000'
typeset -g POWERLEVEL9K_TIME_ICON=

typeset -g POWERLEVEL9K_KUBECONTEXT_CLASSES=(
    '*prod*'  PROD
    '*'       DEFAULT
)
typeset -g POWERLEVEL9K_KUBECONTEXT_PROD_BACKGROUND=red
typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_BACKGROUND=magenta
typeset -g POWERLEVEL9K_KUBECONTEXT_SHORTEN=(gke eks)

ZSH_THEME='powerlevel10k/powerlevel10k'

source $ZSH/oh-my-zsh.sh

setopt autolist
setopt noautomenu

setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

zstyle ':completion:*' special-dirs true

for file in ~/.{exports,aliases,functions}; do
	source "$file";
done;
unset file;
