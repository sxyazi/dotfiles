{ pkgs, lib, ... }:

let softwares = import ./softwares.nix { inherit pkgs; };
in
{
  nix.configureBuildUsers = true;

  security.pam.enableSudoTouchIdAuth = true;

  system.defaults = {
    NSGlobalDomain = {
      # Auto hide the menubar
      _HIHideMenuBar = true;

      # Enable full keyboard access for all controls
      AppleKeyboardUIMode = 3;

      # Enable press-and-hold repeating
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 10;
      KeyRepeat = 1;

      # Disable "Natural" scrolling
      "com.apple.swipescrolldirection" = false;

      # Disable smart dash/period/quote substitutions
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;

      # Disable automatic capitalization
      NSAutomaticCapitalizationEnabled = false;

      # Using expanded "save panel" by default
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;

      # Increase window resize speed for Cocoa applications
      NSWindowResizeTime = 0.001;

      # Save to disk (not to iCloud) by default
      NSDocumentSaveNewDocumentsToCloud = true;
    };

    dock = {
      # Set icon size and dock orientation
      tilesize = 48;
      orientation = "left";

      # Set dock to auto-hide, and transparentize icons of hidden apps (⌘H)
      autohide = true;
      showhidden = true;

      # Disable to show recents, and light-dot of running apps
      show-recents = false;
      show-process-indicators = false;
    };

    finder = {
      # Allow quitting via ⌘Q
      QuitMenuItem = true;

      # Disable warning when changing a file extension
      FXEnableExtensionChangeWarning = false;

      # Show all files and their extensions
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;

      # Show path bar, and layout as multi-column
      ShowPathbar = true;
      FXPreferredViewStyle = "clmv";

      # Search in current folder by default
      FXDefaultSearchScope = "SCcf";
    };

    trackpad = {
      # Enable trackpad tap to click
      Clicking = true;

      # Enable 3-finger drag
      TrackpadThreeFingerDrag = true;
    };

    ActivityMonitor = {
      # Sort by CPU usage
      SortColumn = "CPUUsage";
      SortDirection = 0;
    };

    LaunchServices = {
      # Disable quarantine for downloaded apps
      LSQuarantine = false;
    };

    CustomSystemPreferences = {
      NSGlobalDomain = {
        # Set the system accent color, TODO: https://github.com/LnL7/nix-darwin/pull/230
        AppleAccentColor = 6;
        # Jump to the spot that's clicked on the scroll bar, TODO: https://github.com/LnL7/nix-darwin/pull/672
        AppleScrollerPagingBehavior = true;
        # Prefer tabs when opening documents, TODO: https://github.com/LnL7/nix-darwin/pull/673
        AppleWindowTabbingMode = "always";
      };
      "com.apple.finder" = {
        # Keep the desktop clean
        ShowHardDrivesOnDesktop = false;
        ShowRemovableMediaOnDesktop = false;
        ShowExternalHardDrivesOnDesktop = false;
        ShowMountedServersOnDesktop = false;

        # Show directories first
        _FXSortFoldersFirst = true; # TODO: https://github.com/LnL7/nix-darwin/pull/594

        # New window use the $HOME path
        NewWindowTarget = "PfHm";
        NewWindowTargetPath = "file://$HOME/";

        # Allow text selection in Quick Look
        QLEnableTextSelection = true;
      };
      "com.apple.Safari" = {
        # For better privacy
        UniversalSearchEnabled = false;
        SuppressSearchSuggestions = true;
        SendDoNotTrackHTTPHeader = true;

        # Disable auto open safe downloads
        AutoOpenSafeDownloads = false;

        # Enable Develop Menu, Web Inspector
        IncludeDevelopMenu = true;
        IncludeInternalDebugMenu = true;
        WebKitDeveloperExtras = true;
        WebKitDeveloperExtrasEnabledPreferenceKey = true;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
      };
      "com.apple.universalaccess" = {
        # Set the cursor size, TODO: https://github.com/LnL7/nix-darwin/pull/671
        mouseDriverCursorSize = 1.5;
      };
      "com.apple.screencapture" = {
        # Set the filename which screencaptures should be written, TODO: https://github.com/LnL7/nix-darwin/pull/670
        name = "screenshot";
        include-date = false;
      };
      "com.apple.desktopservices" = {
        # Avoid creating .DS_Store files on USB or network volumes
        DSDontWriteUSBStores = true;
        DSDontWriteNetworkStores = true;
      };
      "com.apple.frameworks.diskimages" = {
        # Disable disk image verification
        skip-verify = true;
        skip-verify-locked = true;
        skip-verify-remote = true;
      };
      "com.apple.CrashReporter" = {
        # Disable crash reporter
        DialogType = "none";
      };
      "com.apple.AdLib" = {
        # Disable personalized advertising
        forceLimitAdTracking = true;
        allowApplePersonalizedAdvertising = false;
        allowIdentifierForAdvertising = false;
      };
    };
  };

  system.activationScripts.setting.text = ''
    # Unpin all apps, TODO: https://github.com/LnL7/nix-darwin/pull/619
    defaults write com.apple.dock persistent-apps -array ""

    # Show metadata info, but not preview in info panel
    defaults write com.apple.finder FXInfoPanesExpanded -dict MetaData -bool true Preview -bool false

    # Allow opening apps from any source
    sudo spctl --master-disable

    # Change the default apps
    duti -s com.microsoft.VSCode .txt all
    duti -s com.microsoft.VSCode .ass all
    duti -s io.mpv .mkv all
    duti -s com.colliderli.iina .mp4 all

    ~/.config/os/darwin/power.sh
  '';

  environment.systemPackages = softwares.nix;

  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
    taps = [
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
    ];
    brews = softwares.brew;
    casks = softwares.cask;
    #masApps = softwares.mas;
  };
}
