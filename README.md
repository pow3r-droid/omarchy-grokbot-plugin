# Omarchy Grok Bot plugin

A small bar widget for the Omarchy 4 shell bar (`omarchy-shell`). It shows a hexagonal mission-patch badge in your theme colors. It pairs with [omarchy-grokbot-theme](https://github.com/pow3r-droid/omarchy-grokbot-theme).

> Community plugin, not affiliated with or endorsed by xAI, SpaceX, or Omarchy.

## What it does

- **Left click** toggles the Grok Bot drop-down panel (Hyprland special workspace `grokbot`). If no Grok Bot window is open, it launches Grok Bot instead.
- **Right click** launches Grok Bot (or brings it up).
- **Status dot**: filled cyan when a Grok Bot window (`grok-bot`) is open, hollow when it isn't. This reads Quickshell's Hyprland window list, so there's no polling and no background daemon.
- **Tooltip**: "Grok Bot".

## Install

```bash
omarchy plugin add https://github.com/pow3r-droid/omarchy-grokbot-plugin --enable
```

To move it: `omarchy bar move pow3r-droid.grokbot --section right`.
To update: `omarchy plugin update pow3r-droid.grokbot`. To remove: `omarchy plugin remove pow3r-droid.grokbot`.

The panel toggle expects the theme's `special:grokbot` window rule from omarchy-grokbot-theme v1.1+. Without that rule, left click still launches the app.

## Settings

| Key | Default | Meaning |
|---|---|---|
| `showStatusDot` | `true` | Show the open/closed dot |
| `launchCommand` | `grok-bot` | Command used to start the app |

## Development

`tests/check.sh` checks the manifest and README. If it runs on an Omarchy machine, it also runs `omarchy plugin validate`.

## License

MIT
