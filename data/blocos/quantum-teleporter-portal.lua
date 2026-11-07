local gameSounds = "__base__/sound/"
local boxSize = 10
local LDAFunctions = require("__LDA-LIB__/init")
local LDAUtils = LDAFunctions.utils
local PATH = LDAFunctions.setBasePath("Quantum-Teleporter")
local defaultFilename = PATH .. "graphics/icons/quantum-teleporter-portal"
local defaultIconSize = 512

-- O Portal Quântico:
-- Construído via LDAFunctions.createAccumulator oficial da LDA-LIB (>= 0.0.17).
-- Configurado como ACUMULADOR especializado de energia quântica.
-- Não possui slots de montagem nem receitas de crafting.
-- Conecta-se à rede elétrica e armazena até 200MJ de energia para saltos quânticos.
data:extend(
    {
        LDAFunctions.createAccumulator({
            name = "quantum-teleporter-portal",
            icon = defaultFilename .. ".png",
            icon_size = defaultIconSize,
            collision_box = LDAUtils.createBoundingBox(boxSize, boxSize),
            selection_box = LDAUtils.createBoundingBox(boxSize, boxSize),
            drawing_box = LDAUtils.createBoundingBox(boxSize, boxSize),
            buffer_capacity = "200MJ",
            input_flow_limit = "50MW",
            output_flow_limit = "0kW", -- Não descarrega de volta para a rede comum
            max_health = 1500,
            corpse = "assembling-machine-2-remnants",
            dying_explosion = "assembling-machine-2-explosion",
            minable = {
                mining_time = 30,
                result = "quantum-teleporter-portal"
            },
            chargable_graphics = {
                picture = {
                    layers = {
                        {
                            filename = defaultFilename .. ".png",
                            priority = "high",
                            width = defaultIconSize,
                            height = defaultIconSize,
                            scale = (boxSize * 32 * 2) / defaultIconSize,
                            shift = {0, 0}
                        }
                    }
                }
            },
            resistances = {
                LDAUtils.createResistance("fire", 70),
                LDAUtils.createResistance("physical", 100),
                LDAUtils.createResistance("impact", 100),
                LDAUtils.createResistance("electric", 5),
                LDAUtils.createResistance("explosion", 97),
                LDAUtils.createResistance("laser", 100)
            },
            extra_props = {
                icon_mipmaps = 4,
                surface_conditions = {
                    {property = "pressure", min = 10}
                }
            },
            working_sound = {
                sound = LDAUtils.getAudio(PATH .. "audio/portal", 0.45),
                idle_sound = LDAUtils.getAudio(gameSounds .. "nuclear-reactor-2")
            },
            close_sound = {
                LDAUtils.getAudio(gameSounds .. "machine-close")
            },
            open_sound = {
                LDAUtils.getAudio(gameSounds .. "machine-open")
            }
        })
    }
)
