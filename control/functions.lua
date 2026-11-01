-- control/functions.lua
-- Funções de teletransporte e efeitos integradas à LDA-LIB

local LDARuntime = require("control.utils.lda-runtime")
local MOD_PATH = "__Quantum-Teleporter__/"

local function play_teleported_effects(player, position)
    local surface = LDARuntime.player.getSurface(player)
    if surface then
        LDARuntime.world.createExplosion(surface, position, "big-explosion")
    end
    player.play_sound({path = MOD_PATH .. "audio/teleported.ogg", position = position})
end

local function play_teleport_effects(player, position)
    player.play_sound({path = MOD_PATH .. "audio/teleport.ogg", position = position})
end

local function teleport_to_planet(player, surface_name)
    local destination_surface = LDARuntime.world.getSurface(surface_name)
    if destination_surface then
        local destination_position = {x = 0, y = 0}

        local current_pos = LDARuntime.player.getPosition(player)
        play_teleport_effects(player, current_pos)

        LDARuntime.player.teleport(player, destination_position, destination_surface)
        play_teleported_effects(player, destination_position)
        LDARuntime.player.notify(player, string.format("%s foi teletransportado para %s!", player.name, surface_name))
    else
        LDARuntime.player.notify(player, string.format("Superfície '%s' não encontrada!", tostring(surface_name)))
    end
end

local function teleport_to_planet_with_cords(player, surface_name, x, y)
    local destination_surface = LDARuntime.world.getSurface(surface_name)
    if destination_surface then
        local destination_position = {x = x, y = y}

        local current_pos = LDARuntime.player.getPosition(player)
        play_teleport_effects(player, current_pos)

        LDARuntime.player.teleport(player, destination_position, destination_surface)
        play_teleported_effects(player, destination_position)
        LDARuntime.player.notify(player, string.format("%s foi teletransportado para %s nas coordenadas %.0f, %.0f!", player.name, surface_name, x, y))
    else
        LDARuntime.player.notify(player, "Erro: Superfície de destino inválida.")
    end
end

return {
    teleport_to_planet_with_cords = teleport_to_planet_with_cords,
    teleport_to_planet = teleport_to_planet,
    play_teleport_effects = play_teleport_effects,
    play_teleported_effects = play_teleported_effects
}
