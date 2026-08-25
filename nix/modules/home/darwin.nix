{ config, pkgs, ... }:
{
  programs.zsh = {
    shellAliases = {
      flush = "dscacheutil -flushcache";

      hidedesktop = "defaults write com.apple.finder CreateDesktop -bool false && killall Finder";
      showdesktop = "defaults write com.apple.finder CreateDesktop -bool true && killall Finder";

      snowsql = "/Applications/SnowSQL.app/Contents/MacOS/snowsql";
    };

    # Homebrew is macOS-only here and both darwin hosts need it on PATH.
    profileExtra = ''
      # Set PATH, MANPATH, etc., for Homebrew.
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
  };

  # Ghostty is installed system-wide as `ghostty-bin` by modules/darwin
  # (pkgs.ghostty doesn't build on darwin), so `package = null` means
  # home-manager only manages ~/.config/ghostty and won't try to install it.
  # A Linux host would instead want `package = pkgs.ghostty`.
  programs.ghostty = {
    enable = true;
    package = null;

    settings = {
      # Same palette neovim renders with `colorscheme gruvbox-material` at its
      # defaults (medium background, material foreground). Follows the macOS
      # appearance; neovim >= 0.10 queries the terminal background (OSC 11) on
      # startup, so it tracks this on its own.
      theme = "dark:Gruvbox Material Dark,light:Gruvbox Material Light";

      font-size = 13;

      macos-option-as-alt = true;
      window-padding-x = 4;
      window-padding-y = 4;
      copy-on-select = "clipboard";
    };
  };

  programs.bat = {
    syntaxes.ghostty = {
      src = pkgs.ghostty-bin;
      file = "Applications/Ghostty.app/Contents/Resources/bat/syntaxes/ghostty.sublime-syntax";
    };
    config.map-syntax = [ "${config.xdg.configHome}/ghostty/config:Ghostty Config" ];
  };
}
