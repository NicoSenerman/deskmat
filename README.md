# deskmat

A fullscreen Wayland cheat sheet overlay for your desktop. Like a physical deskmat, but interactive.

Built with GTK4 + Layer Shell. Themed in Monokai Pro. Integrates with [tldr](https://github.com/tldr-pages/tldr) for deep-dive command lookups.

<!-- TODO: Add screenshot here -->
<!-- ![deskmat screenshot](screenshots/deskmat.png) -->

## Features

- **~370 commands** across 24 collapsible sections (Linux, Git, Docker, Dev Tools, WM keybinds, and more)
- **Click any command** to see its full `tldr` page in a styled popup
- **Live search** — type to filter commands across all sections, with match counts per section
- **Search + Enter** — look up *any* command via tldr, even if it's not in the curated list
- **Monokai Pro** color scheme with semi-transparent background
- **Two-column layout** with three-field rows: command, description, example
- **Fully customizable** via YAML config — add your own commands, change colors, swap sections
- **Zero window management** — renders as a Wayland layer surface (like a bar or notification), not a window
- **Toggle on/off** with a single keybind — running `deskmat` again kills the existing instance

## Dependencies

- Python 3.8+
- GTK4 (`gtk4`)
- gtk4-layer-shell (`gtk4-layer-shell`)
- PyGObject (`python-gobject`)
- [tealdeer](https://github.com/dbrgn/tealdeer) for tldr integration (optional but recommended)
- PyYAML (`python-pyyaml`) — only needed if using a config file

### Arch Linux

```bash
sudo pacman -S gtk4 gtk4-layer-shell python-gobject python-pyyaml tealdeer
tldr --update  # populate the cache
```

### Other distros

Install the equivalent packages. The key requirement is `gtk4-layer-shell` — this is what allows the overlay to render as a layer surface on Wayland.

## Install

```bash
# Clone the repo
git clone https://github.com/NicoSenerman/deskmat.git
cd deskmat

# Install to ~/.local/bin (or run the install script)
./install.sh

# Or manually:
cp deskmat ~/.local/bin/deskmat
chmod +x ~/.local/bin/deskmat
```

## Usage

```bash
# Launch the overlay
deskmat

# Toggle (running again kills the existing instance)
deskmat

# Use a custom config
deskmat --config ~/my-cheatsheet.yaml

# Show version
deskmat --version
```

### Bind to a key (Hyprland example)

Add to `~/.config/hypr/hyprland.conf`:

```ini
bind = $mainMod, F5, exec, ~/.local/bin/deskmat
```

### Bind to a key (Sway example)

Add to `~/.config/sway/config`:

```
bindsym $mod+F5 exec ~/.local/bin/deskmat
```

## Keyboard Shortcuts

| Key | Action |
|-----|--------|
| `ESC` | Close overlay (layered: dismiss popup → clear search → close) |
| `E` | Expand all sections |
| `C` | Collapse all sections |
| `/` | Focus search bar |
| `ENTER` | (in search) Look up command via tldr |
| Click command | Show tldr page for that command |

## Configuration

Deskmat works out of the box with built-in defaults. To customize, create a config file:

```bash
mkdir -p ~/.config/deskmat
cp config.example.yaml ~/.config/deskmat/config.yaml
```

Then edit `~/.config/deskmat/config.yaml`. The config file lets you:

- **Add/remove/reorder commands** — the YAML structure mirrors what you see on screen
- **Customize the Window Manager section** — replace the default Hyprland keybinds with your own
- **Override colors** — change any color in the Monokai Pro palette
- **Change the font** — set `font_family` to any monospace font
- **Adjust opacity** — set `opacity` between 0.0 and 1.0
- **Set column widths** — `cmd_width` and `desc_width` control the layout

See `config.example.yaml` for the full structure with comments.

### Config structure

```yaml
# Appearance
font_family: "MesloLGS NF"
opacity: 0.92

# Two columns, each with categories → sections → groups → commands
left:
  - category: "Linux Core"
    accent: cyan          # red, orange, yellow, green, cyan, purple, or #hex
    sections:
      - title: "Navigation & Files"
        expanded: true    # start expanded?
        groups:
          - name: "Moving Around"
            commands:
              - cmd: "cd dir"
                desc: "Enter directory"
                example: "cd ~/Projects"
```

## How it works

Deskmat uses [gtk4-layer-shell](https://github.com/wmww/gtk4-layer-shell) to render as a `zwlr_layer_surface_v1` on Wayland. This means:

- It's **not a window** — your window manager doesn't see it, there are no window rules to configure
- It sits on the **overlay layer**, above all windows (like a bar or notification daemon)
- It grabs **exclusive keyboard input** while visible
- On Arch Linux, `LD_PRELOAD` is required to load the library before GTK4 initializes — the script handles this automatically

## Project structure

```
deskmat/
├── deskmat               # Main script (single file, no dependencies beyond system packages)
├── config.example.yaml   # Example config with all built-in commands
├── install.sh            # Install script
├── LICENSE               # MIT
└── README.md
```

## Contributing

PRs welcome! Some ideas:

- Additional command sections (Kubernetes, Terraform, Vim, etc.)
- More color themes (Catppuccin, Gruvbox, Nord, etc.)
- Fuzzy search
- Config hot-reload
- AUR package

## License

MIT
