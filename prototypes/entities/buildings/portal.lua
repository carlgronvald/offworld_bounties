


local hit_effects = require("__base__/prototypes/entity/hit-effects")
local sounds = require("__base__/prototypes/entity/sounds")

data:extend({
    {
        type = "assembling-machine",
        name = "ob-portal",
        icon = ob_entities_icons_path .. "portal.png", --TODO: CREATE OB ENTITIES ICONS
        icon_size = 64,
        icon_mipmaps = 4,
        flags = {},
        minable = { mining_time = 100000, result = "ob-portal" },
        max_health = 2000,
        damaged_trigger_effect = hit_effects.entity(), -- TODO: HIT EFFECTS
        corpse = "",
        resistances = {
            { type = "physical", percent = 60},
            { type = "fire", percent = 90},
            { type = "impact", percent = 90}
        },
        collision_box = { { -3.75, -3.75}, {3.75, 3.75} },
        selection_box = { {-3.9, -3.9 }, {3.9, 3.9} },
        -- fast_replaceable_group = ""
        off_animation = {
            layers = {
                {
                    filename = ob_entities_sprites_path .. "portal/portal.png", -- TODO: CREATE
                    priority = "high",
                    width = 260,
                    height = 250,
                    shift = {0.0, -0.1},
                    frame_count = 1,
                    -- hr_version = {}
                }
            }
        },
        on_animation = {
            layers = {
                filename = ob_entities_sprites_path .. "portal/portal-light.png",
                priority = "high",
                width = 77,
                height = 59,
                shift = { 0, -0.8 },
                frame_count = 60,
                line_length = 6,
                animation_speed = 0.85,
                draw_as_light = true,
                -- hr_version = {}
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
})