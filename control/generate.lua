require("value_noise")

local generate = {}


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

    local vn = Value2D(5, rng, 200, 200)

    local width = 200
    local height = 200
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

function generate.roguelike()
    log("yo!")

    local first_player = game.get_player(1)
    local player_character = first_player.character
    local position = {
        x = math.floor(player_character.position.x) + 0.5,
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
    generate.fill_blob_with_resource(copper_blob, "copper-ore", player_character.surface, position)
end

return generate