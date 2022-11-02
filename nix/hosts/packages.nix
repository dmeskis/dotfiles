{ pkgs }:

with pkgs; [
  aws-vault
  awscli2
  bandwhich
  bat
  cheat
  curl
  exercism
  fd
  go_1_18
  gopls
  imgcat
  kubectl
  lua5_3
  lua53Packages.busted
  nixfmt
  ruby
  ripgrep
  shellcheck
  stack
  tig
  tree
  unzip
  wget
  xsv
  zsh
  zsh-syntax-highlighting
  # For nvim
  sumneko-lua-language-server
]
