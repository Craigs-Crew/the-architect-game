workbench_crafts = {}
workbench_crafts.input = {}
workbench_crafts.output = {}

-- new craft type
function workbench:register_crafttype(name)
	workbench_crafts.input[name] = {}
	workbench_crafts.output[name] = {}
end

-- get input size
local function get_recipe_stacks(input, width, height)
	-- recipe items amount
	local scount = 0
	for i = 1, height do
		for j = 1, width do
			if input[i][j] ~= "" then
				scount = scount + 1
			end
		end
	end
	return scount
end

local function cache_recipe(input, width, height)
	local rdata = {}
	-- cache all names and counts
	for i = 1, height do
		for j = 1, width do
			local ni = #rdata + 1
			local ritem = ItemStack(input[i][j])
			rdata[ni] = {}
			rdata[ni].stack = ritem -- recipe item stack
			rdata[ni].name = ritem:get_name() -- recipe item name
			rdata[ni].count = ritem:get_count() -- recipe item count
		end
	end
	return rdata -- table of a single recipe consisting of all above data
end

local function send_error(ctype, ercat, input, output, errordesc)
	minetest.log("error", "[workbench] Error registering recipe - "..errordesc..
		": type: "..ctype..", category: "..ercat..", input: "..dump(input)..", output: "..dump(output))
end

if minetest.settings:get_bool("workbench_disable_crafts") then
	minetest.log("warning", "[workbench] All workbench crafts are disabled!")
end

function workbench:register_craft(def)
	if minetest.settings:get_bool("workbench_disable_crafts") then
		return
	end
	def = def or {}
	local ctype = def.type or "normal" -- recipe type
	local ercat = def.category or ""
	local ctime = def.time or 0
	-- ensure essential values are present
	if not def.output or not def.input or not ctype then
		return send_error(ctype, ercat, def.input, def.output, "Incorrect recipe format")
	end
	-- ensure valid format
	if type(def.output[1]) ~= "table" or type(def.input[1]) ~= "table" then
		return send_error(ctype, ercat, def.input, def.output, "Invalid input/output format")
	end
	-- ensure craft type is already registered first
	if not workbench_crafts.input[ctype] then
		return send_error(ctype, ercat, def.input, def.output, "Invalid crafting type")
	end
	-- ensure time is a number
	if not tonumber(ctime) then
		return send_error(ctype, ercat, def.input, def.output, "Invalid time")
	end
	-- ensure width exists
	local first_width = #def.input[1]
	local second_width = #def.output[1]
	if first_width < 1 or second_width < 1 then
		return send_error(ctype, ercat, def.input, def.output, "Invalid width")
	end
	-- ensure all input widths are matching
	for i = 1, #def.input do
		if #def.input[i] ~= first_width then
			return send_error(ctype, ercat, def.input, def.output, "Unequal input width")
		end
	end
	-- ensure all output widths are matching
	for i = 1, #def.output do
		if #def.output[i] ~= second_width then
			return send_error(ctype, ercat, def.input, def.output, "Unequal output width")
		end
	end
	-- ensure valid replacements
	if def.replacements and type(def.replacements[1]) ~= "table" then
		return send_error(ctype, ercat, def.input, def.output, "Invalid replacements format")
	end
	-- ensure valid transfer_meta
	if def.transfer_meta and type(def.transfer_meta[1]) ~= "table" then
		return send_error(ctype, ercat, def.input, def.output, "Invalid transfer_meta format")
	end
	-- ensure multi id isn't a number
	if tonumber(def.multi_id) then
		return send_error(ctype, ercat, def.input, def.output, "multi_id must be a string, not a number")
	end

	-- save input data
	local iwidth = #def.input[1] -- recipe width
	local iheight = #def.input -- recipe height

	-- trim front columns (if any)
	local trimmed_width = iwidth
	for col = 1, iwidth do
		for row = 1, iheight do
			if (def.input)[row][col] ~= "" then
				goto stop_front_col_trim
			end
		end
		trimmed_width = trimmed_width - 1
	end
	::stop_front_col_trim::

	-- trim front rows (if any)
	local trimmed_height = iheight
	for row = 1, iheight do
		for col = 1, iwidth do
			if (def.input)[row][col] ~= "" then
				goto stop_front_row_trim
			end
		end
		trimmed_height = trimmed_height - 1
	end
	::stop_front_row_trim::

	local trimmed_input = table.copy(def.input)
	if (trimmed_width ~= iwidth) or (trimmed_height ~= iheight) then
		-- adjust list according to trim
		for row = 1, trimmed_height do
			for col = 1, trimmed_width do
				trimmed_input[row][col] = (def.input)[row + (iheight - trimmed_height)][col + (iwidth - trimmed_width)]
			end
		end
		iwidth = trimmed_width
		iheight = trimmed_height
	end

	-- trim back columns (if any)
	for col = 0, (iwidth - 1) do
		for row = 1, iheight do
			if (trimmed_input)[row][iwidth - col] ~= "" then
				goto stop_back_col_trim
			end
		end
		trimmed_width = trimmed_width - 1
	end

	::stop_back_col_trim::
	iwidth = trimmed_width

	-- trim back rows (if any)
	for row = 0, (iheight - 1) do
		for col = 1, iwidth do
			if (trimmed_input)[iheight - row][col] ~= "" then
				goto stop_back_row_trim
			end
		end
		trimmed_height = trimmed_height - 1
	end

	::stop_back_row_trim::
	iheight = trimmed_height

	local new_id = #workbench_crafts.input[ctype] + 1
	local stackcount = get_recipe_stacks(trimmed_input, iwidth, iheight) -- recipe ID
	local i_items = cache_recipe(trimmed_input, iwidth, iheight)
	if def.multi_id then
		local multi_oid = workbench_crafts.output[ctype][def.multi_id]
		if not multi_oid then -- id doesn't exists
			table.insert(workbench_crafts.input[ctype], {
				cat = def.category, -- category
				mod = def.mod, -- modification (supported: shapeless)
				time = ctime, -- timed craft
				width = iwidth, -- width
				height = iheight, -- height
				stacks = stackcount, -- stack count
				items = i_items, -- items table
				input = trimmed_input, -- raw input
				replacements = def.replacements or {},
				id = def.multi_id, -- output id
			})
			workbench_crafts.output[ctype][def.multi_id] = {}
		end
	else
		table.insert(workbench_crafts.input[ctype], {
			cat = def.category, -- category
			mod = def.mod, -- modification (supported: shapeless)
			time = ctime, -- timed craft
			width = iwidth, -- width
			height = iheight, -- height
			stacks = stackcount, -- stack count
			items = i_items, -- items table
			input = trimmed_input, -- raw input
			replacements = def.replacements or {},
			id = new_id, -- output id
		})
		workbench_crafts.output[ctype][new_id] = {}
	end

	-- save output data
	local o_items = workbench.to_invlist(def.output)
	local o_id = def.multi_id or new_id
	table.insert(workbench_crafts.output[ctype][o_id], {
		cat = def.category,
		output = def.output, -- primary output
		items = o_items,
		residue = def.residue or {}, -- secondary output
		extra = def.extra or {}, -- tertiary output
		transfer_meta = def.transfer_meta or {},
		width = #def.output[1],
		height = #def.output,
		id = o_id,
	})
end