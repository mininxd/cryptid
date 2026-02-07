-- Minimal Lovely module implementation for SMODS compatibility
local lovely = {
    version = "0.7.1",
    mod_dir = "mods/",
    repo = "https://github.com/0xDrMerry/lovely",
    
    -- Basic patching functionality placeholder
    apply_patches = function(name, content)
        -- For now, just return the content as-is
        return content
    end
}

return lovely