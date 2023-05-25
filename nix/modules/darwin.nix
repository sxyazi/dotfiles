{ pkgs, lib, ... }:

{
  nix.configureBuildUsers = true;

  programs.zsh.enable = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  system.defaults = {
    # defaults write -g AppleAccentColor -int 6
    NSGlobalDomain.AppleKeyboardUIMode = 3;
    # defaults write -g AppleWindowTabbingMode -string always
    LaunchServices.LSQuarantine = false;
    # defaults write -g NSQuitAlwaysKeepsWindows -bool false
    # defaults write com.apple.CrashReporter DialogType -string none

    #defaults write com.apple.frameworks.diskimages skip-verify -bool true
    #defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
    #defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

    #defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
    #defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

    NSGlobalDomain.ApplePressAndHoldEnabled = false;
    NSGlobalDomain.InitialKeyRepeat = 10;
    NSGlobalDomain.KeyRepeat = 1;

    #".GlobalPreferences"."com.apple.mouse.scaling" = 3.0;
    #NSGlobalDomain."com.apple.trackpad.scaling" = 3.0;
    # defaults write com.apple.universalaccess mouseDriverCursorSize -float 1.5

    NSGlobalDomain."com.apple.swipescrolldirection" = false;
    NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
    NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
    NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
    NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;

    trackpad.Clicking = true;

    NSGlobalDomain._HIHideMenuBar = true;
    dock.autohide = true;

    dock.show-recents = false;

    dock.tilesize = 48;
    # defaults write com.apple.dock no-bouncing -bool true
    dock.show-process-indicators = false;
    dock.showhidden = true;
    #defaults write com.apple.dock persistent-apps -array ""

    finder.AppleShowAllExtensions = true;
    finder.AppleShowAllFiles = true;
    finder.FXEnableExtensionChangeWarning = false;
    finder.ShowPathbar = true;
    finder.FXPreferredViewStyle = "clmv";
    #defaults write com.apple.finder _FXSortFoldersFirst -bool true
    finder.FXDefaultSearchScope = "SCcf";

    #defaults write com.apple.finder NewWindowTarget -string PfHm
    #defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/"

    #defaults write com.apple.finder QLEnableTextSelection -bool true


    NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
    NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;

    #defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

    #defaults write com.apple.finder FXInfoPanesExpanded -dict MetaData -bool true Preview -bool false

    #defaults write com.apple.screencapture name -string screenshot
    #defaults write com.apple.screencapture include-date -bool false

    CustomSystemPreferences = {
      "com.apple.Safari" = {
        "IncludeInternalDebugMenu" = true;
        "IncludeDevelopMenu" = true;
        "WebKitDeveloperExtrasEnabledPreferenceKey" = true;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
      };
    };

    ActivityMonitor.ShowCategory = 101;
    ActivityMonitor.SortColumn = "CPUUsage";
    ActivityMonitor.SortDirection = 0;
  };

  environment.systemPackages = with pkgs; [
    # Nix
    nil
    nixpkgs-fmt

    # Zsh
    zsh-autosuggestions
    zsh-completions
    zsh-history-substring-search
    zsh-syntax-highlighting

    # Golang
    go
    gopls
    gotools

    # Node.js
    nodejs
    nodePackages.pnpm

    exa
    zoxide
    fzf
    ripgrep
    bat
    #gnu-sed
    tldr
    tig
    #dust
    btop
    fd
    tree
    hyperfine

    starship

    kitty
    neovim
    tree-sitter
  ];

  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
    brews = [
    ];
    casks = [
      "fork"
    ];
    masApps = { };
  };
}
