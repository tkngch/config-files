# .zshrc

# History in cache directory
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=$HOME/.cache/zsh.hist

# Environment variables
export TERM="xterm-256color"
export BROWSER=""
export EDITOR="/bin/vim"
export SYSTEMD_EDITOR="/bin/vim"
export PATH="${HOME}/bin:${PATH}"
export VISUAL="/bin/vim"
export PAGER="/bin/less"
export LESS="-r"  # color support
export LESSHISTFILE=$HOME/.cache/less.hist
# export PYTHONPATH="$HOME/lib/python/"
# export PYTHONUSERBASE="$HOME/lib/python/"  # directory for pip -user
export XDG_CONFIG_HOME="$HOME/.config"
# export MATPLOTLIBRC="$HOME/.config/matplotlib/"
export R_LIBS_USER="$HOME/lib/R/"
export R_PROFILE_USER="$HOME/.Rprofile"
export R_DEFAULT_PACKAGES=NULL  # do not let R preload anything
export GREP_COLOR='1;33'  # color grep output in yellow
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/lib/cpp/"
# export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
# export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export STARDICT_DATA_DIR="$HOME/var/stardict/dic"
export GTK_IM_MODULE=fcitx  # support fcitx
export QT_IM_MODULE=fcitx  # support fcitx
export XMODIFIERS=@im=fcitx  # support fcitx
# export KEYTIMEOUT=1  # 10ms after Esc key press before entering the normal mode in zsh

# KEYBINDINGS
# ===========
bindkey -e  # use emacs mode

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"      beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"       end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"    overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}" backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"    delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"        up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"      down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"      backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"     forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"    beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"  end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}" reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
    autoload -Uz add-zle-hook-widget
    function zle_application_mode_start { echoti smkx }
    function zle_application_mode_stop { echoti rmkx }
    add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
    add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# Show only the past commands matching the current line up to the current cursor
# position when Up or Down keys are pressed.
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

# Command editing
# edit a command in vim with ctrl-v
autoload edit-command-line
zle -N edit-command-line
bindkey '^v' edit-command-line


# AUTO COMPLETION
# ===============
autoload -Uz compinit
compinit -d $HOME/.cache/zsh.compdump
# move the cursor around the list of completions to select one
zstyle ':completion:*' menu select
# This way you tell zsh comp to take the first part of the path to be exact,
# and to avoid partial globs. Now path completions became nearly immediate.
zstyle ':completion:*' accept-exact '*(N)'
# autocomplete aliases
setopt COMPLETE_ALIASES


# DIRSTACK
# ========
DIRSTACKFILE="$HOME/.cache/zsh.dirs"
DIRSTACKSIZE=10

autoload -Uz add-zsh-hook

if [[ -f "$DIRSTACKFILE" ]] && (( ${#dirstack} == 0 )); then
    dirstack=("${(@f)"$(< "$DIRSTACKFILE")"}")
    [[ -d "${dirstack[1]}" ]] && cd -- "${dirstack[1]}"
fi

chpwd_dirstack() {
    print -l -- "$PWD" "${(u)dirstack[@]}" > "$DIRSTACKFILE"
}
add-zsh-hook -Uz chpwd chpwd_dirstack
setopt AUTO_PUSHD PUSHD_SILENT PUSHD_TO_HOME

## Remove duplicate entries
setopt PUSHD_IGNORE_DUPS

## This reverts the +/- operators.
setopt PUSHD_MINUS


# ALIASES
# =======
alias ls='/bin/ls --color=auto'
alias mkdir='mkdir -v'
alias mv='mv -iv'
alias cp='cp -i -p'
alias rm='rm -iv'
alias handbrake='ghb'
alias grep='grep --color=always'


# PROMPT
# ======
# Print the elapsed time after a long process
autoload -Uz vcs_info

preexec () {
    # Note the date when the command started, in unix time.
    CMD_START_DATE=$(date +%s)
    # Store the command that we're running.
    CMD_NAME=$1
}

precmd () {
    vcs_info
}

get_last_cmd_info() {
    local LAST_EXIT_CODE=$?

    # Proceed only if we've ran a command in the current shell.
    if ! [[ -z $CMD_START_DATE ]]; then
        # Note current date in unix time
        local CMD_END_DATE=$(date +%s)
        # Store the difference between the last command start date vs. current date.
        local CMD_ELAPSED_TIME=$(($CMD_END_DATE - $CMD_START_DATE))
        # Store an arbitrary threshold, in seconds.
        local CMD_NOTIFY_THRESHOLD=1

        if [[ $CMD_ELAPSED_TIME -gt $CMD_NOTIFY_THRESHOLD ]]; then
            # print elapsed time if the elapsed time (in seconds) is greater than threshold
            local HOURS=$(($CMD_ELAPSED_TIME / 3600))
            local REMAINING_SECONDS=$(($CMD_ELAPSED_TIME % 3600))
            local MINUTES=$(($REMAINING_SECONDS / 60))
            local SECONDS=$(($REMAINING_SECONDS % 60))
            local ELAPSED_TIME="Elapsed $HOURS:$(printf %02d $MINUTES):$(printf %02d $SECONDS). "
        fi
    fi

    if [[ $LAST_EXIT_CODE -ne 0 ]]; then
        local LAST_CMD_STATUS="Exit Code $LAST_EXIT_CODE."
    fi

    if [ -n $ELAPSED_TIME ] || [ -n $LAST_CMD_STATUS ]; then
        echo -e "$ELAPSED_TIME$LAST_CMD_STATUS"
        # echo -e ""
        # echo -e "\033[0m$ELAPSED_TIME$CMD_INFO\033[0m"
        # echo -e ""
    fi
}

## Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr 𝚫
zstyle ':vcs_info:git:*' stagedstr 𝛅
zstyle ':vcs_info:git:*' formats 'git: %b %u%c'
setopt PROMPT_SUBST
PROMPT='${(l:COLUMNS:: :)$(get_last_cmd_info)}
${vcs_info_msg_0_}
%F{white}%d
%F{blue}▷%F{white} '


# MISC
# ====
unsetopt beep

## disable XON/XOFF flow control (^s/^q)
stty -ixon

## activate zsh-syntax-highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ${HOME}/bin/fcd.sh

if [[ -d ${HOME}/var/google-cloud-sdk ]]; then
    export CLOUDSDK_PYTHON=python3
    source ${HOME}/var/google-cloud-sdk/path.zsh.inc
    source ${HOME}/var/google-cloud-sdk/completion.zsh.inc
    export GOOGLE_APPLICATION_CREDENTIALS=${HOME}/.config/gcloud/application_default_credentials.json
fi
