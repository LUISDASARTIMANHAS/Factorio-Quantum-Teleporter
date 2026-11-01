-- ============================================================
-- CONTROL.LUA - Ponto de entrada do estágio de runtime
-- Quantum Teleporter Mod
-- Integração canônica com a LDA-LIB (Factorio 2.1+)
-- ============================================================

local LDARuntime = require("__LDA-LIB__/runtime.init")
local guimaker = require("control.gui.gui-maker")

-- Módulos de controle especializados
require("control.teleport-2")
require("control.portal")

-- ============================================================
-- COMANDO DE CONSOLE: Abrir GUI do equipamento manualmente
-- ============================================================

commands.add_command("testgui", "Abrir GUI do equipamento pessoal de teleporte", function(cmd)
    local player = LDARuntime.player.get(cmd.player_index)
    if not player then return end
    LDARuntime.player.notify(player, "Abrindo interface do equipamento quântico.")
    guimaker.create_teleport_window(player)
end)
