# Noctalia Desktop Shell Migration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking. The user selected **GPT-6 Luna for implementation and GPT-5.6 Terra for review**. This document is awaiting user approval; writing it does not authorize execution.

**Goal:** Replace tofu's fragmented desktop shell with Noctalia while retaining Niri, existing applications, system services, and a recoverable NixOS configuration.

**Architecture:** Install the pinned upstream Noctalia v5 package and Home Manager module, with a single session-scoped systemd user service. Noctalia owns shell surfaces, notifications, locking, idle, and Polkit; Niri retains window management and outputs. Keep configuration minimal and declarative, with writable GUI overrides owned by Noctalia.

**Tech Stack:** NixOS 26.05, Home Manager release-26.05, Niri, Noctalia v5.3.0 (native Wayland, not Quickshell), Nix flakes, KDL, TOML, systemd user services.

**Spec:** This document's [Design baseline](#design-baseline), derived from the conversation; no separate approved spec exists. Scope/defaults below must be approved before execution.

## Global Constraints

- Working repository: `/home/tofu/Projects/dotnix`; architecture: `x86_64-linux`; user: `tofu`; hosts: `dell`, `e14`, `t14`.
- Keep Niri, `greetd + tuigreet + niri-session`, Fcitx5, applications, cursor/icon/GTK configuration, PipeWire, NetworkManager, Bluetooth, UPower, and `auto-cpufreq`.
- Fully retire Waybar, Fuzzel, SwayNC, Wlogout, Swaylock, Swayidle, and Soteria from the final shell configuration after their replacement is verified. Do not delete Swayimg.
- Lock at **600 seconds**, screen off at **601 seconds**, screen on when activity resumes; lock before suspend; **no new auto-suspend policy**, passwordless unlock grace **0 seconds**.
- Preserve `Mod+L { focus-column-right; }`; use **Mod+Escape** for manual lock.
- Pin `github:noctalia-dev/noctalia/v5.3.0`; use its own nixpkgs dependency initially; do not update unrelated inputs or enable a new binary cache/trusted key without consent.
- Do not enable `power-profiles-daemon` or `tuned` alongside the existing `auto-cpufreq` policy. Do not change lid/logind policy or UPower critical battery behavior.
- No custom QML, shell menu scripts, display-management daemon, third-party plugins, or Quickshell/v4 configuration.
- Keep `nwg-displays`, its Niri rule, and `wl-mirror` until there is a separately approved and verified replacement; do not alter `monitor.kdl` or promise native mirroring.
- No greeter migration, automatic application-theme rewriting, clipboard history, external accounts, weather, or calendar in this core plan.
- Do not run `nixos-rebuild switch`, reboot, log out, stop the user's running services, or lock/suspend their session without explicit user consent.
- Do not commit without user permission. Commit steps below are suggested checkpoints, not standing permission to stage or commit user work.
- At planning time, `git status --short` reports pre-existing **modified `flake.lock`** and **untracked `.opencode/`**. Reinspect before execution; preserve both, stage only attributable hunks, never reset/revert them.

## Review Focus

1. Existing Niri navigation: new shortcuts must not shadow `Mod+L`, workspace, gestures, screenshot, or application bindings; automated file assertions and a Niri parser check belong to Task 2.
2. Sleep, locked-state input, and authentication: native lock must be established before suspend, unlock must use working PAM, and brightness/audio must work without opening panels while locked; configuration assertions plus consented runtime tests belong to Tasks 2 and 4.
3. Service restarts/session boundaries: exactly one shell/notification/Polkit owner, correct Niri/Wayland environment, and launched apps surviving shell restart; service assertions and a consented runtime gate belong to Tasks 2 and 4.
4. Read-only configuration and existing GUI state: GUI settings must remain writable and take precedence visibly without corrupting Nix files; configuration validation and persistence/rollback tests belong to Tasks 1 and 4.
5. Disconnected external displays, multiple outputs, and fractional scaling: shell surfaces/lock must remain usable without rewriting output configuration; retained-file assertions and physical-device tests belong to Tasks 3 and 4.

---

## Design baseline

### Intent and ownership

The user wants fewer independently configured desktop tools, mainstream Niri integration, and minimal local code. They chose Noctalia after considering both a hand-written presentation menu and DMS. The destination is one desktop shell, not replacement of the compositor or system services.

Approaches considered:

1. Keep the current stack and add Fuzzel/scripts: rejected because it adds maintenance and does not meet the consolidated-shell goal.
2. DMS/Dux: viable alternative, but the user selected Noctalia.
3. **Noctalia core replacement**: chosen direction. This plan proposes a pinned v5 release, retains working backends, and removes obsolete shell configuration once runtime gates pass.

Additional changes discussed but **not selected**: Noctalia Greeter instead of tuigreet; Noctalia taking over application-theme files; clipboard history; third-party display/mirror plugins. These are independent follow-ups, not silent additions to "complete migration". If the user wants any included, revise the scope before execution.

### Exact initial configuration

Set only the following Noctalia settings; leave other built-in defaults implicit:

- `shell.font_family = "JetBrainsMono Nerd Font"`.
- `shell.polkit_agent = true`.
- `shell.clipboard_enabled = false`; do not install another history daemon.
- `shell.telemetry_enabled = false`.
- `shell.niri_overview_type_to_launch_enabled = false`.
- `theme.mode = "light"`, `theme.source = "builtin"`, `theme.builtin = "Catppuccin"` (planner-proposed defaults, matching the current light-oriented shell colors).
- `theme.templates.enable_builtin_templates = false`, `enable_community_templates = false`; no user templates.
- `bar.main.position = "top"`, `reserve_space = true`, `compositor_blur = false`, `margin_ends = 0`.
- `bar.main.start = [ "workspaces" ]`.
- `bar.main.center = [ "clock" "notifications" ]`.
- `bar.main.end = [ "tray" "bluetooth" "network" "volume" "brightness" "battery" "control-center" "session" ]`.
- `wallpaper.enabled = false`, `backdrop.enabled = false`, `dock.enabled = false`, `desktop_widgets.enabled = false`.
- `calendar.enabled = false`, `weather.enabled = false`, `nightlight.enabled = false`.
- `lockscreen.enabled = true`, `lockscreen.grace_period_seconds = 0`.
- `idle.behavior.lock = { enabled = true; timeout = 600; action = "lock"; }`.
- `idle.behavior.screen-off = { enabled = true; timeout = 601; action = "screen_off"; }`.
- `idle.pre_action_fade_seconds = 0` to avoid delaying the closely spaced 600/601-second events.
- No suspend idle behavior.

CPU/RAM bar widgets are deliberately not promised: the approved goal is consolidation, not a pixel-for-pixel clone. They can be added from the GUI later. Niri's existing plain background remains; Noctalia's wallpaper UI may be enabled later without introducing another wallpaper daemon.

The module's build-time validator must accept these exact keys against v5.3.0. Warnings are reviewed, not treated as harmless success. If a pinned key above is invalid, report the mismatch and propose a correction rather than silently ignoring it.

### Configuration ownership

- Home Manager: `~/.config/noctalia/config.toml`, generated from `programs.noctalia.settings`.
- Noctalia: `~/.local/state/noctalia/settings.toml` (GUI overrides, higher precedence), other runtime/cache files.
- Never put Noctalia's writable state into the Nix store or clear pre-existing overrides automatically.
- A rollback of NixOS generations does not roll back user state. Record/back up existing state before consented runtime tests and preserve it for downgrade recovery.

### Session and security ownership

Use the upstream **Home Manager service only**, not Niri `spawn-at-startup` and not a parallel NixOS service. Scope it to `niri.service`: `PartOf`, ordering `After`, and `WantedBy` must resolve to the Niri session unit. Use `Restart=on-failure` inherited from upstream. Ensure the service sees the environment populated by `niri-session` without hardcoding `WAYLAND_DISPLAY` or `NIRI_SOCKET`.

Upstream v5.3.0 authenticates the lock screen against PAM **`login`** (`src/shell/lockscreen/lock_screen.cpp`). Do not invent `security.pam.services.noctalia`. Inspect the evaluated login stack; retain existing system authentication policy. Remove the obsolete Swaylock PAM declaration only with its retirement.

Noctalia owns the Polkit agent; Soteria must not run alongside it. Noctalia must honor idle inhibitors and acquire lock before logind-triggered suspend; confirm the actual v5.3.0 implementation, not just current online docs. If secure suspend is not achievable using its native facilities, stop and seek approval rather than shipping an unlocked transition or adding a bespoke watcher.

### Keybinding contract

Use KDL `spawn "noctalia" "msg" ...`, not `spawn-sh`. Resolve IPC spelling using **tagged** v5.3.0 docs and `noctalia msg --help` from the built package. Required user-facing contract:

| Key | Required command/behavior |
| --- | --- |
| `Mod+D` | `noctalia msg panel-toggle launcher` |
| `Mod+Shift+E` | `noctalia msg panel-toggle session` |
| `Mod+Escape` | `noctalia msg session lock`, `repeat=false` |
| `Mod+Comma` | `noctalia msg settings-toggle`, `repeat=false` |
| `Mod+S` | `noctalia msg panel-toggle control-center`, `repeat=false` |
| `XF86AudioRaiseVolume` / `LowerVolume` | `noctalia msg volume-up` / `volume-down` |
| `XF86AudioMute` | `noctalia msg volume-mute` |
| `XF86AudioMicMute` | `noctalia msg mic-mute` |
| `XF86MonBrightnessUp` / `Down` | `noctalia msg brightness-up` / `brightness-down` |

Keep all six existing media keybindings `allow-when-locked=true`. Use Noctalia's native step sizes for media/brightness (output volume defaults to 5%); this is a deliberate minimal-config choice, not a guarantee of the old 2% increments or pamixer's explicit unmute-before-adjust behavior. Do not override `Alt+Tab`, Niri screenshots, or navigation. Remove the obsolete `LAUNCHER "fuzzel"` environment entry; bindings call Noctalia directly, so a multiword command in `LAUNCHER` is unnecessary.

### Versioned upstream references

- `https://github.com/noctalia-dev/noctalia/releases/tag/v5.3.0`
- `https://raw.githubusercontent.com/noctalia-dev/noctalia/v5.3.0/flake.nix`
- `https://raw.githubusercontent.com/noctalia-dev/noctalia/v5.3.0/nix/home-module.nix`
- `https://raw.githubusercontent.com/noctalia-dev/noctalia/v5.3.0/nix/package.nix`
- `https://raw.githubusercontent.com/noctalia-dev/noctalia/v5.3.0/example.toml`
- Tagged docs: `docs/user/ipc/{shell,surfaces,system-controls}.mdx` and `docs/user/compositor-settings/niri.mdx` in that repository.
- Current docs explain concepts but may move beyond the pinned release: `https://docs.noctalia.dev/noctalia/configuration/`.

## File structure and boundaries

### Create

- `home/tofu/desktop/niri/noctalia.nix`: Home Manager shell configuration, package/module integration, and session-scoped service settings. Do not split this small module into per-widget files.
- `tests/noctalia-eval.nix`: lazy groups of Nix evaluation assertions for all three hosts; no VM/QML test framework or flake restructuring.

### Modify

- `flake.nix:4-15,17-24,43`: input `noctalia`, outputs argument, NixOS `specialArgs` forwarding.
- `flake.lock`: add only the new dependency graph, preserving existing edits and unrelated locked nodes.
- `profiles/tofu.nix:1,20-24`: accept `noctalia`; pass `home-manager.extraSpecialArgs = { inherit noctalia; };`.
- `home/tofu/desktop/niri/default.nix:4-9,17-30`: import Noctalia; retire shell imports; keep screen tools, Xwayland, and application imports.
- `home/config/niri/config.d/app.kdl:1-13`: binding contract and removal of stale launcher variable.
- `home/config/niri/config.d/media.kdl:1-28`: IPC media controls, preserving locked-key flags.
- `home/config/niri/config.d/layout.kdl`: add a floating Settings rule for exact app ID `dev.noctalia.Noctalia`, width 1080 and height 920 logical pixels; retain all current application rules and corner radius.
- `modules/desktop/niri.nix:10-11`: disable Soteria and retire Swaylock PAM registration.
- `README.md`: installation, controls, GUI override precedence, consented acceptance procedure, rollback, and limitations.

### Delete only in retirement task after consented runtime acceptance

- `home/tofu/desktop/niri/{fuzzel,swayidle,swaylock,swaync,waybar,wlogout}.nix`.
- `home/config/swaync/config.json`, `home/config/swaync/style.css`.
- `home/config/waybar/config.jsonc`, `home/config/waybar/style.css`.
- All 11 tracked `home/config/waybar/modules/*.jsonc`: `backlight`, `battery`, `bluetooth`, `clock`, `cpu`, `memory`, `network`, `notification`, `pulseaudio`, `tray`, `workspaces`.
- Check `git ls-files home/config/waybar home/config/swaync` before deletion; investigate additional files or edits instead of deleting entire directories blindly.

Do not modify `appearance.nix`, `extras.nix`, `login.nix`, output configuration, focus/workspace/screenshot/gesture files, host hardware files, or existing power services. `libnotify` is currently installed by `swaync.nix`; relocate it into the new module to retain `notify-send` for applications and diagnostics.

## Test harness contract

`tests/noctalia-eval.nix` is a plain Nix expression, returning an attribute set of **lazy groups**. Use `builtins.getFlake (toString ../.)`, `lib` from a host's evaluated configuration, and `hosts = [ "dell" "e14" "t14" ]`. Define `allHosts = predicate: builtins.all (host: predicate flake.nixosConfigurations.${host}.config) hosts;`. Each group runs assertions and returns literal `true`. Do not force later groups while running an earlier one.

Run one group with:

```bash
nix eval --impure --json --file tests/noctalia-eval.nix --apply 'checks: checks.packaging'
```

Expected after its implementation: `true`, exit 0. Run the whole expression with the same command without `--apply`; all named groups must be `true`.

Git flakes exclude untracked files: before evaluation, obtain permission to stage **only newly created implementation/test files**, or use an explicitly documented `path:/absolute/worktree` flake for diagnostic runs. Do not stage unrelated user files. If using the path form, make the harness accept an explicit `DOTNIX_TEST_FLAKE` environment variable with default `toString ../.`; resolve with `builtins.getEnv` under `--impure`. Do not silently test a different repository/worktree.

---

### Task 1: Pin and package Noctalia without activating another shell

**Files:**
- Create: `home/tofu/desktop/niri/noctalia.nix`, `tests/noctalia-eval.nix`.
- Modify: `flake.nix`, `flake.lock`, `profiles/tofu.nix`, `home/tofu/desktop/niri/default.nix`.

**Interfaces:**
- Consumes: `home-manager` flake input and shared host/profile imports already in the repository.
- Produces: `noctalia` special argument at NixOS and Home Manager scopes; enabled `programs.noctalia`, installed upstream v5.3.0 package; `checks.packaging`.
- At this checkpoint `programs.noctalia.systemd.enable = false`, and no Noctalia autostart exists; old tools still own the live shell. This is a packaging-only checkpoint, not a migration to activate.

- [ ] **Step 1: Establish a safe baseline.** Read `git status --short`, `git diff -- flake.lock`, current relevant files, and any newly introduced AGENTS instructions. Record the original lock graph and changed-file list. Create an isolated worktree only when permitted and preserve user changes; do not assume the dirty lockfile can be discarded or omitted from the dependency baseline.
- [ ] **Step 2: Write `packaging` assertions.** In the harness, add these exact checks, using `or false`/`or ""` for missing options so the failure is meaningful:

```nix
packaging =
  assert allHosts (c: c.home-manager.users.tofu.programs.noctalia.enable or false);
  assert allHosts (c: c.home-manager.users.tofu.programs.noctalia.checkConfig or false);
  assert allHosts (c: (c.home-manager.users.tofu.programs.noctalia.package.version or "") == "5.3.0");
  true;
```

- [ ] **Step 3: Run `checks.packaging` before implementation.** Expected: assertion failure because Noctalia is not enabled. A missing Nix executable, network failure, or unrelated baseline evaluation error is a blocker, not the intended red test.
- [ ] **Step 4: Wire the pinned input.** Add `inputs.noctalia.url = "github:noctalia-dev/noctalia/v5.3.0"`, forward `noctalia` through `specialArgs` and `home-manager.extraSpecialArgs`, import `noctalia.homeModules.default` from the new module, and enable it with `checkConfig = true`, service disabled for this checkpoint. Do not import the NixOS Noctalia module or recommendedServices preset. Do not use `.follows = "nixpkgs"` for this input yet.
- [ ] **Step 5: Resolve only the new dependency graph.** Run the installed Nix version's minimal lock operation (`nix flake lock` should add the missing input without upgrading existing ones). Compare existing node names and locked values with the recorded baseline. Any unrelated node change must be explained and removed surgically without discarding user edits.
- [ ] **Step 6: Run the packaging test and build the shell.** Expected packaging result: `true`. Build the configured package via `nix build --no-link '.#nixosConfigurations.e14.config.home-manager.users.tofu.programs.noctalia.package'`. Expected: exit 0. No `switch`.
- [ ] **Step 7: Save a focused checkpoint.** If commits are authorized, commit only attributable input/module/test changes with `build: pin Noctalia v5.3.0 for the shared Niri desktop`. Otherwise report the exact patch without committing. Do not include `.opencode/` or unrelated lock edits.

### Task 2: Make Noctalia the only configured desktop shell

**Files:**
- Modify: `tests/noctalia-eval.nix`, `home/tofu/desktop/niri/noctalia.nix`, `home/tofu/desktop/niri/default.nix`, `home/config/niri/config.d/{app,media,layout}.kdl`, `modules/desktop/niri.nix`.

**Interfaces:**
- Consumes: Task 1's enabled module/package, v5.3.0 tagged IPC/config interfaces.
- Produces: lazy `checks.session` and `checks.bindings`; configured Noctalia settings described above; one `systemd.user.services.noctalia` unit bound to Niri; all old shell services disabled in evaluated config, old files temporarily retained for recovery.
- `home-manager.users.tofu.programs.noctalia.settings` remains a Nix attribute set, not a raw TOML string, so assertions can inspect values.

- [ ] **Step 1: Add failing `session` assertions.** For every host, assert service enablement, exact 600/601 actions/timeouts, fade 0, grace 0, Polkit true, clipboard/telemetry false, templates disabled, light Catppuccin theme, bar position and widget arrays from the design. Assert `programs.waybar.enable`, `programs.fuzzel.enable`, `services.swaync.enable`, `services.swayidle.enable`, `programs.swaylock.enable`, and `programs.wlogout.enable` are false (use `or false` when absent), `security.soteria.enable` is false, and `security.pam.services` has no `swaylock` key. Assert NetworkManager/Bluetooth/UPower/auto-cpufreq remain enabled, `power-profiles-daemon` and tuned remain disabled, and UPower `criticalPowerAction == "PowerOff"`. Assert no suspend idle behavior exists.
- [ ] **Step 2: Add failing service/binding checks.** Assert the Noctalia unit's `PartOf`, `After`, and `Install.WantedBy` are exactly `[ "niri.service" ]`, and that its `ExecStart` resolves to the configured package's binary. Check that concatenated Niri config has no Noctalia `spawn-at-startup`. Check exact application bindings in the contract, no `LAUNCHER "fuzzel"`, preserved focus `Mod+L`, screenshot commands, and all six locked media flags. Save the current hashes of untouched focus, workspace, screenshot, gestures, and application-appearance files for later comparison. Check `libnotify` remains in the user's explicit packages.
- [ ] **Step 3: Run the two new groups separately.** Expected: `checks.session` fails because Noctalia has no service/settings and legacy tools remain enabled; `checks.bindings` fails because bindings still call Fuzzel/Wlogout. Do not count Task 1 packaging success as a substitute.
- [ ] **Step 4: Implement the new shell ownership.** Populate the exact initial settings, enable the upstream Home Manager service, and override its three Unit/Install lists with `lib.mkForce [ "niri.service" ]` where necessary. Keep `ExecStart`/restart policy upstream-owned. Stop importing the six old shell modules; add `pkgs.libnotify` to the new module's packages. Remove Soteria enablement and Swaylock PAM registration. Keep pamixer/brightnessctl until dependency review in Task 3, and keep all screen-management packages.
- [ ] **Step 5: Implement bindings and Settings rule.** Preserve browser/terminal bindings, remove only the obsolete launcher environment variable, and implement the exact table above (media verbs were verified against tagged v5.3.0 docs). Assert these literal verbs in the binding tests. Keep current navigation, screenshots, application rules, and `allow-when-locked` flags. Do not enable broad invalid-serial activation or blur debug settings without a demonstrated need and consent.
- [ ] **Step 6: Verify secure native integration before runtime activation.** Read the v5.3.0 lock/logind implementation and confirm how it obtains sleep inhibitors and locks for externally requested suspend. Evaluate `security.pam.services.login` rather than introducing a new PAM service. If the native path cannot meet lock-before-suspend or user apps are tied to the shell's service cgroup, report the issue and resolve it using documented settings; do not hand-wave either gate.
- [ ] **Step 7: Run all evaluation checks and build the generated TOML.** `nix eval --impure --json --file tests/noctalia-eval.nix` must report all current groups true. Build `'.#nixosConfigurations.e14.config.home-manager.users.tofu.xdg.configFile."noctalia/config.toml".source'`; expected exit 0 and no ignored-key warnings. Obtain its store path with `nix eval --raw` and review that TOML contains no secrets or extra defaults.
- [ ] **Step 8: Validate Niri and all three host closures.** Use the exact Niri package configured for e14 to run `niri validate --config "$PWD/home/config/niri/config.kdl"`; optional machine-local monitor config is intentionally absent from this parser test. Evaluate toplevel `.drvPath` for all three hosts, then build each host with `nix build --no-link .#nixosConfigurations.<host>.config.system.build.toplevel`. Expected exit 0; build/network failures are documented, not mislabeled as passing. Activation is still prohibited without consent.
- [ ] **Step 9: Save a focused checkpoint.** Suggested message, only if authorized: `feat: replace the shared Niri shell with Noctalia`. Explain that legacy files are inactive but retained until the runtime gate; do not claim hardware acceptance yet.

### Task 3: Verify replacement and retire obsolete files

**Files:**
- Modify: `tests/noctalia-eval.nix`, `home/tofu/desktop/niri/default.nix`, `README.md`.
- Delete: the exact legacy files listed in File structure, after the runtime gate.

**Interfaces:**
- Consumes: Task 2's successfully built configuration and the user's approval to test it on a named host.
- Produces: `checks.retirement`, no imported or orphaned old shell configuration, preserved output tools and non-shell applications, an initial README usage/rollback section.
- No final old-file deletion until lock/idle/Polkit/session smoke tests below pass. If the user cannot test now, leave this task pending and ask Terra to review the built but not runtime-accepted state.

- [ ] **Step 1: Request a bounded runtime test window.** Ask which host to activate, ensure TTY access and the previous NixOS generation are available, and back up existing Noctalia GUI state only with consent. Do not GC old generations/store paths. Apply only after the user explicitly authorizes activation. Prefer a fresh graphical login after activation over stopping multiple live daemons in place.
- [ ] **Step 2: Run the security/session smoke gate.** Confirm one Noctalia process, one notification owner, one Polkit agent, working manual lock/unlock, locked audio/brightness controls without leaking desktop panels, and correct Polkit authentication. Test `loginctl lock-session` and consented `systemctl suspend`/resume including lid suspend. Monitor must not show the unlocked desktop before authentication. Confirm lock precedes suspend; confirm the 600/601-second sequence without silently changing the committed policy. Any failure blocks retirement.
- [ ] **Step 3: Write failing retirement assertions.** Assert each enumerated legacy file no longer exists. Assert no references to the six old module filenames occur in Niri imports and no remaining shell configuration invokes Fuzzel, Wlogout, Swaylock, Swayidle, Waybar, SwayNC, or `swaync-client`. Scope textual checks to executable configuration and imports, not README/history. Assert `nwg-displays`, `wl-mirror`, `xwayland-satellite`, `libnotify`, and existing application imports remain. Check untouched files against recorded hashes. Include `swayimg` as a positive retained-application check.
- [ ] **Step 4: Run the retirement group.** Expected assertion failure because inactive legacy files still exist.
- [ ] **Step 5: Remove only enumerated obsolete tracked files.** Inspect diffs first; do not delete files with unincorporated user edits. Remove pamixer/brightnessctl from explicit packages only if a repository reference search and Noctalia native backend review demonstrate no remaining need; indirect package dependencies are fine. Preserve all screen tools/rules. Inspect `git diff --stat` and `git diff --check` for accidental broad deletion.
- [ ] **Step 6: Write the operational README.** Explain the new shortcuts, service name, GUI override precedence and state paths, default clipboard-history disablement, unchanged login and app theming, native Niri screenshots, and retained display tools. Include `systemctl --user status noctalia`, `journalctl --user -u noctalia`, `~/.cache/noctalia/noctalia.log`, `noctalia config validate`, and the distinction between a config file validation and effective GUI-overridden configuration.
- [ ] **Step 7: Verify and checkpoint.** Whole harness must show all groups true; `git diff --check` must exit 0; rebuild all affected hosts after package removal. Suggested authorized commit: `refactor: retire obsolete desktop shell configuration`.

### Task 4: Acceptance evidence, rollback instructions, and Terra review

**Files:**
- Modify: `README.md` only for generic acceptance/rollback instructions, not personal runtime data.
- Review: all implementation diffs, `tests/noctalia-eval.nix`, generated TOML/unit, lockfile delta, three host build results.

**Interfaces:**
- Consumes: Task 3's retired stack, evaluation/build evidence, user-approved runtime window.
- Produces: a completion report separating automated checks from hardware acceptance, portable rollback instructions, and independent Terra findings. Do not create extra report files in the user's repo without permission.

- [ ] **Step 1: Test the normal desktop path.** Launcher opens Firefox/Alacritty, Fcitx5 input works, notifications can be invoked/focused, tray menus function, network/Bluetooth UI works without auto-enabling Bluetooth at boot, battery and audio/mic state are correct, screenshots/navigation remain Niri-owned.
- [ ] **Step 2: Test session lifecycle, explicitly unlocked.** Launch a terminal/app from Noctalia, then with consent restart `noctalia.service` while unlocked; the application must survive and the shell must recover without duplicates. Log out/in and confirm one fresh shell and service environment for the new Niri session. If app survival fails, use the tagged native app-launch/systemd-scope setting if available; otherwise stop and propose the smallest lifecycle correction for approval.
- [ ] **Step 3: Test multi-monitor and lock coverage.** Plug/unplug an external display, change scaling using existing tools, and lock with both outputs attached. Each connected output must be protected, controls remain usable after reconnect, and `monitor.kdl` must not be rewritten. Do not interpret this as a mirror test or promise a Win+P menu.
- [ ] **Step 4: Test GUI state persistence and rollback boundaries.** Change one harmless visual setting through GUI, restart unlocked, and confirm persistence without writing to the Nix-managed TOML. Inspect effective config with `noctalia config validate` and export privately, never commit the full export. Demonstrate that the GUI value overrides the base; remove only that test override through the GUI. Do not reset all state. Document backup/restore of state for a version downgrade and that old generations do not undo it.
- [ ] **Step 5: Finish rollback documentation.** Provide user-run `sudo nixos-rebuild switch --rollback` and older-generation boot instructions with a fresh Niri login; note live service handover can require logout. Preserve current generation numbers locally in the handoff, not as universal README commands. Do not execute rollback merely to demonstrate it unless separately authorized. Keep legacy files in Git history, not a second live shell.
- [ ] **Step 6: Re-run automated evidence on the final diff.** Run all harness groups, the Niri validator, Noctalia config validation, `git diff --check`, and builds for `dell`, `e14`, `t14`. Record actual commands/results. Unsupported hardware tests remain explicitly `NOT RUN`, not guessed PASS.
- [ ] **Step 7: Independent review with GPT Terra.** Resolve exact model IDs again if necessary. The catalog at planning time identified implementer `openai/gpt-6-luna` and reviewer `openai/gpt-5.6-terra`. Ask the reviewer to inspect the plan, final diff, user-owned lock changes versus implementation delta, all five Review Focus items, and test outputs. Review is read-only: no activation, fixes, or commits by the reviewer. Findings must include severity, file/line, reproduction/impact, and missing evidence. Absence of runtime evidence is not a successful hardware acceptance.
- [ ] **Step 8: Address findings through Luna and re-review.** Implement only in-scope fixes, add regression assertions where meaningful, and repeat affected verification. New scope or unsafe suspend/PAM behavior requires user input. Suggested authorized documentation checkpoint: `docs: document Noctalia controls and recovery`.
- [ ] **Step 9: Deliver the outcome.** List replaced components, kept exceptions, exact pinned release, all passing checks, remaining manual gates, and rollback instructions. A build-only result is "implementation built; runtime acceptance pending", not "migration complete".

## Execution handoff

**Implementer:** `openai/gpt-6-luna` — use the executing-plans workflow inline, or an implementation child session if the user approves that arrangement. Follow tasks in order; respect runtime and deletion gates. No agent should treat this plan as approval to switch the running desktop.

Skill availability is session-dependent. If a named workflow skill is unavailable at execution time, do not invoke a missing skill or invent its tool ID; follow this document's explicit checklist, permission gates, and test/review procedure directly.

**Reviewer:** `openai/gpt-5.6-terra` — independent final review after implementation, and targeted follow-up review after fixes. The user has selected a review model, not authorized a swarm of per-task subagents; do not launch extra reviewers by default.

**Suggested implementer prompt:**

> Read `docs/superpowers/plans/2026-10-22-noctalia-migration.md` in the repository. After the user approves it and leaves Plan mode, implement Tasks 1–4 in order using executing-plans. Preserve existing user changes, especially the dirty lockfile and `.opencode/`. Do not activate NixOS, stop live services, lock/suspend the machine, delete edited legacy files, or commit without explicit permission. Stop at runtime gates and provide exact commands/evidence for the user's test. Request read-only review from `openai/gpt-5.6-terra` when ready.

**Suggested reviewer prompt:**

> Review the Noctalia migration against `docs/superpowers/plans/2026-10-22-noctalia-migration.md` in the repository. Read the actual diff and test outputs; do not rely on the implementer's summary. Concentrate on session lifecycle/cgroups, lock-before-suspend/PAM, single-owner services, immutable config with writable GUI state, pinned v5 APIs, all three hosts, preservation of user-owned changes, and retained display functionality. Report actionable findings with severity and file/line; identify untested runtime gates. Do not edit files or execute disruptive runtime commands.

## Planner self-review

- Scope coverage: the complete *shell* migration is covered by Tasks 1–3; optional login/theme/mirroring projects remain explicitly outside this plan.
- Step scan: each implementation task has a red assertion group, a defined configuration change, verification, and a permission-gated checkpoint. Runtime evidence is not replaced by fake automated assertions.
- Interface consistency: one `noctalia` input/special argument, one `programs.noctalia` module, one `noctalia.service`, four lazy test groups `packaging`, `session`, `bindings`, and `retirement`; exact group selection is documented.
- Review Focus: all five conditions have an owning test step and manual gates where hardware/active session access is required.
- Known unresolved points are explicit execution gates, not implementation choices hidden behind "handle edge cases": secure external-suspend handling, app cgroup survival, dependency availability/builds, and actual hardware acceptance.
- This plan was initially prepared outside the repository, then moved to `docs/superpowers/plans/` at the user's explicit request. No implementation files were edited.
