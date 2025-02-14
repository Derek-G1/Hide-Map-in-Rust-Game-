# Hide-Map-in-Rust-Game-
Custom OBS Script to Hide your map in the game Rust to stop from getting stream sniped

# OBS Map Cover Script for Rust

A Lua script for OBS Studio that instantly hides your map in Rust when pressing designated hotkeys. This script provides better response time than standard OBS hotkeys, ensuring your map is hidden immediately when needed.

## Features

- Instantly shows/hides a cover image when holding G or Shift+G
- Zero delay on both press and release
- Persists hotkey settings between OBS sessions
- Simple setup process

## Requirements

- OBS Studio (version 27.0.0 or newer recommended)
- A cover image source set up in OBS

## Installation

1. Download the `obs-map-hide.lua` script
2. In OBS Studio, go to Tools -> Scripts
3. Click the + button and select the downloaded script
4. Configure the script settings (see Setup below)

## Setup

1. In OBS, create an image source that will cover your map:
   - Click the + under Sources
   - Select "Image"
   - Name it "Map Hidden" (or your preferred name)
   - Choose any image (solid color recommended)
   - Position it to cover your map area
   - Make sure it's hidden by default

2. In the Scripts window:
   - Enter the exact name of your image source
   - Make sure the source name matches exactly (it's case-sensitive)

3. Configure hotkeys:
   - Go to Settings -> Hotkeys
   - Find "Show Map Cover (Hold G)"
   - Set it to G
   - Find "Show Map Cover (Hold Shift+G)"
   - Set it to Shift+G
   - Click Apply

## Usage

- Hold G or Shift+G to show the cover image
- Release the key to hide it
- The cover will appear and disappear instantly

## Troubleshooting

If the script isn't working:
1. Make sure the image source name matches exactly what you entered in the script settings
2. Verify the hotkeys are properly set in OBS Settings -> Hotkeys
3. Check the Scripts log window for any error messages
4. Try restarting OBS if the source isn't being found

## License

MIT License - Feel free to use and modify as needed.

## Contributing

Feel free to open issues or submit pull requests if you have suggestions for improvements.
