# My NixOS Configuration

## New machine

From this repository checkout, choose the matching host:

```bash
# Dell
./scripts/genhw.sh dell
sudo nixos-rebuild boot --flake .#dell

# ThinkPad T14
./scripts/genhw.sh t14
sudo nixos-rebuild boot --flake .#t14
