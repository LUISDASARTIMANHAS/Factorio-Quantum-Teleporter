local gameSounds = "__base__/sound/"
local boxSize = 10
local LDAFunctions = require("__LDA-LIB__/init")
local LDAUtils = LDAFunctions.utils
local LDAUtilsAnimations = LDAFunctions.utilsAnimations
local LDAUtilsEnergySource = LDAFunctions.utilsEnergySource
local PATH = LDAFunctions.setBasePath("Quantum-Teleporter")
local defaultFilename = PATH .. "graphics/icons/quantum-teleporter-portal"
local defaultIconSize = 512
-- LDA.utils.createBoundingBox(x, y)
-- LDA.utilsEnergySource.createElectricEnergySource(usage_priority, buffer_capacity, input_flow_limit, output_flow_limit, emissions_per_minute, render_no_power_icon, render_no_network_icon, params)
-- LDA.utils.getAudio(filename, volume)
-- LDA.utils.getSequentialAudioList(base_filename, start_index, end_index, volume)
-- LDA.utils.createResistance(resistenceType, percent)
-- LDA.utils.getFullResistance(percent)
-- LDA.utils.createModuleSpec(slots, icon_shift)
-- LDA.utilsAnimations.createAnimation(layers)
-- LDA.utilsAnimations.createAnimationLayer(filename, width, height, hr_scale, shift, draw_as_shadow, custom_props)

data:extend(
    {
        {
            type = "accumulator",
            name = "quantum-teleporter-portal",
            icon = defaultFilename .. ".png",
            icon_size = defaultIconSize,
            icon_mipmaps = 4,
            minable = {
                mining_time = 30,
                results = {
                    {type = "item", name = "quantum-teleporter-portal", amount = 1}
                }
            },
            build_grid_size = 2,
            inventory_size = 80,
            max_health = 1500,
            crafting_speed = 1,
            is_military_target = true,
            off_when_no_fluid_recipe = true,
            energy_usage = "20MW",
            crafting_categories = {"crafting"},
            -- corpse = "big-remnants",
            corpse = "assembling-machine-2-remnants",
            radar_range = 4,
            -- dying_explosion = "big-explosion",
            dying_explosion = "assembling-machine-2-explosion",
            -- Não pode ser construido no espaço
            surface_conditions = {
                {property = "pressure", min = 10}
            },
            alert_icon_shift = {-0.09375, -0.375},
            collision_box = LDAUtils.createBoundingBox(boxSize, boxSize),
            selection_box = LDAUtils.createBoundingBox(boxSize, boxSize),
            drawing_box = LDAUtils.createBoundingBox(boxSize, boxSize),
            energy_source = LDAUtilsEnergySource.createElectricEnergySource(
                "primary-input",
                "200MW",
                "30kW",
                nil,
                0,
                false,
                false,
                {drain = "20MW"}
            ),
            resistances = {
                LDAUtils.createResistance("fire", 70),
                LDAUtils.createResistance("physical", 100),
                LDAUtils.createResistance("impact", 100),
                LDAUtils.createResistance("electric", 5),
                LDAUtils.createResistance("explosion", 97),
                LDAUtils.createResistance("laser", 100)
            },
            damaged_trigger_effect = {
                entity_name = "spark-explosion",
                type = "create-entity",
                damage_type_filters = "fire",
                offsets = {{0, 1}},
                offset_deviation = {{-0.5, -0.5}, {0.5, 0.5}}
            },
            allowed_effects = {
                "consumption",
                "speed",
                "productivity",
                "pollution"
            },
            flags = {
                "placeable-neutral",
                "placeable-player",
                "player-creation"
            },
            placeable_by = {
                item = "quantum-teleporter-portal",
                count = 1
            },
            module_specification = LDAUtils.createModuleSpec(0, 0.5),
            working_sound = {
                sound = LDAUtils.getAudio(PATH .. "audio/portal", 0.45),
                idle_sound = LDAUtils.getAudio(gameSounds .. "nuclear-reactor-2")
            },
            -- renderiza a entidade no mapa
            graphics_set = {
                animation = LDAUtilsAnimations.createAnimation(
                    LDAUtilsAnimations.createAnimationLayer(defaultFilename, defaultIconSize, defaultIconSize)
                )
            },
            close_sound = {
                LDAUtils.getAudio(gameSounds .. "machine-close")
            },
            open_sound = {
                LDAUtils.getAudio(gameSounds .. "machine-open")
            }
        }
    }
)

-- usado como base, __base__/prototypes/item.lua
-- {
--     type = "item",
--     name = "electric-energy-interface",
--     icons = {{icon = "__base__/graphics/icons/accumulator.png", tint = {1, 0.8, 1, 1}}},
--     hidden = true,
--     subgroup = "other",
--     order = "a[electric-energy-interface]-b[electric-energy-interface]",
--     inventory_move_sound = item_sounds.electric_large_inventory_move,
--     pick_sound = item_sounds.electric_large_inventory_pickup,
--     drop_sound = item_sounds.electric_large_inventory_move,
--     place_result = "electric-energy-interface",
--     stack_size = 50
--   },

-- usado como base, __base__/prototypes/recipes.lua

-- {
--     type = "recipe",
--     name = "accumulator",
--     energy_required = 10,
--     enabled = false,
--     ingredients =
--     {
--       {type = "item", name = "iron-plate", amount = 2},
--       {type = "item", name = "battery", amount = 5}
--     },
--     results = {{type="item", name="accumulator", amount=1}}
--   },

-- https://lua-api.factorio.com/latest/prototypes/AccumulatorPrototype.html#examples
-- {
--     type = "accumulator",
--     name = "accumulator",
--     icon = "__base__/graphics/icons/accumulator.png",
--     flags = {"placeable-neutral", "player-creation"},
--     minable = {mining_time = 0.1, result = "accumulator"},
--     fast_replaceable_group = "accumulator",
--     max_health = 150,
--     corpse = "accumulator-remnants",
--     collision_box = {{-0.9, -0.9}, {0.9, 0.9}},
--     selection_box = {{-1, -1}, {1, 1}},
--     energy_source =
--     {
--       type = "electric",
--       buffer_capacity = "5MJ",
--       usage_priority = "tertiary",
--       input_flow_limit = "300kW",
--       output_flow_limit = "300kW"
--     },
--     chargable_graphics =
--     {
--       picture = accumulator_picture(),
--       charge_animation = accumulator_charge(),
--       charge_cooldown = 30,
--       discharge_animation = accumulator_discharge(),
--       discharge_cooldown = 60
--     },
--     water_reflection = accumulator_reflection(),
--     working_sound =
--     {
--       main_sounds =
--       {
--         {
--           sound = {filename = "__base__/sound/accumulator-working.ogg", volume = 0.4, modifiers = volume_multiplier("main-menu", 1.44)},
--           match_volume_to_activity = true,
--           activity_to_volume_modifiers = {offset = 2, inverted = true},
--           fade_in_ticks = 4,
--           fade_out_ticks = 20
--         },
--         {
--           sound = {filename = "__base__/sound/accumulator-discharging.ogg", volume = 0.4, modifiers = volume_multiplier("main-menu", 1.44)},
--           match_volume_to_activity = true,
--           activity_to_volume_modifiers = {offset = 1},
--           fade_in_ticks = 4,
--           fade_out_ticks = 20
--         }
--       },
--       idle_sound = {filename = "__base__/sound/accumulator-idle.ogg", volume = 0.35},
--       max_sounds_per_type = 3,
--       audible_distance_modifier = 0.5
--     },

--     circuit_connector = circuit_connector_definitions["accumulator"],
--     circuit_wire_max_distance = default_circuit_wire_max_distance,

--     default_output_signal = {type = "virtual", name = "signal-A"}
--   }
