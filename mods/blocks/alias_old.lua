
-- This file alias some legacy inconsistent namings for various blocks
-- Impact is likely very minor and is just for compatibility

local shapes_list = {
    {"slab1"},
    {"slab2"},
    {"slab4"},
    {"slab"},
    {"slab12"},
    {"slab14"},
    {"cube1"},
    {"cube2"},
    {"cube4"},
    {"cube"},
    {"cube12"},
    {"cube14"},
    {"step1"},
    {"step2"},
    {"step4"},
    {"step"},
    {"step12"},
    {"step14"},
    {"corner"},
    {"stair"},
    {"halfstair"},
    {"righthalfstair"},
    {"outerstair"},
    {"innerstair"},
    {"forkstair"},
    {"splitstair1"},
    {"splitstair4"},
    {"splitstair"},
    {"pole"},
    {"wallpole"},
    {"cornerpole"},
    {"pillar"},
    {"wallpillar"},
    {"halfpillar"},
    {"pillarcrown"},
    {"wallpillarcrown"},
    {"halfpillarcrown"},
    {"crosscrown"},
    {"beam"},
    {"crossbeam"},
    {"linkdown"},
    {"sphere"},
    {"slope"},
    {"slope2"},
    {"slope3"},
    {"innerslope"},
    {"innerslope2"},
    {"innerslope3"},
    {"cutinnerslope"},
    {"cutinnerslope2"},
    {"cutinnerslope3"},
    {"outerslope"},
    {"outerslope2"},
    {"outerslope3"},
    {"cutouterslope"},
    {"cutouterslope2"},
    {"cutouterslope3"},
    {"cutouterslope4"},
    {"fence"},
    {"fencerail"},
    {"wall"},
    {"pane_flat"},
    {"pane"},
    {"panemc_flat"},
    {"panemc"},
}

local function register_shapes_alias(oldname, newname)
    for _, row in ipairs(shapes_list) do
        local old_mname = string.match(oldname, '(.*):')
        local old_sname = string.match(oldname, ':(.*)')
        local new_mname = string.match(newname, '(.*):')
        local new_sname = string.match(newname, ':(.*)')

        minetest.register_alias(old_mname..":shapes_"..old_sname.."_"..row[1], new_mname..":shapes_"..new_sname.."_"..row[1])
    end
end

-- stick
minetest.register_alias("blocks:mushroom_stick", "blocks:stick_mushroom")
-- wood
minetest.register_alias("blocks:junglewood", "blocks:wood_jungle")
register_shapes_alias("blocks:junglewood", "blocks:wood_jungle")
minetest.register_alias("blocks:pine_wood", "blocks:wood_pine")
register_shapes_alias("blocks:pine_wood", "blocks:wood_pine")
minetest.register_alias("blocks:acacia_wood", "blocks:wood_acacia")
register_shapes_alias("blocks:acacia_wood", "blocks:wood_acacia")
minetest.register_alias("blocks:aspen_wood", "blocks:wood_aspen")
register_shapes_alias("blocks:aspen_wood", "blocks:wood_aspen")
minetest.register_alias("blocks:cherry_wood", "blocks:wood_cherry")
minetest.register_alias("blocks:bonewood", "blocks:wood_bone")
minetest.register_alias("blocks:firewood", "blocks:wood_fire")
minetest.register_alias("blocks:azure_wood", "blocks:wood_azure")
minetest.register_alias("blocks:amber_wood", "blocks:wood_amber")
minetest.register_alias("blocks:dark_wood", "blocks:wood_dark")
minetest.register_alias("blocks:ghost_wood", "blocks:wood_ghost")
minetest.register_alias("blocks:viridis_wood", "blocks:wood_viridis")
-- tree
minetest.register_alias("flora:tree_bark", "flora:treebark")
register_shapes_alias("flora:tree_bark", "flora:treebark")
minetest.register_alias("flora:jungletree", "flora:tree_jungle")
register_shapes_alias("flora:jungletree", "flora:tree_jungle")
minetest.register_alias("flora:jungletree_bark", "flora:treebark_jungle")
register_shapes_alias("flora:jungletree_bark", "flora:treebark_jungle")
minetest.register_alias("flora:jungleleaves", "flora:leaves_jungle")
minetest.register_alias("flora:junglesapling", "flora:sapling_emergent_jungle")
minetest.register_alias("flora:pine_tree", "flora:tree_pine")
register_shapes_alias("flora:pine_tree", "flora:tree_pine")
minetest.register_alias("flora:pine_tree_bark", "flora:treebark_pine")
register_shapes_alias("flora:pine_tree_bark", "flora:treebark_pine")
minetest.register_alias("flora:pine_needles", "flora:needles_pine")
minetest.register_alias("flora:pine_sapling", "flora:sapling_pine")
minetest.register_alias("flora:pine_sapling_big", "flora:sapling_big_pine")
minetest.register_alias("flora:acacia_tree", "flora:tree_acacia")
register_shapes_alias("flora:acacia_tree", "flora:tree_acacia")
minetest.register_alias("flora:acacia_tree_bark", "flora:treebark_acacia")
register_shapes_alias("flora:acacia_tree_bark", "flora:treebark_acacia")
minetest.register_alias("flora:acacia_leaves", "flora:leaves_acacia")
minetest.register_alias("flora:acacia_sapling", "flora:sapling_acacia")
minetest.register_alias("flora:acacia_sapling_big", "flora:sapling_big_acacia")
minetest.register_alias("flora:aspen_tree", "flora:tree_aspen")
register_shapes_alias("flora:aspen_tree", "flora:tree_aspen")
minetest.register_alias("flora:aspen_tree_bark", "flora:treebark_aspen")
register_shapes_alias("flora:aspen_tree_bark", "flora:treebark_aspen")
minetest.register_alias("flora:aspen_leaves", "flora:leaves_aspen")
minetest.register_alias("flora:aspen_sapling", "flora:sapling_aspen")
minetest.register_alias("flora:aspen_sapling_big", "flora:sapling_big_aspen")
minetest.register_alias("flora:cherry_tree", "flora:tree_cherry")
register_shapes_alias("flora:cherry_tree", "flora:tree_cherry")
minetest.register_alias("flora:cherry_tree_bark", "flora:treebark_cherry")
register_shapes_alias("flora:cherry_tree_bark", "flora:treebark_cherry")
minetest.register_alias("flora:cherry_sapling", "flora:sapling_cherry")
minetest.register_alias("flora:cherry_sapling_big", "flora:sapling_big_cherry")
minetest.register_alias("flora:cherry_leaves", "flora:leaves_cherry")
minetest.register_alias("flora:dry_leaves", "flora:leaves_dry")
minetest.register_alias("flora:bone_tree", "flora:tree_bone")
register_shapes_alias("flora:bone_tree", "flora:tree_bone")
minetest.register_alias("flora:bone_tree_bark", "flora:treebark_bone")
register_shapes_alias("flora:bone_tree_bark", "flora:treebark_bone")
minetest.register_alias("flora:bone_sapling", "flora:sapling_bone")
minetest.register_alias("flora:bone_sapling_big", "flora:sapling_big_bone")
minetest.register_alias("flora:crimson_leaves", "flora:leaves_crimson")
-- bush
minetest.register_alias("flora:bush_leaves", "flora:leaves_bush")
minetest.register_alias("flora:bush_stem", "flora:stem_bush")
minetest.register_alias("flora:bush_sapling", "flora:sapling_bush")
minetest.register_alias("flora:acacia_bush_leaves", "flora:leaves_bush_acacia")
minetest.register_alias("flora:acacia_bush_stem", "flora:stem_bush_acacia")
minetest.register_alias("flora:acacia_bush_sapling", "flora:sapling_bush_acacia")
minetest.register_alias("flora:pine_bush_needles", "flora:needles_bush_pine")
minetest.register_alias("flora:pine_bush_stem", "flora:stem_bush_pine")
minetest.register_alias("flora:pine_bush_sapling", "flora:sapling_bush_pine")
minetest.register_alias("flora:bone_bush_stem", "flora:stem_bush_bone")
minetest.register_alias("flora:bone_bush_sapling", "flora:sapling_bush_bone")
minetest.register_alias("flora:blueberry_bush_leaves", "flora:leaves_bush_blueberry")
minetest.register_alias("flora:blueberry_bush_leaves_with_berries", "flora:leaves_bush_blueberry_with_berries")
minetest.register_alias("flora:blueberry_bush_stem", "flora:stem_bush_blueberry")
minetest.register_alias("flora:blueberry_bush_sapling", "flora:sapling_bush_blueberry")
-- bonsai
minetest.register_alias("flora:jungle_tree_bonsai", "flora:bonsai_jungle")
minetest.register_alias("flora:jungle_tree_big_bonsai", "flora:bonsai_big_jungle")
minetest.register_alias("flora:tree_bonsai", "flora:bonsai")
minetest.register_alias("flora:tree_big_bonsai", "flora:bonsai_big")
minetest.register_alias("flora:pine_tree_bonsai", "flora:bonsai_pine")
minetest.register_alias("flora:pine_tree_big_bonsai", "flora:bonsai_big_pine")
minetest.register_alias("flora:acacia_tree_bonsai", "flora:bonsai_acacia")
minetest.register_alias("flora:acacia_tree_big_bonsai", "flora:bonsai_big_acacia")
minetest.register_alias("flora:aspen_tree_bonsai", "flora:bonsai_aspen")
minetest.register_alias("flora:aspen_tree_big_bonsai", "flora:bonsai_big_aspen")
minetest.register_alias("flora:cherry_tree_bonsai", "flora:bonsai_cherry")
minetest.register_alias("flora:cherry_tree_big_bonsai", "flora:bonsai_big_cherry")
minetest.register_alias("flora:bone_tree_bonsai", "flora:bonsai_bone")
minetest.register_alias("flora:bone_tree_big_bonsai", "flora:bonsai_big_bone")
-- shrubbery
minetest.register_alias("flora:acacia_tree_shrubbery", "flora:shrubbery_acacia")
minetest.register_alias("flora:acacia_tree_shrubbery_big", "flora:shrubbery_big_acacia")
minetest.register_alias("flora:acacia_tree_shrubbery_top", "flora:shrubbery_top_acacia")
minetest.register_alias("flora:acacia_tree_shrubbery_tall", "flora:shrubbery_tall_acacia")
minetest.register_alias("flora:aspen_tree_shrubbery", "flora:shrubbery_aspen")
minetest.register_alias("flora:aspen_tree_shrubbery_big", "flora:shrubbery_big_aspen")
minetest.register_alias("flora:aspen_tree_shrubbery_top", "flora:shrubbery_top_aspen")
minetest.register_alias("flora:aspen_tree_shrubbery_tall", "flora:shrubbery_tall_aspen")
minetest.register_alias("flora:bone_tree_shrubbery", "flora:shrubbery_bone")
minetest.register_alias("flora:bone_tree_shrubbery_big", "flora:shrubbery_big_bone")
minetest.register_alias("flora:bone_tree_shrubbery_top", "flora:shrubbery_top_bone")
minetest.register_alias("flora:bone_tree_shrubbery_tall", "flora:shrubbery_tall_bone")
minetest.register_alias("flora:cherry_tree_shrubbery", "flora:shrubbery_cherry")
minetest.register_alias("flora:cherry_tree_shrubbery_big", "flora:shrubbery_big_cherry")
minetest.register_alias("flora:cherry_tree_shrubbery_top", "flora:shrubbery_top_cherry")
minetest.register_alias("flora:cherry_tree_shrubbery_tall", "flora:shrubbery_tall_cherry")
minetest.register_alias("flora:dry_shrubbery", "flora:shrubbery_dry")
minetest.register_alias("flora:dry_shrubbery_big", "flora:shrubbery_big_dry")
minetest.register_alias("flora:dry_shrubbery_top", "flora:shrubbery_top_dry")
minetest.register_alias("flora:dry_shrubbery_tall", "flora:shrubbery_tall_dry")
minetest.register_alias("flora:jungle_tree_shrubbery", "flora:shrubbery_jungle")
minetest.register_alias("flora:jungle_tree_shrubbery_big", "flora:shrubbery_big_jungle")
minetest.register_alias("flora:jungle_tree_shrubbery_top", "flora:shrubbery_top_jungle")
minetest.register_alias("flora:jungle_tree_shrubbery_tall", "flora:shrubbery_tall_jungle")
minetest.register_alias("flora:pine_tree_shrubbery", "flora:shrubbery_pine")
minetest.register_alias("flora:pine_tree_shrubbery_big", "flora:shrubbery_big_pine")
minetest.register_alias("flora:pine_tree_shrubbery_top", "flora:shrubbery_top_pine")
minetest.register_alias("flora:pine_tree_shrubbery_tall", "flora:shrubbery_tall_pine")

function blocks.alias_variation(material)
    minetest.register_alias("variations:" .. material .. "_brick", "variations:brick_" .. material)
    register_shapes_alias("variations:" .. material .. "_brick", "variations:brick_" .. material)
    minetest.register_alias("variations:" .. material .. "_big_tile", "variations:tile_big_" .. material)
    register_shapes_alias("variations:" .. material .. "_big_tile", "variations:tile_big_" .. material)
    minetest.register_alias("variations:" .. material .. "_tile", "variations:tile_" .. material)
    register_shapes_alias("variations:" .. material .. "_tile", "variations:tile_" .. material)
    minetest.register_alias("variations:" .. material .. "_hexagon", "variations:hexagon_" .. material)
    register_shapes_alias("variations:" .. material .. "_hexagon", "variations:hexagon_" .. material)
    minetest.register_alias("variations:" .. material .. "_small_brick", "variations:brick_small_" .. material)
    register_shapes_alias("variations:" .. material .. "_small_brick", "variations:brick_small_" .. material)
    minetest.register_alias("variations:" .. material .. "_small_tile", "variations:tile_small_" .. material)
    register_shapes_alias("variations:" .. material .. "_small_tile", "variations:tile_small_" .. material)
    minetest.register_alias("variations:" .. material .. "_stripe", "variations:stripe_" .. material)
    register_shapes_alias("variations:" .. material .. "_stripe", "variations:stripe_" .. material)
    minetest.register_alias("variations:" .. material .. "_cross_tile", "variations:tile_cross_" .. material)
    register_shapes_alias("variations:" .. material .. "_cross_tile", "variations:tile_cross_" .. material)
    minetest.register_alias("variations:" .. material .. "_spiral_tile", "variations:tile_spiral_" .. material)
    register_shapes_alias("variations:" .. material .. "_spiral_tile", "variations:tile_spiral_" .. material)
end

minetest.register_alias("blocks:obsidian_block", "variations:tile_big_obsidian")
minetest.register_alias("blocks:obsidianbrick", "variations:brick_obsidian")
minetest.register_alias("blocks:stone_block", "variations:tile_big_stone")
minetest.register_alias("blocks:stonebrick", "variations:brick_stone")
minetest.register_alias("blocks:sandstone_block", "variations:tile_big_sandstone")
minetest.register_alias("blocks:sandstonebrick", "variations:brick_sandstone")
minetest.register_alias("blocks:desert_stone_block", "variations:tile_big_desert_stone")
minetest.register_alias("blocks:desert_stonebrick", "variations:brick_desert_stone")
minetest.register_alias("blocks:silver_sandstone_block", "variations:tile_big_silver_sandstone")
minetest.register_alias("blocks:silver_sandstonebrick", "variations:brick_silver_sandstone")
minetest.register_alias("blocks:desert_sandstone_block", "variations:tile_big_desert_sandstone")
minetest.register_alias("blocks:desert_sandstonebrick", "variations:brick_desert_sandstone")

--minetest.register_alias("blocks:oldname", "blocks:newname")