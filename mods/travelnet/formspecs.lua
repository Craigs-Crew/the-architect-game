function travelnet.formspec(pos, player)
	local spos = pos.x..","..pos.y..","..pos.z
	local meta = minetest.get_meta(pos)
	local winv_listring = ""
    local playername = player:get_player_name()
    local right_inv = winv.get_inventory(player, "right")
    local tab_switches = ""
    local selected_tab = meta:get_string("selected_tab")
    local station_netid = meta:get_int("station_netid")
    local station_id = meta:get_int("station_id")

    if playername == meta:get_string("owner") then
        tab_switches = table.concat({
            "style[" .. selected_tab .. ";bgcolor=#AAAAAA]",
            "image_button[6.5,0.25;1.0,1.0;blocks_book.png^[hsl:0:-100:0;travel;]",
            "tooltip[info;Travel]",
            "image_button[6.5,1.5;1.0,1.0;gui_cube.png;settings;]",
            "tooltip[edit;Edit Station]"
        }, "")
    else
        selected_tab = "travel"
    end
    local settings_tab = ""
    if selected_tab == "settings" then
        local available_networks = travelnet.get_available_network_ids(playername)
        local selected_network_dropid
        for i=1,#available_networks do
            if tonumber(available_networks[i]) == station_netid then
                selected_network_dropid = i
            end
        end
        settings_tab = table.concat({
            "dropdown[0.25,0.25;5.0,0.5;selected_network;" .. table.concat(travelnet.get_available_network_names(playername), ",") .. ";" .. selected_network_dropid .. ";true]",
        }, "")
    end
    local travel_tab = ""
    if selected_tab == "travel" then
        local available_stations = travelnet.get_network_stations(station_netid)
        local station_buttons = {}
        local posy = 0.25
        for i=1,#available_stations do
            local station_name = travelnet.get_station_name(available_stations[i], station_netid)
            if tonumber(available_stations[i]) ==  station_id then
                table.insert_all(station_buttons, {"label[0.25," .. posy .. ";" .. station_name .. "]"})
            else
                table.insert_all(station_buttons, {"button[0.25," .. posy .. ";5.0,0.5;" .. available_stations[i] .. ";" .. station_name .. "]"})
            end
                posy = posy + 0.5
        end

        station_buttons = table.concat(station_buttons, "")

        travel_tab = table.concat({
            "style_type[scroll_container;noclip=false]",
            "scroll_container[0.25,0.25;2.25,2.0;stations_scrollbar;vertical;]",
            station_buttons,
            "scroll_container_end[]",
            "scrollbaroptions[max=" .. 10 - #available_stations .. "]",
            "scrollbar[6.0,0.25;0.25,7.0;vertical;stations_scrollbar;]",
        }, "")
    end
    if right_inv == "player" then
        winv_listring =
            "listring[current_player;main]"..
            "listring[nodemeta:"..spos..";input]"..
            "listring[current_player;main]"..
            "listring[nodemeta:"..spos..";output]"
    elseif right_inv == "crafting" then
        winv_listring =
            "listring[nodemeta:"..spos..";input]"..
            "listring[detached:winv_craft_"..playername..";input]"..
            "listring[nodemeta:"..spos..";input]"..
            "listring[nodemeta:"..spos..";output]"..
            "listring[detached:winv_craft_"..playername..";input]"..
            "listring[detached:winv_craft_"..playername..";output]"
    elseif right_inv == "craftguide" then
        winv_listring =
            "listring[detached:winv_creative_"..playername..";main]"..
            "listring[nodemeta:"..spos..";input]"..
            "listring[detached:trash;main]"..
            "listring[nodemeta:"..spos..";output]"..
            "listring[detached:trash;main]"
    end
    local tab = ""
    if selected_tab == "travel" then
        tab = travel_tab
    elseif selected_tab == "settings" then
        tab = settings_tab
    end
	local winv_formspec = {
        "label[0,0;base formspec]",
		"image[0,0;7.75,10.25;winv_bg.png]",
        tab_switches,
        tab,
		winv_listring,
		"style_type[image;noclip=true]",
		"image[-1.4,8.8;1.4,1.4;gui_tab.png]",
		"image_button[-1.1,8.95;1.05,1.05;"..locks.icons(pos, "travelnet", {"lock", "protect", "public"}).."]"
	}
	return winv.init_inventory(player, table.concat(winv_formspec, ""))
end

function travelnet.create_station_formspec(pos, player)
	local spos = pos.x..","..pos.y..","..pos.z
	local meta = minetest.get_meta(pos)
	local winv_listring = ""
    local playername = player:get_player_name()
    local right_inv = winv.get_inventory(player, "right")
    local selected_netid = meta:get_int("station_netid")
    local attached_network = meta:get_int("attached_network")

    local netinfo = ""
    if attached_network == 1 then
        netinfo = "label[0.25,7.5;Selected Network: " .. travelnet.get_network_name(selected_netid) .. "]"
    end

    local station_data = table.concat({
        "field[0.25,2.5;7.0,0.5;station_name;Station name:;New Station]",
    },"")
    local network_dropdown = ""
    local create_network = "field[0.25,1.5;5.0,0.5;create_network;Create Network and Attach:;New Network]" ..
    "field_close_on_enter[create_network;false]"

    local available_networks = travelnet.get_available_network_ids(playername)

    if available_networks[1] ~= nil then
        local selected_network_dropid = 1
        for i=1,#available_networks do
            if tonumber(available_networks[i]) == selected_netid then
                selected_network_dropid = i
            end
        end
        local available_network_names = travelnet.get_available_network_names(playername)
        local network_names
        if #available_network_names > 1 then
            network_names = table.concat(available_network_names, ",")
        else
            network_names = available_network_names[1]
        end
        network_dropdown = table.concat({
            "label[0.25,0.25;Attach to an Existing Network:]",
            "dropdown[0.25,0.5;5.0,0.5;selected_network;" .. network_names .. ";" .. selected_network_dropid .. ";true]",
        }, "")
    end

    if right_inv == "player" then
        winv_listring =
            "listring[current_player;main]"..
            "listring[nodemeta:"..spos..";input]"..
            "listring[current_player;main]"..
            "listring[nodemeta:"..spos..";output]"
    elseif right_inv == "crafting" then
        winv_listring =
            "listring[nodemeta:"..spos..";input]"..
            "listring[detached:winv_craft_"..playername..";input]"..
            "listring[nodemeta:"..spos..";input]"..
            "listring[nodemeta:"..spos..";output]"..
            "listring[detached:winv_craft_"..playername..";input]"..
            "listring[detached:winv_craft_"..playername..";output]"
    elseif right_inv == "craftguide" then
        winv_listring =
            "listring[detached:winv_creative_"..playername..";main]"..
            "listring[nodemeta:"..spos..";input]"..
            "listring[detached:trash;main]"..
            "listring[nodemeta:"..spos..";output]"..
            "listring[detached:trash;main]"
    end
	local winv_formspec = {
        "label[0,0;create station formspec]",
		"image[0,0;7.75,10.25;winv_bg.png]",
        station_data,
        netinfo,
        network_dropdown,
        create_network,
		winv_listring,
		"style_type[image;noclip=true]",
		"image[-1.4,8.8;1.4,1.4;gui_tab.png]",
		"image_button[-1.1,8.95;1.05,1.05;"..locks.icons(pos, "travelnet", {"lock", "protect", "public"}).."]"
	}
	return winv.init_inventory(player, table.concat(winv_formspec, ""))
end

function travelnet.show_formspec(pos, player)
	local playername = player:get_player_name()
	minetest.show_formspec(playername, "travelnet:travelnet", travelnet.formspec(pos, player))
end

function travelnet.show_create_station_formspec(pos, player)
	local playername = player:get_player_name()
	minetest.show_formspec(playername, "travelnet:create_station", travelnet.create_station_formspec(pos, player))
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "travelnet:travelnet" or not player then
		return
	end
	local playername = player:get_player_name()
	local pos = travelnet.pos[playername]
	local meta = minetest.get_meta(pos)
    local netid = meta:get_int("station_netid")

	if not locks.can_access(pos, player) then
		return 0
	end

    local available_stations = travelnet.get_network_stations(netid)

    for i=1,#available_stations do
        local statid = available_stations[i]
        if fields[statid] then
            local target_pos = travelnet.get_station_pos(statid, netid)
            player:set_pos(target_pos)
            minetest.close_formspec(playername, formname)
        end
    end

    if fields.settings then
        meta:set_string("selected_tab", "settings")
        travelnet.show_formspec(pos, player)
    end

    if fields.travel then
        meta:set_string("selected_tab", "travel")
        travelnet.show_formspec(pos, player)
    end

	if locks.fields(pos, player, fields, "travelnet", "TravelNet") then
		travelnet.show_formspec(pos, player)
	end

	if not fields.quit then
		winv.node_receive_fields(player, formname, fields)
		if winv.node_refresh(player) then
			travelnet.show_formspec(pos, player)
		end
	end
end)

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "travelnet:create_station" or not player then
		return
	end
	local playername = player:get_player_name()
	local pos = travelnet.pos[playername]
	local meta = minetest.get_meta(pos)
    local attached_network = meta:get_int("attached_network")

	if not locks.can_access(pos, player) then
		return 0
	end

	if locks.fields(pos, player, fields, "travelnet", "TravelNet") then
		travelnet.show_create_station_formspec(pos, player)
	end

    if fields.key_enter_field == "create_network" then
        if fields.create_network ~= "" then
            local netid = travelnet.register_network(fields.create_network, playername)
            if netid then
                meta:set_int("station_netid", netid)
                meta:set_int("attached_network", 1)
                travelnet.show_create_station_formspec(pos, player)
            else
                minetest.chat_send_player(playername, "You've already created a network with that name")
                travelnet.show_create_station_formspec(pos, player)
            end
        end
    else
        local netids = travelnet.get_available_network_ids(playername)
        if #netids > 0 then
            for netid=1,#netids do
                if tonumber(fields.selected_network) == netid then
                    meta:set_int("station_netid", netids[netid])
                    meta:set_int("attached_network", 1)
                    travelnet.show_create_station_formspec(pos, player)
                end
            end
        end
    end

    if fields.key_enter_field == "station_name" then
        if attached_network == 1 then
            local netid = meta:get_int("station_netid")
            local statid = travelnet.register_station(pos, fields.station_name, playername, netid)
            if statid then
                meta:set_int("station_id", statid)
                meta:set_int("created_station", 1)
                travelnet.update_infotext(pos)
                travelnet.show_formspec(pos, player)
            else
                local network_name = travelnet.get_network_name(netid)
                minetest.chat_send_player(playername, "A station with named " .. fields.station_name .. " has already been created on network " .. network_name .. " by you.")
                travelnet.show_create_station_formspec(pos, player)
            end
        else
            minetest.chat_send_player(playername, "A station needs to be attached to a network first.")
        end
    end

	if not fields.quit then
		winv.node_receive_fields(player, formname, fields)
		if winv.node_refresh(player) then
			travelnet.show_create_station_formspec(pos, player)
		end
	end
end)