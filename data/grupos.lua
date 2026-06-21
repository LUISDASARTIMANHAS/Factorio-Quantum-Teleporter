local LDAFunctions = require("__LDA-LIB__/init")
local PATH = LDAFunctions.setBasePath("Quantum-Teleporter")
-- LDA.createItemGroup(group_name, group_order, icon_size, subgroups, icon_mipmaps)

local subgroups = {
  "component",
  "itens",
  "equipment"
}

data:extend(
    LDAFunctions.createItemGroup("quantum-teleporter-category", "q", 512, subgroups, 2)
)
-------------------------------------------------------------------------- quantum-teleporter-category

-- categorias de receitas
data:extend(
  {
    {
      type = "recipe-category",
      name = "portal-parts"
    }
  }
)
