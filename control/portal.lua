-- control/portal.lua
-- Lógica de eventos e ciclo de vida da Rede Quântica de Portais
-- Integração com LDA-LIB no runtime e registro de rede no storage.

local LDARuntime = require("__LDA-LIB__/runtime.init")
local PortalNetwork = require("control.utils.portal-network")
local PortalGui = require("control.gui.portal-gui")

local PORTAL_NAME = "quantum-teleporter-portal"

--- Varre todas as superfícies do jogo para sincronizar portais já existentes
local function sync_existing_portals()
    PortalNetwork.initStorage()
    if not game or not game.surfaces then return end

    local count = 0
    for _, surface in pairs(game.surfaces) do
        local portals = surface.find_entities_filtered({name = PORTAL_NAME})
        for _, portal in ipairs(portals) do
            if LDARuntime.entity.isValid(portal) then
                PortalNetwork.register(portal)
                count = count + 1
            end
        end
    end
    log(string.format("[Quantum-Teleporter] Sincronização concluída: %d portais registrados na rede.", count))
end

-- =============================================================================
-- CICLO DE VIDA DO MOD (INIT / CONFIG CHANGED)
-- =============================================================================

script.on_init(function()
    PortalNetwork.initStorage()
    sync_existing_portals()
    log("[Quantum-Teleporter] Rede de Portais Quânticos inicializada com sucesso.")
end)

script.on_configuration_changed(function(event)
    PortalNetwork.initStorage()
    sync_existing_portals()
    log("[Quantum-Teleporter] Configuração alterada - rede de portais sincronizada.")
end)

-- =============================================================================
-- CONSTRUÇÃO DE PORTAIS
-- =============================================================================

local function on_portal_created(event)
    local entity = event.entity or event.created_entity
    if not entity or not entity.valid then return end

    if entity.name == PORTAL_NAME then
        local entry = PortalNetwork.register(entity)
        local player = LDARuntime.player.get(event.player_index)
        if player and entry then
            LDARuntime.player.notify(player, string.format("[Quantum Teleporter] %s conectado à rede quântica!", entry.name))
        end
    end
end

script.on_event(defines.events.on_built_entity, on_portal_created)
script.on_event(defines.events.on_robot_built_entity, on_portal_created)
script.on_event(defines.events.script_raised_built, on_portal_created)
if defines.events.on_space_platform_built_entity then
    script.on_event(defines.events.on_space_platform_built_entity, on_portal_created)
end

-- =============================================================================
-- DESTRUIÇÃO / MINERAÇÃO DE PORTAIS
-- =============================================================================

local function on_portal_removed(event)
    local entity = event.entity
    if not entity or not entity.valid then return end

    if entity.name == PORTAL_NAME then
        PortalNetwork.unregister(entity)
    end
end

script.on_event(defines.events.on_player_mined_entity, on_portal_removed)
script.on_event(defines.events.on_robot_mined_entity, on_portal_removed)
script.on_event(defines.events.on_entity_died, on_portal_removed)
script.on_event(defines.events.script_raised_destroy, on_portal_removed)

-- =============================================================================
-- ABERTURA E FECHAMENTO DA INTERFACE DO PORTAL
-- =============================================================================

-- Abrir interface ao clicar com o botão esquerdo ou abrir o portal
script.on_event(defines.events.on_gui_opened, function(event)
    if event.gui_type == defines.gui_type.entity then
        local entity = event.entity
        if entity and entity.valid and entity.name == PORTAL_NAME then
            local player = LDARuntime.player.get(event.player_index)
            if player then
                PortalGui.open(player, entity)
            end
        end
    end
end)

-- Fechar interface customizada do portal
script.on_event(defines.events.on_gui_closed, function(event)
    if event.gui_type == defines.gui_type.custom then
        local element = event.element
        if element and element.valid and element.name == "quantum_portal_window" then
            local player = LDARuntime.player.get(event.player_index)
            if player then
                PortalGui.close(player)
            end
        end
    end
end)

return {
    sync_existing_portals = sync_existing_portals
}
