-- Rate Photos from Filename List
-- Paste the filenames your client picked, and this sets a star rating
-- (and optionally the Pick flag) on every matching photo in Lightroom Classic.

local LrApplication = import 'LrApplication'
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'
local LrBinding = import 'LrBinding'
local LrTasks = import 'LrTasks'
local LrFunctionContext = import 'LrFunctionContext'
local LrPathUtils = import 'LrPathUtils'
local LrProgressScope = import 'LrProgressScope'

local bind = LrView.bind

-- Turn the pasted text into lookup tables.
--   names["img_1234"] = "IMG_1234"   (matched against the filename without extension)
--   numbers[1234]     = "1234"       (bare numbers, matched against the number at the end of the filename)
local function parseList(text)
	local names, numbers, order = {}, {}, {}

	for rawToken in string.gmatch(text or '', '[^%s,;]+') do
		-- strip surrounding quotes
		local token = string.gsub(rawToken, '^["\']+', '')
		token = string.gsub(token, '["\']+$', '')

		if token ~= '' then
			local original = token

			-- drop a file extension like .jpg / .CR3 / .arw if there is one
			if string.match(token, '^.+%.%a[%w]?[%w]?[%w]?$') then
				token = LrPathUtils.removeExtension(token)
			end

			if string.match(token, '^%d+$') then
				local n = tonumber(token)
				if not numbers[n] then
					numbers[n] = original
					order[#order + 1] = { kind = 'number', key = n, label = original }
				end
			else
				local key = string.lower(token)
				if not names[key] then
					names[key] = original
					order[#order + 1] = { kind = 'name', key = key, label = original }
				end
			end
		end
	end

	return names, numbers, order
end

local function run()
	local catalog = LrApplication.activeCatalog()

	LrFunctionContext.callWithContext('RateByFilenameDialog', function(context)
		local f = LrView.osFactory()
		local props = LrBinding.makePropertyTable(context)
		props.names = ''
		props.rating = 5
		props.pick = false
		props.scope = 'view'

		local contents = f:column {
			bind_to_object = props,
			spacing = f:control_spacing(),

			f:static_text {
				title = 'Paste the filenames your client picked.\nOne per line, or separated by commas/spaces. Extensions are optional.',
			},

			f:edit_field {
				value = bind 'names',
				width_in_chars = 50,
				height_in_lines = 12,
			},

			f:row {
				spacing = f:label_spacing(),
				f:static_text { title = 'Star rating:' },
				f:popup_menu {
					value = bind 'rating',
					items = {
						{ title = '1 star', value = 1 },
						{ title = '2 stars', value = 2 },
						{ title = '3 stars', value = 3 },
						{ title = '4 stars', value = 4 },
						{ title = '5 stars', value = 5 },
					},
				},
				f:checkbox {
					title = 'Also flag as Pick',
					value = bind 'pick',
				},
			},

			f:row {
				spacing = f:label_spacing(),
				f:static_text { title = 'Search in:' },
				f:radio_button {
					title = 'Current folder / collection',
					value = bind 'scope',
					checked_value = 'view',
				},
				f:radio_button {
					title = 'Entire catalog',
					value = bind 'scope',
					checked_value = 'catalog',
				},
			},
		}

		local result = LrDialogs.presentModalDialog {
			title = 'Rate Photos from Filename List',
			contents = contents,
			actionVerb = 'Apply',
		}

		if result ~= 'ok' then
			return
		end

		local names, numbers, order = parseList(props.names)
		if #order == 0 then
			LrDialogs.message('Nothing to match', 'No filenames were found in the box.', 'info')
			return
		end

		local photos
		if props.scope == 'catalog' then
			photos = catalog:getAllPhotos()
		else
			photos = catalog:getMultipleSelectedOrAllPhotos()
		end

		local progress = LrProgressScope { title = 'Matching filenames...' }
		local matches = {}
		local found = {}
		local total = #photos

		for i, photo in ipairs(photos) do
			if progress:isCanceled() then
				progress:done()
				return
			end

			local fileName = photo:getFormattedMetadata('fileName') or ''
			local base = string.lower(LrPathUtils.removeExtension(fileName))

			local hit = false
			if names[base] then
				found['name:' .. base] = true
				hit = true
			end

			local digits = string.match(base, '(%d+)$')
			if digits then
				local n = tonumber(digits)
				if numbers[n] then
					found['number:' .. n] = true
					hit = true
				end
			end

			if hit then
				matches[#matches + 1] = photo
			end

			if i % 200 == 0 then
				progress:setPortionComplete(i, total)
				LrTasks.yield()
			end
		end

		progress:done()

		if #matches > 0 then
			local rating = props.rating
			local pick = props.pick
			catalog:withWriteAccessDo('Rate photos from filename list', function()
				for _, photo in ipairs(matches) do
					photo:setRawMetadata('rating', rating)
					if pick then
						photo:setRawMetadata('pickStatus', 1)
					end
				end
			end)
		end

		-- Work out which pasted names never matched anything
		local missing = {}
		for _, entry in ipairs(order) do
			if not found[entry.kind .. ':' .. entry.key] then
				missing[#missing + 1] = entry.label
			end
		end

		local msg = string.format('Rated %d photo(s) with %d star(s)%s.', #matches, props.rating, props.pick and ' and flagged as Pick' or '')
		if #missing > 0 then
			msg = msg .. string.format('\n\n%d name(s) not found:\n%s', #missing, table.concat(missing, ', '))
			msg = msg .. '\n\nIf these should exist, try "Entire catalog" or check the spelling.'
		end

		LrDialogs.message('Done', msg, 'info')
	end)
end

LrTasks.startAsyncTask(run)
