{ pkgs }:

with pkgs; [
  aws-vault
  awscli2
  bandwhich
  bat
  cheat
  # curl
  exercism
  fd
  go_1_18
  google-cloud-sdk
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
  tmux
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
  rubyPackages.solargraph
  python39Packages.python-lsp-server
  nodePackages.pyright
]
