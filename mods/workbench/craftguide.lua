workbench.craftbench = {}
local winv_exists = minetest.global_exists("winv")
if not winv_exists then
    return
end

--local craftguide_form_list = {}
local max_item_per_page = 36
local max_item_per_row = 6
local craftguide_list = {}
local craftguide_names_list = {}
local craftguide_data = {}

local function craftguide_init(player)
    local playername = player:get_player_name()
    craftguide_data[playername] = {
        item = "",
        item_recipe_curr = 1,
        item_recipe_max = 1,
        form_list = nil,

        curr_page = 1,
        max_page = 1,

        filter = "",
        old_filter = nil,

        content = minetest.registered_items,
        content_name = "all",
        old_content = nil,

        mod_filter = {},
		show_mod_filter = nil,
		old_mod_filter = {},
		mod_filter_scroll = 0,
    }
end

local function craftguide_recipe_form(player)
    local playername = player:get_player_name()
    if not craftguide_data[playername] or craftguide_data[playername].item == "" then
        return ""
    end

    local ret_form = ""
    local item = craftguide_data[playername].item
    local output_data = workbench_crafts.output_by_name[item]
    local recipe_count = 0
    if output_data then -- workbench crafting
        for index, value in pairs(output_data) do
            local input_data = workbench_crafts.input[value.ctype][value.input_index]
            if input_data then
                recipe_count = recipe_count + 1

                if recipe_count == craftguide_data[playername].item_recipe_curr then
                    --local input_size = input_data.width * input_data.height
                    for i = 1, input_data.height do
                        for j = 1, input_data.width do
                            local recipe_item = input_data.input[i][j]
                            local recipe_itemname = ItemStack(recipe_item):get_name()
                            ret_form = ret_form..
                                "item_image_button["..( 0.875 + ((j - 1) * 1.25) )..","..( 0.75 + ((i - 1) * 1.25) )..
                                    ";1,1;"..recipe_item..";workbench_craftguide_item_"..recipe_itemname..";]"
                        end
                    end

                    -- output item(s)
                    local output_items = (workbench_crafts.output[value.ctype][input_data.id][value.output_index].items)
                    for index2, output_item in pairs(output_items) do
                        local output_itemname = output_item:get_name()
                        local output_itemstring = output_item:get_name().." "..output_item:get_count()
                        ret_form = ret_form..
                            "item_image_button["..1.4375 + ((index2 - 1) * 1.25)..",7.625;1,1;"..output_itemstring..";workbench_craftguide_item_"..output_itemname..";]"
                    end

                    -- output arrow (crafting type)
                    local crafting_arrow = "gui_arrow.png^[transformFYR90"
                    if workbench_crafts.data[value.ctype].icon then
                        crafting_arrow = workbench_crafts.data[value.ctype].icon
                    end

                    local crafting_desc = value.ctype
                    if workbench_crafts.data[value.ctype].description then
                        crafting_desc = workbench_crafts.data[value.ctype].description
                    end

                    ret_form = ret_form..
                        "style[workbench_craftguide_ctype;border=false]"..
                        "image_button[0.25,7.625;1,1;"..crafting_arrow..";workbench_craftguide_ctype;]"..
                        "tooltip[workbench_craftguide_ctype;"..crafting_desc.."]"
                end
            end
        end
    end

    local mt_output_data = minetest.get_all_craft_recipes(item)
    if mt_output_data then -- mt crafting api
        for index, value in pairs(mt_output_data) do
            recipe_count = recipe_count + 1
            if recipe_count == craftguide_data[playername].item_recipe_curr then
                for i = 1, 3 do -- height
                    for j = 1, 3 do -- width
                        local recipe_index = ((i - 1) * 3) + j
                        local recipe_item = value.items[recipe_index]
                        local recipe_itemname = ItemStack(recipe_item):get_name()
                        if recipe_itemname and recipe_itemname ~= "" then
                            ret_form = ret_form..
                                "item_image_button["..( 0.875 + ((j - 1) * 1.25) )..","..( 0.75 + ((i - 1) * 1.25) )..
                                    ";1,1;"..recipe_item..";workbench_craftguide_item_"..recipe_itemname..";]"
                        end
                    end
                end

                -- output item
                local output_item = value.output
                local output_itemname = ItemStack(output_item):get_name()

                local crafting_arrow = "gui_arrow.png^[transformFYR90"
                if value.method == "normal" then
                    crafting_arrow = workbench_crafts.data["normal"].icon
                elseif value.method == "cooking" then
                    crafting_arrow = workbench_crafts.data["cooking"].icon
                end

                local crafting_desc = value.method
                if value.method == "normal" then
                    crafting_desc = workbench_crafts.data["normal"].description
                elseif value.method == "cooking" then
                    crafting_desc = workbench_crafts.data["cooking"].description
                end

                ret_form = ret_form..
                    "item_image_button[1.4375,7.625;1,1;"..output_item..";workbench_craftguide_item_"..output_itemname..";]"..
                    "style[workbench_craftguide_ctype;border=false]"..
                    "image_button[0.25,7.625;1,1;"..crafting_arrow..";workbench_craftguide_ctype;]"..
                    "tooltip[workbench_craftguide_ctype;"..crafting_desc.."]"
            end
        end
    end
    craftguide_data[playername].item_recipe_max = recipe_count
    ret_form = ret_form..
            "label[0.25,9.25;Recipe " .. minetest.colorize("#FFFF00", tostring(craftguide_data[playername].item_recipe_curr)) .. " / " .. tostring(recipe_count) .. "]"
    return ret_form
end

local function craftguide_display_form(player)
    local playername = player:get_player_name()
    if not craftguide_data[playername] or craftguide_data[playername].item == "" then
        return ""
    end

    local ret_form = ""
    if craftguide_data[playername].item and craftguide_data[playername].item ~= "" then
        local itemname = craftguide_data[playername].item
        local itemdesc = minetest.registered_items[itemname].short_description or minetest.registered_items[itemname].description
        itemdesc = itemdesc:gsub("\n.*", "") -- First line only
        ret_form =
            "item_image_button[0.25,-0.9;0.8,0.8;"..itemname..";workbench_craftguide_display_"..itemname..";]"..
            "style_type[label;font_size=20;font=bold]"..
            "label[1.2,-0.7;"..itemdesc.."]"..
            "style_type[label;font_size=13;font=normal]"..
            "label[1.2,-0.3;"..itemname.."]"
    end
    return ret_form
end

local function mod_match(s, mod_filter)
	if not mod_filter or not next(mod_filter) then
		return true
	end
	for i, modname in pairs(mod_filter) do
		if s:lower():find(modname..":", 1, true) then
			return nil
		end
	end
	return true
end

local NO_MATCH = 999
local function match(s, filter)
	if filter == "" then
		return 0
	end
	if s:lower():find(filter, 1, true) then
		return #s - #filter
	end
	return NO_MATCH
end

local function description(def, lang_code)
	local s = def.description
	if lang_code then
		s = minetest.get_translated_string(lang_code, s)
	end
	return s:gsub("\n.*", "") -- First line only
end

local function construct_itemlist_form(player)
    print("constructing item list!")
    local playername = player:get_player_name()
    if craftguide_data[playername].form_list then
        return
    else
        craftguide_data[playername].form_list = {}
    end

    local lang
	local player_info = minetest.get_player_information(playername)
	if player_info and player_info.lang_code ~= "" then
		lang = player_info.lang_code
	end

    local filter = craftguide_data[playername].filter
    local filtered_list = {}
	local order = {}
    -- created a sorted list according to filter
    for itemname, def in pairs(craftguide_list) do
        local mf = mod_match(name, craftguide_data[playername].mod_filter)
		if mf then
            local m = match(description(def), filter)
            if m > 0 then
                m = math.min(m, match(description(def, lang), filter))
            end
            if m > 0 then
                m = math.min(m, match(itemname, filter))
            end

            if m < NO_MATCH then
                filtered_list[#filtered_list+1] = itemname
                -- Sort by match value first so closer matches appear earlier
                order[itemname] = string.format("%02d", m) .. itemname
            end
        end
    end

    table.sort(filtered_list, function(a, b) return order[a] < order[b] end)

    local count = 0
    for index, itemname in ipairs(filtered_list) do
        --if match(itemname, craftguide_data[playername].filter) then
            count = count + 1
            local curr_page = math.ceil(count / max_item_per_page)
            if not craftguide_data[playername].form_list[curr_page] then
                craftguide_data[playername].form_list[curr_page] = ""
            end
            -- item counters
            local item_count_in_page = count % max_item_per_page
            if item_count_in_page == 0 then
                item_count_in_page = max_item_per_page
            end
            local curr_row = math.ceil(item_count_in_page / max_item_per_row)

            local item_count_in_row = count % max_item_per_row
            if item_count_in_row == 0 then
                item_count_in_row = max_item_per_row
            end

            -- construct form
            craftguide_data[playername].form_list[curr_page] = craftguide_data[playername].form_list[curr_page]..
                "item_image_button["..( 0.25 + ((item_count_in_row - 1) * 1.25))..","..( 0.25 + ((curr_row - 1) * 1.25))..
                    ";1,1;"..itemname..";workbench_craftguide_item_"..itemname..";]"
        --end
    end

    if not craftguide_data[playername].form_list[1] then -- ensure first page is always constructed -- TODO -- change to "Nothing found" message
        craftguide_data[playername].form_list[1] = ""
    end
    craftguide_data[playername].max_page = math.ceil(count / max_item_per_page)
end

-- cache all craft items
local start_time
minetest.register_on_mods_loaded(function()
    start_time = os.clock()
    print("[workbench] caching craftguide items...")
    for itemname, def in pairs(minetest.registered_items) do
        if def.description and def.description ~= "" then --and def.groups.not_in_creative_inventory ~= 1 then
            if minetest.get_craft_recipe(itemname) and minetest.get_craft_recipe(itemname).items or workbench_crafts.output_by_name[itemname] then
                craftguide_list[itemname] = def
            end
        end
    end

    for key, def in pairs(craftguide_list) do
        craftguide_names_list[#craftguide_names_list+1] = key
    end
    table.sort(craftguide_names_list)
    print("[workbench] craftguide items cached! took "..os.clock() - start_time.."s")
end)

-- craftguide formspec
local function craftguide_form(player)
    local playername = player:get_player_name()
    if not craftguide_data[playername] then -- ensure data initalized
        craftguide_init(player)
    end

    if not craftguide_data[playername].form_list then -- reconstruct item list
        construct_itemlist_form(player)
    end

    local form =
        "formspec_version[4]"..
        "size[17.75, 9]"..
        "style_type[*;noclip=true;font_size=13]"..
        "bgcolor[#00000000;neither]"..
        "container[0,0]"..
            --left_form..
            --1.25 per grid
            "image[0,0;7.75,9;winv_bg.png]"..
            -- LIST
            -- search icons
			"field[0.25,7.75;5.25,1;workbench_craftguide_filter;;"..craftguide_data[playername].filter.."]"..
			"field_close_on_enter[workbench_craftguide_filter;false]"..
			"image_button[5.75,7.75;0.5,0.5;gui_pointer.png;workbench_craftguide_search;]"..
			"image_button[5.75,8.25;0.5,0.5;gui_cross.png;workbench_craftguide_clear;]"..

            -- icons
            "image_button[-0.9,0.25;0.8,0.8;winv_cicon_all.png;workbench_craftguide_filter_all;;true;false;]"..
			"tooltip[workbench_craftguide_filter_all;Show all]"..

			"image_button[-0.9,1.15;0.8,0.8;winv_cicon_block.png;workbench_craftguide_filter_block;;true;false;]"..
			"tooltip[workbench_craftguide_filter_block;Show blocks only]"..

			"image_button[-0.9,2.05;0.8,0.8;winv_cicon_tool.png;workbench_craftguide_filter_tool;;true;false;]"..
			"tooltip[workbench_craftguide_filter_tool;Show tools only]"..

			"image_button[-0.9,2.95;0.8,0.8;winv_cicon_craftitem.png;workbench_craftguide_filter_craftitem;;true;false;]"..
			"tooltip[workbench_craftguide_filter_craftitem;Show craft items only]"..

			"image_button[-0.9,3.85;0.8,0.8;winv_cicon_filter.png;workbench_craftguide_filter_mod;;true;false;]"..
			"tooltip[workbench_craftguide_filter_mod;Filter by mods]"..

            "style_type[item_image_button;border=false]"..
            craftguide_data[playername].form_list[craftguide_data[playername].curr_page]..

            -- arrows
			"image_button[6.5,7.83;0.5,0.8;winv_cicon_miniarrow.png^[transformFX;workbench_craftguide_prev;;;false;]"..
			"image_button[7,7.85;0.5,0.8;winv_cicon_miniarrow.png;workbench_craftguide_next;;;false;]"..
            "label[0.25,9.25;Page " .. minetest.colorize("#FFFF00", tostring(craftguide_data[playername].curr_page)) .. " / " .. tostring(craftguide_data[playername].max_page) .. "]"..
        "container_end[]"..
        "container[10,0]"..
            --right_form..

            "image[0,0;7.75,9;winv_bg.png]"..
			-- CRAFT FORM
            "style[workbench_current_item;border=false]"..
            craftguide_display_form(player)..
            "box[0.25,0.25;7.275,7.055;#00000070]"..
            craftguide_recipe_form(player)..

            -- arrows
			"image_button[6.5,7.83;0.5,0.8;winv_cicon_miniarrow.png^[transformFX;workbench_craftguide_recipe_prev;;;false;]"..
			"image_button[7,7.85;0.5,0.8;winv_cicon_miniarrow.png;workbench_craftguide_recipe_next;;;false;]"..
        "container_end[]"

    return form
end

winv:register_inventory("craftguide", {
    button = {
        texture = "winv_icon_craftguide.png",
        tooltip = "Craft Guide",
    },
    hide_in_node = true,
    button_function = function(player)
        local playername = player:get_player_name()
        minetest.show_formspec(playername, "workbench:craftguide", craftguide_form(player))
    end,
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "workbench:craftguide" then
        return
    end

    local playername = player:get_player_name()
    local cgdata = craftguide_data[playername]

    -- search filter
    if fields.workbench_craftguide_search or fields.key_enter_field == "workbench_craftguide_filter" or fields.workbench_craftguide_clear then
        cgdata.old_filter = cgdata.filter
        if fields.workbench_craftguide_clear then
            cgdata.filter = ""
        else
            cgdata.filter = fields.workbench_craftguide_filter:lower()
        end

        if cgdata.filter ~= cgdata.old_filter then -- prevent unnecessary reconstruction
            -- reset filter and list
            cgdata.curr_page = 1
            cgdata.max_page = 1
            cgdata.form_list = nil
        end
    end

    -- change pages
    if fields.workbench_craftguide_prev then -- previous page
        if cgdata.curr_page <= 1 then
            cgdata.curr_page = cgdata.max_page
        else
            cgdata.curr_page = cgdata.curr_page - 1
        end
    elseif fields.workbench_craftguide_next then -- next page
        if cgdata.curr_page >= cgdata.max_page then
            cgdata.curr_page = 1
        else
            cgdata.curr_page = cgdata.curr_page + 1
        end
    end

    -- change recipes
    if cgdata.item and cgdata.item ~= "" then
        if cgdata.item_recipe_max > 1 then
            if fields.workbench_craftguide_recipe_prev then -- previous recipe
                if cgdata.item_recipe_curr <= 1 then
                    cgdata.item_recipe_curr = cgdata.item_recipe_max
                else
                    cgdata.item_recipe_curr = cgdata.item_recipe_curr - 1
                end
            elseif fields.workbench_craftguide_recipe_next then -- next recipe
                if cgdata.item_recipe_curr >= cgdata.item_recipe_max then
                    cgdata.item_recipe_curr = 1
                else
                    cgdata.item_recipe_curr = cgdata.item_recipe_curr + 1
                end
            end
        end
    end

    for index, itemname in ipairs(craftguide_names_list) do
        if (fields["workbench_craftguide_item_"..itemname]) then
            cgdata.item = itemname
            cgdata.item_recipe_curr = 1 -- reset page
        end
    end

    if not fields.quit then -- refresh and updates formspec (if not quitting)
        minetest.show_formspec(playername, "workbench:craftguide", craftguide_form(player))
    end
end)