-- data/soundMaker.lua
-- Registro de protótipos de som (SoundPrototype) para uso com SoundPath / play_sound no runtime

local path_main = "__Quantum-Teleporter__/"

data:extend(
    {
        {
            type = "sound",
            name = "quantum-teleport-sound",
            filename = path_main .. "audio/teleport.ogg",
            volume = 1.0
        },
        {
            type = "sound",
            name = "quantum-teleported-sound",
            filename = path_main .. "audio/teleported.ogg",
            volume = 1.0
        },
        {
            type = "sound",
            name = "quantum-portal-sound",
            filename = path_main .. "audio/portal.ogg",
            volume = 1.0
        },
        -- Aliases para retrocompatibilidade
        {
            type = "sound",
            name = "teleport-sound",
            filename = path_main .. "audio/teleport.ogg",
            volume = 1.0
        },
        {
            type = "sound",
            name = "teleported-sound",
            filename = path_main .. "audio/teleported.ogg",
            volume = 1.0
        },
        {
            type = "sound",
            name = "portal-sound",
            filename = path_main .. "audio/portal.ogg",
            volume = 1.0
        }
    }
)
