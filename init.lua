local S = minetest.get_translator("dagger")

minetest.register_tool("dagger:dagger", {
    description = "Dagger",
    inventory_image = "dagger.png",
    tool_capabilities = {
		full_punch_interval = 1.0,
        max_drop_level = 0,
        groupcaps = {
            snappy = {times = {[2] = 2.0}, uses = 25, maxlevel = 2},
        },
        damage_groups = {fleshy = 1},
    },
})

local function calculate_damage(distance)
    if distance == 0 then
        return math.random(35, 50)
    elseif distance == 1 then
        return math.random(15, 34)
    elseif distance == 2 then
        return math.random(1, 5)
    elseif distance == 3 then
        return math.random(1, 3)
    elseif distance == 4 then
        return math.random(1, 2)
    else
        return 0
    end
end

minetest.register_on_punchplayer(function(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)
    local wielded_item = hitter:get_wielded_item()
    if wielded_item:get_name() == "dagger:dagger" then
        local hitter_pos = hitter:get_pos()
        local player_pos = player:get_pos()
        local distance = vector.distance(hitter_pos, player_pos)

        local calculated_damage = calculate_damage(math.floor(distance))

        if calculated_damage > 0 then
            local player_hp = player:get_hp()
            player:set_hp(player_hp - calculated_damage)

            local wear_increase = 65535 / 25
            wielded_item:add_wear(wear_increase)
            hitter:set_wielded_item(wielded_item)
        end
    end
end)

minetest.register_craft({
    output = "dagger:dagger",
    recipe = {
        {"", "default:steel_ingot", ""},
        {"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
        {"", "default:stick", ""}
    }
})
