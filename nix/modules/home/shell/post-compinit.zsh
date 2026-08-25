zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# Enable completion for cd .. <TAB> cd ../
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' menu select
zmodload zsh/complist

# Put secret stuff here
if [ -f ~/.localrc ]; then
    . ~/.localrc
fi

# Stray `5;13~` (and friends) appearing at the prompt {{{
#
# Ghostty sets TERM=xterm-ghostty. Per ghostty.5, the `xterm` prefix is a
# deliberate hack: vim/neovim key off it to enable xterm's modifyOtherKeys
# protocol. Under that protocol ctrl+enter is reported as CSI 27;5;13~ rather
# than a plain CR.
#
# If the editor exits abnormally the mode is never turned back off, and the
# shell inherits it. ZLE has no binding for CSI 27;5;13~ -- the only ^[[2...
# binding is ^[[200~ (bracketed-paste) -- so the CSI intro is swallowed as a
# failed partial match and the remainder gets self-inserted. That is the
# literal `5;13~`.
#
# Two independent defences, because either alone leaves a gap:
if [[ -o interactive ]]; then
  # 1. Turn the protocols back off before drawing each prompt, so a mode leaked
  #    by a crashed TUI is cleaned up rather than persisting for the session.
  #    `CSI > 4 ; 0 m` disables modifyOtherKeys; `CSI < u` pops any kitty
  #    keyboard flags a TUI pushed. Both are no-ops when already off.
  _hm_reset_key_protocols() { printf '\e[>4;0m\e[<u' }
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd _hm_reset_key_protocols

  # 2. Bind the sequences anyway, so a stale mode is merely harmless instead of
  #    corrupting the line. Without the protocol every one of these modifier
  #    combinations sends a bare CR, i.e. accept-line -- so that is what they
  #    should do here too.
  for _hm_mod in 2 3 4 5 6 7 8; do
    bindkey "^[[27;${_hm_mod};13~" accept-line
  done
  unset _hm_mod
fi
# }}}
