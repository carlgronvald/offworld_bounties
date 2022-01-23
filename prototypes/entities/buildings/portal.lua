


local hit_effects = require("__base__/prototypes/entity/hit-effects")
local sounds = require("__base__/prototypes/entity/sounds")


data:extend({
    {
      type = "assembling-machine",
      name = "ob-portal",
      icon = ob_entities_icons_path .. "portal.png",
      icon_size = 64,
      icon_mipmaps = 0,
      flags = { "placeable-neutral", "player-creation" },
      minable = { mining_time = 0.5, result = "ob-lode" },
      max_health = 300,
      fast_replaceable_group = "solar-panel",
      corpse = "solar-panel-remnants",
      dying_explosion = "solar-panel-explosion",
      collision_box = { { -1.75, -1.75 }, { 1.75, 1.75 } },
      selection_box = { { -2, -2 }, { 2, 2 } },
      damaged_trigger_effect = hit_effects.entity(),

      animation = {
        layers = {
          {
            filename = ob_entities_sprites_path .. "portal/portal.png",
            priority = "high",
            width = 140,
            height = 140,
            shift = { 0.1, 0.1 },
            frame_count = 1,
            hr_version = {
              filename = ob_entities_sprites_path .. "portal/portal.png",
              priority = "high",
              width = 256,
              height = 256,
              shift = { 0.1, 0.1 },
              scale = 0.5,
              frame_count = 1,
            },
          },
        },
      },
      -- TODO: WORKING VISUALIZATIONS
      vehicle_impact_sound = sounds.generic_impact,
      crafting_categories = { "portal" },
      crafting_speed = 1,
      scale_entity_info_icon = true,
      energy_source = {
          type = "electric",
          usage_priority = "secondary-input",
          emissions_per_second_per_watt = 2 / 10000000
      },
      energy_usage = "0.25MW",
      ingredient_count = 1,
      module_specification = { module_slots = 2, module_info_icon_shift = { 0, 1.2 }, module_info_icon_scale = 1 },
      allowed_effects = { "consumption", "speed", "productivity", "pollution" },
      open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.75},
      close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75}
    },
  })
  

--[[data:extend({
    {
        type = "assembling-machine",
        name = "ob-portal",
        icon = ob_entities_icons_path .. "portal.png",
        icon_size = 64,
        icon_mipmaps = 0,
        flags = { "player-creation" },
        minable = { mining_time = 1, result = "ob-portal" },
        max_health = 2000,
        damaged_trigger_effect = hit_effects.entity(),
        corpse = "solar-panel-remnants",
        resistances = {
            { type = "physical", percent = 60},
            { type = "fire", percent = 90},
            { type = "impact", percent = 90}
        },
        collision_box = { { -3.75, -3.75}, {3.75, 3.75} },
        selection_box = { {-3.9, -3.9 }, {3.9, 3.9} },
        -- fast_replaceable_group = ""
        picture = {
            layers = {
                {
                    filename = ob_entities_sprites_path .. "portal/portal.png", -- TODO: CREATE
                    priority = "high",
                    width = 256,
                    height = 256,
                    hr_version = {
                        filename = ob_entities_sprites_path .. "portal/portal.png", -- TODO: CREATE
                        priority = "high",
                        width = 512,
                        height = 512,
                        scale = 0.5,
                    }
                }
            }
        },
        light = {
            {
                intensity = 0.95,
                size = 5,
                shift = { 0.0, -0.6},
                color = { r = 0, g = 0.917, b = 1}
            }
        },
        working_sound = {
            sound = {
                filename = "__base__/sound/machine-open.ogg",
                volume = 1.15
            }
        },
        vehicle_impact_sound = sounds.generic_impact,
        water_reflection = {
            pictures = {
                filename = ob_entities_sprites_path .. "portal/portal.png",
                priority = "extra-high",
                width = 42,
                height = 38,
                shift = util.by_pixel(0,40),
                variation_count = 1,
                scale = 5
            },
            rotate = false,
            orientation_to_variation = false
        },

        crafting_categories = { "portal" },
        crafting_speed = 1,
        scale_entity_info_icon = true,
        energy_source = {
            type = "electric",
            usage_priority = "secondary-input",
            emissions_per_second_per_watt = 2 / 10000000
        },
        energy_usage = "0.25MW",
        ingredient_count = 1,
        module_specification = { module_slots = 2, module_info_icon_shift = { 0, 1.2 }, module_info_icon_scale = 1 },
        allowed_effects = { "consumption", "speed", "productivity", "pollution" },
        open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.75},
        close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75}
    }
}) ]]