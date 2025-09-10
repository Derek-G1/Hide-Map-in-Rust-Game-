# Hide-Map-in-Rust-Game-
Custom OBS Script to Hide your map in the game Rust to stop from getting stream sniped

# OBS Map Cover Script for Rust

A Lua script for OBS Studio that instantly hides your map in Rust when pressing designated hotkeys. This script provides better response time than standard OBS hotkeys, ensuring your map is hidden immediately when needed.

## Features

- Instantly shows/hides a cover image when holding G or Shift+G
- **FIXED:** Includes a slight delay on release to prevent the map from flashing.
- Persists hotkey settings between OBS sessions
- Simple setup process

## Requirements

- **OBS Studio version 27.0.0 or newer is required** for the timer functionality.
- A cover image source set up in OBS

## Installation

1. Download the `rust-obs-map-hide.lua` script.
2. In OBS Studio, go to Tools -> Scripts.
3. Click the `+` button and select the downloaded script.
4. Configure the script settings (see Setup below).

## Setup

1. In OBS, create an image source that will cover your map:
   - Click the `+` under Sources.
   - Select "Image".
   - Name it "Map Hidden" (or your preferred name).
   - Choose any image (a solid color is recommended).
   - Position it to cover your map area.
   - Make sure it's hidden by default.

2. In the Scripts window:
   - Enter the exact name of your image source.
   - **Make sure the source name matches exactly (it's case-sensitive).**

3. Configure hotkeys:
   - Go to Settings -> Hotkeys.
   - Find "Show Map Cover (Hold G)" and set it to `G`.
   - Find "Show Map Cover (Hold Shift+G)" and set it to `Shift+G`.
   - Click Apply.

## Usage

- Hold `G` or `Shift+G` to show the cover image.
- Release the key to hide it.
- The cover will appear instantly and disappear after a brief delay to prevent flickering.

## Troubleshooting

If the script isn't working:
1. Make sure the image source name in the script settings **perfectly matches** the source name in your OBS scene.
2. Verify the hotkeys are properly set in OBS Settings -> Hotkeys.
3. Check the Scripts log window for any error messages (`Tools -> Scripts -> Log`).
4. Ensure you are running OBS Studio version 27.0.0 or newer.

## License

MIT License - Feel free to use and modify as needed.

## Contributing

Feel free to open issues or submit pull requests if you have suggestions for improvements.
