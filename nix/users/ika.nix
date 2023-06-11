{ config, lib, pkgs, ... }:

{
  home.stateVersion = "23.05";

  home.file.".zshenv".text = ''
    source ${config.system.build.setEnvironment}
    source $HOME/.config/zsh/.zshenv
  '';

  xdg.dataFile = with pkgs; {
    # Zsh plugins
    "zsh/zsh-autosuggestions".source = "${zsh-autosuggestions}/share/zsh-autosuggestions";
    "zsh/zsh-completions".source = "${zsh-autosuggestions}/share/zsh-completions";
    "zsh/zsh-history-substring-search".source = "${zsh-history-substring-search}/share/zsh-history-substring-search";
    "zsh/zsh-syntax-highlighting".source = "${zsh-syntax-highlighting}/share/zsh-syntax-highlighting";
    "zsh/fzf".source = "${fzf}/share/fzf";
  };

  programs.ssh = {
    enable = true;
    compression = true;
    serverAliveCountMax = 5;
    serverAliveInterval = 30;
    extraConfig = ''
      Host *
        IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

      Host github.com
        Hostname ssh.github.com
        Port 443
        User git
    '';
  };

  programs.git = {
    enable = true;
    userName = "sxyazi";
    userEmail = "sxyazi@gmail.com";
    ignores = [
      ".DS_Store"
    ];
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB7IT5qOcGD6ov8Z2OfgI2wHnfbYjYVZhi08OHTSyDoV";
      signByDefault = true;
    };
    extraConfig = {
      core = {
        editor = "nvim";
      };

      gpg.format = "ssh";
      gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";

      push.default = "current";
      push.autoSetupRemote = true;
    };
    delta.enable = true;
  };
}

