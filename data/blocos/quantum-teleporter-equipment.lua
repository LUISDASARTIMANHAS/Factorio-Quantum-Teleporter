local LDAFunctions = require("__LDA-LIB__/init")
local LDAUtils = LDAFunctions.utils
local LDAUtilsEnergySource = LDAFunctions.utilsEnergySource
local PATH = LDAFunctions.setBasePath("Quantum-Teleporter")
-- LDA.utilsEnergySource.createElectricEnergySource(usag
-- LDA.utils.getAudio(filename, volume)
-- LDA.utils.getSequentialAudioList(base_filename, start_index, end_index, volume)

data:extend(
    {
        {
            type = "movement-bonus-equipment",
            name = "quantum-teleporter-equipment",
            categories = {"armor"},
            icon_size = 128,
            energy_consumption = "20MW",
            take_result = "quantum-teleporter-equipment",
            sprite = {
                filename = PATH .. "graphics/icons/quantum-teleporter-equipment.png",
                width = 128,
                height = 128,
                priority = "medium"
            },
            shape = {
                type = "full",
                width = 2,
                height = 2
            },
            energy_source = LDAUtilsEnergySource.createElectricEnergySource(
                "secondary-input",
                "112MW",
                "52kW",
                nil,
                0,
                false,
                false
            ),
            movement_bonus = 0,
            activate_sound = LDAUtils.getAudio("audio/portal.ogg"),
            deactivate_sound = LDAUtils.getAudio("__base__/sound/nightvision-off.ogg")
        }
    }
)

-- usado como base, __base__/prototypes/equipment.lua

-- {
--     type = "movement-bonus-equipment",
--     name = "exoskeleton-equipment",
--     sprite =
--     {
--       filename = "__base__/graphics/equipment/exoskeleton-equipment.png",
--       width = 128,
--       height = 256,
--       priority = "medium",
--       scale = 0.5
--     },
--     shape =
--     {
--       width = 2,
--       height = 4,
--       type = "full"
--     },
--     energy_source =
--     {
--       type = "electric",
--       usage_priority = "secondary-input"
--     },
--     energy_consumption = "200kW",
--     movement_bonus = 0.3,
--     categories = {"armor"}
--   },


-- usado como base, __base__/prototypes/item.lua


-- {
--     type = "item",
--     name = "exoskeleton-equipment",
--     icon = "__base__/graphics/icons/exoskeleton-equipment.png",
--     place_as_equipment_result = "exoskeleton-equipment",
--     subgroup = "utility-equipment",
--     order = "d[exoskeleton]-a[exoskeleton-equipment]",
--     inventory_move_sound = item_sounds.exoskeleton_inventory_move,
--     pick_sound = item_sounds.exoskeleton_inventory_pickup,
--     drop_sound = item_sounds.exoskeleton_inventory_move,
--     stack_size = 20
--   },


-- usado como base, __base__/prototypes/recipe.lua


-- {
--     type = "recipe",
--     name = "exoskeleton-equipment",
--     enabled = false,
--     energy_required = 10,
--     ingredients =
--     {
--       {type = "item", name = "processing-unit", amount = 10},
--       {type = "item", name = "electric-engine-unit", amount = 30},
--       {type = "item", name = "steel-plate", amount = 20}
--     },
--     results = {{type="item", name="exoskeleton-equipment", amount=1}}
--   },