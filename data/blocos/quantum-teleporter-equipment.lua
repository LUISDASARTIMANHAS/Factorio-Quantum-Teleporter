local path_main = "__Quantum-Teleporter__/"

data:extend(
    {
        {
            type = "movement-bonus-equipment",
            name = "quantum-teleporter-equipment",
            categories = {"armor"},
            energy_consumption = "20MW",
            take_result = "quantum-teleporter-equipment",
            sprite = {
                filename = path_main .. "graficos/itens/quantum-teleporter-equipment-128.png",
                width = 128,
                height = 128,
                priority = "medium"
            },
            shape = {
                type = "full",
                width = 2,
                height = 2
            },
            energy_source = {
                type = "electric",
                buffer_capacity = "112MW", -- Energia máxima armazenada
                input_flow_limit = "52MW", -- Velocidade de recarga
                usage_priority = "secondary-input",
                drain = "5MW"
            },
            movement_bonus = 0,
            activate_sound = {filename = path_main .. "audio/portal.ogg", volume = 0.5},
            deactivate_sound = {filename = "__base__/sound/nightvision-off.ogg", volume = 0.5}
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