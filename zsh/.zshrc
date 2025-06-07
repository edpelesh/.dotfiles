export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

export ZCONFIG=$XDG_CONFIG_HOME/zsh
export ZSH_CACHE_DIR=$XDG_CACHE_HOME/zsh
export ZDOTDIR=$HOME
export HISTFILE=$ZSH_CACHE_DIR/zhistory

if [[ -r "$XDG_DATA_HOME/oh-my-zsh" ]]; then
  export ZSH=$XDG_DATA_HOME/oh-my-zsh
else
  export ZSH=$HOME/.oh-my-zsh
fi

export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8
export LANGUAGE=en
export LC_ALL="${LANG}"
export TERM="xterm-256color"

if [[ -n $SSH_CONNECTION ]]; then
  SESSION_TYPE=ssh
elif [[ -n $DISPLAY || -n $WAYLAND_DISPLAY ]]; then
  SESSION_TYPE=gui
else
  SESSION_TYPE=tty
fi

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
[[ ! -f "${ZCONFIG}/.p10k.zsh" ]] || source "${ZCONFIG}/.p10k.zsh"

if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR='vi'
else
	export EDITOR='nvim'
fi

ZSH_CUSTOM=$ZCONFIG/custom
case "$SESSION_TYPE" in
  gui)
    ZSH_THEME="powerlevel10k/powerlevel10k"
    ;;
  ssh)
    ZSH_THEME="dst"
    ;;
  tty)
    ZSH_THEME="dst"
    ;;
esac

DISABLE_AUTO_UPDATE="false"
DISABLE_UPDATE_PROMPT="true"
UPDATE_ZSH_DAYS=7

CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"

COMPLETION_WAITING_DOTS="false"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="dd.mm.yyyy"

plugins=()
plugins+=(zsh-autosuggestions)
plugins+=(zsh-syntax-highlighting)
plugins+=(git)
plugins+=(tmux)
source $ZSH/oh-my-zsh.sh

(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Load eventually common [custom] configuration, either:
# - generic ZSH functions defined in $ZDOTDIR/lib
# - common to all shells (from ~/.config/shell/[custom/]*.sh typically)
# - specific custom to zsh (from ~/.config/zsh/custom/*.zsh
for d in \
${ZDOTDIR}/lib \
${XDG_CONFIG_HOME}/shell \
${XDG_CONFIG_HOME}/shell/custom \
${ZDOTDIR}/custom
do
	if [ -d "${d}" ]; then
		for f in ${d}/*.(sh|zsh)(N); do
			[[ -r "$f" ]] && source $f
	done
	fi
done

export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# Force re-completion
autoload -U compinit && compinit

export PATH=/usr/local/bin:/opt/gcc-14.2.0-3-aarch64/bin/:$PATH
if [ -d "$HOME/bin" ]; then
	export PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/.local/bin" ]; then
	export PATH="$HOME/.local/bin:$PATH"
fi
if [ -d "$HOME/Library/Python/3.9/bin" ]; then
	export PATH="$PATH:$HOME/Library/Python/3.9/bin"
fi
typeset -U PATH path

source <(fzf --zsh)
eval "$(zoxide init zsh)"

# Bindkeys - use sudo showkey -a to get sequences
# Shift-Left / Shift-Right
bindkey "^[[1;2D" backward-word
bindkey "^[[1;2C" forward-word
# Shift-Up / Shift-Down
bindkey "^[[1;2A" beginning-of-line
bindkey "^[[1;2B" end-of-line

if [[ -r "$(which eza)" ]]; then
	alias ls="eza"
	alias ll="eza -alh"
	alias tree="eza --tree"
fi
if [[ -r "$(which bat)" ]]; then
	alias cat="bat -p"
fi

alias vi="nvim"
alias vim="nvim"
alias unstow='stow --delete'

# Mac settings
alias cleanderived="rm -rdf ~/Library/Developer/Xcode/DerivedData/*"
alias screenshots="xcrun simctl status_bar booted override --time '9:41' --batteryState charged --batteryLevel 100 --cellularMode active --cellularBars 4"

export HOMEBREW_NO_ANALYTICS=1
