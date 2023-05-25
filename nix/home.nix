{ config, lib, pkgs, ... }:

{
  home.stateVersion = "22.11";

  programs.neovim = {
    enable = true;
    #package = pkgs.neovim-nightly;

    plugins = with pkgs; [
      vimPlugins.telescope-fzf-native-nvim
    ];
  };

  xdg.dataFile = with pkgs; {
    # Zsh
    "zsh/zsh-autosuggestions".source = "${zsh-autosuggestions}/share/zsh-autosuggestions";
    "zsh/zsh-completions".source = "${zsh-autosuggestions}/share/zsh-completions";
    "zsh/zsh-history-substring-search".source = "${zsh-history-substring-search}/share/zsh-history-substring-search";
    "zsh/zsh-syntax-highlighting".source = "${zsh-syntax-highlighting}/share/zsh-syntax-highlighting";
    "zsh/fzf".source = "${fzf}/share/fzf";

    # Neovim
    "nvim/lazy/telescope-fzf-native.nvim/build/libfzf.so".source = "${vimPlugins.telescope-fzf-native-nvim}/build/libfzf.so";
  } // builtins.listToAttrs (map
    (key:
      let
        name = lib.pipe key [
          # added in buildGrammar
          (lib.removeSuffix "-grammar")

          # grammars from tree-sitter.builtGrammars
          (lib.removePrefix "tree-sitter-")
          (lib.replaceStrings [ "-" ] [ "_" ])
        ];
      in
      {
        name = "nvim/lazy/nvim-treesitter/parser/${name}.so";
        value = { source = "${pkgs.tree-sitter.builtGrammars."${key}"}/parser"; };
      }
    )
    (builtins.attrNames pkgs.tree-sitter.builtGrammars)
  );
}

