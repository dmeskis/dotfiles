# Prompt
# PS1='%(?.%(!.#.;).%F{6}%B;%b%f) '

# History/reverse-search
HISTDUP=erase

# If a command is issued that can’t be executed as a normal command, and the
# command is the name of a directory, perform the cd command to that directory.
# currently using zoxide for this
# setopt AUTO_CD

setopt auto_pushd

setopt prompt_sp
setopt nomatch
# setopt extended_glob
setopt transient_rprompt

setopt append_history
setopt share_history
setopt incappendhistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Shutup ALL beeps
setopt nobeep
# Shutup autocomplete bell
# unsetopt LIST_BEEP

if type brew &>/dev/null; then
	FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi
