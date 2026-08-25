# fnm does not auto-install a missing version; it prints the version it wanted.
# Run `fnm install` in the repo to fetch it.
eval "$(fnm env --use-on-cd --version-file-strategy=recursive --shell zsh)"
