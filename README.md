# Kaffeine

A KDE Plasma 6 port of GNOME's Caffeine extension. Click the tray icon to toggle screen sleep on or off.

## Features

- Toggle screen sleep inhibition from the system tray
- Automatically adapts icon to light/dark mode
- No sudo required — uses the freedesktop ScreenSaver DBus interface
- Inhibition lifts automatically if Plasma crashes or the plasmoid is removed

## Installation

### Dependencies

```bash
sudo dnf install plasma5support    # Fedora
sudo apt install libplasma-dev     # Debian/Ubuntu (coming soon)
```

### Install

```bash
make dev-install
```

### Uninstall

```bash
make dev-uninstall
```

## Development

```bash
# Install and restart Plasma
make dev-install
plasmashell --replace &

# Package as .plasmoid
make plasmoid
```

## A note on AI-assisted development

KDE Plasma 6 is relatively new and documentation is sparse. Most online resources still reference Plasma 5 APIs, and the QML module structure changed significantly between versions. I used Claude (Anthropic) to help navigate the differences — things like the removal of `PlasmaCore.DataSource`, the split of `PlasmaCore` into `Kirigami`, `P5Support`, and `PlasmaComponents`, and how `plasma_install_package()` was dropped from CMake in favour of a plain `install(DIRECTORY ...)` call.

AI wasn't a shortcut — it was a resource to fill the gaps where official docs and community examples hadn't caught up to Plasma 6 yet.

## License

GPL-2.0-or-later