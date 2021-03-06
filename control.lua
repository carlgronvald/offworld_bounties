-- This is just done so there's no useless warnings in the code.
log = log
remote = remote
game = game


local event = require("__flib__.event")
local on_tick_n = require("__flib__.on-tick-n")
local freeplay = require("control.freeplay")
local generate = require("control.generate")

local portal_part = {
    name = "ob-portal",
    angle_deviation = 0.2,
    max_distance = 25,
    min_separation = 10,
    fire_count = 3,
    explosion_count = 1,
    force = "player",
}

local solar_panel = {
    name = "solar-panel",
    angle_deviation = 0.2,
    max_distance = 25,
    min_separation = 10,
    fire_count = 3,
    explosion_count = 1,
    force = "player",
}

event.on_init(function()

    log("yo!")
    on_tick_n.init()

    if
      remote.interfaces["freeplay"]
      and remote.interfaces["freeplay"].get_disable_crashsite
      and not remote.call("freeplay", "get_disable_crashsite")
      and not remote.call("freeplay", "get_init_ran")
    then
      local ship_parts = remote.call("freeplay", "get_ship_parts")
      ship_parts = {
          portal_part,
          portal_part,
          solar_panel
      }
      remote.call("freeplay", "set_ship_parts", ship_parts)
    end
end)

event.on_picked_up_item(function()
  generate.roguelike()

end)
event.on_player_mined_entity(function()
  generate.count_tiles()

end)

log("yowzers")