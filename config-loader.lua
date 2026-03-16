local Config = {}

local cache = {}

--- Obtém o multiplicador de dificuldade
--- @return number
function Config.getDifficultyMultiplier()
    return Config.get("difficulty-multiplier")
end

--- Obtém valor de configuração do mod
--- Procura automaticamente em startup, global ou player
--- @param name string Nome da configuração
--- @return any
function Config.get(name)

    if cache[name] then
        return cache[name]
    end

    local value

    if settings.startup and settings.startup[name] then
        value = settings.startup[name].value
    elseif settings.global and settings.global[name] then
        value = settings.global[name].value
    elseif settings.player and settings.player[name] then
        value = settings.player[name].value
    end

    if value == nil then
        error("Setting não encontrado: " .. name)
    end

    cache[name] = value
    return value
end

return Config