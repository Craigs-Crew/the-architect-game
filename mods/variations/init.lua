variations = {}

workbench:register_crafttype("brickmaking", {
	description = ccore.comment("Brick Making", "Use a variations brickmaker"),
	icon = "crafticon_brickmaking.png",
})

variations.variations = {
	{
		name = "brick";
		description = "Brick";
		texture = "0,0";
		enabled_shapes = "cat:slab, cat:cube, cat:step, cat:corner, cat:stair, cat:splitstair, cat:pole, cat:pillar, cat:pillarcrown, cat:beam, cat:slope, cat:fence";
		recipe = {
			{0, 1, 1, 1, 0},
			{0, 1, 1, 1, 0},
			{0, 0, 0, 0, 0},
			{1, 1, 0, 1, 1},
			{1, 1, 0, 1, 1},
		},
		recipe_amount = 14,
	},
	{
		name = "tile_big";
		description = "Big Tile";
		texture = "1,0";
		enabled_shapes = "cat:slab, cat:cube, cat:step, cat:corner, cat:stair, cat:splitstair, cat:pole, cat:pillar, cat:pillarcrown, cat:beam, cat:slope, cat:fence";
		recipe = {
			{0, 0, 0, 0, 0},
			{0, 1, 1, 1, 0},
			{0, 1, 1, 1, 0},
			{0, 1, 1, 1, 0},
			{0, 0, 0, 0, 0},
		},
		recipe_amount = 9,
	},
	{
		name = "tile";
		description = "Tile";
		texture = "2,0";
		enabled_shapes = "slab1, slab4, slab, slab12, slab14, cube, step, cat:corner, cat:stair";
		recipe = {
			{1, 1, 0, 1, 1},
			{1, 1, 0, 1, 1},
			{0, 0, 0, 0, 0},
			{1, 1, 0, 1, 1},
			{1, 1, 0, 1, 1},
		},
		recipe_amount = 16,
	},
	{
		name = "stripe";
		description = "Stripe";
		texture = "0,2";
		rotation = true;
		enabled_shapes = "slab1, slab4, slab, slab12, slab14, cube, step, cat:corner, cat:stair";
		recipe = {
			{1, 1, 1, 1, 1},
			{1, 1, 1, 1, 1},
			{0, 0, 0, 0, 0},
			{1, 1, 1, 1, 1},
			{1, 1, 1, 1, 1},
		},
		recipe_amount = 20,
	},
	{
		name = "brick_small";
		description = "Small Brick";
		texture = "1,1";
		enabled_shapes = "slab1, slab4, slab, slab12, slab14, cube, step, cat:corner, cat:stair";
		recipe = {
			{1, 1, 0, 1, 1},
			{0, 1, 1, 1, 0},
			{1, 1, 0, 1, 1},
			{0, 1, 1, 1, 0},
			{1, 1, 0, 1, 1},
		},
		recipe_amount = 18,
	},
	{
		name = "tile_small";
		description = "Small Tile";
		texture = "2,1";
		enabled_shapes = "slab1, slab4, slab, slab12, slab14, cube, step, cat:corner, cat:stair";
		recipe = {
			{1, 0, 1, 0, 1},
			{0, 1, 0, 1, 0},
			{1, 0, 1, 0, 1},
			{0, 1, 0, 1, 0},
			{1, 0, 1, 0, 1},
		},
		recipe_amount = 13,
	},
	-- Unique patterns (Only basic shapes enabled)
	{
		name = "hexagon";
		description = "Hexagon Tile";
		texture = "0,1";
		rotation = true;
		enabled_shapes = "slab1, slab4, slab, slab12, slab14, cube, step, cat:corner, cat:stair";
		recipe = {
			{0, 0, 0, 0, 0},
			{0, 1, 1, 1, 0},
			{1, 1, 1, 1, 1},
			{0, 1, 1, 1, 0},
			{0, 0, 0, 0, 0},
		},
		recipe_amount = 11,
	},
	{
		name = "tile_cross";
		description = "Cross Tile";
		texture = "1,2";
		enabled_shapes = "slab1, slab4, slab, slab12, slab14, cube, step, cat:corner, cat:stair";
		recipe = {
			{0, 1, 1, 1, 0},
			{1, 1, 1, 1, 1},
			{1, 1, 1, 1, 1},
			{1, 1, 1, 1, 1},
			{0, 1, 1, 1, 0},
		},
		recipe_amount = 21,
	},
	{
		name = "tile_spiral";
		description = "Spiral Tile";
		texture = "2,2";
		enabled_shapes = "slab1, slab4, slab, slab12, slab14, cube, step, cat:corner, cat:stair";
		recipe = {
			{1, 1, 1, 0, 1},
			{0, 1, 1, 1, 1},
			{1, 1, 1, 1, 1},
			{1, 1, 1, 1, 0},
			{1, 0, 1, 1, 1},
		},
		recipe_amount = 21,
	},
}

local function convert_craft(base_node, variant_node)
	minetest.register_craft({
		output = base_node,
		recipe = {
			{variant_node},
		}
	})
end

function variations.register_for_base(base_node, tiles_override, transparent, sunlight)
	local base_definition = minetest.registered_nodes[base_node]
	ccore.station_comment(base_node, "Brickable")
	for _, variation in ipairs(variations.variations) do
		local sname = string.match(base_node, ':(.*)')
		local variation_name = "variations:" .. variation.name .. "_" .. sname
		local variation_description = ccore.strip_newlines(base_definition.description) .. " " .. variation.description
		local tiles
		if (tiles_override == nil) then
			tiles = {"variations_" .. sname .. ".png^[sheet:3x3:" .. variation.texture}
		else
			tiles = {"(" .. tiles_override .. ")^[sheet:3x3:" .. variation.texture}
		end
		local paramtype_light = ""
		local paramtype2 = nil
		if (variation.rotation) then
			paramtype2 = "facedir"
		end
		if not sunlight and transparent then
			sunlight = true
			paramtype_light = "light"
		end
		minetest.register_node(variation_name, {
			description = variation_description,
			tiles = tiles,
			groups = ccore.groups_copy(base_definition.groups),
			drawtype = base_definition.drawtype,
			use_texture_alpha = transparent or base_definition.use_texture_alpha,
			paramtype = paramtype_light or base_definition.paramtype,
			paramtype2 = paramtype2,
			light_source = base_definition.light_source,
			sunlight_propagates = sunlight or base_definition.sunlight_propagates,
			sounds = base_definition.sounds,
		})
		shapes:register_shape(variation_name, {
			enabled = variation.enabled_shapes,
		})
		local recipe = {{}, {}, {}, {}, {}}
		for i=1,5 do
			for j=1,5 do
				if variation.recipe[i][j] == 1 then
					recipe[i][j] = base_node
				else
					recipe[i][j] = ""
				end
			end
		end
		workbench:register_craft({
			type = "brickmaking",
			input =	recipe,
			output = {
				{variation_name .. " " .. variation.recipe_amount},
			},
		})
		if (variation.name == "brick") then
			minetest.register_craft({
				output = variation_name .. " 4",
				recipe = {
					{base_node, base_node},
					{base_node, base_node},
				}
			})
		elseif (variation.name == "tile_big") then
			minetest.register_craft({
				output = variation_name .. " 9",
				recipe = {
					{base_node, base_node, base_node},
					{base_node, base_node, base_node},
					{base_node, base_node, base_node},
				}
			})
		end
		convert_craft(base_node, variation_name)
	end
	blocks.alias_variation(string.match(base_node, ':(.*)'))
end

function variations.register_checker(base_node, second_node, name, transparent, sunlight)
	local base_definition = minetest.registered_nodes[base_node]
	for _, variation in ipairs(variations.variations) do
		local sname = string.match(base_node, ':(.*)') .. "_" .. string.match(second_node, ':(.*)')
		local variation_name = "variations:" .. variation.name .. "_checker_" .. sname
		local variation_description = name .. " " .. variation.description
		local tiles = {"variations_" .. sname .. "_checker.png^[sheet:3x3:" .. variation.texture}
		local paramtype_light = ""
		local paramtype2 = nil
		if (variation.rotation) then
			paramtype2 = "facedir"
		end
		if not sunlight and transparent then
			sunlight = true
			paramtype_light = "light"
		end
		minetest.register_node(variation_name, {
			description = variation_description,
			tiles = tiles,
			groups = ccore.groups_copy(base_definition.groups),
			drawtype = base_definition.drawtype,
			use_texture_alpha = transparent or base_definition.use_texture_alpha,
			paramtype = paramtype_light or base_definition.paramtype,
			paramtype2 = paramtype2,
			sunlight_propagates = sunlight or base_definition.sunlight_propagates,
			sounds = base_definition.sounds,
		})
		shapes:register_shape(variation_name, {
			enabled = variation.enabled_shapes,
		})
		minetest.register_craft({
			output = variation_name,
			recipe = {
				{"variations:" .. variation.name .. "_" .. string.match(base_node, ':(.*)'), "variations:" .. variation.name .. "_" .. string.match(second_node, ':(.*)')},
				{"variations:" .. variation.name .. "_" .. string.match(second_node, ':(.*)'), "variations:" .. variation.name .. "_" .. string.match(base_node, ':(.*)')},
			}
		})
	end
end

variations.supp_desc = {
	steel = "Steel",
	rust = "Rusty",
	wood = "Wooden"
}

variations.supp_craft = {
	steel = "blocks:steel_stick",
	rust = "blocks:rust_stick",
	wood = "blocks:stick"
}

function variations.register_support(base_node, support_type, support_material, transparent, sunlight)
	local base_definition = minetest.registered_nodes[base_node]
	local sname = string.match(base_node, ':(.*)')
	local craft_secondary = variations.supp_craft[support_material]
	for _, variation in ipairs(variations.variations) do
		local variation_name = "variations:" .. variation.name .. "_" .. sname .. "_support_" .. support_material
		local variation_clean_name = "variations:" .. variation.name .. "_" .. sname
		local variation_description = ccore.strip_newlines(base_definition.description) .. " " .. variation.description .. " with " .. variations.supp_desc[support_material] .. " Support"
		local tiles
		if (support_type == "full") then
			tiles = {"(variations_" .. sname .. ".png^[sheet:3x3:" .. variation.texture .. ")^(variations_support_" .. support_material .. ".png^[sheet:3x3:" .. variation.texture .. ")"}
		elseif (support_type == "single") then
			tiles = {"(variations_" .. sname .. ".png^[sheet:3x3:" .. variation.texture .. ")^variations_support_" .. support_material .. "_single.png"}
		end
		local paramtype_light = ""
		if not sunlight and transparent then
			sunlight = true
			paramtype_light = "light"
		end
		minetest.register_node(variation_name, {
			description = variation_description,
			tiles = tiles,
			groups = ccore.groups_copy(base_definition.groups),
			drawtype = base_definition.drawtype,
			use_texture_alpha = transparent or base_definition.use_texture_alpha,
			paramtype = paramtype_light or base_definition.paramtype,
			sunlight_propagates = sunlight or base_definition.sunlight_propagates,
			sounds = base_definition.sounds,
		})
		minetest.register_craft({
			output = variation_name .. " 4",
			recipe = {
				{craft_secondary, variation_clean_name, craft_secondary},
				{variation_clean_name, craft_secondary, variation_clean_name},
				{craft_secondary, variation_clean_name, craft_secondary},
			}
		})
		shapes:register_shape(variation_name, {
			enabled = variation.enabled_shapes,
		})
	end
	-- And for the base node
	local tiles_base
	if (support_type == "full") then
		tiles_base = {base_definition.tiles[1] .. "^(variations_support_" .. support_material .. ".png^[sheet:3x3:1,0)"}
	elseif (support_type == "single") then
		tiles_base = {base_definition.tiles[1] .. "^variations_support_" .. support_material .. "_single.png"}
	end
	minetest.register_node("variations:" .. sname .. "_support_" .. support_material, {
		description = ccore.strip_newlines(base_definition.description) .. " with " .. variations.supp_desc[support_material] .. " Support",
		tiles = tiles_base,
		groups = ccore.groups_copy(base_definition.groups),
		drawtype = base_definition.drawtype,
		use_texture_alpha = base_definition.use_texture_alpha,
		paramtype = base_definition.paramtype,
		sunlight_propagates = base_definition.sunlight_propagates,
		sounds = base_definition.sounds,
	})
	minetest.register_craft({
		output = "variations:" .. sname .. "_support_" .. support_material .. " 4",
		recipe = {
			{craft_secondary, base_node, craft_secondary},
			{base_node, craft_secondary, base_node},
			{craft_secondary, base_node, craft_secondary},
		}
	})
	shapes:register_shape("variations:" .. sname .. "_support_" .. support_material, {
		enabled = "slab, cube, step, cat:stair, splitstair, cat:pillar, cat:pillarcown, corner, pane, pane_flat, slope, slope2, slope3, innerslope, innerslope2, innerslope3, outerslope, outerslope2, outerslope3",
	})
end

variations.frames = {
	{
		name = "top";
		description = "Top";
		texture = "0";
	},
	{
		name = "upper";
		description = "Upper";
		texture = "1";
	},
	{
		name = "middle";
		description = "Middle";
		texture = "2";
	},
	{
		name = "lower";
		description = "Lower";
		texture = "3";
	},
	{
		name = "bottom";
		description = "Bottom";
		texture = "4";
	},
}

variations.frame_variations = {
	{
		name = "square";
		description = "Square";
		texture = "0";
	},
	{
		name = "diamond";
		description = "Diamond";
		texture = "1";
	},
	{
		name = "bars";
		description = "Bars";
		texture = "2";
	},
}

function variations.register_frame(base_node)
	local base_definition = minetest.registered_nodes[base_node]
	for _, frame in ipairs(variations.frames) do
		for _, variation in ipairs(variations.frame_variations) do
			local sname = string.match(base_node, ':(.*)')
			local frame_name = "variations:" .. variation.name .. "_" .. frame.name .. "_" .. sname
			local frame_description = ccore.comment(ccore.strip_newlines(base_definition.description) .. " Frame", "Type: " .. variation.description .. "\nSegment: " .. frame.description)
			local tiles = {"(variations_" .. sname .. ".png^[mask:(variations_glass_mask.png\\^[sheet\\:3x5\\:" .. variation.texture .. "," .. frame.texture .. "))", "variations_" .. sname .. ".png"}
			minetest.register_node(frame_name, {
				description = frame_description,
				tiles = tiles,
				groups = ccore.groups_copy(base_definition.groups),
				drawtype = "mesh",
				mesh = "frame.obj",
				collision_box = {
					type = "fixed",
					fixed = {
						{-0.5, -0.5, -0.1, 0.5, 0.5, 0.1},
					},
				},
				selection_box = {
					type = "fixed",
					fixed = {
						{-0.5, -0.5, -0.1, 0.5, 0.5, 0.1},
					},
				},
				use_texture_alpha = base_definition.use_texture_alpha,
				paramtype = "light",
				paramtype2 = "facedir",
				sunlight_propagates = true,
				sounds = base_definition.sounds,
			})
			convert_craft(base_node, frame_name)
		end
	end
end
function variations.register_stainglass(base_node)
	local base_definition = minetest.registered_nodes[base_node]
	for _, frame in ipairs(variations.frames) do
		for _, variation in ipairs(variations.frame_variations) do
			local sname = string.match(base_node, ':(.*)')
			local frame_dark_name = "variations:stainglass_dark_" .. variation.name .. "_" .. frame.name .. "_" .. sname
			local frame_dark_description = ccore.comment(ccore.strip_newlines(base_definition.description) .. " Dark Stainglass", "Type: " .. variation.description .. "\nSegment: " .. frame.description)
			local tiles_dark = {"variations_stainglass_" .. sname .. ".png^[sheet:3x5:" .. variation.texture .. "," .. frame.texture, "variations_void.png"}
			local frame_light_name = "variations:stainglass_light_" .. variation.name .. "_" .. frame.name .. "_" .. sname
			local frame_light_description = ccore.comment(ccore.strip_newlines(base_definition.description) .. " Light Stainglass", "Type: " .. variation.description .. "\nSegment: " .. frame.description)
			local tiles_light = {"variations_stainglass_light_" .. sname .. ".png^[sheet:3x5:" .. variation.texture .. "," .. frame.texture, "variations_glass.png"}
			minetest.register_node(frame_dark_name, {
				description = frame_dark_description,
				tiles = tiles_dark,
				groups = ccore.groups_copy(base_definition.groups),
				drawtype = "mesh",
				mesh = "frame.obj",
				collision_box = {
					type = "fixed",
					fixed = {
						{-0.5, -0.5, -0.1, 0.5, 0.5, 0.1},
					},
				},
				selection_box = {
					type = "fixed",
					fixed = {
						{-0.5, -0.5, -0.1, 0.5, 0.5, 0.1},
					},
				},
				light_source = 4,
				use_texture_alpha = base_definition.use_texture_alpha,
				paramtype = "light",
				paramtype2 = "facedir",
				sunlight_propagates = true,
				sounds = base_definition.sounds,
			})
			minetest.register_node(frame_light_name, {
				description = frame_light_description,
				tiles = tiles_light,
				groups = ccore.groups_copy(base_definition.groups),
				drawtype = "mesh",
				mesh = "frame.obj",
				collision_box = {
					type = "fixed",
					fixed = {
						{-0.5, -0.5, -0.1, 0.5, 0.5, 0.1},
					},
				},
				selection_box = {
					type = "fixed",
					fixed = {
						{-0.5, -0.5, -0.1, 0.5, 0.5, 0.1},
					},
				},
				light_source = 8,
				use_texture_alpha = base_definition.use_texture_alpha,
				paramtype = "light",
				paramtype2 = "facedir",
				sunlight_propagates = true,
				sounds = base_definition.sounds,
			})
		end
	end
end
variations.register_frame("blocks:obsidian_glass")
variations.register_frame("blocks:glass")

variations.register_for_base("blocks:stone")
variations.register_for_base("blocks:obsidian")
variations.register_for_base("blocks:desert_stone")
variations.register_for_base("blocks:sandstone")
variations.register_for_base("blocks:silver_sandstone")
variations.register_for_base("blocks:desert_sandstone")
variations.register_for_base("blocks:steelblock")
variations.register_for_base("blocks:steelblock_hazard")
variations.register_for_base("blocks:copperblock")
variations.register_for_base("blocks:copperblock_patinated")
variations.register_for_base("blocks:bronzeblock")
variations.register_for_base("blocks:tinblock")
variations.register_for_base("blocks:goldblock")
variations.register_for_base("blocks:brick")
variations.register_for_base("blocks:ice")
variations.register_for_base("blocks:dirt")
variations.register_for_base("blocks:coalblock")
variations.register_for_base("blocks:amethyst")
variations.register_for_base("blocks:garnet")
variations.register_for_base("blocks:lapis_lazuli")
variations.register_for_base("blocks:malachite")
variations.register_for_base("blocks:turquoise")
variations.register_for_base("blocks:amber")
variations.register_for_base("blocks:silverblock")
variations.register_for_base("blocks:mithrilblock")
variations.register_for_base("blocks:basalt")
variations.register_for_base("blocks:chalk")
variations.register_for_base("blocks:granite")
variations.register_for_base("blocks:marble")
variations.register_for_base("blocks:mud")
variations.register_for_base("blocks:porphyry")
variations.register_for_base("blocks:serpentine")
variations.register_for_base("blocks:slate")
variations.register_for_base("blocks:mineral_salt")
variations.register_for_base("blocks:concrete")
variations.register_for_base("blocks:wood")
variations.register_for_base("blocks:acacia_wood")
variations.register_for_base("blocks:aspen_wood")
variations.register_for_base("blocks:firewood")
variations.register_for_base("blocks:junglewood")
variations.register_for_base("blocks:azure_wood")
variations.register_for_base("blocks:amber_wood")
variations.register_for_base("blocks:dark_wood")
variations.register_for_base("blocks:ghost_wood")
variations.register_for_base("blocks:viridis_wood")
variations.register_for_base("blocks:pine_wood")
variations.register_for_base("blocks:cherry_wood")
variations.register_for_base("blocks:rustblock")
variations.register_for_base("blocks:rustblock_hazard")
variations.register_for_base("blocks:mese")
variations.register_for_base("blocks:malachite_glass")
variations.register_for_base("blocks:cobble")
variations.register_for_base("blocks:moonstone")

variations.register_for_base("blocks:obsidian_cursed", "variations_obsidian.png^[colorizehsl:-58:66")
variations.register_for_base("blocks:obsidian_sickly", "variations_obsidian.png^[colorizehsl:107:74")
variations.register_for_base("blocks:obsidian_hot", "variations_obsidian.png^[colorizehsl:-2:64")
variations.register_for_base("blocks:obsidian_crying", "variations_obsidian.png^[colorizehsl:-173:65")

variations.register_support("blocks:stone", "full", "wood")
variations.register_support("blocks:sandstone", "full", "wood")
variations.register_support("blocks:chalk", "full", "wood")

variations.register_support("blocks:brick", "single", "steel")
variations.register_support("blocks:brick", "single", "rust")

variations.register_stainglass("blocks:malachite_glass")
variations.register_stainglass("blocks:amethyst")
variations.register_stainglass("blocks:garnet")
variations.register_stainglass("blocks:moonstone")
for _, color in ipairs(blocks.stone_colors) do
	variations.register_for_base("blocks:stone_" .. color[1])
end

variations.register_checker("blocks:stone_black", "blocks:stone_dark_grey", "Black-Dark Grey Stone")
variations.register_checker("blocks:stone_dark_grey", "blocks:stone_grey", "Dark Grey-Grey Stone")
variations.register_checker("blocks:stone_grey", "blocks:stone_white", "Grey-White Stone")