-- data/utils.lua
-- Utilitários locais do Quantum Teleporter
-- Nota: O builder de acumulador (createAccumulator) foi oficialmente incorporado à LDA-LIB (v0.0.17+).

local functions = {}
local LDAFunctions = require("__LDA-LIB__/init")
local PATH = LDAFunctions.setBasePath("Quantum-Teleporter")

--- Cria item de bloco com receita usando a LDA-LIB
function functions.createBlockItem(name, ingredients, alternative_unlock_methods, isEnabled)
    return LDAFunctions.createBlockItemWithRecipe(
        name,
        "itens",
        1,
        "advanced-crafting",
        120,
        ingredients,
        {
            {type = "item", name = name, amount = 1}
        },
        alternative_unlock_methods,
        isEnabled,
        nil,
        512
    )
end

--- Cria itens de peças de portal com receita usando a LDA-LIB
function functions.createPortalPartsItem(name, ingredients, alternative_unlock_methods, isEnabled)
    return LDAFunctions.createItemWithRecipe(
        name,
        "itens",
        10,
        "portal-parts",
        120,
        ingredients,
        {
            {type = "item", name = name, amount = 1}
        },
        alternative_unlock_methods,
        isEnabled
    )
end

return functions
