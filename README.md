# Hide Map in Rust Game

An OBS Studio Lua script that hides the Rust map on stream to reduce the risk of stream sniping.

The script shows a cover image while your map key is held and hides it shortly after release. It includes separate hotkey states for normal use, sprinting, crouching, and crouching while sprinting so modifier changes do not make the cover flicker or disappear unexpectedly.

## Features

- Shows the cover immediately while a configured map hotkey is held
- Supports `G`, `Shift+G`, `Ctrl+G`, and `Ctrl+Shift+G`
- Continues working while crouching or changing modifiers
- Tracks every hotkey independently to prevent incorrect release events
- Uses a configurable one-shot hide delay to prevent map flashes
- Preserves hotkey settings between OBS sessions
- Includes **Check Source**, **Show Cover Test**, and **Hide Cover Test** buttons
- Does not automatically hide the image when the script is loaded or its settings are edited
- Controls the scene item in the current scene instead of globally disabling the underlying source

## Requirements

- OBS Studio 27.0.0 or newer
- An image source positioned over the Rust map
- The cover source must be present in the current scene or inside one of its groups

## Installation

1. Download [`obs-map-hide.lua`](./obs-map-hide.lua).
2. Open OBS Studio.
3. Go to **Tools -> Scripts**.
4. Click the **+** button.
5. Select `obs-map-hide.lua`.

## Create the Map Cover

1. In the OBS scene used for Rust, click **+** under **Sources**.
2. Select **Image**.
3. Give it a clear name such as `Map Hidden`.
4. Choose a solid image, logo, stream graphic, or other cover image.
5. Resize and position it over the Rust map.
6. Leave the source visible temporarily while positioning it.

## Configure the Script

1. Select `obs-map-hide.lua` in **Tools -> Scripts**.
2. Enter the exact, case-sensitive image source name under **Image Source Name**.
3. Set **Hide Delay After Release**. The default is `250 ms`.
4. Click **Check Source** and confirm the Scripts log reports success.
5. Click **Show Cover Test** and **Hide Cover Test** to verify that the correct scene item is controlled.

The script intentionally does not hide the source just because it was loaded or updated. This prevents the cover from appearing permanently lost before the hotkeys have been configured.

## Configure Hotkeys

Open **Settings -> Hotkeys** and find these four actions:

| OBS action | Recommended binding | Rust state covered |
|---|---:|---|
| Rust Map Cover - G | `G` | Normal map use |
| Rust Map Cover - Shift+G | `Shift+G` | Sprint modifier held |
| Rust Map Cover - Ctrl+G (Crouching) | `Ctrl+G` | Crouch modifier held |
| Rust Map Cover - Ctrl+Shift+G (Crouching) | `Ctrl+Shift+G` | Crouch and sprint modifiers held |

Click **Apply**, then **OK**.

The action names describe the recommended defaults, but each action can be assigned to a different combination if your Rust controls are customized. Configure every modifier combination that can be active when you open the map.

## Usage

- Hold your configured Rust map key to show the cover.
- Release the key to hide the cover after the configured delay.
- Moving between `G`, `Shift+G`, `Ctrl+G`, and `Ctrl+Shift+G` while the map is open should keep the cover visible.

## Upgrading From an Older Version

1. Replace the old `obs-map-hide.lua` file with the latest version.
2. Reload the script in OBS.
3. Your existing `G` and `Shift+G` bindings should remain saved.
4. Add the new `Ctrl+G` and `Ctrl+Shift+G` bindings for crouching support.
5. Run **Check Source**, **Show Cover Test**, and **Hide Cover Test** before streaming.

## Troubleshooting

### The cover image disappeared

1. Open **Tools -> Scripts** and select the script.
2. Confirm **Image Source Name** exactly matches the OBS source name, including capitalization.
3. Confirm the source exists in the current scene or one of its groups.
4. Click **Check Source**.
5. Click **Show Cover Test**.
6. Open **Settings -> Hotkeys** and make sure the required bindings are assigned.

The updated script no longer hides the source automatically during script loading or settings changes.

### It does not work while crouching

Assign both of these actions:

- **Rust Map Cover - Ctrl+G (Crouching)** -> `Ctrl+G`
- **Rust Map Cover - Ctrl+Shift+G (Crouching)** -> `Ctrl+Shift+G`

If crouch is bound to another key, assign equivalent combinations using that modifier.

### It works in one scene but not another

Add the cover source to every OBS scene where Rust may be shown, using the same source name, or place it in a shared group used by those scenes. The script controls the matching item in the currently active scene.

### The map briefly flashes after release

Increase **Hide Delay After Release**. Values between `200 ms` and `400 ms` are a reasonable starting range.

### Nothing happens and no source is found

Open **Tools -> Scripts -> Log** and review messages beginning with `[Rust Map Cover]`.

## License

MIT License. You may use and modify the script under the terms of the repository license.

## Contributing

Issues and pull requests are welcome. When reporting a problem, include:

- OBS Studio version
- Rust key bindings for map, crouch, and sprint
- Whether crouch is hold or toggle
- The relevant `[Rust Map Cover]` log messages
