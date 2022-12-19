local whomes_inventory = {}
local mod_storage = winv.mod_storage
local whomes_icons = {
	"blocks:wool_white",
	"blocks:marble",
	"blocks:stone",
	"blocks:stonebrick",
	"blocks:cobble",
	"blocks:brick",
	"blocks:lava_source",
	"variations:bronzeblock_big_tile",
	"blocks:amber",
	"blocks:mese",
	"blocks:sand",
	"blocks:dirt_with_grass",
	"flora:cactus",
	"flora:leaves",
	"blocks:water_source",
	"blocks:diamondblock",
	"variations:mithrilblock_big_tile",
	"blocks:amethyst",
	"blocks:mineral_salt",
	"crates:chest",
	"crates:crate",
	"crates:barrel",
	"flora:tree",
	"blocks:coalblock",
	"blocks:granite",
}

local function homes_chat(name, message)
	if minetest.get_player_by_name(name) then
		minetest.chat_send_player(name, minetest.colorize("grey", "[homes]").." "..message)
	end
end

minetest.register_on_newplayer(function(player)
	local name = player:get_player_name()
	local default_limit = tonumber(minetest.settings:get("winv_max_homes")) or 3
	mod_storage:set_int("whomes_limit_"..name, default_limit)
end)

local function get_homes_limit(player)
	local name = player:get_player_name()
	local homes_limit = mod_storage:get_int("whomes_limit_"..name)
	if homes_limit and tonumber(homes_limit) then
		return homes_limit
	else
		local default_limit = tonumber(minetest.settings:get("winv_max_homes")) or 3
		mod_storage:set_int("whomes_limit_"..name, default_limit)
		return default_limit
	end
end

local function get_homes_amt(player, type)
	local name = player:get_player_name()
	local homespd = mod_storage:get_string("whomes_"..name)
	if not homespd or homespd == "" then
		return 0, 0
	end
	local homesdata = minetest.deserialize(homespd)
	local homes_amt = 0
	local total_amt = 0
	for i, homelist in pairs(homesdata) do
		if type and homelist.type == type then
			homes_amt = homes_amt + 1
		end
		total_amt = total_amt + 1
	end
	if type then
		return homes_amt, total_amt
	else
		return total_amt
	end
end

local function init_homes(player)
	local homes_amt, total_amt = get_homes_amt(player, "home")
	local name = player:get_player_name()
	whomes_inventory[name] = {
		waypoints = {},
		ordered_table = {},
		scroll = 0,
		teleporting = nil,
		hamt = homes_amt,
		tamt = total_amt,
		hlimit = get_homes_limit(player),
	}
	return whomes_inventory[name]
end

local function create_ordered_table(homesdata)
	local ordered_table = {}
	for hname, homelist in pairs(homesdata) do
		ordered_table[homelist.order] = hname
	end
	return ordered_table
end

local function add_home(player, hname, htype)
	local htype2 = htype or "home"
	local name = player:get_player_name()
	local hinv = whomes_inventory[name] or init_homes(player)
	if not hname or hname == "" then
		homes_chat(name, "Please add a name for the "..htype2.."!")
		return false
	end
	local homes_amt, total_amt = hinv.hamt, hinv.tamt
	local homes_limit = hinv.hlimit
	local homesdata = minetest.deserialize(mod_storage:get_string("whomes_"..name)) or {}
	if htype2 == "home" and homesdata and (homes_amt + 1) > homes_limit then -- check home limit
		homes_chat(name, "You have reached your limit of "..homes_limit.." "..htype2.."s! Delete existing ones.")
		return false
	end
	if homesdata[hname] then -- ensure name isnt already registered
		homes_chat(name, hname.." is already registered! Please pick another name or delete the existing entry.")
		return false
	end
	local ppos = player:get_pos()
	local order = total_amt + 1
	hinv.tamt = hinv.tamt + 1
	if htype2 == "waypoint" then
		local color = math.random(0xFFFFFF)
		homesdata[hname] = {x = ppos.x, y = ppos.y, z = ppos.z, type = "waypoint", icon = math.random(1, #whomes_icons), hud = true, color = color, order = order}
	else
		homesdata[hname] = {x = ppos.x, y = ppos.y, z = ppos.z, type = "home", icon = math.random(1, #whomes_icons), hud = nil, color = nil, order = order}
		hinv.hamt = hinv.hamt + 1
	end
	mod_storage:set_string("whomes_"..name, minetest.serialize(homesdata))
	homes_chat(name, "Saved '"..hname.."' ("..ppos.x..", "..ppos.y..", "..ppos.z..") to your list of "..htype2.."s!")
	-- set scrollbar to latest created home
	if order >= 3 then
		local scroll = 4 + ((order - 3) * 20)
		if order == 3 then
			scroll = 4
		end
		hinv.scroll = scroll
	end
end

local function delete_home(player, hname, htype)
	local htype2 = htype or "home"
	local name = player:get_player_name()
	if not hname or hname == "" then
		homes_chat(name, "Please select a "..htype2.." to delete!")
		return
	end
	local homesdata = minetest.deserialize(mod_storage:get_string("whomes_"..name)) or {}
	if homesdata[hname] then
		local rm_order = homesdata[hname].order
		if rm_order ~= #homesdata then -- update the order of the rest of the homes
			for hname2, homelist in pairs(homesdata) do
				local ch_order = homelist.order
				if ch_order > rm_order then
					homesdata[hname2].order = ch_order - 1
				end
			end
		end
		local hinv = whomes_inventory[name] or init_homes(player)
		local wp_id = hinv.waypoints[hname]
		if wp_id then -- remove waypoint if it exists
			player:hud_remove(wp_id)
		end
		local htype3 = homesdata[hname].type
		homesdata[hname] = nil
		hinv.tamt = hinv.tamt - 1
		hinv.hamt = hinv.hamt - 1
		mod_storage:set_string("whomes_"..name, minetest.serialize(homesdata))
		homes_chat(name, "Removed '"..hname.."' from your list of "..htype3.."s!")
	else
		homes_chat(name, "Invalid home selected / '"..hname.."' does not exist!")
	end
end

local function tp_home(player, hname)
	local name = player:get_player_name()
	local hinv = whomes_inventory[name] or init_homes(player)
	if not hname or hname == "" then
		homes_chat(name, "Please select a home to warp to!")
		return
	end
	local homesdata = minetest.deserialize(mod_storage:get_string("whomes_"..name)) or {}
	if homesdata[hname] then
		local htype = homesdata[hname].type
		if htype == "home" then
			if hinv.teleporting then
				homes_chat(name, "You are already warping to another home!")
				return
			end
			local hpos = homesdata[hname]
			homes_chat(name, "Warping to '"..hname.."' home ("..hpos.x..", "..hpos.y..", "..hpos.z..")...")
			player:set_fov(410, false, 15)
			hinv.teleporting = true
			minetest.sound_play("winv_home_teleport", {
				gain = 0.5,
				to_player = name,
			})
			minetest.after(4, function()
				if minetest.is_player(player) then
					player:set_fov(0)
					player:set_pos(hpos)
					hinv.teleporting = nil
				end
			end)
		elseif htype ~= "home" then
			homes_chat(name, "'"..hname.."' is a "..htype..", you can only warp to homes!")
		end
	else
		homes_chat(name, "Invalid home selected / '"..hname.."' does not exist!")
	end
end

local function change_order(player, chhome, direction)
	local name = player:get_player_name()
	local homesdata = minetest.deserialize(mod_storage:get_string("whomes_"..name))
	local homelist = homesdata[chhome]
	local otable = create_ordered_table(homesdata)
	local horder = homelist.order
	local hinv = whomes_inventory[name] or init_homes(player)
	if otable[horder] == chhome then
		if direction == "up" then
			if (horder - 1) < 1 then
				homes_chat(name, chhome.." is already at the top!")
				return
			else
				local top_home = otable[horder - 1]
				homesdata[top_home].order = horder
				homesdata[chhome].order = horder - 1
				mod_storage:set_string("whomes_"..name, minetest.serialize(homesdata))
				winv.refresh(player)
			end
		elseif direction == "down" then
			if (horder + 1) > hinv.tamt then
				homes_chat(name, chhome.." is already at the bottom!")
				return
			else
				local bot_home = otable[horder + 1]
				homesdata[bot_home].order = horder
				homesdata[chhome].order = horder + 1
				mod_storage:set_string("whomes_"..name, minetest.serialize(homesdata))
				winv.refresh(player)
			end
		end
	else
		homes_chat(name, "Error changing home's ordering. Refreshing list...")
		winv.refresh(player)
		return
	end
end

local function hud_waypoint(player, hname)
	local name = player:get_player_name()
	local homesdata = minetest.deserialize(mod_storage:get_string("whomes_"..name))
	local hinv = whomes_inventory[name] or init_homes(player)
	local wp_id = hinv.waypoints[hname]
	local homelist = homesdata[hname]
	if not homelist then
		return
	end
	if wp_id then -- remove waypoint if it exists
		player:hud_remove(wp_id)
		hinv.waypoints[hname] = nil
		homesdata[hname].hud = nil
		mod_storage:set_string("whomes_"..name, minetest.serialize(homesdata))
	else -- add waypoint if it doesnt
		if not homesdata[hname].color then
			local color = math.random(0xFFFFFF)
			homesdata[hname].color = color
		end
		hinv.waypoints[hname] = player:hud_add({
			hud_elem_type = "waypoint",
			name = hname,
			text = "m",
			world_pos = {x=homelist.x,y=homelist.y,z=homelist.z},
			number = homesdata[hname].color,
			z_index = -300,
		})
		homesdata[hname].hud = true
		mod_storage:set_string("whomes_"..name, minetest.serialize(homesdata))
		winv.refresh(player)
	end
end


winv:register_inventory("home", {
	lists = {
		{"main", 6 * 6},
	},
	button = {
		texture = "winv_icon_home.png",
		tooltip = "Saved Homes",
	},
	hide_in_node = true,
	formspec_function = function(player)
		local name = player:get_player_name()
		local hinv = whomes_inventory[name] or init_homes(player)
		local homesdata = minetest.deserialize(mod_storage:get_string("whomes_"..name))
		local homes_form = ""
		-- homes list
		if homesdata then
			local otable = create_ordered_table(homesdata)
			for i, hname in ipairs(otable) do
				local homelist = homesdata[hname]
				local yshift = 2 * (i - 1)
				local icon_bg, icon_bg_pressed = "gui_bg_curved.png", "gui_bg_hover_curved.png"
				local colorize_arrows, activate_wp = "", ""
				local hname_label = hname
				if #hname > 15 then
					hname_label = string.sub(hname, 1, 13).."..."
				end
				if homelist.color then
					local hexcolor = string.format("%02x", homelist.color)
					while #hexcolor < 6 do
						hexcolor = "0" .. hexcolor
					end
					icon_bg = "gui_bg_curved.png^[colorize:#"..hexcolor..":90"
					icon_bg_pressed = "gui_bg_hover_curved.png^[colorize:#"..hexcolor..":90"
					colorize_arrows = "^[colorize:#"..hexcolor..":100"
				end
				if homelist.hud then
					activate_wp = "^[brighten"
				end
				local waypoint_buttons
				local coords = "("..ccore.round(homelist.x, 1)..", "..ccore.round(homelist.y, 1)..", "..ccore.round(homelist.z, 1)..")"
				if homelist.type == "waypoint" then
					waypoint_buttons =
						"image_button[6.175,"..(0.375 + yshift)..";0.7,0.7;gui_cross.png;winv_homes_del_"..hname..";]"
				else
					waypoint_buttons =
						"image_button[6.175,"..(0.375 + yshift)..";0.7,0.7;gui_pointer.png;winv_homes_tp_"..hname..";]"..
						"image_button[6.175,"..(1.175 + yshift)..";0.7,0.7;gui_cross.png;winv_homes_del_"..hname..";]"
				end
				homes_form = homes_form..
					"box[0.25,"..(0.25 + yshift)..";6.75,1.75;#94949470]"..
					"image_button[0.375,"..(0.375 + yshift)..";1.5,1.5;"..icon_bg..";winv_homes_icon_"..hname..";;;false;"..icon_bg_pressed.."]"..
					"item_image[0.545,"..(0.54 + yshift)..";1.2,1.2;"..whomes_icons[homelist.icon].."]"..
					"label[2.1,"..(1.0 + yshift)..";"..hname_label.."\n"..coords.."]"..
					"image_button[4.575,"..(0.375 + yshift)..";0.7,0.7;gui_paintbrush.png;winv_homes_color_"..hname..";]"..
					"image_button[5.375,"..(0.375 + yshift)..";0.7,0.7;gui_location.png"..activate_wp..";winv_homes_wp_"..hname..";]"..
					waypoint_buttons..
					"image_button[0.35,"..(0.4 + yshift)..";0.5,0.5;gui_pointer.png^[transformR90"..colorize_arrows..";winv_homes_up_"..hname..";;;false;]"..
					"image_button[0.35,"..(1.35 + yshift)..";0.5,0.5;gui_pointer.png^[transformR90FY"..colorize_arrows..";winv_homes_down_"..hname..";;;false;]"..
					"tooltip[2,"..(0.45 + yshift)..";2.5,1.3;"..hname.."\n"..coords.."]"
			end
		end
		local total_amt = hinv.tamt
		local scrollbar_max = 0
		if total_amt == 3 then
			scrollbar_max = 4
		elseif total_amt > 3 then
			scrollbar_max = 4 + ((total_amt - 3) * 20)
		end
		-- scrollbar length
		local scroll_form = ""
		if scrollbar_max ~= 0 then
			scroll_form =
				"scrollbaroptions[max="..scrollbar_max..";thumbsize=22]"..
				"scrollbar[7.85,0.65;0.3,5.9;vertical;winv_home_scroll;"..hinv.scroll.."]"
		end
		-- base formspec
		local formspec = {
			"image[0,0;7.75,7.75;winv_bg.png]",
			"box[0.25,0.65;7.25,5.9;#00000069]",
			"label[0.25,0.4;Your Homes & Waypoints]",
			scroll_form,
			"scroll_container[0.25,0.65;7.25,5.9;winv_home_scroll;vertical;0.1]",
				"style_type[box,image_button,image,label,item_image;noclip=false]",
				homes_form,
			"scroll_container_end[]",
			-- add
			"field[0.25,6.8;4.65,0.7;winv_home_name;;]",
			"image_button[5.15,6.8;1.05,0.7;winv_add_home.png;winv_home_add;;;true;winv_add_home.png]",
			"image_button[6.45,6.8;1.05,0.7;winv_add_waypoint.png;winv_home_add_wp;;;true;winv_add_waypoint.png]",
			"tooltip[winv_home_add;Add a home \nYour homes limit: "..hinv.hlimit.." homes\nPosition based on your current location \nFill field on the left with home name]",
			"tooltip[winv_home_add_wp;Add a waypoint \nPosition based on your current location \nFill field on the left with waypoint name]",
		}
		return table.concat(formspec, "")
	end,
	on_player_receive_fields = function(player, formname, fields)
		local name = player:get_player_name()
		local homesdata = minetest.deserialize(mod_storage:get_string("whomes_"..name))
		local hinv = whomes_inventory[name] or init_homes(player)
		if fields.winv_home_add then
			local hname = minetest.formspec_escape(fields.winv_home_name)
			if add_home(player, hname) ~= false then
				winv.refresh(player)
			end
		elseif fields.winv_home_add_wp then
			local hname = minetest.formspec_escape(fields.winv_home_name)
			if add_home(player, hname, "waypoint") ~= false then
				hud_waypoint(player, fields.winv_home_name)
				winv.refresh(player)
			end
		elseif fields.winv_home_scroll then
			local scroll = minetest.explode_scrollbar_event(fields.winv_home_scroll)
			hinv.scroll = scroll.value
		end
		if homesdata then
			for hname, homelist in pairs(homesdata) do
				if fields["winv_homes_color_"..hname] then
					local color = math.random(0xFFFFFF)
					homesdata[hname].color = color
					mod_storage:set_string("whomes_"..name, minetest.serialize(homesdata))
					winv.refresh(player)
					local wp_id = hinv.waypoints[hname]
					if wp_id then -- if waypoint exists, change its color
						player:hud_change(wp_id, "number", color)
					end
				elseif fields["winv_homes_wp_"..hname] then
					hud_waypoint(player, hname)
					winv.refresh(player)
				elseif fields["winv_homes_icon_"..hname] then
					local newicon = homesdata[hname].icon + 1
					if newicon > #whomes_icons then
						newicon = 1
					end
					homesdata[hname].icon = newicon
					mod_storage:set_string("whomes_"..name, minetest.serialize(homesdata))
					winv.refresh(player)
				elseif fields["winv_homes_tp_"..hname] then
					tp_home(player, hname)
					minetest.after(0.01, function() -- delay to counter node inventories re-applying form
						minetest.close_formspec(name, "")
					end)
				elseif fields["winv_homes_del_"..hname] then
					delete_home(player, hname)
					winv.refresh(player)
				elseif fields["winv_homes_up_"..hname] then
					change_order(player, hname, "up")
				elseif fields["winv_homes_down_"..hname] then
					change_order(player, hname, "down")
				end
			end
		end
	end,
})

minetest.register_chatcommand("homelimit", {
	params = "<playername> <new_limit_no.>",
    description = "Change player's home limits.",
    privs = {privs=true},
    func = function(name, param)
		local pname, nlimit = string.match(param, '(%S+) (.*)')
		if pname == "" or not pname or nlimit == "" or not nlimit then
			homes_chat(name, "Invalid parameters, use '/homelimit <playername> <new_limit_no.>'")
			return
		end
		local player = minetest.get_player_by_name(pname)
		if not player then
			if minetest.player_exists(pname) == false then
				homes_chat(name, "'"..pname.."' does not exist!")
				return
			end
		end
		if tonumber(nlimit) then
			local hinv = whomes_inventory[pname]
			if hinv or player then
				if not hinv then
					hinv = init_homes(player)
				end
				hinv.hlimit = tonumber(nlimit)
			end
			mod_storage:set_int("whomes_limit_"..pname, nlimit)
			winv.refresh(player)
			homes_chat(name, "Set '"..pname.."' home limits to "..nlimit..".")
			if pname ~= name then
				homes_chat(pname, "'"..name.."' has set your home limits to "..nlimit..".")
			end
		else
			homes_chat(name, "'"..nlimit.."' is invalid. Limit must be a number!")
		end
    end,
})

minetest.register_chatcommand("homeclear", {
	params = "<playername>",
    description = "Clear player's homes",
	privs = {ban=true},
    func = function(name, param)
		if not param then
			homes_chat(name, "Invalid parameters, use '/homeclear <playername>'")
		end
		local player = minetest.get_player_by_name(param)
		if not player then
			if minetest.player_exists(param) == false then
				homes_chat(name, "'"..param.."' does not exist!")
				return
			end
		end
		if player then
			local hinv = whomes_inventory[param] or init_homes(player)
			if hinv.waypoints then -- remove waypoints
				for i, wp_id in pairs(hinv.waypoints) do
					player:hud_remove(wp_id)
				end
			end
		end
		whomes_inventory[param] = nil
		mod_storage:set_string("whomes_"..param, "")
		winv.refresh(player)
		homes_chat(name, "'"..param.."' homes have been cleared!")
		if param ~= name then
			homes_chat(param, "'"..name.."' has cleared all your homes!")
		end
	end,
})

minetest.register_chatcommand("home", {
	params = "<home_name>",
	description = "Warp to your homes.",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		tp_home(player, param)
	end,
})

minetest.register_chatcommand("sethome", {
	params = "<home_name>",
	description = "Add / change a home based on your current location.",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		add_home(player, param)
		winv.refresh(player)
	end,
})

minetest.register_chatcommand("delhome", {
	params = "<home_name>",
	description = "Delete an existing home.",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		delete_home(player, param)
		winv.refresh(player)
	end,
})

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	local hinv = whomes_inventory[name]
	if hinv then
		hinv.waypoints = {} -- remove waypoints table when player leaves
		hinv.teleporting = nil -- reset teleporting status
	end
end)

-- resume waypoint huds
minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	local homesdata = minetest.deserialize(mod_storage:get_string("whomes_"..name))
	if not homesdata then
		return
	end
	for hname, homelist in pairs(homesdata) do
		if homelist.hud then
			hud_waypoint(player, hname)
		end
	end
end)