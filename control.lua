-- ============================================================
-- FACTORIO SCRIPT EVENTS REFERENCE
-- Lista de eventos principais para desenvolvimento de mods
-- ============================================================

-- ============================================================
-- CICLO DO MOD
-- ============================================================

-- Executado quando o mod é inicializado pela primeira vez no save
-- script.on_init(function()
--     log("Mod inicializado")
-- end)

-- Executado quando o save é carregado
-- NÃO pode usar game.print
-- script.on_load(function()
--     log("Save carregado")
-- end)

-- Executado quando:
-- - mod atualizado
-- - mod adicionado/removido
-- - versão do jogo mudou
-- script.on_configuration_changed(function(event)
--     log("Configuração mudou")
-- end)


-- ============================================================
-- EVENTOS DE TEMPO
-- ============================================================

-- Executa a cada tick (60 vezes por segundo)
-- script.on_event(defines.events.on_tick, function(event)
-- end)


-- ============================================================
-- EVENTOS DE JOGADOR
-- ============================================================

-- Jogador criado pela primeira vez no mapa
-- script.on_event(defines.events.on_player_created, function(event)
--     local player = game.get_player(event.player_index)
-- end)

-- Jogador entrou no jogo
-- script.on_event(defines.events.on_player_joined_game, function(event)
-- end)

-- Jogador saiu do jogo
-- script.on_event(defines.events.on_player_left_game, function(event)
-- end)

-- Jogador morreu
-- script.on_event(defines.events.on_player_died, function(event)
-- end)

-- Jogador renasceu
-- script.on_event(defines.events.on_player_respawned, function(event)
-- end)


-- ============================================================
-- CONSTRUÇÃO DE ENTIDADES
-- ============================================================

-- Jogador construiu entidade
-- script.on_event(defines.events.on_built_entity, function(event)
--     local entity = event.created_entity
-- end)

-- Robô construiu entidade
-- script.on_event(defines.events.on_robot_built_entity, function(event)
-- end)

-- Antes do jogador minerar entidade
-- script.on_event(defines.events.on_pre_player_mined_item, function(event)
-- end)

-- Jogador removeu entidade
-- script.on_event(defines.events.on_player_mined_entity, function(event)
-- end)

-- Robô removeu entidade
-- script.on_event(defines.events.on_robot_mined_entity, function(event)
-- end)


-- ============================================================
-- DESTRUIÇÃO
-- ============================================================

-- Entidade morreu
-- script.on_event(defines.events.on_entity_died, function(event)
--     local entity = event.entity
-- end)


-- ============================================================
-- PESQUISA
-- ============================================================

-- Pesquisa começou
-- script.on_event(defines.events.on_research_started, function(event)
-- end)

-- Pesquisa terminou
-- script.on_event(defines.events.on_research_finished, function(event)
--     local research = event.research
-- end)


-- ============================================================
-- CONFIGURAÇÕES DO MOD
-- ============================================================

-- Runtime setting alterado
-- script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
-- end)


-- ============================================================
-- GUI
-- ============================================================

-- Botão GUI clicado
-- script.on_event(defines.events.on_gui_click, function(event)
-- end)

-- Interface aberta
-- script.on_event(defines.events.on_gui_opened, function(event)
-- end)

-- Interface fechada
-- script.on_event(defines.events.on_gui_closed, function(event)
-- end)


-- ============================================================
-- MAPA / MUNDO
-- ============================================================

-- Chunk gerado
-- script.on_event(defines.events.on_chunk_generated, function(event)
-- end)


-- ============================================================
-- SELEÇÃO DE ÁREA
-- ============================================================

-- Área selecionada com ferramenta
-- script.on_event(defines.events.on_player_selected_area, function(event)
-- end)

-- Área selecionada com ALT
-- script.on_event(defines.events.on_player_alt_selected_area, function(event)
-- end)


-- ============================================================
-- INVENTÁRIO
-- ============================================================

-- Inventário principal mudou
-- script.on_event(defines.events.on_player_main_inventory_changed, function(event)
-- end)

-- Item do cursor mudou
-- script.on_event(defines.events.on_player_cursor_stack_changed, function(event)
-- end)


-- ============================================================
-- ENTIDADES / CONFIGURAÇÕES
-- ============================================================

-- Configuração copiada entre entidades
-- script.on_event(defines.events.on_entity_settings_pasted, function(event)
-- end)

-- Entidade marcada para desconstrução
-- script.on_event(defines.events.on_marked_for_deconstruction, function(event)
-- end)

-- Desconstrução cancelada
-- script.on_event(defines.events.on_cancelled_deconstruction, function(event)
-- end)
-- =============================================================
-- require("control/teleport-1")
require("control/teleport-2")
require("control/portal")

local guimaker = require("control.gui.gui-maker")

-- ============================================================
-- TESTE: MOD INICIALIZADO
-- ============================================================

script.on_init(function()
    game.print("CONTROL LOADED!")
end)


commands.add_command("testgui", "Abrir GUI de teleporte", function(cmd)

    local player = game.get_player(cmd.player_index)

    player.print("Abrindo GUI de teleporte")

    guimaker.create_teleport_window(player)

end)


script.on_event(defines.events.on_player_joined_game, function(event)

    local player = game.get_player(event.player_index)

    player.print("Entrou no jogo - abrindo GUI")

    guimaker.create_teleport_window(player)

end)
-- ============================================================
-- TESTE: PLAYER CRIADO
-- ============================================================

script.on_event(defines.events.on_player_created, function(event)

    local player = game.get_player(event.player_index)

    player.print("TESTE GUI - Janela criada")

    guimaker.create_teleport_window(player)

end)

-- ============================================================
-- TESTE: CLIQUE EM BOTÕES
-- ============================================================

script.on_event(defines.events.on_gui_click, function(event)

    local element = event.element
    if not element or not element.valid then return end

    local player = game.get_player(event.player_index)

    -- botão confirmar teleporte
    if element.name == "confirm_button" then

        player.print("Botão TELEPORT clicado")

        local window = player.gui.screen.teleport_window

        if window then

            local x = tonumber(window.coord_x.text) or 0
            local y = tonumber(window.coord_y.text) or 0

            player.print("Coordenadas: X=" .. x .. " Y=" .. y)

        end

    end

    -- botão fechar
    if element.name == "close_button" then

        player.print("Janela fechada")

        guimaker.close_window(player, "window")

    end

end)

-- ============================================================
-- TESTE: DROPDOWN
-- ============================================================

script.on_event(defines.events.on_gui_selection_state_changed, function(event)

    local element = event.element
    if not element or not element.valid then return end

    if element.name == "surface_dropdown" then

        local player = game.get_player(event.player_index)

        local surface = element.get_item(element.selected_index)

        player.print("Superfície selecionada: " .. surface)

    end

end)