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

## Niri desktop shell

The shared Niri session uses Noctalia **v5.3.0** for the bar, launcher, notifications, lock screen, and Polkit agent. Niri remains the compositor and owns window management, outputs, and screenshots. Start the shell through the configured `niri.service` session; there is no Niri `spawn-at-startup` entry or parallel shell service.

### Controls

| Key | Action |
| --- | --- |
| `Mod+D` | Noctalia launcher |
| `Mod+Shift+E` | Session panel |
| `Mod+Escape` | Lock the session |
| `Mod+Comma` | Noctalia Settings |
| `Mod+S` | Control Center |
| Volume, mic mute, and brightness media keys | Native Noctalia controls, available while locked |
| `Print` / `Ctrl+Print` | Niri full-screen / focused-window screenshots |

`Mod+L` remains Niri's focus-column-right binding. Noctalia-launched applications run as transient systemd user services so they can survive a Noctalia service restart.

Bluetooth is managed from the native Bluetooth tab in Noctalia Control Center (`Mod+S`): power, discovery, pairing/unpairing, and connecting/disconnecting are provided by Noctalia's BlueZ integration. Noctalia is the UI and BlueZ remains the system backend (`hardware.bluetooth.enable = true`); Bluetooth is not powered on automatically at boot. Pairing requests that need a PIN, passkey, or confirmation are handled by Noctalia's BlueZ agent. This replaces Blueman; it does not change the BlueZ backend or pairing setup. Hardware behavior has not been validated by configuration evaluation/build checks. The base configuration leaves the Bluetooth tab visible, but GUI overrides in `~/.local/state/noctalia/settings.toml` take precedence and may hide it; manage such overrides through Noctalia Settings, not by editing or deleting state files as part of this change.

### Configuration and GUI overrides

Home Manager generates the read-only base configuration at `~/.config/noctalia/config.toml`. Noctalia stores GUI overrides in the writable `~/.local/state/noctalia/settings.toml`; those overrides take precedence over the Home Manager base. A NixOS generation rollback does **not** roll back this user state. Preserve or back up the Noctalia state before downgrading Noctalia, and restore it separately if needed; do not edit the Nix-managed TOML or clear the state directory to troubleshoot.

Clipboard history is disabled. The theme setting here does not rewrite GTK, Qt, or application theme files, and the login greeter remains `greetd` with `tuigreet`.

The bar's volume and brightness widgets render their glyphs by default in Noctalia v5.3.0; their config schema has no `show_glyph` option, so only `show_label = false` is configured for the requested glyph-only appearance.

`noctalia config validate` (without a path) validates the merged active config, including state-directory overrides. Supplying a TOML file path validates only that file and does not check the complete active stack. Validation does not establish that a running shell has reloaded a change. `noctalia config export merged` prints merged configuration; treat its output as private because user settings can contain personal data.

### Displays, screenshots, and limitations

Niri continues to own output configuration and native screenshots. `nwg-displays`, its Niri window rule, and `wl-mirror` remain available for display management and mirroring; Noctalia does not add a display-switching menu or promise native mirroring. Keep the local `monitor.kdl` as machine-specific configuration. `Swayimg`, Xwayland support, and the existing application configuration are retained.

### Diagnostics

```bash
systemctl --user status noctalia
journalctl --user -u noctalia
noctalia config validate
```

Noctalia also writes `~/.cache/noctalia/noctalia.log`. Check the service and logs before changing configuration. The read-only check above validates configuration; it is not a substitute for checking actual hardware, lock/unlock, authentication, or multi-monitor behavior.

### Rollback

To return to a previous system generation, use the NixOS rollback action or boot an older generation from the boot menu, then start a fresh Niri login if necessary. The user may run `sudo nixos-rebuild switch --rollback` to switch to the previous generation. A live service handover can require logging out and back in. System generations do not revert `~/.local/state/noctalia`; preserve and restore Noctalia state separately when rolling back across Noctalia versions. Do not remove generations or clear user state as part of routine rollback.
