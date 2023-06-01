{ pkgs, ... }:

let
  base = {
    cmake = "nix";
    less = "nix";
    gnused = "nix";
    wget = "nix";
  };

  cli = {
    exa = "nix";
    bat = "nix";
    zoxide = "nix";
    fd = "nix";
    fzf = "nix";
    ripgrep = "nix";
    du-dust = "nix";
    tldr = "nix";
    tig = "nix";
    btop = "nix";
    tree = "nix";
    tmux = "nix";
    starship = "nix";
    hyperfine = "nix";

    # Neovim
    neovim = "nix";
    tree-sitter = "nix";

    # Network
    nali = "nix";
    aria = "nix";
    dogdns = "nix";
    httpie = "nix";
    nmap = "nix";
    telnet = "brew";

    # Archive
    unar = "nix";
    sevenzip = "brew";
    brotli = "nix";
    upx = "nix";
    rar = "nix";

    # Graphic
    ffmpeg = "nix";
    graphviz = "nix";
    exiftool = "nix";

    # JSON
    jless = "nix";
    jq = "nix";
    jc = "nix";

    # Writting
    hugo = "nix";

    # macOS
    duti = "nix";
  };

  utility = {
    adguard = "cask";
    alfred = "cask";
    "1password" = "cask";
    bettermouse = "cask";
    maczip = "cask";
    downie = "cask";
    aerial = "cask";

    # Terminal
    kitty = "nix";
    iterm2 = "nix";

    # Browser
    google-chrome = "cask";
    google-chrome-canary = "cask";
    firefox = "cask";
    microsoft-edge = "cask";

    # Filesync
    OneDrive = 823766827;
    "Transmit 5" = 1436522307;
  };

  gui = {
    # Development
    vscode = "nix";
    fork = "cask";
    postman = "nix";
    coderunner = "cask";
    dash = "cask";
    orbstack = "cask";
    imhex = "cask";
    wireshark = "nix";
    proxyman = "cask";
    another-redis-desktop-manager = "cask";
    "Microsoft Remote Desktop" = 1295203466;
    "Cleaner for Xcode" = 1296084683;

    # Database
    "jetbrains.datagrip" = "nix";
    "Sequel Ace" = 1518036000;

    # Social
    Telegram = 747648890;
    discord = "nix";
    element-desktop = "nix";
    WeChat = 836500024;

    # Movie
    mpv-unwrapped = "nix";
    iina = "nix";
    spotify = "nix";

    # Screen recording
    snipaste = "cask";
    kap = "cask";
    screenflow = "cask";
    obs = "cask";

    # Writting
    notion = "cask";
    obsidian = "nix";
    raindropio = "cask";
    "Reeder 5" = 1529448980;

    # Design
    sip = "cask";
    "OmniGraffle 7" = 1142578753;
    # "Affinity Photo" = 824183456;

    # Others
    "TickTick" = 966085870;
    "Text Scanner" = 1452523807;
  } // {
    # Development
    ## "altair-graphql-client"
    ## charles = "nix";
    ## paw = "cask";

    # Database
    ## "Navicat Premium 16" = 1594061654;

    # Social
    ## lark = "cask";
    ## "QQ" = 451108668;
    ## "DingTalk" = 1435447041;

    # Writting
    ## calibre = "cask";

    # Others
    ## parallels = "cask";
    ## "Dynamic Wallpaper Engine" = 1453504509;
  };

  languages = {
    # Nix
    nixpkgs-fmt = "nix";

    # Golang
    go = "nix";

    # Node.js
    nodejs = "nix";
    "nodePackages.pnpm" = "nix";
    bun = "nix";

    # Rust
    "rust-bin.nightly.latest.minimal" = "nix";

    # Python
    python3 = "nix";

    # Lua
    lua = "nix";
    luarocks = "nix";

    # PHP
    php82 = "nix";
    "php82Packages.composer" = "nix";
    "php82Packages.psysh" = "nix";
  };

  fonts = {
    font-sf-mono = "cask";
    font-fira-code = "cask";
    font-roboto-mono = "cask";
    font-dejavu = "cask";
    font-symbols-only-nerd-font = "cask";
    sf-symbols = "cask";
  };

  external = {
    # Zsh plugins
    zsh-autosuggestions = "nix";
    zsh-completions = "nix";
    zsh-history-substring-search = "nix";
    zsh-syntax-highlighting = "nix";
  };
in

with builtins; let
  all = base // cli // utility // gui // languages // fonts // external;
  grouped = groupBy
    (item: if typeOf all.${item} == "int" then "mas" else all.${item})
    (attrNames all);
  grouped' = mapAttrs
    (group: items: map
      (item: {
        nix = foldl' (carry: key: carry.${key}) pkgs (filter isString (split "\\." item));
        mas = { name = item; value = all.${item}; };
      }.${group} or item)
      items
    )
    grouped;
in
grouped' // { mas = builtins.listToAttrs grouped'.mas; }

