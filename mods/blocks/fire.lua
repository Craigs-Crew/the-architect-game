local S = default.get_translator

blocks.fire_types = {
    {"amber", "Amber", "blocks:amber_shard"},
    {"amethyst", "Amethyst", "blocks:amethyst_crystal"},
    {"azure", "Azureshroom", "group:azure"},
    {"diamond", "Diamond", "blocks:diamond"},
    {"fire", "Fireshroom", "group:fire_biome"},
    {"garnet", "Garnet", "blocks:garnet_crystal"},
    {"malachite", "Malachite", "blocks:malachite"},
    {"mese", "Mese", "blocks:mese_crystal"},
    {"moonstone", "Moonstone", "blocks:moonstone_crystal"},
}

-- Fires

minetest.register_node("blocks:fire_default", {
    description = S("Fake Fire"),
    tiles = {{
        name = "blocks_fire_default_animated.png",
        animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 2.0}
    }},
    inventory_image = "blocks_fire_default.png",
    drawtype = "firelike",
    paramtype = "light",
    sunlight_propagates = true,
    walkable = false,
    floodable = true,
    light_source = default.LIGHT_MAX,
    groups = {oddly_breakable_by_hand = 1},
    --sounds = default.node_sound_leaves_defaults()
})

for i=1,#blocks.fire_types do
    local name = blocks.fire_types[i][1]
    minetest.register_node("blocks:fire_" .. name, {
        description = S("Fake " .. blocks.fire_types[i][2] .. " Fire"),
        tiles = {{
            name = "blocks_fire_" .. name .. "_animated.png",
            animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 2.0}
        }},
        inventory_image = "blocks_fire_" .. name .. ".png",
        drawtype = "firelike",
        paramtype = "light",
        sunlight_propagates = true,
        walkable = false,
        floodable = true,
        light_source = default.LIGHT_MAX,
        groups = {oddly_breakable_by_hand = 1},
        --sounds = default.node_sound_leaves_defaults()
    })
end

-- Crafts

minetest.register_craft({
	output = "blocks:fire_default 3",
	recipe = {
		{"blocks:coal_lump", "blocks:coal_lump", "blocks:coal_lump"},
		{"group:stick", "group:stick", "group:stick"},
	}
})

for i=1,#blocks.fire_types do
    local name = blocks.fire_types[i][1]
    minetest.register_craft({
        output = "blocks:fire_" .. name .. " 3",
        recipe = {
            {blocks.fire_types[i][3], blocks.fire_types[i][3], blocks.fire_types[i][3]},
            {"group:stick", "group:stick", "group:stick"},
        }
    })
end