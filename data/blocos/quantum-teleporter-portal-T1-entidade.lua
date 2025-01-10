local path_main = "__Quantum-Teleporter__/"
local gameSounds = "__base__/sound/"

data:extend(
    {
        {
            type = "assembling-machine",
            name = "quantum-teleporter-portal-T1-entidade",
            icon = path_main .. "graficos/blocos/T2-portal.png",
            icon_size = 128,
            icon_mipmaps = 4,
            minable = {mining_time = 60, result = "quantum-teleporter-portal"},
            max_health = 1000,
            crafting_speed = 1,
            ingredient_count = 3,
            off_when_no_fluid_recipe = true,
            energy_usage = "5MW",
            crafting_categories = {"portal-parts"},
            fixed_recipe = "part-portal-T1",
            -- corpse = "big-remnants",
            corpse = "assembling-machine-2-remnants",
            -- dying_explosion = "big-explosion",
            dying_explosion = "assembling-machine-2-explosion",
            alert_icon_shift = {-0.09375, -0.375},
            collision_box = {
                {-8, -8},
                {10, 10}
            },
            selection_box = {
                {-8.5, -8.5},
                {10.5, 10.5}
            },
            drawing_box = {
                {-8.5, -8.5},
                {10.5, 10.5}
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
                item = "quantum-teleporter-portal-T2",
                count = 1
            },
            module_specification = {
                module_slots = 0,
                module_info_icon_shift = {0, 0.5}
            },
            placeable_position_visualization = {
                filename = path_main .. "graficos/blocos/T1-portal.png",
                priority = "medium",
                width = 32,
                height = 32
            },
            working_sound = {
                sound = {
                    filename = path_main .. "audio/construction.ogg",
                    volume = 0.45
                },
                idle_sound = {filename = gameSounds .. "nuclear-reactor-1.ogg", volume = 0.45}
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
