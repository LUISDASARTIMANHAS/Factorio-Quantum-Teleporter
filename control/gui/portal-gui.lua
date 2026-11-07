-- control/gui/portal-gui.lua
-- Interface visual dedicada do Portal Quântico
-- Integração com a biblioteca LDA-LIB no runtime via LDARuntime.network e LDARuntime.gui (>= 0.0.17).

local LDARuntime = require("__LDA-LIB__/runtime.init")

local PortalGui = {}

local WINDOW_NAME = "quantum_portal_window"
local NETWORK_NAME = "portals"
local TELEPORT_ENERGY_COST = 20e6 -- 20 MJ por teletransporte via portal

--- Retorna os destinos válidos disponíveis na rede, excluindo o portal de origem
local function get_available_destinations(force_name, exclude_unit_number)
    local all = LDARuntime.network.getAll(NETWORK_NAME, force_name)
    local destinations = {}
    for _, node in ipairs(all) do
        if not exclude_unit_number or node.unit_number ~= exclude_unit_number then
            table.insert(destinations, node)
        end
    end
    table.sort(destinations, function(a, b)
        return (a.name or "") < (b.name or "")
    end)
    return destinations
end

--- Fecha a janela do portal se estiver aberta
--- @param player LuaPlayer
function PortalGui.close(player)
    if not LDARuntime.player.isValid(player) then return end
    LDARuntime.gui.closeWindow(player, WINDOW_NAME)
end

--- Abre a interface do portal para o jogador
--- @param player LuaPlayer
--- @param portal_entity LuaEntity
function PortalGui.open(player, portal_entity)
    if not LDARuntime.player.isValid(player) or not LDARuntime.entity.isValid(portal_entity) then
        return
    end

    -- Fecha janela pré-existente
    PortalGui.close(player)

    local unit_number = portal_entity.unit_number
    local entry = LDARuntime.network.get(NETWORK_NAME, unit_number)
    if not entry then
        entry = LDARuntime.network.register(NETWORK_NAME, portal_entity)
    end

    local current_energy = LDARuntime.entity.getEnergy(portal_entity)
    local max_energy = 200e6 -- 200 MJ
    local energy_percent = math.min(1, current_energy / max_energy)
    local energy_cost = TELEPORT_ENERGY_COST

    local surface = LDARuntime.entity.getSurface(portal_entity)
    local position = LDARuntime.entity.getPosition(portal_entity)
    local gps_tag = LDARuntime.world.formatGps(position, surface)

    local destinations = get_available_destinations(player.force.name, unit_number)

    local screen = player.gui.screen
    local window = screen.add({
        type = "frame",
        name = WINDOW_NAME,
        direction = "vertical",
        caption = "Rede Quântica de Portais",
        style = "frame"
    })

    -- Armazena o ID do portal atual na interface
    local root_flow = window.add({type = "flow", direction = "vertical"})
    root_flow.style.vertical_spacing = 8

    -- Header / Titlebar com botão Fechar
    local title_flow = root_flow.add({type = "flow", direction = "horizontal"})
    title_flow.style.horizontally_stretchable = true
    title_flow.style.vertical_align = "center"

    local title_label = title_flow.add({
        type = "label",
        caption = "Terminal de Controle do Portal"
    })
    title_label.style.font = "default-bold"

    local filler = title_flow.add({type = "empty-widget"})
    filler.style.horizontally_stretchable = true

    title_flow.add({
        type = "button",
        name = "quantum_portal_close_btn",
        caption = "X",
        style = "close_button"
    })

    -- Linha horizontal divisória
    root_flow.add({type = "line"})

    -- =========================================================================
    -- SEÇÃO 1: Portal de Origem (Local)
    -- =========================================================================
    local origin_frame = root_flow.add({
        type = "frame",
        direction = "vertical",
        style = "inside_shallow_frame"
    })
    origin_frame.style.width = 440
    origin_frame.style.padding = 10

    local origin_header = origin_frame.add({
        type = "label",
        caption = "Portal Local (Origem):"
    })
    origin_header.style.font = "default-bold"

    -- Nome customizável
    local name_flow = origin_frame.add({type = "flow", direction = "horizontal"})
    name_flow.style.vertical_align = "center"
    name_flow.style.top_margin = 4

    name_flow.add({type = "label", caption = "Nome: "})
    local name_input = name_flow.add({
        type = "textfield",
        name = "quantum_portal_name_input",
        text = entry and entry.name or ("Portal #" .. unit_number)
    })
    name_input.style.width = 240

    local save_btn = name_flow.add({
        type = "button",
        name = "quantum_portal_save_name_btn",
        caption = "Salvar Nome",
        style = "button"
    })
    save_btn.style.height = 28
    save_btn.tags = {unit_number = unit_number}

    -- Informações de localização
    local loc_flow = origin_frame.add({type = "flow", direction = "horizontal"})
    loc_flow.style.top_margin = 4
    loc_flow.add({
        type = "label",
        caption = string.format("Localização: Superfície [font=default-bold]%s[/font] %s", surface and surface.name or "N/A", gps_tag)
    })

    -- Barra de Energia do Portal
    local energy_box = origin_frame.add({type = "flow", direction = "vertical"})
    energy_box.style.top_margin = 6

    local energy_text = string.format(
        "Carga de Energia: %s / %s (%d%%)",
        LDARuntime.gui.formatEnergy(current_energy),
        LDARuntime.gui.formatEnergy(max_energy),
        math.floor(energy_percent * 100)
    )
    local energy_label = energy_box.add({
        type = "label",
        caption = energy_text
    })
    if current_energy < energy_cost then
        energy_label.style.font_color = {r = 1.0, g = 0.5, b = 0.2}
    end

    local progress_bar = energy_box.add({
        type = "progressbar",
        value = energy_percent,
        style = "progressbar"
    })
    progress_bar.style.horizontally_stretchable = true
    progress_bar.style.color = (current_energy >= energy_cost) and {r = 0.2, g = 0.8, b = 1.0} or {r = 1.0, g = 0.5, b = 0.2}

    local cost_label = energy_box.add({
        type = "label",
        caption = string.format("Consumo por teletransporte: %s", LDARuntime.gui.formatEnergy(energy_cost))
    })
    cost_label.style.font_color = {r = 0.7, g = 0.7, b = 0.7}

    -- =========================================================================
    -- SEÇÃO 2: Destino (Rede de Portais)
    -- =========================================================================
    local dest_frame = root_flow.add({
        type = "frame",
        direction = "vertical",
        style = "inside_shallow_frame"
    })
    dest_frame.style.width = 440
    dest_frame.style.padding = 10

    local dest_header = dest_frame.add({
        type = "label",
        caption = "Destino na Rede Quântica:"
    })
    dest_header.style.font = "default-bold"

    if #destinations == 0 then
        local empty_warning = dest_frame.add({
            type = "label",
            caption = "Nenhum outro portal conectado à rede.\nConstrua outro Portal Quântico para criar uma conexão de teletransporte!"
        })
        empty_warning.style.font_color = {r = 1.0, g = 0.7, b = 0.2}
        empty_warning.style.top_margin = 8
        empty_warning.style.bottom_margin = 8
    else
        local items = {}
        for _, dest in ipairs(destinations) do
            local dest_surface = dest.surface_name or "nauvis"
            local item_label = string.format("%s  [%s]", dest.name or ("Portal #" .. dest.unit_number), dest_surface)
            table.insert(items, item_label)
        end

        local dropdown_flow = dest_frame.add({type = "flow", direction = "horizontal"})
        dropdown_flow.style.top_margin = 6
        dropdown_flow.style.vertical_align = "center"

        dropdown_flow.add({type = "label", caption = "Selecionar Portal: "})
        local dropdown = dropdown_flow.add({
            type = "drop-down",
            name = "quantum_portal_dest_dropdown",
            items = items,
            selected_index = 1
        })
        dropdown.style.width = 280

        -- Detalhes do destino selecionado
        local first_dest = destinations[1]
        local dest_detail_box = dest_frame.add({
            type = "flow",
            name = "quantum_portal_dest_info_box",
            direction = "vertical"
        })
        dest_detail_box.style.top_margin = 6

        PortalGui.renderDestDetails(dest_detail_box, portal_entity, first_dest)
    end

    -- =========================================================================
    -- SEÇÃO 3: Ação de Teletransporte
    -- =========================================================================
    local action_flow = root_flow.add({type = "flow", direction = "horizontal"})
    action_flow.style.top_margin = 4
    action_flow.style.horizontally_stretchable = true

    local can_teleport = (#destinations > 0) and (current_energy >= energy_cost)

    local teleport_btn = action_flow.add({
        type = "button",
        name = "quantum_portal_teleport_btn",
        caption = "ATIVAR SALTO QUÂNTICO",
        style = can_teleport and "confirm_button" or "button",
        enabled = can_teleport
    })
    teleport_btn.style.horizontally_stretchable = true
    teleport_btn.style.height = 36
    teleport_btn.tags = {
        origin_unit_number = unit_number
    }

    -- Centraliza a janela na tela
    window.force_auto_center()

    -- Associa a janela ao player.opened para fechar naturalmente com ESC ou 'E'
    player.opened = window
end

--- Renderiza os detalhes do portal de destino selecionado
function PortalGui.renderDestDetails(container, origin_entity, dest_entry)
    container.clear()
    if not dest_entry then return end

    local dest_entity = dest_entry.entity
    local is_dest_valid = LDARuntime.entity.isValid(dest_entity)

    local origin_surface = LDARuntime.entity.getSurface(origin_entity)
    local dest_surface_name = dest_entry.surface_name

    local distance_text
    if origin_surface and origin_surface.name == dest_surface_name then
        local dist = LDARuntime.world.getDistance(origin_entity.position, dest_entry.position)
        distance_text = string.format("Distância: %.0f blocos (Mesmo Planeta)", dist)
    else
        distance_text = string.format("Salto Interplanetário: %s ➔ %s", origin_surface and origin_surface.name or "?", dest_surface_name)
    end

    local dest_gps = LDARuntime.world.formatGps(dest_entry.position, dest_surface_name)

    container.add({
        type = "label",
        caption = string.format("Destino: [font=default-bold]%s[/font]", dest_entry.name)
    })
    local sub_info = container.add({
        type = "label",
        caption = string.format("%s  %s", distance_text, dest_gps)
    })
    sub_info.style.font_color = {r = 0.7, g = 0.7, b = 0.7}

    if not is_dest_valid then
        local warn = container.add({
            type = "label",
            caption = "[AVISO] O portal de destino parece estar inativo ou obstruído!"
        })
        warn.style.font_color = {r = 1.0, g = 0.4, b = 0.2}
    end
end

--- Manipula cliques nos elementos da interface do portal
--- @param event table Evento on_gui_click
function PortalGui.on_gui_click(event)
    local element = event.element
    if not element or not element.valid then return end

    local player = LDARuntime.player.get(event.player_index)
    if not player then return end

    -- Botão fechar
    if element.name == "quantum_portal_close_btn" then
        PortalGui.close(player)
        return
    end

    -- Botão Salvar Nome do Portal
    if element.name == "quantum_portal_save_name_btn" then
        local window = player.gui.screen[WINDOW_NAME]
        if window and element.tags and element.tags.unit_number then
            local textfield = LDARuntime.gui.findElementByName(window, "quantum_portal_name_input")
            if textfield and textfield.valid then
                local new_name = textfield.text
                if string.len(new_name) > 0 then
                    LDARuntime.network.setName(NETWORK_NAME, element.tags.unit_number, new_name)
                    LDARuntime.player.flyingText(player, "Nome atualizado!", {color = {r=0.2, g=1, b=0.4}})
                    LDARuntime.player.notify(player, "Nome do portal alterado para: " .. new_name)
                end
            end
        end
        return
    end

    -- Botão Teletransportar
    if element.name == "quantum_portal_teleport_btn" then
        local window = player.gui.screen[WINDOW_NAME]
        if not window then return end

        local origin_id = element.tags and element.tags.origin_unit_number
        if not origin_id then return end

        local origin_entry = LDARuntime.network.get(NETWORK_NAME, origin_id)
        if not origin_entry or not LDARuntime.entity.isValid(origin_entry.entity) then
            LDARuntime.player.notify(player, "Erro: Portal de origem não encontrado ou inválido.")
            PortalGui.close(player)
            return
        end

        local origin_entity = origin_entry.entity

        -- Verifica energia do portal
        local energy_cost = TELEPORT_ENERGY_COST
        local current_energy = LDARuntime.entity.getEnergy(origin_entity)
        if current_energy < energy_cost then
            LDARuntime.player.flyingText(player, "Energia insuficiente no portal!", {color = {r=1, g=0.2, b=0.2}})
            LDARuntime.player.notify(player, string.format(
                "Energia insuficiente. Necessário: %s (Atual: %s)",
                LDARuntime.gui.formatEnergy(energy_cost),
                LDARuntime.gui.formatEnergy(current_energy)
            ))
            return
        end

        -- Descobre destino selecionado no dropdown
        local dropdown = LDARuntime.gui.findElementByName(window, "quantum_portal_dest_dropdown")
        if not dropdown or not dropdown.valid then
            LDARuntime.player.notify(player, "Nenhum destino selecionado.")
            return
        end

        local destinations = get_available_destinations(player.force.name, origin_id)
        local selected_idx = dropdown.selected_index
        local dest_entry = destinations[selected_idx]

        if not dest_entry or not LDARuntime.entity.isValid(dest_entry.entity) then
            LDARuntime.player.notify(player, "Erro: Portal de destino não está mais disponível.")
            PortalGui.close(player)
            return
        end

        local dest_entity = dest_entry.entity
        local dest_surface = LDARuntime.entity.getSurface(dest_entity)
        local dest_pos = LDARuntime.network.findFreeSpawnPosition(dest_entity, "character", 8)
        if not dest_surface or not dest_pos then
            LDARuntime.player.notify(player, "Não foi encontrada uma posição livre perto do portal de destino.")
            return
        end

        local origin_pos = LDARuntime.player.getPosition(player)

        -- Salto Quântico usando a LDA-LIB
        local success = LDARuntime.player.teleport(player, dest_pos, dest_surface)

        if success then
            LDARuntime.entity.setEnergy(origin_entity, current_energy - energy_cost)
            LDARuntime.world.createExplosion(
                LDARuntime.entity.getSurface(origin_entity),
                origin_pos,
                "big-explosion"
            )
            -- Efeitos de chegada no destino
            player.play_sound({path = "quantum-teleported-sound", position = dest_pos})
            LDARuntime.world.createExplosion(dest_surface, dest_pos, "big-explosion")
            LDARuntime.player.notify(player, string.format("Teleportado com sucesso para: %s!", dest_entry.name or "Portal"))
            LDARuntime.player.flyingText(player, "Salto Quântico Concluído!", {color = {r=0.2, g=0.8, b=1.0}})
        else
            LDARuntime.player.notify(player, "O Factorio recusou a posição de destino; nenhuma energia foi consumida.")
        end

        -- Fecha a interface após o teleporte
        PortalGui.close(player)
    end
end

--- Atualiza a interface quando o jogador escolhe outro portal no dropdown
--- @param event table Evento on_gui_selection_state_changed
function PortalGui.on_selection_changed(event)
    local element = event.element
    if not element or not element.valid then return end
    if element.name ~= "quantum_portal_dest_dropdown" then return end

    local player = LDARuntime.player.get(event.player_index)
    if not player then return end

    local window = player.gui.screen[WINDOW_NAME]
    if not window then return end

    local teleport_btn = LDARuntime.gui.findElementByName(window, "quantum_portal_teleport_btn")
    local origin_id = teleport_btn and teleport_btn.tags and teleport_btn.tags.origin_unit_number
    if not origin_id then return end

    local origin_entry = LDARuntime.network.get(NETWORK_NAME, origin_id)
    if not origin_entry then return end

    local destinations = get_available_destinations(player.force.name, origin_id)
    local selected_dest = destinations[element.selected_index]

    local detail_box = LDARuntime.gui.findElementByName(window, "quantum_portal_dest_info_box")
    if detail_box and detail_box.valid then
        PortalGui.renderDestDetails(detail_box, origin_entry.entity, selected_dest)
    end
end

return PortalGui
