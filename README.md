### Settings

First consider checking the system settings. 
- iCloud sync
- Hostname
- Trackpad gestures
- Other

Enable `Ctrl+Shift` window drag:
```bash
defaults write -g NSWindowShouldDragOnGesture -bool true
```
---
### Apps

- #### [Arc browser](https://arc.net/)
	- Bitwarden extension
- #### [Spark Mail](https://sparkmailapp.com/)
- #### Xcode
- #### [Antigravity](https://antigravity.google/)
- #### [LM Studio](https://lmstudio.ai/)
- #### [ClearVPN](https://clearvpn.com/)
---
### Install the Command Line Tools package in Terminal

```bash
xcode-select --install
```

After that you need to restore ssh config and keys before cloning dotfiles:
```bash
git clone git@github.com:edpelesh/.dotfiles.git
git submodule update --init --recursive
```

---
### Oh My ZSH! (___optional___)

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Apps
```bash
brew analytics off
brew install --cask font-caskaydia-cove-nerd-font
brew install --cask karabiner-elements
brew install --cask blackhole-2ch
brew install --cask transmission
brew install --cask flashspace
brew install --cask cyberduck
brew install --cask ghostty
brew install --cask tg-pro
brew install gemini-cli
brew install immich-go
brew install syncthing
brew install fastfetch
brew install obsidian
brew install posting
brew install ripgrep
brew install lazygit
brew install thefuck
brew install zoxide
brew install node
brew install stow
brew install yazi
brew install nvim
brew install tmux
brew install bat
brew install fzf
brew install eza
brew install go
brew install fd
```

After installation, stow each configuration. In terminal/Ghostty go into `.dotfiles` and `stow ${dir}`.

For tmux packages intallation, launch tmux, and use `Ctrl+S` and then `I` (capital "i").
For nvim, use `:Lazy`, `:TSUpdate` and `:Mason`.

