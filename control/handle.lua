-- control/handle.lua
-- Gerenciador de eventos para o Equipamento Pessoal de Teleporte Quântico
-- Integração obrigatória com a biblioteca LDA-LIB no runtime.

local LDARuntime = require("__LDA-LIB__/runtime.init")
local functions = require("control.functions")
local guimaker = require("control.gui.gui-maker")

local EQUIPMENT_NAME = "quantum-teleporter-equipment"
local TELEPORT_ENERGY_REQUIRED = 50e6 -- 50 MJ por salto com equipamento

local function crafted_item(event)
    local player = LDARuntime.player.get(event.player_index)
    if not player then return end

    local item_stack = event.item_stack
    if item_stack and item_stack.valid and item_stack.name == EQUIPMENT_NAME then
        guimaker.create_teleport_window(player)
    end
end

local function player_died_teleport(event)
    local player = LDARuntime.player.get(event.player_index)
    if not player then return end
    guimaker.close_teleport_window(player)
end

local function toggle_teleport_equipment(event)
    local player = LDARuntime.player.get(event.player_index)
    if not player then return end

    local armor = player.get_inventory(defines.inventory.character_armor)[1]

    if armor and armor.valid_for_read and armor.grid then
        local grid = armor.grid
        local has_teleporter = (grid.count(EQUIPMENT_NAME) > 0)

        if has_teleporter then
            log("[Quantum-Teleporter] Equipamento pessoal detectado na armadura.")
            if not player.gui.screen.teleport_window then
                guimaker.create_teleport_window(player)
            end
        else
            log("[Quantum-Teleporter] Equipamento pessoal removido.")
            guimaker.close_teleport_window(player)
        end
    else
        guimaker.close_teleport_window(player)
    end
end

local function check_teleport_equipment_on_respawn(event)
    local player = LDARuntime.player.get(event.player_index)
    if not player then return end

    local armor = player.get_inventory(defines.inventory.character_armor)[1]
    if not armor or not armor.valid_for_read or not armor.grid then
        guimaker.close_teleport_window(player)
        return
    end

    local grid = armor.grid
    if grid.count(EQUIPMENT_NAME) > 0 then
        if not player.gui.screen.teleport_window then
            guimaker.create_teleport_window(player)
        end
    end
end

-- Teletransporte livre por coordenadas do Equipamento Pessoal
local function teleport_cords(event)
    local player = LDARuntime.player.get(event.player_index)
    if not player then return end

    local element = event.element
    if not element or not element.valid then return end

    if element.name == "confirm_button" then
        local teleport_window = player.gui.screen.teleport_window
        if not teleport_window then return end

        local surface_dropdown = teleport_window.surface_dropdown
        if not surface_dropdown then return end

        local armor = player.get_inventory(defines.inventory.character_armor)[1]
        if armor and armor.valid_for_read and armor.grid then
            local grid = armor.grid
            if grid.count(EQUIPMENT_NAME) > 0 then
                local selected_index = surface_dropdown.selected_index
                local surface_name = surface_dropdown.items[selected_index]

                local coord_x = tonumber(teleport_window.coord_x.text) or 0
                local coord_y = tonumber(teleport_window.coord_y.text) or 0

                local energy_available = grid.available_in_batteries
                if energy_available >= TELEPORT_ENERGY_REQUIRED then
                    grid.drain_energy(TELEPORT_ENERGY_REQUIRED)
                    functions.teleport_to_planet_with_cords(player, surface_name, coord_x, coord_y)
                    LDARuntime.player.notify(player, string.format("Salto para %s [%.0f, %.0f] executado!", surface_name, coord_x, coord_y))
                else
                    LDARuntime.player.flyingText(player, "Bateria insuficiente!", {color = {r=1, g=0.2, b=0.2}})
                    LDARuntime.player.notify(player, string.format("Energia insuficiente na armadura. Necessário: %.0f MJ (Disponível: %.1f MJ)", TELEPORT_ENERGY_REQUIRED / 1e6, energy_available / 1e6))
                end
            else
                LDARuntime.player.notify(player, "Equipamento de teletransporte não encontrado na armadura.")
            end
        else
            LDARuntime.player.notify(player, "Nenhuma armadura com grade de equipamento equipada.")
        end
    end
end

-- Teleporte planetário (legado)
local function teleport_planet(event)
    local player = LDARuntime.player.get(event.player_index)
    if not player then return end

    local element = event.element
    if not element or not element.valid then return end

    if element.name == "confirm_button" then
        local surface_name = player.gui.screen.teleport_window.surface_name.text
        functions.teleport_to_planet(player, surface_name)
    end
end

return {
    crafted_item = crafted_item,
    player_died_teleport = player_died_teleport,
    teleport_planet = teleport_planet,
    teleport_cords = teleport_cords,
    toggle_teleport_equipment = toggle_teleport_equipment,
    check_teleport_equipment_on_respawn = check_teleport_equipment_on_respawn
}
