workbench.craftbench = {}
local winv_exists = minetest.global_exists("winv")
if not winv_exists then
    return
end

local craftguide_form_list = {}
local max_item_per_page = 36
local max_item_per_row = 6
local max_page = 0
local craftguide_list = {}
local craftguide_sorted_list = {}
local craftguide_data = {}

local function craftguide_init(player)
    local playername = player:get_player_name()
    craftguide_data[playername] = {
        item = "",
        item_recipe_curr = 1,
        item_recipe_max = 1,
        page = 1,
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

                    -- output item
                    local output_item = (workbench_crafts.output[value.ctype][input_data.id][value.output_index].items[1])
                    local output_itemname = output_item:get_name()
                    local output_itemstring = output_item:get_name().." "..output_item:get_count()
                    ret_form = ret_form..
                        "item_image_button[1.4375,7.625;1,1;"..output_itemstring..";workbench_craftguide_item_"..output_itemname..";]"..
                        -- output arrow (crafting type)
                        "image_button[0.25,7.625;1,1;gui_arrow.png^[transformFYR90;workbench_craftguide_ctype;]"..
                        "tooltip[workbench_craftguide_ctype;"..value.ctype.."]"
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
                ret_form = ret_form..
                    "item_image_button[1.4375,7.625;1,1;"..output_item..";workbench_craftguide_item_"..output_itemname..";]"..
                    -- output arrow (crafting type)
                    "image_button[0.25,7.625;1,1;gui_arrow.png^[transformFYR90;workbench_craftguide_ctype;]"..
                    "tooltip[workbench_craftguide_ctype;"..value.method.."]"
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
        ret_form =
            "item_image_button[0.25,-0.9;0.8,0.8;"..itemname..";workbench_craftguide_display_"..itemname..";]"..
            "style_type[label;font_size=20;font=bold]"..
            "label[1.2,-0.7;"..itemdesc.."]"..
            "style_type[label;font_size=13;font=normal]"..
            "label[1.2,-0.3;"..itemname.."]"
    end
    return ret_form
end

minetest.register_on_mods_loaded(function()
    print("caching craft guide items...")
    for itemname, def in pairs(minetest.registered_items) do
        if def.description and def.description ~= "" then --and def.groups.not_in_creative_inventory ~= 1 then
            if minetest.get_craft_recipe(itemname) and minetest.get_craft_recipe(itemname).items or workbench_crafts.output_by_name[itemname] then
                craftguide_list[itemname] = def
            end
        end
    end

    for key, def in pairs(craftguide_list) do
        craftguide_sorted_list[#craftguide_sorted_list+1] = key
    end
    table.sort(craftguide_sorted_list)

    local count = 0
    for key, itemname in ipairs(craftguide_sorted_list) do
        count = count + 1

        local curr_page = math.ceil(count / max_item_per_page)
        if not craftguide_form_list[curr_page] then
            craftguide_form_list[curr_page] = ""
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
        craftguide_form_list[curr_page] = craftguide_form_list[curr_page]..
            "item_image_button["..( 0.25 + ((item_count_in_row - 1) * 1.25))..","..( 0.25 + ((curr_row - 1) * 1.25))..
                ";1,1;"..itemname..";workbench_craftguide_item_"..itemname..";]"
    end

    max_page = math.ceil(count / max_item_per_page)
    print("craft guide items cached!")
end)

local function craftguide_form(player)
    local playername = player:get_player_name()
    if not craftguide_data[playername] then
        craftguide_init(player)
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
			"field[0.25,7.75;5.25,1;winv_creative_filter;;search]"..
			"field_close_on_enter[winv_creative_filter;false]"..
			"image_button[5.75,7.75;0.5,0.5;gui_pointer.png;winv_creative_search;]"..
			"image_button[5.75,8.25;0.5,0.5;gui_cross.png;winv_creative_clear;]"..

            -- icons
            "image_button[-0.9,0.25;0.8,0.8;winv_cicon_all.png;winv_creative_all;;true;false;]"..
			"tooltip[winv_creative_all;Show all]"..

			"image_button[-0.9,1.15;0.8,0.8;winv_cicon_block.png;winv_creative_block;;true;false;]"..
			"tooltip[winv_creative_block;Show blocks only]"..

			"image_button[-0.9,2.05;0.8,0.8;winv_cicon_tool.png;winv_creative_tool;;true;false;]"..
			"tooltip[winv_creative_tool;Show tools only]"..

			"image_button[-0.9,2.95;0.8,0.8;winv_cicon_craftitem.png;winv_creative_craftitem;;true;false;]"..
			"tooltip[winv_creative_craftitem;Show craft items only]"..

			"image_button[-0.9,3.85;0.8,0.8;winv_cicon_filter.png;winv_creative_modfilter;;true;false;]"..
			"tooltip[winv_creative_modfilter;Filter by mods]"..

            "style_type[item_image_button;border=false]"..
            craftguide_form_list[craftguide_data[playername].page]..

            -- arrows
			"image_button[6.5,7.83;0.5,0.8;winv_cicon_miniarrow.png^[transformFX;workbench_craftguide_prev;;;false;]"..
			"image_button[7,7.85;0.5,0.8;winv_cicon_miniarrow.png;workbench_craftguide_next;;;false;]"..
            "label[0.25,9.25;Page " .. minetest.colorize("#FFFF00", tostring(craftguide_data[playername].page)) .. " / " .. tostring(max_page) .. "]"..

			--"list[current_player;main;0.25,0.25;6,6;]"..
        "container_end[]"..
        "container[10,0]"..
            --right_form..

            "image[0,0;7.75,9;winv_bg.png]"..
			-- CRAFT FORM
            "style[workbench_current_item;border=false]"..
            craftguide_display_form(player)..
            "box[0.25,0.25;7.275,7.055;#00000070]"..
            craftguide_recipe_form(player)..

            --"box[1.375,7.5;6.125,1.25;#00000070]"..
            -- "box[2.75,7.75;1,1;#00000070]"..
            -- "box[4.00,7.75;1,1;#00000070]"..
            -- "box[5.25,7.75;1,1;#00000070]"..
            -- "box[6.50,7.75;1,1;#00000070]"..

            -- "item_image_button[1.4375,7.625;1,1;blocks:dirt 1;workbench_current_item;]"..
            -- "item_image_button[2.6875,7.625;1,1;blocks:dirt 2;workbench_current_item;]"..
            -- "item_image_button[3.9375,7.625;1,1;blocks:dirt 3;workbench_current_item;]"..
            -- "item_image_button[5.1875,7.625;1,1;blocks:dirt 4;workbench_current_item;]"..

            -- arrows
			"image_button[6.5,7.83;0.5,0.8;winv_cicon_miniarrow.png^[transformFX;workbench_craftguide_recipe_prev;;;false;]"..
			"image_button[7,7.85;0.5,0.8;winv_cicon_miniarrow.png;workbench_craftguide_recipe_next;;;false;]"..

            --"list[current_player;main;1.5,7.75;5,1;]"..
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
    if fields.workbench_craftguide_prev then -- previous page
        if craftguide_data[playername].page <= 1 then
            craftguide_data[playername].page = max_page
        else
            craftguide_data[playername].page = craftguide_data[playername].page - 1
        end
    elseif fields.workbench_craftguide_next then -- next page
        if craftguide_data[playername].page >= max_page then
            craftguide_data[playername].page = 1
        else
            craftguide_data[playername].page = craftguide_data[playername].page + 1
        end
    end

    if craftguide_data[playername].item and craftguide_data[playername].item ~= "" then
        if craftguide_data[playername].item_recipe_max > 1 then
            if fields.workbench_craftguide_recipe_prev then -- previous recipe
                if craftguide_data[playername].item_recipe_curr <= 1 then
                    craftguide_data[playername].item_recipe_curr = craftguide_data[playername].item_recipe_max
                else
                    craftguide_data[playername].item_recipe_curr = craftguide_data[playername].item_recipe_curr - 1
                end
            elseif fields.workbench_craftguide_recipe_next then -- next recipe
                if craftguide_data[playername].item_recipe_curr >= craftguide_data[playername].item_recipe_max then
                    craftguide_data[playername].item_recipe_curr = 1
                else
                    craftguide_data[playername].item_recipe_curr = craftguide_data[playername].item_recipe_curr + 1
                end
            end
        end
    end

    for key, itemname in ipairs(craftguide_sorted_list) do
        if (fields["workbench_craftguide_item_"..itemname]) then
            craftguide_data[playername].item = itemname
            craftguide_data[playername].item_recipe_curr = 1
        end
    end

    if not fields.quit then -- refresh and updates formspec (as long as form is not quitting)
        minetest.show_formspec(playername, "workbench:craftguide", craftguide_form(player))
    end
end)