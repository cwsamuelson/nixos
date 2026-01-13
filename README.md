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

## Install
Purge unnecessaries
```bash
sudo snap remove --purge firefox
sudo apt purge vim curl git firefox -y
sudo apt autoremove -y
```

```bash
git clone flake
cd flake
wget --output-document=/dev/stdout https://nixos.org/nix/install | sh -s -- --daemon --yes \
    && source /etc/profile \
    && nix-shell -p home-manager --run "home-manager switch --extra-experimental-features 'nix-command flakes' --flake ."
```

## Uninstall nix
Uninstalling nix:
1. Delete the systemd service and socket units

  sudo systemctl stop nix-daemon.socket
  sudo systemctl stop nix-daemon.service
  sudo systemctl disable nix-daemon.socket
  sudo systemctl disable nix-daemon.service
  sudo systemctl daemon-reload
2. Restore /etc/bash.bashrc.backup-before-nix back to /etc/bash.bashrc

  sudo mv /etc/bash.bashrc.backup-before-nix /etc/bash.bashrc

(after this one, you may need to re-open any terminals that were
opened while it existed.)

3. Delete the files Nix added to your system:

  sudo rm -rf "/etc/nix" "/nix" "/root/.nix-profile" "/root/.nix-defexpr" "/root/.nix-channels" "/root/.local/state/nix" "/root/.cache/nix" "/home/chris/.nix-profile" "/home/chris/.nix-defexpr" "/home/chris/.nix-channels" "/home/chris/.local/state/nix" "/home/chris/.cache/nix"

and that is it.
