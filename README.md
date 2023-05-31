# README

Initialize for Darwin system:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

sh <(curl -L https://nixos.org/nix/install)

git clone https://github.com/sxyazi/dotfiles.git ~/.config
ln -s ~/.config/zsh/.zshenv ~/.zshenv

cd ~/.config/nix
nix build .#darwinConfigurations.ikas-Virtual-Machine.system
./result/sw/bin/darwin-rebuild switch --flake .
```

gc

```
sudo nix-collect-garbage -d
nix-store --gc
```
