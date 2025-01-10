local path_main = "__Quantum-Teleporter__/"

data:extend(
    {
        {
            type = "active-defense-equipment", -- Equipamento compatível com armadura vanilla
            name = "quantum-teleporter-equipment",
            categories = {"armor"},
            -- Desativa comportamento automático
            automatic = false,
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
            attack_parameters = {
                -- Desativa ataques, mas mantém o consumo de energia
                type = "projectile",
                -- Altamente ineficiente para evitar uso automático
                cooldown = 9999999,
                range = 0,
                ammo_type = {
                    category = "bullet",
                    target_type = "position",
                    action = {
                        type = "direct",
                        action_delivery = {
                            type = "instant",
                            target_effects = {}
                        }
                    }
                }
            },
        }
    }
)
