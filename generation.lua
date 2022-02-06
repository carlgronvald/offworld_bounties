
local noise = require("noise")

local tne = noise.to_noise_expression

local function water_level_correct(to_be_corrected, map)
    return noise.max(
      map.wlc_elevation_minimum,
      to_be_corrected + map.wlc_elevation_offset
    )
  end

local x_var = tne{
  type = "variable",
  variable_name = "x"
}
local y_var = tne{
  type = "variable",
  variable_name = "y"
}

local function finish_elevation(elevation, map, x, y)
    elevation = elevation - (x_var*x_var + y_var*y_var)/noise.var("water_size") + noise.var("water_bias")
    elevation = elevation / 1000

    return elevation
end


local function make_multioctave_noise_function(seed0,seed1,octaves,octave_output_scale_multiplier,octave_input_scale_multiplier,output_scale0,input_scale0)
  octave_output_scale_multiplier = octave_output_scale_multiplier or 2
  octave_input_scale_multiplier = octave_input_scale_multiplier or 1 / octave_output_scale_multiplier
  return function(x,y,inscale,outscale)
    return tne{
      type = "function-application",
      function_name = "factorio-quick-multioctave-noise",
      arguments =
      {
        x = tne(x),
        y = tne(y),
        seed0 = tne(seed0),
        seed1 = tne(seed1),
        input_scale = tne((inscale or 1) * (input_scale0 or 1)),
        output_scale = tne((outscale or 1) * (output_scale0 or 1)),
        octaves = tne(octaves),
        octave_output_scale_multiplier = tne(octave_output_scale_multiplier),
        octave_input_scale_multiplier = tne(octave_input_scale_multiplier)
      }
    }
  end
end

data:extend {
    {
        type = "noise-expression",
        name = "roguelike-noise",
        intended_property = "elevation",
        -- Elevation function often described as 'swampy' from 0.16
        expression = noise.define_noise_function( function(x,y,tile,map)
          local moct_noise = make_multioctave_noise_function(
            tne(noise.var("map_seed")),
            tne(noise.var("map_seed")),
            noise.var("octaves"),
            noise.var("octave_output_scale_modifier"),
            noise.var("octave_input_scale_modifier"), 
            noise.var("output_scale"), noise.var("input_scale"))(x, y, 1, 1)
          return noise.ident(finish_elevation(moct_noise, map))
        end)
        --[[type = "noise-expression",
        name = "roguelike-noise",
        intended_property = "elevation",
        expression = noise.define_noise_function( function(x, y, tile, map)
            local basis_noise = {
                type = "function-application",
                function_name = "factorio-quick-multioctave-noise",
                arguments = {
                    x = noise.var("x"),
                    y = noise.var("y"),
                    seed0 = tne(noise.var("map_seed")),
                    seed1 = tne(123),
                    input_scale = tne(noise.var("segmentation_multiplier")),
                    output_scale = tne(noise.var("output_scale")),
                    octaves = tne(noise.var("octaves")),
                    octave_output_scale_multipler = tne(noise.var("octave_output_scale_multipler")),
                    octave_input_scale_multiplier = tne(noise.var("octave_input_scale_multiplier"))
                }
            }
            return finish_elevation(basis_noise, map, x, y)
        end)]]
    }
}
