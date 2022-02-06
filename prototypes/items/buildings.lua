data:extend({
    -- Portal
    {
        type = "item",
        name = "ob-portal",
        localised_name = { "entity-name.ob-portal" },
        localised_description = { "entity-description.ob-portal"},
        icon = ob_entities_icons_path .. "portal.png",
        icon_size = 64,
        icon_mipmaps = 4,
        subgroup = "inserter",
        order = "x[portal]",
        place_result = "ob-portal",
        stack_size = 1,
        flags = { "hidden" }
    },
    -- Dome 
    {
        type = "item",
        name = "ob-dome",
        localised_name = { "entity-name.ob-dome" },
        localised_description = { "entity-description.ob-dome"},
        icon = ob_entities_icons_path .. "portal.png", --TODO: DOME ICON
        icon_size = 64,
        icon_mipmaps = 4,
        subgroup = "inserter",
        order = "x[dome]",
        place_result = "ob-dome",
        stack_size = 1,
        flags = { "hidden" }
    }
})