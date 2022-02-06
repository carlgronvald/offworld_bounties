data:extend({
    {
        type = "fluid",
        name = "mana",
        default_temperature = 15,
        max_temperature = 1000,
        heat_capacity = "1MJ",
        icon = "__base__/graphics/icons/fluid/steam.png",
        icon_size = 64, icon_mipmaps = 4,
        base_color = {r=0.6, g=0.4, b=0.6},
        flow_color = {r=0.8, g=0.45, b=0.8},
        order = "a[fluid]-b[mana]",
        gas_temperature = 15,
        auto_barrel = false
    }
})