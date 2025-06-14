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
  go_1_22
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
  sumneko-lua-language-server
  terraform-ls
  rubyPackages.solargraph
  python311Packages.python-lsp-server
  python311Packages.python-lsp-black
  pyright
  # python311Packages.pyls-isort
]
