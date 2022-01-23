local portal_part = {
    {
        name = "ob-portal",
        angle_deviation = 0.2,
        max_distance = 25,
        min_separation = 10,
        fire_count = 3,
        explosion_count = 1,
        force = "player",
    }
}
local freeplay = {}

function freeplay.add_to_crash_site()
    if
      remote.interfaces["freeplay"]
      and remote.interfaces["freeplay"].get_disable_crashsite
      and not remote.call("freeplay", "get_disable_crashsite")
      and not remote.call("freeplay", "get_init_ran")
    then
      local ship_parts = remote.call("freeplay", "get_ship_parts")
      ship_parts[#ship_parts + 1] = portal_part
      remote.call("freeplay", "set_ship_parts", ship_parts)
    end
  end

  return freeplay