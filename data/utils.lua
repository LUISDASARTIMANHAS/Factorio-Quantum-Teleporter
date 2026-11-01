-- data/utils.lua
-- Utilitários locais do Quantum Teleporter
-- NOTA: Funções ausentes na LDA-LIB oficial são adicionadas aqui temporariamente
-- e reportadas como Feature Request para a biblioteca.

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

--------------------------------------------------------------------------------
-- [FEATURE REQUEST TO LDA-LIB: data-stage.builders.base.create-accumulator]
-- A biblioteca LDA-LIB possui builders para solar-panel (createEntity), fluidos,
-- receitas e itens, mas carece de um builder modular para AccumulatorPrototype.
-- Enquanto não é adicionado oficialmente à LDA-LIB, implementamos aqui em utils:
--------------------------------------------------------------------------------
function functions.createAccumulator(params)
    local LDAUtils = LDAFunctions.utils
    local LDAUtilsEnergySource = LDAFunctions.utilsEnergySource
    local LDAUtilsAnimations = LDAFunctions.utilsAnimations

    local name = params.name
    local icon = params.icon
    local icon_size = params.icon_size or 512
    local boxSize = params.box_size or 10
    local buffer_capacity = params.buffer_capacity or "200MJ"
    local input_flow_limit = params.input_flow_limit or "50MW"
    local output_flow_limit = params.output_flow_limit or "0kW"

    local energy_source = LDAUtilsEnergySource.createElectricEnergySource(
        "secondary-input",
        buffer_capacity,
        input_flow_limit,
        output_flow_limit,
        0,
        false,
        false
    )

    return {
        type = "accumulator",
        name = name,
        icon = icon,
        icon_size = icon_size,
        icon_mipmaps = params.icon_mipmaps or 4,
        flags = {"placeable-neutral", "player-creation"},
        minable = {
            mining_time = params.mining_time or 30,
            results = {
                {type = "item", name = name, amount = 1}
            }
        },
        max_health = params.max_health or 1500,
        corpse = params.corpse or "assembling-machine-2-remnants",
        dying_explosion = params.dying_explosion or "assembling-machine-2-explosion",
        collision_box = LDAUtils.createBoundingBox(boxSize, boxSize),
        selection_box = LDAUtils.createBoundingBox(boxSize, boxSize),
        drawing_box = LDAUtils.createBoundingBox(boxSize, boxSize),
        energy_source = energy_source,
        surface_conditions = params.surface_conditions or {
            {property = "pressure", min = 10}
        },
        resistances = params.resistances or {
            LDAUtils.createResistance("fire", 70),
            LDAUtils.createResistance("physical", 100),
            LDAUtils.createResistance("impact", 100),
            LDAUtils.createResistance("electric", 5),
            LDAUtils.createResistance("explosion", 97),
            LDAUtils.createResistance("laser", 100)
        },
        chargable_graphics = {
            picture = {
                layers = {
                    {
                        filename = icon,
                        priority = "high",
                        width = icon_size,
                        height = icon_size,
                        scale = params.scale or ((boxSize * 32 * 2) / icon_size),
                        shift = {0, 0}
                    }
                }
            }
        },
        working_sound = params.working_sound,
        close_sound = params.close_sound,
        open_sound = params.open_sound
    }
end

return functions
