zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# Enable completion for cd .. <TAB> cd ../
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' menu select
zmodload zsh/complist

# Put secret stuff here
if [ -f ~/.localrc ]; then
    . ~/.localrc
fi
