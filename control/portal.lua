local functions = require("control.functions")
local handle = require("control.handle")
local MOD_PATH = "__Quantum-Teleporter__/"

script.on_event(defines.events.on_tick, function(event)
    for _, player in pairs(game.connected_players) do
        local character = player.character

        if character and character.valid then
            local portal = player.surface.find_entities_filtered({
                name = "quantum-teleporter-portal",
                position = player.position,
                radius = 5 -- Raio de detecção
            })[1]

            if portal and portal.valid then
                local energy_available = portal.energy -- Verifica energia disponível
                if energy_available >= 10 then
                    -- Coordenada de destino (exemplo)
                    local destination = {x = 0, y = 0}

                    -- Reproduz som de teleporte (Factorio 2.1: play_sound com path de arquivo)
                    player.play_sound({path = MOD_PATH .. "audio/teleport.ogg", position = portal.position})

                    -- Teleporte
                    player.teleport(destination)

                    -- Consome energia do portal
                    portal.energy = portal.energy - 10

                    -- Efeito visual no destino
                    player.surface.create_entity({
                        name = "big-explosion",
                        position = destination
                    })

                    -- Reproduz som ao completar o teleporte (Factorio 2.1: play_sound com path de arquivo)
                    player.play_sound({path = MOD_PATH .. "audio/teleported.ogg", position = destination})
                end
            end
        end
    end
end)
