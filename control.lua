-- ============================================================
-- CONTROL.LUA - Ponto de entrada do estágio de runtime
-- Quantum Teleporter Mod
-- ============================================================

-- Módulos de controle
-- require("control/teleport-1")  -- legado, desativado
require("control/teleport-2")
require("control/portal")

local guimaker = require("control.gui.gui-maker")

-- ============================================================
-- INICIALIZAÇÃO DO MOD
-- ============================================================

script.on_init(function()
    log("[Quantum-Teleporter] Mod inicializado.")
end)

-- ============================================================
-- COMANDO DE TESTE: Abrir GUI manualmente
-- ============================================================

commands.add_command("testgui", "Abrir GUI de teleporte", function(cmd)
    local player = game.get_player(cmd.player_index)
    if not player then return end
    player.print("Abrindo GUI de teleporte")
    guimaker.create_teleport_window(player)
end)

-- ============================================================
-- DROPDOWN: Superfície selecionada
-- ============================================================

script.on_event(defines.events.on_gui_selection_state_changed, function(event)
    local element = event.element
    if not element or not element.valid then return end

    if element.name == "surface_dropdown" then
        local player = game.get_player(event.player_index)
        if not player then return end
        local surface = element.get_item(element.selected_index)
        player.print("Superfície selecionada: " .. surface)
    end
end)
