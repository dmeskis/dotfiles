zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# Enable completion for cd .. <TAB> cd ../
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' menu select
zmodload zsh/complist

bindkey '^ ' autosuggest-accept 
