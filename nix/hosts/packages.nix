{ pkgs }:

with pkgs; [
  aws-vault
  awscli2
  bandwhich
  bat
  cheat
  exercism
  fd
  go
  google-cloud-sdk
  imgcat
  kubectl
  lua5_3
  lua53Packages.busted
  nixfmt
  redis
  ruby
  ripgrep
  shellcheck
  stack
  steampipe
  tig
  tmux
  tree
  unzip
  wget
  xan
  zsh
  zsh-syntax-highlighting
  yq
  # language servers
  gopls
  lua-language-server
  terraform-ls
  rubyPackages.solargraph
  pyright
  black # for ALE
]
