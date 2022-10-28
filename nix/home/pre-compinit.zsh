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

# Shutup ALL beeps
unsetopt BEEP
# Shutup autocomplete bell
# unsetopt LIST_BEEP
