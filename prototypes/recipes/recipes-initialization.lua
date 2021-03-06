data:extend({
    {
        type = "recipe",
        name = "ob-mana-pack-creation",
        category = "portal",
        icon = ob_items_icons_path .. "mana-pack.png",
        icon_size = 64,
        enabled = true,
        energy_required = 1,
        ingredients = {
            { type = "item", name = "ob-lode", amount = 1},
        },
        result = "ob-mana-pack",
        result_count = 1,
    },
    {
        type = "recipe",
        name = "ob-mana",
        category = "mana",
        icon = ob_items_icons_path .. "mana-pack.png",
        icon_size = 64,
        enabled = true,
        energy_required = 1,
        ingredients = {
            { type = "item", name = "ob-mana-pack", amount = 10},
        },
        results = {
            {type="fluid", name="mana", amount=10}
        },
    }
})