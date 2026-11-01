-- control/functions.lua
-- Funções de teletransporte e efeitos integradas à LDA-LIB

local LDARuntime = require("control.utils.lda-runtime")

local function play_teleported_effects(player, position)
    local surface = LDARuntime.player.getSurface(player)
    if surface then
        LDARuntime.world.createExplosion(surface, position, "big-explosion")
    end
    player.play_sound({path = "quantum-teleported-sound", position = position})
end

local function play_teleport_effects(player, position)
    player.play_sound({path = "quantum-teleport-sound", position = position})
end

local function teleport_to_planet_with_cords(player, surface_name, x, y)
    local destination_surface = LDARuntime.world.getSurface(surface_name)
    if not destination_surface then
        LDARuntime.player.notify(player, "Erro: Superfície de destino inválida.")
        return false
    end

    local requested_position = {x = x, y = y}
    local destination_position = LDARuntime.world.findFreePosition(
        destination_surface,
        "character",
        requested_position,
        12,
        1
    )
    if not destination_position then
        LDARuntime.player.notify(player, "Não foi encontrada uma posição livre perto das coordenadas escolhidas.")
        return false
    end

    if not LDARuntime.player.teleport(player, destination_position, destination_surface) then
        LDARuntime.player.notify(player, "O Factorio recusou a posição de destino; nenhuma energia foi consumida.")
        return false
    end

    play_teleport_effects(player, LDARuntime.player.getPosition(player))
    play_teleported_effects(player, LDARuntime.player.getPosition(player))
    LDARuntime.player.notify(player, string.format(
        "%s foi teletransportado para %s nas coordenadas %.0f, %.0f!",
        player.name,
        surface_name,
        destination_position.x,
        destination_position.y
    ))
    return true
end

local function teleport_to_planet(player, surface_name)
    return teleport_to_planet_with_cords(player, surface_name, 0, 0)
end

return {
    teleport_to_planet_with_cords = teleport_to_planet_with_cords,
    teleport_to_planet = teleport_to_planet,
    play_teleport_effects = play_teleport_effects,
    play_teleported_effects = play_teleported_effects
}
