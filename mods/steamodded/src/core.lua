--- STEAMODDED CORE
--- MODULE CORE

SMODS = {}
MODDED_VERSION = require'SMODS.version'
RELEASE_VERSION = require'SMODS.release'
SMODS.id = 'Steamodded'
SMODS.version = MODDED_VERSION:gsub('%-STEAMODDED', '')
SMODS.can_load = true
SMODS.meta_mod = true
SMODS.config_file = 'config.lua'

-- Include lovely and nativefs modules
local nativefs = require "nativefs"
local lovely = require "lovely"
local json = require "json"

local lovely_mod_dir = lovely.mod_dir:gsub("/$", "")
NFS = nativefs
-- make lovely_mod_dir an absolute path.
-- respects symlink/.. combos
if NFS.setWorkingDirectory(lovely_mod_dir) then
    lovely_mod_dir = NFS.getWorkingDirectory()
end
-- make sure NFS behaves the same as love.filesystem
NFS.setWorkingDirectory(love.filesystem.getSaveDirectory())

JSON = json

local function set_mods_dir()
    local love_dirs = {
        love.filesystem.getSaveDirectory(),
        love.filesystem.getSourceBaseDirectory()
    }
    for _, love_dir in ipairs(love_dirs) do
        if lovely_mod_dir:sub(1, #love_dir) == love_dir then
            -- relative path from love_dir
            SMODS.MODS_DIR = lovely_mod_dir:sub(#love_dir+2)
            NFS.setWorkingDirectory(love_dir)
            return
        end
    end
    SMODS.MODS_DIR = lovely_mod_dir
end
set_mods_dir()

local function find_smods_path()
    -- 1. Try to get path from debug info (where this file was loaded from)
    local info = debug.getinfo(1, "S")
    if info and info.source then
        local source = info.source
        if source:sub(1, 1) == "@" then
            source = source:sub(2)
        end
        -- source is path to core.lua, e.g. "mods/steamodded/src/core.lua"
        -- We want the root of the mod, e.g. "mods/steamodded/"
        
        -- Check for standard structure: .../steamodded/src/core.lua
        local path = source:match("(.*[/\\])src[/\\]core%.lua$")
        if path then
             -- path is "mods/steamodded/"
             -- verify existence
             if NFS.getInfo(path) or love.filesystem.getInfo(path) then
                 return path
             end
        end

        -- Fallback: Check for just core.lua location
        path = source:match("(.*[/\\])core%.lua$")
        if path then
            -- If not in src, maybe we are in root? (Unlikely for SMODS)
            -- Or maybe src is missing from path?
            if NFS.getInfo(path .. "../steamodded/") then
                 return path .. "../steamodded/"
            end
        end
    end

    -- 2. Fallback: Recursive search in MODS_DIR
    local function find_self(directory, target_filename, target_line, depth)
        depth = depth or 1
        if depth > 4 then return end
        for _, filename in ipairs(NFS.getDirectoryItems(directory)) do
            local file_path = directory .. "/" .. filename
            local file_type = NFS.getInfo(file_path).type
            if file_type == 'directory' or file_type == 'symlink' then
                local f = find_self(file_path, target_filename, target_line, depth+1)
                if f then return f end
            elseif filename == target_filename then
                local first_line = NFS.read(file_path):match('^(.-)\n')
                if first_line == target_line then
                    -- use parent directory
                    return directory:match('^(.+/)')
                end
            end
        end
    end

    local found = find_self(SMODS.MODS_DIR, 'core.lua', '--- STEAMODDED CORE')
    if found then return found end

    -- 3. Last resort: Check known location relative to MODS_DIR
    local path = SMODS.MODS_DIR .. "/steamodded/"
    if NFS.getInfo(path .. "src/core.lua") then
        return path
    end
    
    return nil
end

SMODS.path = find_smods_path()

if not SMODS.path then
    -- Attempt to construct a path even if check failed, maybe NFS is just blind but read works?
    -- This is risky but better than crashing if we are sure of the structure.
    SMODS.path = SMODS.MODS_DIR .. "/steamodded/"
    sendWarnMessage("SMODS.path could not be verified, defaulting to: " .. SMODS.path, "SMODS")
end

-- Ensure SMODS.path ends with /
if SMODS.path:sub(-1) ~= "/" and SMODS.path:sub(-1) ~= "\\" then
    SMODS.path = SMODS.path .. "/"
end

local function load_file(path)
    local content = NFS.read(SMODS.path..path)
    if not content then
        -- Fallback to love.filesystem if NFS fails (e.g. inside fused archive)
        content = love.filesystem.read(SMODS.path..path)
    end
    
    if not content then
        error("Failed to load SMODS module: " .. path .. " at " .. SMODS.path .. path)
    end

    assert(load(content, ('=[SMODS _ "%s"]'):format(path)))()
end

-- Load modules that do not depend on Game or Object being defined
for _, path in ipairs {
    "src/index.lua",
    "src/utils.lua",
    "src/logging.lua",
    "src/compat_0_9_8.lua",
    "src/loader.lua",
} do
    load_file(path)
end

-- Modules that depend on Game/Object must be loaded later
local deferred_modules = {
    "src/game_object.lua", -- Defines loadAPIs which uses Object
    "src/ui.lua",          -- Uses Game.main_menu
    "src/overrides.lua",   -- Uses Card, Blind, etc.
}

-- Use explicit global assignment to avoid ambiguity
local original_initSteamodded = initSteamodded
_G.initSteamodded = function()
    -- print("SMODS: Loading deferred modules...")
    for _, path in ipairs(deferred_modules) do
        load_file(path)
    end
    -- print("SMODS: Deferred modules loaded.")
    if original_initSteamodded then original_initSteamodded() end
end

sendInfoMessage("Steamodded v" .. SMODS.version, "SMODS")
