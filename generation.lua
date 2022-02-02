
local noise = require("noise")

local tne = noise.to_noise_expression

local function water_level_correct(to_be_corrected, map)
    return noise.max(
      map.wlc_elevation_minimum,
      to_be_corrected + map.wlc_elevation_offset
    )
  end

local function finish_elevation(elevation, map, x, y)
    local elevation = water_level_correct(elevation, map)
    elevation = elevation - (x*x + y*y)/1000

    return elevation
end

local x_var = tne{
  type = "variable",
  variable_name = "x"
}
local y_var = tne{
  type = "variable",
  variable_name = "y"
}

data:extend {
    {
        type = "noise-expression",
        name = "constant-one-hundre",
        intended_property = "elevation",
        expression = noise.define_noise_function( function(x, y, tile, map)
            local basis_noise = {
                type = "function-application",
                function_name = "factorio-basis-noise",
                arguments = {
                    x = noise.var("x"),
                    y = noise.var("y"),
                    seed0 = tne(noise.var("map_seed")),
                    seed1 = tne(123),
                    input_scale = tne(noise.var("segmentation_multiplier")/120),
                    output_scale = tne(20)
                }
            }
            return finish_elevation(basis_noise, map, x, y)
        end)
    }
}
