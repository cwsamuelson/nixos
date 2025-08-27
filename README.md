# Just some links

https://nixos-and-flakes.thiscute.world/nixos-with-flakes/start-using-home-manager
https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-configuration-explained
https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-with-flakes-enabled
https://discourse.nixos.org/t/set-up-nixos-home-manager-via-flake/29710/7
https://github.com/nmasur/dotfiles/tree/b282e76be4606d9f2fecc06d2dc8e58d5e3514be
https://github.com/minikN/nix
https://nixos.wiki/wiki/Flakes
https://github.com/DeterminateSystems/nix-installer
https://discourse.nixos.org/t/linking-a-nixosconfiguration-to-a-given-homeconfiguration/19737/2
https://github.com/Misterio77/nix-starter-configs
https://codeberg.org/justgivemeaname/.dotfiles
https://borretti.me/article/nixos-for-the-impatient#upgrading

```bash
nix flake update
home-manager switch --flake .
```

```bash
nix flake update
sudo nixos-rebuild switch --flake .#laptop-fw
```

## Update commands
``` bash
sudo nixos-rebuild switch --flake ~/projects/nixos
```
```bash
home-manager switch --flake ~/projects/nixos/
```
