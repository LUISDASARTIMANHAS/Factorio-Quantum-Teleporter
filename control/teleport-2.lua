-- Importa todas as funções do arquivo functions.lua
local functions = require("control.functions")
local handle = require("control.handle")
local eventos = defines.events

-- Evento para detectar o clique nos botões
script.on_event(eventos.on_gui_click, handle.teleport_cords)

-- cria a janela de teletransporte caso o player equipe
script.on_event(eventos.on_player_placed_equipment, handle.toggle_teleport_equipment)

-- REMOÇÃO DA JANELA DE TELEPORTE

-- Evento para lidar com a remoção de equipamento
script.on_event(eventos.on_player_removed_equipment, handle.toggle_teleport_equipment)

-- destroi a janela quando o player morre
script.on_event(eventos.on_player_died, handle.player_died_teleport)

script.on_event(eventos.on_player_armor_inventory_changed, handle.toggle_teleport_equipment)

-- Detecta quando o jogador ressuscita
script.on_event(eventos.on_player_respawned, handle.check_teleport_equipment_on_respawn)
