--for _,resource in pairs(data.raw.resource) do
--    resource.autoplace = nil
--end

--data.raw.resource['iron-ore'].autoplace = nil
--data.raw.resource['copper-ore'].autoplace = nil
--data.raw.resource['stone'].autoplace = nil
--data.raw.resource['uranium-ore'].autoplace = nil
--data.raw.resource['crude-oil'].autoplace = nil
--data.raw.resource['coal'].autoplace = nil


-- Fix technologies.
for _, technology in pairs(data.raw.technology) do
    if technology.name:find("ob-", 1, true) ~= 1 then --Not an offworld bounties technology
        technology.hidden = true
    end
end

data.raw['recipe']['assembling-machine-1'].enabled = true