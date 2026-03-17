local LDAFunctions = require("__LDA-LIB__/init")
local PATH = LDAFunctions.setBasePath("Quantum-Teleporter")

local config = require("config-loader")
local multiplier = config.getDifficultyMultiplier()

local utils = require("data.utils")
-- category = "advanced-crafting" maquinas de montagem tier 2 e 3
-- category = "basic-crafting" maquinas de montagem tier 1
-- category = "crafting" feito a mão
-- category = "smelting" feito em fornalhas
-- category = "centrifuging" feito na centrifuge
-- category = "portal-parts" feito em portais em construção
-- createBlockItemWithRecipe(name, subgroup, stack_size, crafted_in, time, ingredients, results,alternative_unlock_methods,isEnabled,pictures,icon_size,pick_sound,drop_sound)
-- createItemWithRecipe(name, subgroup, stack_size, crafted_in, time, ingredients, results,alternative_unlock_methods,isEnabled,pictures)

-- quantum-teleporter-equipment
data:extend(
    LDAFunctions.createEquipmentItemWithRecipe(
        "quantum-teleporter-equipment",
        nil,
        10,
        "advanced-crafting",
        120,
        {
            {type = "item", name = "supercapacitor", amount = 2048 * multiplier},
            {type = "item", name = "tungsten-plate", amount = 128 * multiplier},
            {type = "item", name = "carbon-fiber", amount = 32 * multiplier},
            {type = "item", name = "quantum-processor", amount = 128 * multiplier}
        },
        {
            {type = "item", name = "quantum-teleporter-equipment", amount = 1}
        },
        {"Quantum-Teleporter"}
    )
)

data:extend(
    utils.createBlockItem(
        "quantum-teleporter-portal-T1",
        -- ingredients
        {
            {type = "item", name = "quantum-processor", amount = 128 * multiplier},
            {type = "item", name = "tungsten-plate", amount = 2560 * multiplier},
            {type = "item", name = "superconductor", amount = 512 * multiplier},
            {type = "item", name = "carbon-fiber", amount = 1024 * multiplier}
        },
        nil,
        true
    )
)

data:extend(
    utils.createBlockItem(
        "quantum-teleporter-portal-T2",
        -- ingredients
        {
            {type = "item", name = "part-portal-T1", amount = 2500 * multiplier},
            {type = "item", name = "quantum-teleporter-portal-T1", amount = 1},
            {type = "item", name = "quantum-processor", amount = 256 * multiplier},
            {type = "item", name = "tungsten-plate", amount = 5120 * multiplier},
            {type = "item", name = "superconductor", amount = 1024 * multiplier},
            {type = "item", name = "carbon-fiber", amount = 2048 * multiplier}
        },
        {"Quantum-Teleporter"},
        false
    )
)

data:extend(
    utils.createBlockItem(
        "quantum-teleporter-portal",
        -- ingredients
        {
            {type = "item", name = "part-portal-T2", amount = 5000 * multiplier},
            {type = "item", name = "quantum-teleporter-portal-T2", amount = 1},
            {type = "item", name = "quantum-processor", amount = 512 * multiplier},
            {type = "item", name = "tungsten-plate", amount = 10240 * multiplier},
            {type = "item", name = "superconductor", amount = 2048 * multiplier},
            {type = "item", name = "carbon-fiber", amount = 4096 * multiplier}
        },
        {"Quantum-Teleporter"},
        false
    )
)

data:extend(
    utils.createPortalPartsItem(
        "part-portal-T1",
        -- ingredients
        {
            {type = "item", name = "quantum-processor", amount = 128},
            {type = "item", name = "tungsten-plate", amount = 1024},
            {type = "item", name = "superconductor", amount = 512},
            {type = "item", name = "carbon-fiber", amount = 4096}
        },
        {"Quantum-Teleporter"},
        true
    )
)

data:extend(
    utils.createPortalPartsItem(
        "part-portal-T2",
        -- ingredients
        {
            {type = "item", name = "quantum-processor", amount = 512},
            {type = "item", name = "tungsten-plate", amount = 4096},
            {type = "item", name = "superconductor", amount = 2048},
            {type = "item", name = "carbon-fiber", amount = 4096}
        },
        {"Quantum-Teleporter"},
        true
    )
)