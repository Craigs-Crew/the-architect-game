local S = default.get_translator

-- Required wrapper to allow customization of default.after_place_leaves
local function after_place_leaves(...)
	return default.after_place_leaves(...)
end

-- Required wrapper to allow customization of default.grow_sapling
local function grow_sapling(...)
	return flora.grow_sapling(...)
end

minetest.register_node("flora:stem_bush", {
	description = S("Bush Stem"),
	drawtype = "plantlike",
	visual_scale = 1.41,
	tiles = {"flora_bush_stem.png"},
	inventory_image = "flora_bush_stem.png",
	wield_image = "flora_bush_stem.png",
	paramtype = "light",
	sunlight_propagates = true,
	groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-7 / 16, -0.5, -7 / 16, 7 / 16, 0.5, 7 / 16},
	},
})

minetest.register_node("flora:leaves_bush", {
	description = S("Bush Leaves"),
	drawtype = "allfaces_optional",
	tiles = {"flora_leaves_simple.png"},
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"flora:sapling_bush"}, rarity = 5},
			{items = {"flora:leaves_bush"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = after_place_leaves,
})

minetest.register_node("flora:sapling_bush", {
	description = S("Bush Sapling"),
	drawtype = "plantlike",
	tiles = {"flora_bush_sapling.png"},
	inventory_image = "flora_bush_sapling.png",
	wield_image = "flora_bush_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = grow_sapling,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 2 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(300, 1500))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		itemstack = flora.sapling_on_place(itemstack, placer, pointed_thing,
			"flora:sapling_bush",
			-- minp, maxp to be checked, relative to sapling pos
			{x = -1, y = 0, z = -1},
			{x = 1, y = 1, z = 1},
			-- maximum interval of interior volume check
			2)

		return itemstack
	end,
})

minetest.register_craftitem("flora:blueberries", {
	description = S("Blueberries"),
	inventory_image = "flora_blueberries.png",
	groups = {food_blueberries = 1, food_berry = 1},
	on_use = minetest.item_eat(2),
})

minetest.register_node("flora:leaves_bush_blueberry_with_berries", {
	description = S("Blueberry Bush Leaves with Berries"),
	drawtype = "allfaces_optional",
	tiles = {"flora_blueberry_bush_leaves.png^flora_blueberry_overlay.png"},
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1, dig_immediate = 3},
	drop = "flora:blueberries",
	sounds = default.node_sound_leaves_defaults(),
	node_dig_prediction = "flora:leaves_bush_blueberry",

	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		minetest.set_node(pos, {name = "flora:leaves_bush_blueberry"})
		minetest.get_node_timer(pos):start(math.random(300, 1500))
	end,
})

minetest.register_node("flora:leaves_bush_blueberry", {
	description = S("Blueberry Bush Leaves"),
	drawtype = "allfaces_optional",
	tiles = {"flora_blueberry_bush_leaves.png"},
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"flora:sapling_bush_blueberry"}, rarity = 5},
			{items = {"flora:leaves_bush_blueberry"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	on_timer = function(pos, elapsed)
		if minetest.get_node_light(pos) < 11 then
			minetest.get_node_timer(pos):start(200)
		else
			minetest.set_node(pos, {name = "flora:leaves_bush_blueberry_with_berries"})
		end
	end,

	after_place_node = after_place_leaves,
})

minetest.register_node("flora:sapling_bush_blueberry", {
	description = S("Blueberry Bush Sapling"),
	drawtype = "plantlike",
	tiles = {"flora_blueberry_bush_sapling.png"},
	inventory_image = "flora_blueberry_bush_sapling.png",
	wield_image = "flora_blueberry_bush_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = grow_sapling,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 2 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(300, 1500))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		itemstack = flora.sapling_on_place(itemstack, placer, pointed_thing,
			"flora:sapling_bush_blueberry",
			-- minp, maxp to be checked, relative to sapling pos
			{x = -1, y = 0, z = -1},
			{x = 1, y = 1, z = 1},
			-- maximum interval of interior volume check
			2)

		return itemstack
	end,
})

minetest.register_node("flora:stem_bush_acacia", {
	description = S("Acacia Bush Stem"),
	drawtype = "plantlike",
	visual_scale = 1.41,
	tiles = {"flora_acacia_bush_stem.png"},
	inventory_image = "flora_acacia_bush_stem.png",
	wield_image = "flora_acacia_bush_stem.png",
	paramtype = "light",
	sunlight_propagates = true,
	groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-7 / 16, -0.5, -7 / 16, 7 / 16, 0.5, 7 / 16},
	},
})

minetest.register_node("flora:leaves_bush_acacia", {
	description = S("Acacia Bush Leaves"),
	drawtype = "allfaces_optional",
	tiles = {"flora_acacia_leaves_simple.png"},
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"flora:sapling_bush_acacia"}, rarity = 5},
			{items = {"flora:leaves_bush_acacia"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = after_place_leaves,
})

minetest.register_node("flora:sapling_bush_acacia", {
	description = S("Acacia Bush Sapling"),
	drawtype = "plantlike",
	tiles = {"flora_acacia_bush_sapling.png"},
	inventory_image = "flora_acacia_bush_sapling.png",
	wield_image = "flora_acacia_bush_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = grow_sapling,
	selection_box = {
		type = "fixed",
		fixed = {-3 / 16, -0.5, -3 / 16, 3 / 16, 2 / 16, 3 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(300, 1500))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		itemstack = flora.sapling_on_place(itemstack, placer, pointed_thing,
			"flora:sapling_bush_acacia",
			-- minp, maxp to be checked, relative to sapling pos
			{x = -1, y = 0, z = -1},
			{x = 1, y = 1, z = 1},
			-- maximum interval of interior volume check
			2)

		return itemstack
	end,
})

minetest.register_node("flora:stem_bush_pine", {
	description = S("Pine Bush Stem"),
	drawtype = "plantlike",
	visual_scale = 1.41,
	tiles = {"flora_pine_bush_stem.png"},
	inventory_image = "flora_pine_bush_stem.png",
	wield_image = "flora_pine_bush_stem.png",
	paramtype = "light",
	sunlight_propagates = true,
	groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-7 / 16, -0.5, -7 / 16, 7 / 16, 0.5, 7 / 16},
	},
})

minetest.register_node("flora:needles_bush_pine", {
	description = S("Pine Bush Needles"),
	drawtype = "allfaces_optional",
	tiles = {"flora_pine_needles.png"},
	paramtype = "light",
	groups = {snappy = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"flora:sapling_bush_pine"}, rarity = 5},
			{items = {"flora:needles_bush_pine"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = after_place_leaves,
})

minetest.register_node("flora:sapling_bush_pine", {
	description = S("Pine Bush Sapling"),
	drawtype = "plantlike",
	tiles = {"flora_pine_bush_sapling.png"},
	inventory_image = "flora_pine_bush_sapling.png",
	wield_image = "flora_pine_bush_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = grow_sapling,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 2 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(300, 1500))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		itemstack = flora.sapling_on_place(itemstack, placer, pointed_thing,
			"flora:sapling_bush_pine",
			-- minp, maxp to be checked, relative to sapling pos
			{x = -1, y = 0, z = -1},
			{x = 1, y = 1, z = 1},
			-- maximum interval of interior volume check
			2)

		return itemstack
	end,
})

minetest.register_node("flora:stem_bush_bone", {
	description = S("Ossified Bush Stem"),
	drawtype = "plantlike",
	visual_scale = 1.41,
	tiles = {"flora_bone_bush_stem.png"},
	inventory_image = "flora_bone_bush_stem.png",
	wield_image = "flora_bone_bush_stem.png",
	paramtype = "light",
	sunlight_propagates = true,
	groups = {choppy = 2, oddly_breakable_by_hand = 1},
	sounds = default.node_sound_wood_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-7 / 16, -0.5, -7 / 16, 7 / 16, 0.5, 7 / 16},
	},
})

default.register_leafdecay({
	trunks = {"flora:stem_bush"},
	leaves = {"flora:leaves_bush"},
	radius = 1,
})

default.register_leafdecay({
	trunks = {"flora:stem_bush_acacia"},
	leaves = {"flora:leaves_bush_acacia"},
	radius = 1,
})

default.register_leafdecay({
	trunks = {"flora:stem_bush_pine"},
	leaves = {"flora:needles_bush_pine"},
	radius = 1,
})

default.register_leafdecay({
	trunks = {"flora:stem_bush_bone"},
	leaves = {"flora:leaves_bone"},
	radius = 1,
})
