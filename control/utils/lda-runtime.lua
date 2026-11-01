-- control/utils/lda-runtime.lua
-- Carregador seguro dos módulos de runtime da LDA-LIB
--
-- [FEATURE REQUEST / BUG REPORT TO LDA-LIB: runtime/init.lua & runtime/commands.lua]
-- Importar "__LDA-LIB__/runtime.init" em mods dependentes causa colisão do comando
-- de console "lda-list" (commands.add_command falha se o comando já existe).
-- Este utilitário consome diretamente os módulos oficiais da LDA-LIB sem reexecutar
-- o registro de comandos do mod base.

local player_module = require("__LDA-LIB__/runtime/modules/player")

local function player_id(player_or_id)
    if type(player_or_id) == "number" or type(player_or_id) == "string" then
        return player_or_id
    end
    return player_or_id and player_or_id.index
end

local function bind_player(fn)
    return function(player_or_id, ...)
        return fn(player_id(player_or_id), ...)
    end
end

local world_module = require("__LDA-LIB__/runtime/modules/world")

local function surface_id(surface_or_id)
    if type(surface_or_id) == "string" or type(surface_or_id) == "number" or surface_or_id == nil then
        return surface_or_id
    end
    return surface_or_id.name
end

local function bind_surface(fn)
    return function(surface_or_id, ...)
        return fn(surface_id(surface_or_id), ...)
    end
end

return {
    player = {
        get = bind_player(player_module.get),
        isValid = player_module.isValid,
        getCharacter = bind_player(player_module.getCharacter),
        getPosition = bind_player(player_module.getPosition),
        getSurface = bind_player(player_module.getSurface),
        getGps = bind_player(player_module.getGps),
        getItemCount = bind_player(player_module.getItemCount),
        hasItem = bind_player(player_module.hasItem),
        give = bind_player(player_module.give),
        remove = bind_player(player_module.remove),
        teleport = bind_player(player_module.teleport),
        flyingText = bind_player(player_module.flyingText),
        notify = bind_player(player_module.notify)
    },
    entity = require("__LDA-LIB__/runtime/modules/entity"),
    world = {
        getSurface = bind_surface(world_module.getSurface),
        getDistance = world_module.getDistance,
        formatGps = function(position, surface)
            return world_module.formatGps(position, surface_id(surface))
        end,
        findEntitiesInRadius = bind_surface(world_module.findEntitiesInRadius),
        findEntitiesInBox = bind_surface(world_module.findEntitiesInBox),
        findFreePosition = bind_surface(world_module.findFreePosition),
        spawnEntity = bind_surface(world_module.spawnEntity),
        setTile = bind_surface(world_module.setTile),
        setTiles = bind_surface(world_module.setTiles),
        getTile = bind_surface(world_module.getTile),
        createExplosion = bind_surface(world_module.createExplosion),
        teleportEntity = function(entity, position, surface)
            return world_module.teleportEntity(entity, position, surface_id(surface))
        end
    },
    item   = require("__LDA-LIB__/runtime/modules/item")
}
