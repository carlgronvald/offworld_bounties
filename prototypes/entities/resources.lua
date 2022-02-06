
local sounds = require("__base__/prototypes/entity/sounds")
local resource_autoplace = require("__core__/lualib/resource-autoplace")
data:extend({
    {
        type = "resource",
        name = "ob-lode-ore",
        icon = ob_items_icons_path .. "lode.png",
        icon_size = 64,
        icon_mipmaps = 4,
        flags = {"placeable-neutral"},
        order = "a-b-a",
        tree_removal_probability = 0.8,
        tree_removal_max_distance = 32*32,
        minable = {
            mining_particle = "iron-ore-particle", -- TODO: CORRECT PARTICLE
            mining_time = 1,
            result = "ob-lode"
        },
        walking_sound = sounds.ore,
        collision_box = {{-0.1, -0.1}, {0.1, 0.1}},
        selection_box = {{-0.5, -0.5}, {0.5, 0.5}},

        autoplace = resource_autoplace.resource_autoplace_settings{
            name = "ob-lode-ore",
            order = "d",
            base_density = 1,
            base_spots_per_km2 = 1,
            has_starting_area_placement = true,
            random_spot_size_minimum = 0.1,
            random_spot_size_maximum = 0.4,
            regular_rq_factor_multiplier = 1
          },
        stage_counts = {15000, 9500, 5500, 2900, 1300, 400, 150, 80},
        stages = {
            sheet = {
                filename = ob_entities_sprites_path .. "lode-ore/lode-ore.png",
                priority = "extra-high",
                size = 64,
                frame_count = 8,
                variation_count = 8,
                --TODO: HIGH-RES
            }
        },
        map_color = { 55.0/255.0, 157.0/255.0, 158.0/255.0},
        mining_visualisation_tint = {r = 0.895, g= 0.965, b = 1.000, a = 1.000},
    },
    {
      type = "autoplace-control",
      name = "ob-lode-ore",
      localised_name = { "", "[entity=ob-lode-ore] ", { "autoplace-control-names.ob-lode-ore" } },
      richness = true,
      order = "b-g",
      category = "resource",
    },
    {
      type = "noise-layer",
      name = "ob-lode-ore",
    },
})