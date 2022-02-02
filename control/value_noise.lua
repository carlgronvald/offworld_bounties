function Value2D(octaves, rng, width, height) 

    local seeds = {};
    local octaveSize = {}
    local octaveAmplitude = {}

    for i=1,octaves do
      seeds[#seeds+1] = rng(1, 1000000)
      octaveSize[#octaveSize+1] = 2.0 ^ i
      octaveAmplitude[#octaveAmplitude+1] = 0.5 ^ (octaves-i)
    end

    -- Cosine interpolation
    local function coserp(v1, v2, frac)
      local ft = frac * 3.141592
      local f = ((1.0 - math.cos(ft)) *0.5)

      return v1*(1-f) + v2*f
    end

    local function noise(x, y, octave)
      local x_v = x + seeds[octave] + y *5693
      x_v = bit32.bxor(bit32.lshift(x_v,13), x_v)
      return ( 1.0 - ((x_v * ((x_v * x_v * 15737 + 789221) % 2147483647) + 1376312627) % 2147483647)) / 1073741824.0
    end

    local noise_array = {}
    for i=0,width+3 do
      for j =0,height+3 do
        for k = 1,octaves do
          noise_array[#noise_array+1] = noise(i,j,k)
        end
      end
    end

    local function smooth_noise(x, y, octave)
      log(":" .. tostring((x+2)*(height+4)*octaves +  (y+2)*octaves + octave) .. " / " .. tostring(#noise_array) .. "(" .. tostring(x) .. "," .. tostring(y) .. "," .. tostring(octave) .. ")")
      local corners = noise_array[x*(height+4)*octaves +  y*octaves + octave]+noise_array[(x+2)*(height+4)*octaves +  y*octaves + octave]
          +noise_array[x*(height+4)*octaves +  (y+2)*octaves + octave] + noise_array[(x+2)*(height+4)*octaves +  (y+2)*octaves + octave]
      local sides = noise_array[x*(height+4)*octaves +  (y+1)*octaves + octave]+noise_array[(x+2)*(height+4)*octaves +  (y+1)*octaves + octave]
          +noise_array[(x+1)*(height+4)*octaves +  y*octaves + octave] + noise_array[(x+1)*(height+4)*octaves +  (y+2)*octaves + octave];
      local center = noise_array[(x+1)*(height+4)*octaves +  (y+1)*octaves + octave];
      return corners/16+sides/8+center/4
    end
    
    local smooth_noise_array = {}
    for i=0,width+1 do
      for j =0,height+1 do
        for k = 1,octaves do
          smooth_noise_array[#smooth_noise_array+1] = smooth_noise(i,j,k)
        end
      end
    end

    local function interpolated_noise(x,y,octave)
        
      local x_i = math.floor(x);
      local y_i = math.floor(y);
      local x_f = x-x_i;
      local y_f = y-y_i;

      local v_1 = smooth_noise_array[x_i*height*octaves + y_i*octaves+ octave];
      local v_2 = smooth_noise_array[(x_i+1)*height*octaves + y_i*octaves+ octave];
      local v_3 = smooth_noise_array[x_i*height*octaves + (y_i+1)*octaves+ octave];
      local v_4 = smooth_noise_array[(x_i+1)*height*octaves + (y_i+1)*octaves+ octave];
      
      local vy_1 = coserp(v_1, v_2, x_f);
      local vy_2 = coserp(v_3, v_4, x_f);
      
      return coserp(vy_1, vy_2, y_f)
    end

    local function value_noise(x,y)

      local total = 1.0;
      for loop=1,octaves do
        local size = octaveSize[loop];
        local amplitude = octaveAmplitude[loop];
        total = total+ interpolated_noise(x/size, y/size, loop)*amplitude;
      end
      
      total = total /2.0

      if(total < 0) then total = -total end

      return total;
    end


    return {
        value_noise = value_noise
    }
end