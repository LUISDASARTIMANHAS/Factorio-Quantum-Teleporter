-- control/teleport-2.lua
-- Gerenciador de eventos de equipamento e despacho de GUI

local handle = require("control.handle")
local portal_gui = require("control.gui.portal-gui")
local eventos = defines.events

-- =============================================================================
-- DESPACHO UNIFICADO DE INTERFACE GRÁFICA (GUI)
-- =============================================================================

-- Cliques em botões (Rede de Portais e Equipamento Pessoal)
script.on_event(eventos.on_gui_click, function(event)
    -- Manipulação da interface do Portal Quântico
    portal_gui.on_gui_click(event)
    -- Manipulação da interface do Equipamento Pessoal
    handle.teleport_cords(event)
end)

-- Mudança de seleção em drop-downs
script.on_event(eventos.on_gui_selection_state_changed, function(event)
    -- Dropdown de destinos da Rede de Portais
    portal_gui.on_selection_changed(event)
end)

-- =============================================================================
-- EVENTOS DO EQUIPAMENTO PESSOAL DE TELETRANSPORTE
-- =============================================================================

-- Cria ou abre a janela de teletransporte caso o jogador equipe
script.on_event(eventos.on_player_placed_equipment, handle.toggle_teleport_equipment)

-- Lida com a remoção de equipamento
script.on_event(eventos.on_player_removed_equipment, handle.toggle_teleport_equipment)

-- Destrói a janela quando o jogador morre
script.on_event(eventos.on_player_died, handle.player_died_teleport)

-- Detecta alterações na armadura do jogador
script.on_event(eventos.on_player_armor_inventory_changed, handle.toggle_teleport_equipment)

-- Detecta quando o jogador ressuscita
script.on_event(eventos.on_player_respawned, handle.check_teleport_equipment_on_respawn)
