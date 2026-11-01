-- control/utils/lda-runtime.lua
-- Carregador seguro dos módulos de runtime da LDA-LIB
--
-- [FEATURE REQUEST / BUG REPORT TO LDA-LIB: runtime/init.lua & runtime/commands.lua]
-- Importar "__LDA-LIB__/runtime.init" em mods dependentes causa colisão do comando
-- de console "lda-list" (commands.add_command falha se o comando já existe).
-- Este utilitário consome diretamente os módulos oficiais da LDA-LIB sem reexecutar
-- o registro de comandos do mod base.

return {
    player = require("__LDA-LIB__/runtime/modules/player"),
    entity = require("__LDA-LIB__/runtime/modules/entity"),
    world  = require("__LDA-LIB__/runtime/modules/world"),
    item   = require("__LDA-LIB__/runtime/modules/item")
}

