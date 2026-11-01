-- control/utils/portal-network.lua
-- Gerenciador da Rede Quântica de Portais
--
-- [FEATURE REQUEST TO LDA-LIB: runtime.modules.network]
-- A biblioteca LDA-LIB possui módulos excelentes para player, entity, world e item,
-- mas ainda não possui um módulo 'network' para gerenciar registros e listas globais
-- de entidades vinculadas no storage (ex: teleporters, radares, balizadores).
-- Enquanto a funcionalidade não entra oficialmente na LDA-LIB, mantemos este módulo em utils.

local LDARuntime = require("control.utils.lda-runtime")
local PortalNetwork = {}

local TELEPORT_ENERGY_COST = 20e6 -- 20 MJ por teletransporte via portal

--- Garante que a tabela da rede no storage esteja inicializada
function PortalNetwork.initStorage()
    if not storage then return end
    storage.portal_network = storage.portal_network or {}
end

--- Registra um portal construído na rede
--- @param entity LuaEntity
--- @return table|nil
function PortalNetwork.register(entity)
    if not LDARuntime.entity.isValid(entity) then return nil end
    if entity.name ~= "quantum-teleporter-portal" then return nil end

    PortalNetwork.initStorage()

    local unit_number = entity.unit_number
    if not unit_number then return nil end

    local surface = LDARuntime.entity.getSurface(entity)
    local pos = LDARuntime.entity.getPosition(entity)
    local force = LDARuntime.entity.getForce(entity)

    local default_name = string.format("Portal #%d (%s)", unit_number, surface and surface.name or "desconhecido")

    local entry = {
        unit_number = unit_number,
        entity = entity,
        surface_name = surface and surface.name or "nauvis",
        position = pos or {x = 0, y = 0},
        force_name = force and force.name or "player",
        name = default_name,
        created_tick = game.tick
    }

    storage.portal_network[unit_number] = entry
    log(string.format("[Quantum-Teleporter] Portal registrado: %s [ID: %d]", entry.name, unit_number))
    return entry
end

--- Remove um portal da rede quando destruído ou minerado
--- @param entity LuaEntity
function PortalNetwork.unregister(entity)
    if not entity then return end
    PortalNetwork.initStorage()

    local unit_number = entity.unit_number
    if unit_number and storage.portal_network[unit_number] then
        storage.portal_network[unit_number] = nil
        log(string.format("[Quantum-Teleporter] Portal removido da rede: ID %d", unit_number))
    end
end

--- Retorna os dados de um portal específico
--- @param unit_number number
--- @return table|nil
function PortalNetwork.get(unit_number)
    PortalNetwork.initStorage()
    local entry = storage.portal_network[unit_number]
    if not entry then return nil end

    -- Limpa do storage caso a entidade não seja mais válida
    if not LDARuntime.entity.isValid(entry.entity) then
        storage.portal_network[unit_number] = nil
        return nil
    end

    return entry
end

--- Atualiza o nome personalizado de um portal
--- @param unit_number number
--- @param new_name string
--- @return boolean
function PortalNetwork.setName(unit_number, new_name)
    local entry = PortalNetwork.get(unit_number)
    if not entry then return false end

    if new_name and string.len(new_name) > 0 then
        entry.name = new_name
        return true
    end
    return false
end

--- Retorna todos os portais válidos da mesma força, excluindo opcionalmente o portal de origem
--- @param force_name string
--- @param exclude_unit_number number|nil
--- @return table[]
function PortalNetwork.getAvailableDestinations(force_name, exclude_unit_number)
    PortalNetwork.initStorage()
    local destinations = {}

    for unit_number, entry in pairs(storage.portal_network) do
        if not LDARuntime.entity.isValid(entry.entity) then
            -- Auto-limpeza de referências mortas
            storage.portal_network[unit_number] = nil
        else
            local matches_force = (entry.force_name == force_name)
            local not_excluded = (exclude_unit_number == nil or unit_number ~= exclude_unit_number)

            if matches_force and not_excluded then
                table.insert(destinations, entry)
            end
        end
    end

    -- Ordena alfabeticamente por nome para facilidade na interface
    table.sort(destinations, function(a, b)
        return (a.name or "") < (b.name or "")
    end)

    return destinations
end

--- Encontra uma posição segura e livre de colisão ao redor do portal para o jogador
--- @param portal_entity LuaEntity
--- @return table
function PortalNetwork.getSpawnPosition(portal_entity)
    if not LDARuntime.entity.isValid(portal_entity) then
        return {x = 0, y = 0}
    end

    local surface = LDARuntime.entity.getSurface(portal_entity)
    local pos = LDARuntime.entity.getPosition(portal_entity)

    -- Tenta encontrar uma posição desobstruída nas imediações do portal
    local free_pos = LDARuntime.world.findFreePosition(surface, "character", pos, 12, 1)
    if free_pos then
        return free_pos
    end

    -- Fallback: 6 tiles ao sul da base do portal
    return {x = pos.x, y = pos.y + 6}
end

--- Custo de energia fixo em Joules para uso do portal
function PortalNetwork.getEnergyCost()
    return TELEPORT_ENERGY_COST
end

return PortalNetwork

