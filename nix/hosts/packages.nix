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
  imgcat
  kubectl
  lua5_3
  lua53Packages.busted
  nixfmt
  ruby
  ripgrep
  shellcheck
  stack
  steampipe
  tig
  tree
  unzip
  wget
  xsv
  zsh
  zsh-syntax-highlighting
  # language servers
  gopls
  sumneko-lua-language-server
  terraform-ls
]
