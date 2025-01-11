local path_main = "__Quantum-Teleporter__/"
local gameSounds = "__base__/sound/"
local boxSize = 10

data:extend(
    {
        {
            type = "accumulator",
            name = "quantum-teleporter-portal-entidade",
            icon = path_main .. "graficos/blocos/quantum-teleporter-portal.png",
            icon_size = 500,
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
            collision_box = {
                {-boxSize, -boxSize},
                {boxSize, boxSize}
            },
            selection_box = {
                {-boxSize, -boxSize},
                {boxSize, boxSize}
            },
            drawing_box = {
                {-boxSize, -boxSize},
                {boxSize, boxSize}
            },
            energy_source = {
                type = "electric",
                usage_priority = "primary-input",
                buffer_capacity = "200MW",
                input_flow_limit = "30MW",
                drain = "20MW"
            },
            resistances = {
                {
                    type = "fire",
                    percent = 70
                },
                {
                    type = "physical",
                    percent = 100
                },
                {
                    type = "impact",
                    percent = 100
                },
                {
                    type = "electric",
                    percent = 5
                },
                {
                    type = "explosion",
                    percent = 97
                },
                {
                    type = "laser",
                    percent = 100
                }
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
            module_specification = {
                module_slots = 0,
                module_info_icon_shift = {0, 0.5}
            },
            working_sound = {
                sound = {
                    filename = path_main .. "audio/portal.ogg",
                    volume = 0.45
                },
                idle_sound = {filename = gameSounds .. "nuclear-reactor-2.ogg", volume = 0.45}
            },
            -- renderiza a entidade no mapa
            graphics_set = {
                animation = {
                    filename =  path_main .. "graficos/blocos/quantum-teleporter-portal.png",
                    priority = "extra-high",
                    width = 500,
                    height = 500,
                    frame_count = 1,
                }
            },
            close_sound = {
                {
                    filename = "__base__/sound/machine-close.ogg",
                    volume = 0.5
                }
            },
            open_sound = {
                {
                    filename = "__base__/sound/machine-open.ogg",
                    volume = 0.5
                }
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