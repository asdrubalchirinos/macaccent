# macaccent

A simple Swift command-line tool to change your macOS system accent color to match the exclusive hardware colors of the newest MacBook Neo.

## Features

Apple includes special hardware-specific accent colors on modern Macs (like the MacBook Neo). This script uses undocumented macOS defaults to "trick" your system into simulating one of those hardware enclosure colors, giving you access to accent colors that aren't normally available in System Settings.

Currently supported colors:
- **Blush** (Color ID: 15)
- **Citrus** (Color ID: 16)
- **Indigo** (Color ID: 17)

## Usage

You can run the script directly using Swift:

```bash
swift macaccent.swift blush
swift macaccent.swift citrus
swift macaccent.swift indigo
swift macaccent.swift reset
```

Or you can compile it into a standalone executable:

```bash
swiftc macaccent.swift -o macaccent
./macaccent blush
```

## How It Works

1. **Modifying System Defaults**: The script runs two terminal commands via the macOS `defaults` utility:
   - `defaults write -g NSColorSimulateHardwareAccent -bool YES`
   - `defaults write -g NSColorSimulatedHardwareEnclosureNumber -int <ID>`
2. **Changing the Wallpaper**: The script uses AppleScript to automatically apply the corresponding MacBook Neo wallpaper from the local `wallpapers/` directory.
3. **Applying the Changes**: After updating preferences and wallpaper, the script uses AppleScript to gracefully quit Finder, reopens it, and restarts the Dock so the new colors take effect immediately.
4. **Resetting**: If you pass the `reset` argument, the script deletes the preference keys to return your Mac to its normal accent color behavior and reverts the wallpaper to the default macOS `Sonoma.heic`.

## Note on System Settings

Because this script uses undocumented generic macOS defaults (`NSColorSimulateHardwareAccent`) rather than standard user-facing settings, the active color won't actually be selected in the normal grid of Accent colors under **System Settings > Appearance**. The macOS interface itself will reflect the accent color.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
