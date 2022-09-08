# Prompt
PS1='%(?.%(!.#.;).%F{6}%B;%b%f) '

# History/reverse-search
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=5000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# zsh completions
autoload -U compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select

# Vim keybindings
bindkey -v

# asdf
$(brew --prefix asdf)/libexec/asdf.sh

# Zsh plugin activations
FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# autosuggestions
bindkey '^ ' autosuggest-accept 
