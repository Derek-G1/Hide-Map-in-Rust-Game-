obs = obslua

-- Script properties
local source_name = ""
local hotkey_id = obs.OBS_INVALID_HOTKEY_ID
local hotkey_id_shift = obs.OBS_INVALID_HOTKEY_ID
local check_attempts = 0
local MAX_ATTEMPTS = 5

-- Function to print to the OBS script log
function debug_log(message)
    print(message)
end

-- Function to show/hide the source
function set_visibility(visible)
    local source = obs.obs_get_source_by_name(source_name)
    if source ~= nil then
        obs.obs_source_set_enabled(source, visible)
        debug_log(string.format("Source '%s' visibility set to %s", source_name, tostring(visible)))
        obs.obs_source_release(source)
        return true
    else
        debug_log(string.format("ERROR: Could not find source '%s'", source_name))
        return false
    end
end

-- Callback for key press/release
function on_hotkey(pressed)
    if pressed then
        debug_log("Hotkey pressed - showing source")
        set_visibility(true)
    else
        debug_log("Hotkey released - hiding source")
        set_visibility(false)
    end
end

function script_description()
    return [[Map Cover Script for Rust
    Shows an image when G or Shift+G is held, hides it when released.
    
    Setup:
    1. Enter the exact name of your image source below
    2. Configure hotkeys in OBS Settings -> Hotkeys
    3. Make sure the image is hidden by default]]
end

function script_properties()
    local props = obs.obs_properties_create()
    obs.obs_properties_add_text(props, "source", "Image Source Name", obs.OBS_TEXT_DEFAULT)
    return props
end

function script_update(settings)
    source_name = obs.obs_data_get_string(settings, "source")
    debug_log(string.format("Source name updated to '%s'", source_name))
    
    -- Immediately check if source exists
    local source = obs.obs_get_source_by_name(source_name)
    if source ~= nil then
        debug_log("Source found successfully")
        obs.obs_source_release(source)
        set_visibility(false)  -- Ensure it starts hidden
    else
        debug_log("WARNING: Source not found!")
    end
end

function script_load(settings)
    debug_log("Script loading...")
    
    -- Register hotkeys
    hotkey_id = obs.obs_hotkey_register_frontend("map_cover_g", "Show Map Cover (Hold G)", on_hotkey)
    hotkey_id_shift = obs.obs_hotkey_register_frontend("map_cover_shift_g", "Show Map Cover (Hold Shift+G)", on_hotkey)
    
    -- Load saved hotkey data
    local htdata = obs.obs_data_get_array(settings, "htkey_g")
    obs.obs_hotkey_load(hotkey_id, htdata)
    obs.obs_data_array_release(htdata)
    
    local htdata_shift = obs.obs_data_get_array(settings, "htkey_shift_g")
    obs.obs_hotkey_load(hotkey_id_shift, htdata_shift)
    obs.obs_data_array_release(htdata_shift)
    
    script_update(settings)
    debug_log("Script loaded successfully - configure hotkeys in Settings -> Hotkeys")
end

function script_save(settings)
    -- Save hotkey data
    local htdata = obs.obs_hotkey_save(hotkey_id)
    obs.obs_data_set_array(settings, "htkey_g", htdata)
    obs.obs_data_array_release(htdata)
    
    local htdata_shift = obs.obs_hotkey_save(hotkey_id_shift)
    obs.obs_data_set_array(settings, "htkey_shift_g", htdata_shift)
    obs.obs_data_array_release(htdata_shift)
end
