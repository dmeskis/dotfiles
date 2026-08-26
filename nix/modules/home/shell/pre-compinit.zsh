# Prompt
# PS1='%(?.%(!.#.;).%F{6}%B;%b%f) '

# If a command is issued that can’t be executed as a normal command, and the
# command is the name of a directory, perform the cd command to that directory.
# currently using zoxide for this
# setopt AUTO_CD

setopt auto_pushd

setopt prompt_sp
setopt nomatch
# setopt extended_glob
setopt transient_rprompt

# The rest of the history options live in programs.zsh.history in default.nix.
# They must: home-manager emits its own `setopt` block after this fragment, so
# a setopt here for anything it manages gets silently reverted. INC_APPEND_HISTORY
# is the one with no home-manager option, so it stays. It is redundant while
# share_history is on, but keeps write-on-execute if that is ever turned off.
setopt inc_append_history

# Shutup ALL beeps
setopt nobeep
# Shutup autocomplete bell
# unsetopt LIST_BEEP

if type brew &>/dev/null; then
	FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi
