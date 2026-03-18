-- Copyright (C) 2025 かにふぁん
-- SPDX-License-Identifier: GPL-3.0-or-later

local utils = require 'mp.utils'

-- CHANGE THIS to the actual folder where server.py and wait.py are located:
local SERVER_DIR = "/home/nemui/.config/mpv/scripts/autocards"
local BASE = mp.command_native({'expand-path', '~~/'})

local CURL = "curl"
local PYTHON = "python3"

local function post(endpoint, v)
    utils.subprocess({ args = {
        CURL, '-s', '-X', 'POST', 'http://127.0.0.1:6969' .. endpoint, '--json', v
    } })
end

local function post_init(v)
    -- Using /tmp/ ensures we don't have permission issues on Linux
    local temp = "/tmp/autocards_temp.json"
    local f = io.open(temp, "w")
    if not f then return end
    f:write(v)
    f:close()
    utils.subprocess({ args = {
        CURL, '-s', '-X', 'POST', 'http://127.0.0.1:6969/init', '--json', '@' .. temp
    } })
    os.remove(temp)
end

local HAS_SERVER = false
local SERVER_FILE

local function update(t)
    local delay = mp.get_property_native('sub-delay')
    local payload = utils.format_json({
        time = t - delay,
        delay = delay
    })
    return post('/update', payload)
end

local function get_active_sub()
    local tracks = mp.get_property_native("track-list")
    for _, track in ipairs(tracks) do
        if track["type"] == "sub" and track["selected"] then
            if track["external"] then
                return { type = "external", path = track["external-filename"] }
            else
                return { type = "internal", index = track["ff-index"], codec = track["codec"] }
            end
        end
    end
    return nil
end

local function init(k, v)
    if not v or SERVER_FILE == v then
        return
    end

    mp.msg.info("Autocards initializing for: " .. mp.get_property("path"))

    if not HAS_SERVER then
        -- We point directly to your Downloads folder logic here
        mp.command_native_async({ 
            name = 'subprocess', 
            args = { PYTHON, SERVER_DIR .. '/server.py' }, 
            playback_only = false 
        })
        utils.subprocess({ 
            args = { PYTHON, SERVER_DIR .. '/wait.py' }, 
            playback_only = false 
        })

        HAS_SERVER = true
    end

    local sub_info = get_active_sub()
    local payload = utils.format_json({
        video = v:gsub('\\', '/'),
        sub = sub_info
    })

    post_init(payload)
    update(mp.get_property_native('time-pos'))
end

local function tick(k, v)
    if not v or not HAS_SERVER then return end
    update(v)
end

local function on_sub_change(name, value)
    if HAS_SERVER then
        local path = mp.get_property("path")
        if path then init(nil, path) end
    end
end

mp.register_event('file-loaded', function() init(nil, mp.get_property('path')) end)
mp.observe_property('time-pos', 'number', tick)
mp.observe_property('sid', 'string', on_sub_change)
