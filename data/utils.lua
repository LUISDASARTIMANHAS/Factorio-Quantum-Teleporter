local functions = {}
local LDAFunctions = require("__LDA-LIB__/init")
local PATH = LDAFunctions.setBasePath("Quantum-Teleporter")
-- category = "advanced-crafting" maquinas de montagem tier 2 e 3
-- category = "basic-crafting" maquinas de montagem tier 1
-- category = "crafting" feito a mão
-- category = "smelting" feito em fornalhas
-- category = "centrifuging" feito na centrifuge
-- category = "portal-parts" feito em portais em construção
-- createBlockItemWithRecipe(name, subgroup, stack_size, crafted_in, time, ingredients, results,alternative_unlock_methods,isEnabled,pictures,icon_size,pick_sound,drop_sound)
-- createItemWithRecipe(name, subgroup, stack_size, crafted_in, time, ingredients, results,alternative_unlock_methods,isEnabled,pictures)

-- graphics/icons - icones de itens

function functions.createBlockItem(name, ingredients, alternative_unlock_methods, isEnabled)
    return LDAFunctions.createBlockItemWithRecipe(
        name,
        "itens",
        1,
        "advanced-crafting",
        120,
        -- ingredients
        ingredients,
        {
            {type = "item", name = name, amount = 1}
        },
        alternative_unlock_methods,
        isEnabled,
        nil,
        500
    )
end

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
