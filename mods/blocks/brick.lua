local S = default.get_translator

minetest.register_craftitem("blocks:clay_brick", {
	description = S("Clay Brick"),
	inventory_image = "blocks_clay_brick.png",
	groups = {loot = 1}
})

minetest.register_craftitem("blocks:clay_lump", {
	description = S("Clay Lump"),
	inventory_image = "blocks_clay_lump.png",
	groups = {loot = 1}
})

minetest.register_node("blocks:clay", {
	description = S("Clay"),
	tiles = {"blocks_clay.png"},
	groups = {crumbly = 3, loot = 1},
	drop = "blocks:clay_lump 4",
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_node("blocks:clay_hard", {
	description = S("Hardened Clay"),
	tiles = {"blocks_clay_hard.png"},
	groups = {crumbly = 2, loot = 2},
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_node("blocks:brick", {
	description = S("Brick Block"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {
		"blocks_brick.png^[transformFX",
		"blocks_brick.png",
	},
	is_ground_content = false,
	groups = {cracky = 3, loot = 2},
	sounds = default.node_sound_stone_defaults(),
})

--
-- == CRAFTS
-- ==

minetest.register_craft({
	output = "blocks:clay_brick 4",
	recipe = {
		{"blocks:brick"},
	}
})

minetest.register_craft({
	output = "blocks:clay_lump 4",
	recipe = {
		{"blocks:clay"},
	}
})

minetest.register_craft({
	type = "cooking",
	output = "blocks:clay_brick",
	recipe = "blocks:clay_lump",
})

minetest.register_craft({
	output = "blocks:clay",
	recipe = {
		{"blocks:clay_lump", "blocks:clay_lump"},
		{"blocks:clay_lump", "blocks:clay_lump"},
	}
})

minetest.register_craft({
	output = "blocks:brick",
	recipe = {
		{"blocks:clay_brick", "blocks:clay_brick"},
		{"blocks:clay_brick", "blocks:clay_brick"},
	}
})

minetest.register_craft({
	output = "blocks:clay_hard",
	recipe = {
		{"blocks:clay", "blocks:clay", "blocks:clay"},
		{"blocks:clay", "blocks:clay", "blocks:clay"},
		{"blocks:clay", "blocks:clay", "blocks:clay"},
	}
})

minetest.register_craft({
	output = "blocks:clay 9",
	recipe = {
		{"blocks:clay_hard"},
	}
})