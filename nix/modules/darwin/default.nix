# Shared macOS system configuration, imported by every darwin host.
{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget

  # User CLI tools live in home-manager (hosts/packages.nix). Keep this list to
  # things that genuinely must be system-wide
  environment.systemPackages = with pkgs; [
    ghostty-bin
  ];

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      # Deliberately left at "none" to avoid deleting manually installed
      # taps/casks at work
      cleanup = "none";
    };

    # Shared across machines. Work-only casks live in
    # hosts/homebot-mbp/darwin.nix; homebrew.casks is a list option, so the
    # host's entries merge with these.
    casks = [
      "anki"
      "raycast"
      "rectangle"
      "shortcat"
      "spotify"
      "todoist-app"
    ];
  };

  system.primaryUser = "dylanmeskis";

  system.defaults.NSGlobalDomain.AppleKeyboardUIMode = 3;
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 15;
  system.defaults.NSGlobalDomain.KeyRepeat = 1;
  system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;
  system.defaults.NSGlobalDomain._HIHideMenuBar = true;

  system.defaults.dock.autohide = true;
  system.defaults.dock.orientation = "right";
  system.defaults.dock.showhidden = true;
  system.defaults.dock.mru-spaces = false;

  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.finder.QuitMenuItem = true;
  system.defaults.finder.FXEnableExtensionChangeWarning = false;

  system.defaults.trackpad.Clicking = true;
  system.defaults.trackpad.TrackpadThreeFingerDrag = true;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  system.defaults.finder.ShowStatusBar = true;
  system.defaults.finder.ShowPathbar = true;
  system.defaults.finder._FXShowPosixPathInTitle = true;
  system.defaults.ActivityMonitor.OpenMainWindow = true;

  # nix-darwin manages nix-daemon unconditionally when `nix.enable` is on.
  # nix.package = pkgs.nix;

  # Preserved from the hand-written /etc/nix/nix.conf that nix-darwin took over.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.gc = {
    automatic = true;
    interval.Day = 7;
    options = "--delete-older-than 30d";
  };
  nix.optimise.automatic = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 7;

  # Nix here was installed while the default build-user group was still GID
  # 30000; stateVersion >= 5 expects 350 and aborts activation on mismatch.
  # Changing the real GID needs a full Nix reinstall, so pin the expectation.
  ids.gids.nixbld = 30000;
}
