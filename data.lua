--data.lua
data = data
util = util

require("lib/paths")

require("generation")

-- Prototypes
require(ob_entities_prototypes_path .. "entities-initialization")
require(ob_items_prototypes_path .. "items-initialization")
require(ob_categories_prototypes_path .. "categories-initialization")