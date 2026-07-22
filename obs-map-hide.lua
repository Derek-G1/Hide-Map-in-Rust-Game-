obs = obslua

-- User settings
local source_name = ""
local release_delay_ms = 250

-- Registered OBS hotkeys
local hotkey_id_g = obs.OBS_INVALID_HOTKEY_ID
local hotkey_id_shift_g = obs.OBS_INVALID_HOTKEY_ID
local hotkey_id_ctrl_g = obs.OBS_INVALID_HOTKEY_ID
local hotkey_id_ctrl_shift_g = obs.OBS_INVALID_HOTKEY_ID

-- Track every binding independently so modifier transitions do not hide the cover.
local hotkey_states = {
    g = false,
    shift_g = false,
    ctrl_g = false,
    ctrl_shift_g = false,
}

local hide_timer_running = false

local function debug_log(message)
    print("[Rust Map Cover] " .. message)
end

local function any_hotkey_active()
    for _, active in pairs(hotkey_states) do
        if active then
            return true
        end
    end

    return false
end

local function find_cover_in_current_scene()
    if source_name == nil or source_name == "" then
        debug_log("ERROR: Enter an image source name in the script settings.")
        return nil, nil
    end

    local scene_source = obs.obs_frontend_get_current_scene()
    if scene_source == nil then
        debug_log("ERROR: OBS does not currently have an active scene.")
        return nil, nil
    end

    local scene = obs.obs_scene_from_source(scene_source)
    if scene == nil then
        debug_log("ERROR: The active OBS source is not a scene.")
        obs.obs_source_release(scene_source)
        return nil, nil
    end

    local scene_item = obs.obs_scene_find_source_recursive(scene, source_name)
    return scene_item, scene_source
end

local function set_cover_visible(visible)
    local scene_item, scene_source = find_cover_in_current_scene()

    if scene_item == nil then
        if scene_source ~= nil then
            obs.obs_source_release(scene_source)
        end

        debug_log(string.format(
            "ERROR: Could not find '%s' in the current scene or one of its groups. Check the exact, case-sensitive source name.",
            source_name
        ))
        return false
    end

    obs.obs_sceneitem_set_visible(scene_item, visible)
    obs.obs_source_release(scene_source)

    debug_log(string.format(
        "Cover '%s' is now %s.",
        source_name,
        visible and "visible" or "hidden"
    ))
    return true
end

local function cancel_hide_timer()
    if hide_timer_running then
        obs.timer_remove(hide_cover_after_delay)
        hide_timer_running = false
    end
end

function hide_cover_after_delay()
    obs.remove_current_callback()
    hide_timer_running = false

    if not any_hotkey_active() then
        set_cover_visible(false)
    end
end

local function schedule_hide_timer()
    cancel_hide_timer()

    if release_delay_ms <= 0 then
        set_cover_visible(false)
        return
    end

    hide_timer_running = true
    obs.timer_add(hide_cover_after_delay, release_delay_ms)
end

local function set_hotkey_state(state_name, pressed)
    hotkey_states[state_name] = pressed

    if pressed then
        cancel_hide_timer()
        set_cover_visible(true)
    elseif not any_hotkey_active() then
        schedule_hide_timer()
    end
end

function on_hotkey_g(pressed)
    set_hotkey_state("g", pressed)
end

function on_hotkey_shift_g(pressed)
    set_hotkey_state("shift_g", pressed)
end

function on_hotkey_ctrl_g(pressed)
    set_hotkey_state("ctrl_g", pressed)
end

function on_hotkey_ctrl_shift_g(pressed)
    set_hotkey_state("ctrl_shift_g", pressed)
end

function test_show_cover()
    cancel_hide_timer()
    return set_cover_visible(true)
end

function test_hide_cover()
    cancel_hide_timer()
    return set_cover_visible(false)
end

function check_cover_source()
    local scene_item, scene_source = find_cover_in_current_scene()

    if scene_item ~= nil then
        debug_log(string.format("SUCCESS: Found '%s' in the current scene.", source_name))
    else
        debug_log(string.format(
            "ERROR: Could not find '%s' in the current scene or one of its groups.",
            source_name
        ))
    end

    if scene_source ~= nil then
        obs.obs_source_release(scene_source)
    end

    return scene_item ~= nil
end

function script_description()
    return [[Rust Map Cover

Shows an image source while a configured map hotkey is held, then hides it after a short release delay.

The script supports G, Shift+G, Ctrl+G, and Ctrl+Shift+G so the cover continues working while crouching or changing modifiers.

Setup:
1. Add an image source over the Rust map in your current scene.
2. Enter its exact, case-sensitive source name below.
3. Use the Check/Show/Hide buttons to verify the source.
4. Assign the four hotkeys in Settings -> Hotkeys.]]
end

function script_defaults(settings)
    obs.obs_data_set_default_int(settings, "release_delay_ms", 250)
end

function script_properties()
    local props = obs.obs_properties_create()

    obs.obs_properties_add_text(
        props,
        "source",
        "Image Source Name",
        obs.OBS_TEXT_DEFAULT
    )

    obs.obs_properties_add_int(
        props,
        "release_delay_ms",
        "Hide Delay After Release (ms)",
        0,
        2000,
        25
    )

    obs.obs_properties_add_button(props, "check_source", "Check Source", check_cover_source)
    obs.obs_properties_add_button(props, "show_cover", "Show Cover Test", test_show_cover)
    obs.obs_properties_add_button(props, "hide_cover", "Hide Cover Test", test_hide_cover)

    return props
end

function script_update(settings)
    source_name = obs.obs_data_get_string(settings, "source")
    release_delay_ms = obs.obs_data_get_int(settings, "release_delay_ms")

    debug_log(string.format("Source name set to '%s'.", source_name))
    debug_log(string.format("Release delay set to %d ms.", release_delay_ms))

    -- Do not change visibility here. Older versions hid the selected image
    -- immediately, which made it appear permanently missing when hotkeys were
    -- not yet configured or were configured incorrectly.
end

local function load_hotkey(settings, setting_name, hotkey_id)
    local hotkey_data = obs.obs_data_get_array(settings, setting_name)
    obs.obs_hotkey_load(hotkey_id, hotkey_data)
    obs.obs_data_array_release(hotkey_data)
end

function script_load(settings)
    debug_log("Loading script...")

    hotkey_id_g = obs.obs_hotkey_register_frontend(
        "rust_map_cover_g",
        "Rust Map Cover - G",
        on_hotkey_g
    )
    hotkey_id_shift_g = obs.obs_hotkey_register_frontend(
        "rust_map_cover_shift_g",
        "Rust Map Cover - Shift+G",
        on_hotkey_shift_g
    )
    hotkey_id_ctrl_g = obs.obs_hotkey_register_frontend(
        "rust_map_cover_ctrl_g",
        "Rust Map Cover - Ctrl+G (Crouching)",
        on_hotkey_ctrl_g
    )
    hotkey_id_ctrl_shift_g = obs.obs_hotkey_register_frontend(
        "rust_map_cover_ctrl_shift_g",
        "Rust Map Cover - Ctrl+Shift+G (Crouching)",
        on_hotkey_ctrl_shift_g
    )

    load_hotkey(settings, "htkey_g", hotkey_id_g)
    load_hotkey(settings, "htkey_shift_g", hotkey_id_shift_g)
    load_hotkey(settings, "htkey_ctrl_g", hotkey_id_ctrl_g)
    load_hotkey(settings, "htkey_ctrl_shift_g", hotkey_id_ctrl_shift_g)

    script_update(settings)
    debug_log("Script loaded. Configure all required bindings in Settings -> Hotkeys.")
end

local function save_hotkey(settings, setting_name, hotkey_id)
    local hotkey_data = obs.obs_hotkey_save(hotkey_id)
    obs.obs_data_set_array(settings, setting_name, hotkey_data)
    obs.obs_data_array_release(hotkey_data)
end

function script_save(settings)
    save_hotkey(settings, "htkey_g", hotkey_id_g)
    save_hotkey(settings, "htkey_shift_g", hotkey_id_shift_g)
    save_hotkey(settings, "htkey_ctrl_g", hotkey_id_ctrl_g)
    save_hotkey(settings, "htkey_ctrl_shift_g", hotkey_id_ctrl_shift_g)
end

function script_unload()
    cancel_hide_timer()

    for state_name, _ in pairs(hotkey_states) do
        hotkey_states[state_name] = false
    end

    debug_log("Script unloaded.")
end
