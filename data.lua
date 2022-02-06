--data.lua
data = data
util = util

require("paths")

require("generation")

-- Prototypes
require(ob_prototypes_path .. "fluids")
require(ob_entities_prototypes_path .. "entities-initialization")
require(ob_items_prototypes_path .. "items-initialization")
require(ob_categories_prototypes_path .. "categories-initialization")
require(ob_recipes_prototypes_path .. "recipes-initialization")