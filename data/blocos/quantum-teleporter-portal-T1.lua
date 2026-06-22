local gameSounds = "__base__/sound/"
local boxSize = 10
local LDAFunctions = require("__LDA-LIB__/init")
local LDAUtils = LDAFunctions.utils
local LDAUtilsAnimations = LDAFunctions.utilsAnimations
local LDAUtilsEnergySource = LDAFunctions.utilsEnergySource
local PATH = LDAFunctions.setBasePath("Quantum-Teleporter")
local defaultFilename = PATH .. "graphics/icons/quantum-teleporter-portal-T1"
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
            type = "assembling-machine",
            name = "quantum-teleporter-portal-T1",
            icon = defaultFilename .. ".png",
            icon_size = defaultIconSize,
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
            fixed_recipe = "part-portal-T1",
            -- corpse = "big-remnants",
            corpse = "assembling-machine-2-remnants",
            -- dying_explosion = "big-explosion",
            dying_explosion = "assembling-machine-2-explosion",
            -- next_upgrade = "quantum-teleporter-portal-T2",
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
                "25MW",
                "7kW",
                nil,
                0,
                false,
                false,
                {drain = "5MW"}
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
                item = "quantum-teleporter-portal-T1",
                count = 1
            },
            module_specification = LDAUtils.createModuleSpec(0, 0.5),
            working_sound = {
                sound = LDAUtils.getAudio(PATH .. "audio/construction", 0.45),
                idle_sound = LDAUtils.getAudio(gameSounds .. "nuclear-reactor-1")
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
