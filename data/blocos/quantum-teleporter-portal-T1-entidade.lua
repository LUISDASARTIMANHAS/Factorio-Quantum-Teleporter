local path_main = "__Quantum-Teleporter__/"
local gameSounds = "__base__/sound/"
local boxSize = 10

data:extend(
    {
        {
            type = "assembling-machine",
            name = "quantum-teleporter-portal-T1-entidade",
            icon = path_main .. "graficos/blocos/T1-portal.png",
            icon_size = 500,
            icon_mipmaps = 4,
            minable = {
                mining_time = 30,
                results = {
                    {type = "item", name = "quantum-teleporter-portal-T1", amount = 1}
                }
            },
            build_grid_size = 2,
            max_health = 1000,
            crafting_speed = 1,
            ingredient_count = 4,
            off_when_no_fluid_recipe = true,
            energy_usage = "5MW",
            is_military_target = true,
            crafting_categories = {"portal-parts"},
            fixed_recipe = "part-portal-T1-recipe",
            -- corpse = "big-remnants",
            corpse = "assembling-machine-2-remnants",
            -- dying_explosion = "big-explosion",
            dying_explosion = "assembling-machine-2-explosion",
            -- next_upgrade = "quantum-teleporter-portal-T2-entidade",
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
                buffer_capacity = "25MW",
                input_flow_limit = "7MW",
                drain = "5MW"
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
                item = "quantum-teleporter-portal-T1",
                count = 1
            },
            module_specification = {
                module_slots = 0,
                module_info_icon_shift = {0, 0.5}
            },
            working_sound = {
                sound = {
                    filename = path_main .. "audio/construction.ogg",
                    volume = 0.45
                },
                idle_sound = {filename = gameSounds .. "nuclear-reactor-1.ogg", volume = 0.45}
            },
            -- renderiza a entidade no mapa
            graphics_set = {
                animation = {
                    filename =  path_main .. "graficos/blocos/T1-portal.png",
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
