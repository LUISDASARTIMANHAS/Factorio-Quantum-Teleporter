local MOD_PATH = "__Quantum-Teleporter__/"

local function play_teleported_effects(player, position)
    -- Efeito visual no destino
    player.surface.create_entity(
        {
            name = "big-explosion",
            position = position
        }
    )

    -- Reproduz som ao completar o teleporte (Factorio 2.1: play_sound com path de arquivo)
    player.play_sound({path = MOD_PATH .. "audio/teleported.ogg", position = position})
end

local function play_teleport_effects(player, position)
    -- Reproduz som de teleporte antes de teleportar (Factorio 2.1: play_sound com path de arquivo)
    player.play_sound({path = MOD_PATH .. "audio/teleport.ogg", position = position})
end

local function teleport_to_planet(player, surface_name)
    local destination_surface = game.surfaces[surface_name]
    if destination_surface then
        local destination_position = {x = 0, y = 0} -- Posição padrão

        play_teleport_effects(player, player.position)
        player.teleport(destination_position, destination_surface)
        play_teleported_effects(player, destination_position)
        game.print(player.name .. " foi teletransportado para " .. surface_name)
    else
        game.print("Superfície " .. surface_name .. " não encontrada!")
    end
end

local function teleport_to_planet_with_cords(player, surface_name, x, y)
    if surface_name and game.surfaces[surface_name] then
        local destination_surface = game.surfaces[surface_name]

        if destination_surface then
            local destination_position = {x = x, y = y}

            play_teleport_effects(player, player.position)
            player.teleport(destination_position, destination_surface)
            play_teleported_effects(player, destination_position)
            game.print(
                player.name .. " foi teletransportado para " .. surface_name .. " nas coordenadas " .. x .. ", " .. y
            )
        else
            game.print("Superfície " .. surface_name .. " não encontrada!")
        end
    else
        player.print("Erro: Superfície inválida.")
    end
end

return {
    teleport_to_planet_with_cords = teleport_to_planet_with_cords,
    teleport_to_planet = teleport_to_planet
}
