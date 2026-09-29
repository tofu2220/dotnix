# My NixOS Configuration

## New machine

From this repository checkout, choose the matching host:

```bash
# Dell
./scripts/genhw.sh dell
sudo nixos-rebuild boot --flake .#dell

# ThinkPad E14
./scripts/genhw.sh e14
sudo nixos-rebuild boot --flake .#e14

# ThinkPad T14
./scripts/genhw.sh t14
sudo nixos-rebuild boot --flake .#t14
```
