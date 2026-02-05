export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

export ZSH_CONFIG_DIR=$XDG_CONFIG_HOME/zsh
export ZSH_CACHE_DIR=$XDG_CACHE_HOME/zsh

# Homebrew
if ! command -v brew &> /dev/null; then
  for brew_path in "/opt/homebrew/bin/brew" "/usr/local/bin/brew" "/home/linuxbrew/.linuxbrew/bin/brew"; do
    if [[ -x "$brew_path" ]]; then
      eval "$($brew_path shellenv)"
      break
    fi
  done
fi

export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8
export LANGUAGE=en
export LC_ALL="${LANG}"
export TERM="xterm-256color"
export GOPATH=$HOME/.local/go

export HISTFILE=$ZSH_CACHE_DIR/zhistory
export HISTDUP=erase

if [ ! -d "$ZSH_CACHE_DIR" ]; then
  mkdir -p "$ZSH_CACHE_DIR"
  touch "$HISTFILE"
fi

HISTSIZE=5000
SAVEHIST=$HISTSIZE

setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

if [[ -n $SSH_CONNECTION ]]; then
  SESSION_TYPE=ssh
elif [[ -n $DISPLAY || -n $WAYLAND_DISPLAY ]]; then
  SESSION_TYPE=gui
else
  SESSION_TYPE=tty
fi

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vi'
else
  export EDITOR='nvim'
fi

ZSH_CUSTOM=$ZSH_CONFIG_DIR/custom

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zi ice from'gh' as'program' sbin'**/eza -> eza' atclone'CARGO_HOME=$ZPFX cargo install --path . && cp -vf completions/eza.zsh _eza'
zi light eza-community/eza

zi ice pick"async.zsh" src"pure.zsh"
zi light sindresorhus/pure

zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode
ZVM_SYSTEM_CLIPBOARD_ENABLED=true

zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light Aloxaf/fzf-tab

zi snippet OMZP::git
zi snippet OMZP::tmux
zi snippet OMZP::thefuck
zi snippet OMZP::command-not-found

# xcb	xcodebuild
# xcdd	rm -rf ~/Library/Developer/Xcode/DerivedData/*
# xcp	xcode-select --print-path
# xcsel	sudo xcode-select --switch
# xx	open -a "Xcode.app"
# xc	Opens the current directory in Xcode
# simulator
# xcselv -l
# xcselv default
zi snippet OMZP::xcode

# Force re-completion
autoload -U compinit && compinit
zinit cdreplay -q

(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none


typeset -U PATH path

# Path exports
if [ -d "$HOME/bin" ]; then
	path=("$HOME/bin" $path)
fi
if [ -d "$HOME/.local/bin" ]; then
	path=("$HOME/.local/bin" $path)
fi
if [ -d "$HOME/Library/Python/3.9/bin" ]; then
	path+=("$HOME/Library/Python/3.9/bin")
fi
if [[ -n "$SWIFTLY_BIN_DIR" && -d "$SWIFTLY_BIN_DIR" ]]; then
	path=("$SWIFTLY_BIN_DIR" $path)
fi
export PATH


source <(fzf --zsh)
eval "$(zoxide init zsh)"

# Bindkeys - use sudo showkey -a to get sequences
# Shift-Left / Shift-Right
bindkey "^[[1;2D" backward-word
bindkey "^[[1;2C" forward-word
# Shift-Up / Shift-Down
bindkey "^[[1;2A" beginning-of-line
bindkey "^[[1;2B" end-of-line

# Aliases
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias ll="eza -alh"
alias tree="eza --tree --level=2"
alias cd="z"
alias vi="nvim"
alias vim="nvim"
alias unstow='stow --delete'
# Takes screenshots for simulator status bar
alias screenshots="xcrun simctl status_bar booted override --time '9:41' --batteryState charged --batteryLevel 100 --cellularMode active --cellularBars 4"

export HOMEBREW_NO_ANALYTICS=1

export BAT_THEME="Catppuccin Macchiato"

export FZF_DEFAULT_OPTS=" \
--color=bg+:#363A4F,bg:#24273A,spinner:#F4DBD6,hl:#ED8796 \
--color=fg:#CAD3F5,header:#ED8796,info:#C6A0F6,pointer:#F4DBD6 \
--color=marker:#B7BDF8,fg+:#CAD3F5,prompt:#C6A0F6,hl+:#ED8796 \
--color=selected-bg:#494D64 \
--color=border:#363A4F,label:#CAD3F5"
bindkey "ç" fzf-cd-widget
export FZF_DEFAULT_COMMAND='fd --type file'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() {
	fd --hidden --exclude .git . "${1}"
}
_fzf_compgen_dir() {
	fd --type=d --hidden --exclude .git . "${1}"
}

if [[ -f "${ZSH_CUSTOM}/plugins/fzf-git.sh/fzf-git.sh" ]]; then
  source "${ZSH_CUSTOM}/plugins/fzf-git.sh/fzf-git.sh"
fi

export FZF_CTRL_T_OPTS="
--walker-skip .git,node_modules,target
--preview 'bat -n --color=always --line-range :500 {}'
--bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always --icons=always {} | head -200'"

_fzf_comprun() {
	local command=$1
	shift

	case "$command" in
		cd)				fzf --preview 'eza --tree --color=always --icons=always {} | head -200' "$@" ;;
		export|unset)	fzf --preview "eval 'echo \$'{}" "$@" ;;
		ssh)			fzf --preview 'dig {}' "$@" ;;
		*)				fzf --preview "--preview 'bat -n --color=always --line-range :500 {}'" "$@" ;;
	esac
}

export SWIFTLY_HOME_DIR="$HOME/.local/share/swiftly"
export SWIFTLY_BIN_DIR="$HOME/.local/share/swiftly/bin"
export SWIFTLY_TOOLCHAINS_DIR="$HOME/.local/share/swiftly/toolchains"

# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

