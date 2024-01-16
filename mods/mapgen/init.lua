mapgen = {}

mapgen.np_stalagmites = {
	offset = -0.85,
	scale = 1,
	spread = {x = 10, y = 10, z = 10},
	seed = 2620,
	octaves = 2,
	persistence = 1,
	lacunarity = 1,
	flags = "",
}

mapgen.lost_mese_ore_params = {
	scarcity = 20 * 20 * 20,
	num_ores = 3,
	clust_size = 3,
}

mapgen.core_plating_barrier = -2305 -- Quarry Bottom - 1

mapgen.terrain_ceiling = 512 -- How high up the ores spawn in the terrain

mapgen.lush_biomes = {"grassland", "grassland_dunes", "grassland_ocean",
					"coniferous_forest", "coniferous_forest_ocean", "coniferous_forest_dunes",
					"deciduous_forest", "deciduous_forest_shore", "deciduous_forest_ocean",
					"rainforest", "rainforest_swamp", "rainforest_ocean",
					"chalk_grassland", "chalk_grassland_ocean"}
mapgen.frosty_biomes = {"cold_desert", "cold_desert_ocean",
					"taiga", "taiga_ocean",
					"snowy_grassland", "snowy_grassland_ocean",
					"icesheet", "icesheet_ocean",
					"tundra", "tundra_highland", "tundra_ocean", "tundra_beach"}
mapgen.hot_biomes = {"desert", "desert_ocean",
					"sandstone_desert", "sandstone_desert_ocean",
					"savanna", "savanna_shore", "savanna_ocean"}

-- Clear default biomes, ores and decorations
minetest.clear_registered_biomes()
minetest.clear_registered_ores()
minetest.clear_registered_decorations()

local path = minetest.get_modpath("mapgen")
local biomes_path = minetest.get_modpath("mapgen") .. "/underground_biomes"
dofile(path.."/alias.lua")
dofile(path.."/functions.lua")
dofile(path.."/noise.lua")
dofile(path.."/mapgen.lua")
dofile(path.."/oregen.lua")
dofile(path.."/flowergen.lua")
dofile(path.."/grassspread.lua")
dofile(path.."/mossspread.lua")

dofile(biomes_path .. "/sfcave.lua")
dofile(biomes_path .. "/underground.lua")
dofile(biomes_path .. "/mushroom.lua")
dofile(biomes_path .. "/quarry.lua")

-- Register biomes, ores and decorations
local mapgen_name = minetest.get_mapgen_setting("mg_name")
if mapgen_name ~= "singlenode" and mapgen_name ~= "flat" then
	mapgen.register_sfcave_biomes()
	mapgen.register_underground_biomes()
	mapgen.register_quarry_biomes()
	mapgen.register_mushroom_biomes()
	mapgen.register_surface_biomes()

	mapgen.register_sfcave_ores()
	mapgen.register_underground_ores()
	mapgen.register_mushroom_ores()
	mapgen.register_quarry_ores()
	mapgen.register_ores()

	mapgen.register_sfcave_decorations()
	mapgen.register_underground_decorations()
	mapgen.register_mushroom_decorations()
	mapgen.register_quarry_decorations()
	mapgen.register_decorations()

	minetest.register_ore({
		ore_type = "stratum",
		ore = "blocks:core_plating",
		wherein = {"blocks:stone", "air"},
		y_max = mapgen.core_plating_barrier,
		y_min = mapgen.core_plating_barrier - 3,
	})

end
-- Modifying light by placing glowing schems requires lighting recalc
minetest.register_on_generated(function(minp, maxp, blockseed)
	local vm = minetest.get_voxel_manip()
    local emin, emax = vm:read_from_map(minp, maxp)
	minetest.fix_light(emin, emax)
end)