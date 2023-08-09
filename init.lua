local S = minetest.get_translator("dagger")

local function calculate_dagger_damage(distance)
    if distance <= 1 then
        return 50 -- critical damage
    elseif distance <= 2 then
        return 15
    elseif distance <= 3 then
        return 7
    elseif distance <= 4 then
        return 4
    elseif distance <= 5 then
        return 2
    else
        return 1
    end
end

minetest.register_tool("dagger:dagger", {
    description = S("Dagger\nThe closer you are to your target the more damage you will do."),
    inventory_image = "dagger.png",
    tool_capabilities = {
        full_punch_interval = 0.5,
        max_drop_level = 1,
        groupcaps = {
            snappy = {times = {[2] = 1.0}, uses = 25, maxlevel = 2},
        },
        damage_groups = {fleshy = 12},
    },
    on_use = function(itemstack, user, pointed_thing)
            if user and user:is_player() then
                local user_pos = user:get_pos()

                if pointed_thing and pointed_thing.type == "object" then
                    local target = pointed_thing.ref
                    local target_pos = target:get_pos()
                    local distance = vector.distance(user_pos, target_pos)

                    if distance <= 4 then
                        local damage = calculate_dagger_damage(distance)
                        target:punch(user, nil, {damage_groups = {fleshy = damage}})

                        local particle_pos = vector.add(target_pos, {x = 0, y = 1, z = 0})
                        minetest.add_particlespawner({
                            amount = 10,
                            time = 0.5,
                            minpos = particle_pos,
                            maxpos = particle_pos,
                            minvel = {x = -1, y = 0, z = -1},
                            maxvel = {x = 1, y = 2, z = 1},
                            minacc = {x = 0, y = -5, z = 0},
                            maxacc = {x = 0, y = -9, z = 0},
                            minexptime = 0.5,
                            maxexptime = 1.5,
                            minsize = 3,
                            maxsize = 4,
                            texture = "blood.png",
                        })
                    if itemstack:get_wear() + 1 <= 65535 then
                    itemstack:add_wear(65535 / 25)
                    end
                end
            end
        else
            return ItemStack("")
        end
        return itemstack
    end,
})

minetest.register_craft({
    output = "dagger:dagger",
    recipe = {
        {"", "default:steel_ingot", ""},
        {"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
        {"", "default:stick", ""}
    }
})

