local tree_shapes_list = {"tree", "jungletree", "pine_tree", "acacia_tree", "aspen_tree", "cherry_tree", "bone_tree"}

for _, names in ipairs(tree_shapes_list) do
	shapes:register_shape("flora:"..names, {
		cube_tiles = {"flora_"..names.."_top.png","flora_"..names.."_top.png", "shapes_"..names.."_2.png", "flora_"..names..".png", "flora_"..names..".png", "shapes_"..names.."_2.png"},
		cube1_tiles = {"flora_"..names.."_top.png","flora_"..names.."_top.png", "shapes_"..names.."_2.png", "flora_"..names..".png", "flora_"..names..".png", "shapes_"..names.."_2.png"},
		cube2_tiles = {"flora_"..names.."_top.png","flora_"..names.."_top.png", "shapes_"..names.."_2.png", "flora_"..names..".png", "flora_"..names..".png", "shapes_"..names.."_2.png"},
		cube4_tiles = {"flora_"..names.."_top.png","flora_"..names.."_top.png", "shapes_"..names.."_2.png", "flora_"..names..".png", "flora_"..names..".png", "shapes_"..names.."_2.png"},
		cube12_tiles = {"flora_"..names.."_top.png","flora_"..names.."_top.png", "shapes_"..names.."_2.png", "flora_"..names..".png", "flora_"..names..".png", "shapes_"..names.."_2.png"},
		cube14_tiles = {"flora_"..names.."_top.png","flora_"..names.."_top.png", "shapes_"..names.."_2.png", "flora_"..names..".png", "flora_"..names..".png", "shapes_"..names.."_2.png"},
		step_tiles = {"flora_"..names.."_top.png","flora_"..names.."_top.png", "flora_"..names..".png", "flora_"..names..".png", "flora_"..names..".png", "shapes_"..names.."_2.png^[transformFY"},
		corner_tiles = {"flora_"..names.."_top.png","flora_"..names.."_top.png", "shapes_"..names.."_3.png^[transformFY]", "flora_"..names..".png", "shapes_"..names.."_3.png^[transformFYFX", "flora_"..names..".png"},
		halfstair_tiles = {"flora_"..names.."_top.png","flora_"..names.."_top.png", "shapes_"..names.."_2.png", "flora_"..names..".png", "flora_"..names..".png", "shapes_"..names..".png"},
		righthalfstair_tiles = {"flora_"..names.."_top.png","flora_"..names.."_top.png", "flora_"..names..".png", "shapes_"..names.."_2.png", "flora_"..names..".png", "shapes_"..names..".png"},
		stair_tiles = {"flora_"..names.."_top.png","flora_"..names.."_top.png", "flora_"..names..".png", "flora_"..names..".png", "flora_"..names..".png", "shapes_"..names..".png"},
		outerstair_tiles = {"flora_"..names.."_top.png","flora_"..names.."_top.png", "shapes_"..names..".png", "flora_"..names..".png", "flora_"..names..".png", "shapes_"..names..".png"},
		innerstair_tiles = {"flora_"..names.."_top.png","flora_"..names.."_top.png", "shapes_"..names.."_3.png^[transformFX", "flora_"..names..".png", "flora_"..names..".png", "shapes_"..names.."_3.png"},
		forkstair_tiles = {"flora_"..names.."_top.png","flora_"..names.."_top.png", "shapes_"..names.."_4.png^[transformFX", "flora_"..names..".png", "flora_"..names..".png", "shapes_"..names.."_4.png"},
		splitstair1_tiles = {"flora_"..names.."_top.png","flora_"..names.."_top.png", "flora_"..names..".png", "flora_"..names..".png", "shapes_"..names..".png^[transformFY.png", "shapes_"..names..".png"},
		splitstair4_tiles = {"flora_"..names.."_top.png","flora_"..names.."_top.png", "flora_"..names..".png", "flora_"..names..".png", "shapes_"..names..".png^[transformFY.png", "shapes_"..names..".png"},
		splitstair_tiles = {"flora_"..names.."_top.png","flora_"..names.."_top.png", "flora_"..names..".png", "flora_"..names..".png", "shapes_"..names..".png^[transformFY.png", "shapes_"..names..".png"},
		pole_tiles = {"shapes_"..names.."_fence_top.png", "shapes_"..names.."_fence_top.png", "flora_"..names..".png"},
		wallpole_tiles = {"shapes_"..names.."_fence_top_2.png", "shapes_"..names.."_fence_top_2.png^[transformFY", "flora_"..names..".png"},
		cornerpole_tiles = {"shapes_"..names.."_fence_top_3.png", "shapes_"..names.."_fence_top_3.png^[transformFY", "flora_"..names..".png"},
		pillar_tiles = {"shapes_"..names.."_wall_top.png", "shapes_"..names.."_wall_top.png", "flora_"..names..".png"},
		wallpillar_tiles = {"shapes_"..names.."_wall_top_2.png", "shapes_"..names.."_wall_top_2.png^[transformFY", "flora_"..names..".png"},
		halfpillar_tiles = {"shapes_"..names.."_wall_top_3.png", "shapes_"..names.."_wall_top_3.png^[transformFY", "flora_"..names..".png"},
		pillarcrown_tiles = {"flora_"..names..".png^shapes_"..names.."_wall_top.png", "flora_"..names..".png"},
		halfpillarcrown_tiles = {"flora_"..names..".png^shapes_"..names.."_wall_top_3.png", "flora_"..names..".png"},
		wallpillarcrown_tiles = {"flora_"..names..".png^shapes_"..names.."_wall_top_2.png", "flora_"..names..".png"},
		crosscrown_tiles = {"flora_"..names..".png^shapes_"..names.."_wall_top.png", "flora_"..names..".png"},
		beam_tiles = {"flora_"..names..".png", "flora_"..names..".png", "flora_"..names..".png^[transformR90", "flora_"..names..".png^[transformR90", "shapes_"..names.."_wall_top_2.png^[transformFY", "shapes_"..names.."_wall_top_2.png^[transformFY"},
		crossbeam_tiles = {"flora_"..names..".png", "flora_"..names..".png", "flora_"..names..".png^[transformR90^shapes_"..names.."_wall_top_2.png^[transformFY"},
		linkdown_tiles = {"flora_"..names..".png", "flora_"..names..".png", "flora_"..names..".png^[transformR90", "flora_"..names..".png^[transformR90", "flora_"..names..".png^shapes_"..names.."_wall_top_2.png", "flora_"..names..".png^shapes_"..names.."_wall_top_2.png"},
		texture = "flora_"..names..".png",
		align_style = "node",
		use_texture_alpha = "opaque",
	})

	shapes:register_shape("flora:"..names.."_bark", {
		disabled = "cat:pole, cat:pillar, cat:pillarcrown, cat:beam, cat:fence",
	})
end