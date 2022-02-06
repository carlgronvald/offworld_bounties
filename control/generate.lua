require("value_noise")

local generate = {}

function generate.dump(o, d)
    if not d then d=0 end

    if type(o) == 'table' then
       local s = string.rep('  ', d) .. '{ \n'
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. string.rep('  ', d) .. '['..k..'] = ' .. generate.dump(v, d+1) .. ',\n'
       end
       return s .. string.rep('  ', d) .. '}'
    else
       return tostring(o)
    end
 end
 


function generate.sum_array(array) 
    local total = 0.0
    for _,v in ipairs(array) do
       total = total+v
    end
    return total
end

-- Amount = what will the blob sum to?
-- rng = rng instance
-- spread = what part of the area will be positive?
-- mask = anything where mask is zero will be zero as well.
function generate.blob(amount, rng, spread, mask)

    local vn = Value2D(5, rng, 500, 500)

    local width = 500
    local height = 500
    if not mask then
        mask = {}
        for i = 1,width do
            for j=1,height do
                mask[i+j*width] = 1
            end
        end
    end
    local grid = {}
    local histogram = {}
    local histogram_bins = 1000
    for i=1,histogram_bins do
        histogram[#histogram+1] = 0
    end

    -- First, we fill out the entire area using value noise and create a histogram of it
    for i =1,width do
        for j =1,height do
            grid[i+j*width] = vn.value_noise(i,j)+0.1
            if mask[i+j*width] <= 0.0 then
                grid[i+j*width] = 0.0
            end
            local hist_index = math.floor(grid[i+j*width]*histogram_bins)
            if hist_index < 1 then hist_index = 1 end
            if hist_index > histogram_bins then hist_index = histogram_bins end
            histogram[hist_index] = histogram[hist_index]+1
        end
    end

    -- Then, we use the histogram to find out the cutoff value between ground covered in iron and ground not covered in iron.

    local hist_sum = 0
    local last_hist_bin = -1
    for i=histogram_bins,1,-1 do
        hist_sum = hist_sum + histogram[i]
        log("At hist bin " .. tostring(i) .. " we have hist sum " .. tostring(hist_sum))
        if hist_sum / (width*height) >= spread then
            last_hist_bin = i
            break
        end
    end
    log("Last hist bin: " .. tostring(last_hist_bin))

    -- Now we normalize everything to the cutoff.
    local total_above_cutoff = 0.0
    for i =1,width do
        for j =1,height do
            grid[i+j*width] = grid[i+j*width] - (last_hist_bin+.0)/histogram_bins
            if grid[i+j*width] < 0.0 then
                grid[i+j*width] = 0.0
            else
                total_above_cutoff = total_above_cutoff + grid[i+j*width]
            end
        end
    end

    -- We multiply up the sizes so that the total amount will equal the requested amount
    local multiplier = amount/total_above_cutoff
    log("total above cutoff: " .. tostring(total_above_cutoff))
    log("multiplier: " .. tostring(multiplier))

    for i =1,width do
        for j =1,height do
            grid[i+j*width] = grid[i+j*width] * multiplier
        end
    end

    return {
        width = width,
        height = height,
        grid = grid
    }


    --[[local total_resource = amount


    local resulting_resources = {}
    local frontier = {position}
    local previous = {}

    while total_resource > 0 and #frontier > 0 do
        local position = frontier[math.random(1, #frontier)]

        for _,value in ipairs(resulting_resources) do
            if value.position.x == position.x-1 and value.position.y == position.y then
                break
            end
            frontier[#frontier+1] = {x = position.x-1, y = position.y}
        end
        for _,value in ipairs(resulting_resources) do
            if value.position.x == position.x+1 and value.position.y == position.y then
                break
            end
            frontier[#frontier+1] = {x = position.x+1, y = position.y}
        end
        for _,value in ipairs(resulting_resources) do
            if value.position.x == position.x and value.position.y == position.y-1 then
                break
            end
            frontier[#frontier+1] = {x = position.x, y = position.y-1}
        end
        for _,value in ipairs(resulting_resources) do
            if value.position.x == position.x and value.position.y == position.y+1 then
                break
            end
            frontier[#frontier+1] = {x = position.x, y = position.y+1}
        end


        local new = true
        for _,value in ipairs(resulting_resources) do
            if value.position.x == position.x and value.position.y == position.y then
                value.amount = value.amount + 40
                total_resource = total_resource - 40
                new = false
            end
        end
        if new then
            local result_resource = surface.create_entity{
              name = "iron-ore",
              position = position,
            }
          
            result_resource.amount = 40
            resulting_resources[#resulting_resources+1] = result_resource
            total_resource = total_resource - 40
        end

        previous[#previous+1] = position
    end-]]
end

function generate.fill_blob_with_resource(grid, resource, surface, position) 
    for i =1,grid.width do
        for j =1,grid.width do
            if grid.grid[i+j*grid.width] >= 1 then
                local result_resource = surface.create_entity{
                    name = resource,
                    position = {
                        x = position.x + i,
                        y = position.y + j
                    },
                }
                
                result_resource.amount = grid.grid[i+j*grid.width]
        
            end
        end
    end
end

function generate.land_blob(grid, surface, position)
    local tiles = {}
    for i =1,grid.width do
        for j =1,grid.width do
            if grid.grid[i+j*grid.width] > 0 then
                tiles[#tiles+1] = {
                    position = {
                        x = position.x+i, y = position.y+j
                    },
                    name = "grass-4"
                }
            else
                tiles[#tiles+1] = {
                    position = {
                        x = position.x+i, y = position.y+j
                    },
                    name = "water"
                }
            end
        end
    end
    surface.set_tiles(tiles)
end

function generate.map_generation_settings()
    local width = 500
    local height = 500
    local water_area_factor = 0.5 -- Amount of area expected lost to water
    local area = width*height/1000000 * water_area_factor
    local water_size = width/500

    local magic_number = 3/11

    local expected_lode_patches = 3
    local lode_frequency = expected_lode_patches/area*magic_number

    return {
        width = width,
        height = height,
        property_expression_names = {
            elevation = "roguelike-noise",
            output_scale = "200.0",
            input_scale = "1.0",
            octaves = "6",
            octave_output_scale_modifier = "2.0",
            octave_input_scale_modifier = "0.46",
            water_size = tostring(water_size),
            water_bias = "10000",
            cliffiness = "0",
            ["enemy-base-frequency"] = "0",
        },
        starting_area = 0,
        autoplace_controls = {
            ["iron-ore"] = {
                frequency = 4,
                size = 0.25,
                richness = 0.5
            },
            ["copper-ore"] = {
                frequency = 4,
                size = 0.5,
                richness = 0.5,
            },
            ["stone"] = {
                frequency = 2,
                size = 0.5,
                richness = 0.5
            },
            ["coal"] = {
                frequency = 2,
                size = 0.5,
                richness = 0.5,
            },
            ["ob-lode-ore"] = {
                frequency = lode_frequency,
                size = 0.25,
                richness = 1,
            }
        },

    }
end

function generate.roguelike()
    --[[log("yo!")

    local first_player = game.get_player(1)
    local player_character = first_player.character
    local position = {
        x = math.floor(player_character.positison.x) + 0.5,
        y = math.floor(player_character.position.y) + 0.5
    }

    local rng = game.create_random_generator()

    local land_blob = generate.blob(1000, rng, 0.65)
    generate.land_blob(land_blob, player_character.surface, position)
    local iron_blob = generate.blob(50000, rng, 0.05, land_blob.grid)
    generate.fill_blob_with_resource(iron_blob, "iron-ore", player_character.surface, position)
    local mask = land_blob.grid
    for i=1,land_blob.width do
        for j=1,land_blob.height do
            if iron_blob.grid[i+j*iron_blob.width] > 0.0 then
                mask[i+j*iron_blob.width] = -1
            end
        end
    end
    local copper_blob = generate.blob(50000, rng, 0.05, mask)
    generate.fill_blob_with_resource(copper_blob, "copper-ore", player_character.surface, position)]]

    if not generate.rng then
        generate.rng = game.create_random_generator()
    end
    local level_surface = game.create_surface("roguelike_level", generate.map_generation_settings())
    level_surface.request_to_generate_chunks({x=0, y=0}, 250);
    local first_player = game.get_player(1)
    --log(generate.dump(first_player.surface.map_gen_settings))

    first_player.teleport({x=0, y=0}, level_surface)

end

function generate.distribute_amounts(total, splits, split_min_part, rng) 

    local distributable = total * (1 - split_min_part * splits)
    
    local patch_weights = {}
    local patch_weight_total = 0

    for i=1,splits do
        patch_weights[#patch_weights+1] = rng()
        patch_weight_total = patch_weight_total + patch_weights[i]
    end

    local patch_sizes = {}
    for i=1,splits do
        patch_sizes[#patch_sizes+1] = math.floor((patch_weights[i] / patch_weight_total) * distributable) + split_min_part * total
    end

    return patch_sizes
end

function generate.count_tiles()
    if not generate.rng then
        generate.rng = game.create_random_generator()
    end
    local level_surface = game.get_player(1).surface
    local available_tiles = level_surface.get_connected_tiles(
        {x = 0, y = 0}, {"grass-1", "grass-2", "grass-3", "grass-4"}
    )

    local min_x = 0
    local min_y = 0
    local max_x = 0
    local max_y = 0

    for _,tile in ipairs(available_tiles) do
        if tile.x < min_x then min_x = tile.x end
        if tile.x > max_x then max_x = tile.x end
        if tile.y < min_y then min_y = tile.y end
        if tile.y > max_y then max_y = tile.y end
    end

    log("min, max: (" .. tostring(min_x) .. "," .. tostring(min_y) .. ") - (" .. tostring(max_x) .. "," .. tostring(max_y) .. ")")
    local mask = {}
    for i=1,max_x-min_x do
        for j=1,max_y-min_y do
            mask[#mask+1] = -1
        end
    end

    for _,tile in ipairs(available_tiles) do
        mask[tile.x-min_x + (tile.y-min_y)*(max_x-min_x)] = 1
    end


    local totals = {
        ["iron-ore"] = 100000,
        ["coal"] = 10000,
        ["copper-ore"] = 30000,
        ["stone"] = 25000,
        ["ob-lode-ore"] = 1000,
    }

    local resource_counts = level_surface.get_resource_counts()

    local multipliers = {}
    for k,v in pairs(totals) do
        if resource_counts[k] then
            log("Found " .. tostring(resource_counts[k]) .. " of " .. tostring(k))
            multipliers[k] = v / resource_counts[k]
        else
            resource_counts[k] = 1
        end
    end

    for k,mult in pairs(multipliers) do
        local resource_entities = level_surface.find_entities_filtered {
            area = {
                left_top = {-250, -250},
                right_bottom = {250,250}
            },
            name = k
        }
        for _,t in ipairs(resource_entities) do
            t.amount = math.max(t.amount*mult, 1)
        end
    end

    --local iron_patches = 3
    --local iron_patch_min = 0.25

    --local patch_distribution = generate.distribute_amounts(total_iron, iron_patches, iron_patch_min, generate.rng)

    --log("Patches: " .. tostring(patch_distribution[1]) .. ", " .. tostring(patch_distribution[2]) .. ", " .. tostring(patch_distribution[3]) )
end

return generate