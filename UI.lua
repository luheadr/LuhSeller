local LS = LuhUtilities

local UI = {}
LS.UI = UI

local PANEL_WIDTH = 530
local PANEL_HEIGHT = 540
local ROW_HEIGHT = 20
local LIST_ROWS = 9
local FOOTER_HEIGHT = 78
local TAB_HEIGHT = 24
local TAB_TOP = -44
local CONTENT_TOP = -78

local QUALITY_COLORS = {
	grey = "9d9d9d",
	white = "ffffff",
	green = "1eff00",
	blue = "0070dd",
	purple = "a335ee",
}

local function CreateCheckbox(parent, label, x, y, onClick)
	local check = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
	check:SetPoint("TOPLEFT", x, y)
	check:SetSize(24, 24)
	local text = parent:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	text:SetPoint("LEFT", check, "RIGHT", 4, 0)
	text:SetText(label)
	check.label = text
	check:SetScript("OnClick", function(self)
		onClick(self:GetChecked() == 1)
	end)
	return check
end

local function CreateQualityCheckbox(parent, colorHex, qualityWord, restText, x, y, onClick)
	local label = "Sell |cff" .. colorHex .. qualityWord .. "|r" .. restText
	return CreateCheckbox(parent, label, x, y, onClick)
end

local function CreateButton(parent, label, width, x, y, onClick)
	local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	button:SetSize(width, 22)
	button:SetPoint("TOPLEFT", x, y)
	button:SetText(label)
	button:SetScript("OnClick", onClick)
	return button
end

local function CreateEditBox(parent, width, x, y)
	local box = CreateFrame("EditBox", nil, parent)
	box:SetAutoFocus(false)
	box:SetSize(width, 22)
	box:SetPoint("TOPLEFT", x, y)
	box:SetMaxLetters(120)
	box:SetFontObject(GameFontHighlight)
	box:SetTextInsets(6, 6, 2, 2)

	local bg = box:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints()
	bg:SetTexture(0, 0, 0, 0.55)

	local border = CreateFrame("Frame", nil, box)
	border:SetPoint("TOPLEFT", -2, 2)
	border:SetPoint("BOTTOMRIGHT", 2, -2)
	border:SetBackdrop({
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 12,
		insets = { left = 2, right = 2, top = 2, bottom = 2 },
	})
	border:SetBackdropBorderColor(0.6, 0.6, 0.6, 1)

	box:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)
	box:SetScript("OnEnterPressed", function(self)
		self:ClearFocus()
	end)

	local function AcceptDrag(self)
		local cursorType, _, itemLink = GetCursorInfo()
		if cursorType == "item" and itemLink then
			self:SetText(itemLink)
			self:ClearFocus()
			ClearCursor()
		end
	end

	box:SetScript("OnReceiveDrag", AcceptDrag)
	box:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" and GetCursorInfo() then
			AcceptDrag(self)
		end
	end)

	return box
end

local function CreateSearchBox(parent, width, x, y, onChange)
	local box = CreateEditBox(parent, width, x, y)
	box:SetScript("OnTextChanged", function(self)
		onChange(self:GetText())
	end)
	return box
end

local function SetTabSelected(button, selected)
	if selected then
		button:SetBackdropColor(0.2, 0.4, 0.8, 1)
	else
		button:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
	end
end

local function CreateListFooter(panel, onAdd, onRemove, hintText, withQuantity)
	local footer = CreateFrame("Frame", nil, panel)
	footer:SetPoint("BOTTOMLEFT", 0, 0)
	footer:SetPoint("BOTTOMRIGHT", 0, 0)
	footer:SetHeight(FOOTER_HEIGHT)
	panel.footer = footer

	local hint = footer:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
	hint:SetPoint("TOPLEFT", 0, -2)
	hint:SetWidth(470)
	hint:SetJustifyH("LEFT")
	hint:SetText(hintText)

	panel.addBox = CreateEditBox(footer, withQuantity and 220 or 280, 0, -20)

	if withQuantity then
		local qtyLabel = footer:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		qtyLabel:SetPoint("TOPLEFT", 230, -18)
		qtyLabel:SetText("Qty")

		panel.qtyBox = CreateEditBox(footer, 50, 260, -20)
		panel.qtyBox:SetNumeric(true)
		panel.qtyBox:SetMaxLetters(4)

		panel.addButton = CreateButton(footer, "Add", 60, 320, -20, onAdd)
		panel.removeButton = CreateButton(footer, "Remove", 70, 390, -20, onRemove)
	else
		panel.addButton = CreateButton(footer, "Add", 60, 290, -20, onAdd)
		panel.removeButton = CreateButton(footer, "Remove", 70, 360, -20, onRemove)
	end

	return footer
end

function UI:CreateListPanel(parent, name, listName)
	local panel = CreateFrame("Frame", nil, parent)
	panel:SetPoint("TOPLEFT", 12, CONTENT_TOP)
	panel:SetPoint("BOTTOMRIGHT", -12, 12)
	panel:Hide()

	panel.selectedID = nil
	panel.searchText = ""
	panel.listName = listName

	local searchLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	searchLabel:SetPoint("TOPLEFT", 0, 0)
	searchLabel:SetText("Search")

	panel.searchBox = CreateSearchBox(panel, 220, 0, -16, function(text)
		panel.searchText = text
		UI:RefreshListPanel(panel)
	end)

	local scrollFrame = CreateFrame("ScrollFrame", name .. "Scroll", panel, "FauxScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", 0, -40)
	scrollFrame:SetPoint("BOTTOMRIGHT", -28, FOOTER_HEIGHT + 8)
	panel.scrollFrame = scrollFrame

	panel.rows = {}
	for i = 1, LIST_ROWS do
		local row = CreateFrame("Button", nil, panel)
		row:SetHeight(ROW_HEIGHT)
		row:SetPoint("TOPLEFT", scrollFrame, "TOPLEFT", 4, -((i - 1) * ROW_HEIGHT))
		row:SetPoint("RIGHT", scrollFrame, "RIGHT", -4, 0)
		row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")

		row.text = row:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		row.text:SetPoint("LEFT", 4, 0)
		row.text:SetPoint("RIGHT", -4, 0)
		row.text:SetJustifyH("LEFT")

		row.index = i
		row:SetScript("OnClick", function(self)
			local filtered = LS:GetFilteredList(panel.listRef, panel.searchText)
			local offset = FauxScrollFrame_GetOffset(scrollFrame)
			local entry = filtered[offset + self.index]
			if entry then
				panel.selectedID = entry.id
				UI:RefreshListPanel(panel)
			end
		end)

		panel.rows[i] = row
	end

	CreateListFooter(
		panel,
		function()
			UI:AddListEntry(panel)
		end,
		function()
			UI:RemoveListEntry(panel)
		end,
		"Drag item here, or enter item link / ID / name"
	)

	scrollFrame:SetScript("OnVerticalScroll", function(self, offset)
		FauxScrollFrame_OnVerticalScroll(self, offset, ROW_HEIGHT, function()
			UI:RefreshListPanel(panel)
		end)
	end)

	return panel
end

function UI:CreateRestockPanel(parent, name)
	local panel = CreateFrame("Frame", nil, parent)
	panel:SetPoint("TOPLEFT", 12, CONTENT_TOP)
	panel:SetPoint("BOTTOMRIGHT", -12, 12)
	panel:Hide()

	panel.selectedID = nil
	panel.searchText = ""
	panel.listName = "restock list"
	panel.isRestockPanel = true

	local searchLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	searchLabel:SetPoint("TOPLEFT", 0, 0)
	searchLabel:SetText("Search")

	panel.searchBox = CreateSearchBox(panel, 220, 0, -16, function(text)
		panel.searchText = text
		UI:RefreshListPanel(panel)
	end)

	local scrollFrame = CreateFrame("ScrollFrame", name .. "Scroll", panel, "FauxScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", 0, -40)
	scrollFrame:SetPoint("BOTTOMRIGHT", -28, FOOTER_HEIGHT + 12)
	panel.scrollFrame = scrollFrame

	panel.rows = {}
	for i = 1, LIST_ROWS do
		local row = CreateFrame("Button", nil, panel)
		row:SetHeight(ROW_HEIGHT)
		row:SetPoint("TOPLEFT", scrollFrame, "TOPLEFT", 4, -((i - 1) * ROW_HEIGHT))
		row:SetPoint("RIGHT", scrollFrame, "RIGHT", -4, 0)
		row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")

		row.text = row:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		row.text:SetPoint("LEFT", 4, 0)
		row.text:SetPoint("RIGHT", -4, 0)
		row.text:SetJustifyH("LEFT")

		row.index = i
		row:SetScript("OnClick", function(self)
			local filtered = LS:GetFilteredList(panel.listRef, panel.searchText)
			local offset = FauxScrollFrame_GetOffset(scrollFrame)
			local entry = filtered[offset + self.index]
			if entry then
				panel.selectedID = entry.id
				UI:RefreshListPanel(panel)
			end
		end)

		panel.rows[i] = row
	end

	local footer = CreateFrame("Frame", nil, panel)
	footer:SetPoint("BOTTOMLEFT", 0, 0)
	footer:SetPoint("BOTTOMRIGHT", 0, 0)
	footer:SetHeight(FOOTER_HEIGHT + 8)
	panel.footer = footer

	local hint = footer:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
	hint:SetPoint("TOPLEFT", 0, -2)
	hint:SetWidth(470)
	hint:SetJustifyH("LEFT")
	hint:SetText("Drag item here, or enter item link / ID / name. Quantity defaults to stack size.")

	panel.addBox = CreateEditBox(footer, 220, 0, -22)

	local qtyLabel = footer:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	qtyLabel:SetPoint("TOPLEFT", 230, -18)
	qtyLabel:SetText("Qty")

	panel.qtyBox = CreateEditBox(footer, 50, 230, -22)
	panel.qtyBox:SetNumeric(true)
	panel.qtyBox:SetMaxLetters(4)

	panel.addButton = CreateButton(footer, "Add", 60, 290, -22, function()
		UI:AddRestockEntry(panel)
	end)
	panel.removeButton = CreateButton(footer, "Remove", 70, 360, -22, function()
		UI:RemoveListEntry(panel)
	end)

	scrollFrame:SetScript("OnVerticalScroll", function(self, offset)
		FauxScrollFrame_OnVerticalScroll(self, offset, ROW_HEIGHT, function()
			UI:RefreshListPanel(panel)
		end)
	end)

	return panel
end

function UI:RefreshListPanel(panel)
	if not panel or not panel.listRef then
		return
	end

	local filtered = LS:GetFilteredList(panel.listRef, panel.searchText)
	local scrollFrame = panel.scrollFrame
	local offset = FauxScrollFrame_GetOffset(scrollFrame)
	local visibleRows = math.min(LIST_ROWS, math.max(1, math.floor((scrollFrame:GetHeight() or (ROW_HEIGHT * LIST_ROWS)) / ROW_HEIGHT)))

	FauxScrollFrame_Update(scrollFrame, #filtered, visibleRows, ROW_HEIGHT)

	for i = 1, LIST_ROWS do
		local row = panel.rows[i]
		if i > visibleRows then
			row:Hide()
		else
			row:Show()
			local entry = filtered[offset + i]
			if entry then
				if panel.isRestockPanel then
					row.text:SetText(string.format("[%d] %s  (x%d)", entry.id, entry.name or "Unknown", entry.quantity or 1))
				elseif panel.isRollRulesPanel then
					row.text:SetText(string.format("[%d] %s  -> %s", entry.id, entry.name or "Unknown", (entry.behavior or "?"):upper()))
				else
					row.text:SetText(string.format("[%d] %s", entry.id, entry.name or "Unknown"))
				end
				if panel.selectedID == entry.id then
					row:LockHighlight()
				else
					row:UnlockHighlight()
				end
			else
				row.text:SetText("")
				row:UnlockHighlight()
			end
		end
	end
end

function UI:AddListEntry(panel)
	local text = panel.addBox:GetText()
	local itemID, itemName = LS:ResolveItemInput(text)
	if not itemID then
		LS:Print("Could not resolve item. Use a link, numeric ID, or exact item name from your bags.")
		return
	end

	local ok, err = LS:AddToList(panel.listRef, itemID, itemName)
	if ok then
		panel.addBox:SetText("")
		panel.selectedID = itemID
		UI:RefreshListPanel(panel)
		LS:Print("Added " .. (itemName or itemID) .. " to " .. panel.listName .. ".")
	else
		LS:Print(err)
	end
end

function UI:AddRestockEntry(panel)
	local text = panel.addBox:GetText()
	local itemID, itemName = LS:ResolveItemInput(text)
	if not itemID then
		LS:Print("Could not resolve item. Use a link, numeric ID, or exact item name from your bags.")
		return
	end

	local qtyText = panel.qtyBox:GetText()
	local quantity = tonumber(qtyText)
	if not quantity or quantity < 1 then
		quantity = LS:GetItemStackSize(itemID)
	end

	local ok, err = LS:AddToRestockList(itemID, itemName, quantity)
	if ok then
		panel.addBox:SetText("")
		panel.qtyBox:SetText("")
		panel.selectedID = itemID
		UI:RefreshListPanel(panel)
		LS:Print("Added " .. (itemName or itemID) .. " to restock list (x" .. quantity .. ").")
	else
		LS:Print(err)
	end
end

function UI:AddRollRuleEntry(panel)
	local text = panel.addBox:GetText()
	local itemID, itemName = LS:ResolveItemInput(text)
	if not itemID then
		LS:Print("Could not resolve item. Use a link, numeric ID, or exact item name from your bags.")
		return
	end

	local ok, err = LS:AddToRollForceList(itemID, itemName, panel.selectedBehavior)
	if ok then
		panel.addBox:SetText("")
		panel.selectedID = itemID
		UI:RefreshListPanel(panel)
		LS:Print("Added " .. (itemName or itemID) .. " to roll rules (" .. (panel.selectedBehavior or "greed") .. ").")
	else
		LS:Print(err)
	end
end

function UI:CycleRollBehavior(panel)
	local behaviors = LS.ROLL_BEHAVIORS
	local current = panel.selectedBehavior or "greed"
	local index = 1
	for i, behavior in ipairs(behaviors) do
		if behavior == current then
			index = i
			break
		end
	end
	index = (index % #behaviors) + 1
	panel.selectedBehavior = behaviors[index]
	panel.behaviorButton:SetText(LS.ROLL_BEHAVIOR_LABELS[panel.selectedBehavior] or panel.selectedBehavior)
end

function UI:CreateRollRulesPanel(parent, name)
	local panel = CreateFrame("Frame", nil, parent)
	panel:SetPoint("TOPLEFT", 12, CONTENT_TOP)
	panel:SetPoint("BOTTOMRIGHT", -12, 12)
	panel:Hide()

	panel.selectedID = nil
	panel.searchText = ""
	panel.listName = "roll rules"
	panel.isRollRulesPanel = true
	panel.selectedBehavior = "greed"

	local searchLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	searchLabel:SetPoint("TOPLEFT", 0, 0)
	searchLabel:SetText("Search")

	panel.searchBox = CreateSearchBox(panel, 220, 0, -16, function(text)
		panel.searchText = text
		UI:RefreshListPanel(panel)
	end)

	local scrollFrame = CreateFrame("ScrollFrame", name .. "Scroll", panel, "FauxScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", 0, -40)
	scrollFrame:SetPoint("BOTTOMRIGHT", -28, FOOTER_HEIGHT + 12)
	panel.scrollFrame = scrollFrame

	panel.rows = {}
	for i = 1, LIST_ROWS do
		local row = CreateFrame("Button", nil, panel)
		row:SetHeight(ROW_HEIGHT)
		row:SetPoint("TOPLEFT", scrollFrame, "TOPLEFT", 4, -((i - 1) * ROW_HEIGHT))
		row:SetPoint("RIGHT", scrollFrame, "RIGHT", -4, 0)
		row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")

		row.text = row:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		row.text:SetPoint("LEFT", 4, 0)
		row.text:SetPoint("RIGHT", -4, 0)
		row.text:SetJustifyH("LEFT")

		row.index = i
		row:SetScript("OnClick", function(self)
			local filtered = LS:GetFilteredList(panel.listRef, panel.searchText)
			local offset = FauxScrollFrame_GetOffset(scrollFrame)
			local entry = filtered[offset + self.index]
			if entry then
				panel.selectedID = entry.id
				UI:RefreshListPanel(panel)
			end
		end)

		panel.rows[i] = row
	end

	local footer = CreateFrame("Frame", nil, panel)
	footer:SetPoint("BOTTOMLEFT", 0, 0)
	footer:SetPoint("BOTTOMRIGHT", 0, 0)
	footer:SetHeight(FOOTER_HEIGHT + 8)
	panel.footer = footer

	local hint = footer:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
	hint:SetPoint("TOPLEFT", 0, -2)
	hint:SetWidth(490)
	hint:SetJustifyH("LEFT")
	hint:SetText("Force roll: Need / Greed / Pass / DE. Drag item or enter link / ID / name.")

	panel.addBox = CreateEditBox(footer, 200, 0, -22)
	panel.behaviorButton = CreateButton(footer, "Greed", 60, 210, -22, function()
		UI:CycleRollBehavior(panel)
	end)
	panel.addButton = CreateButton(footer, "Add", 60, 280, -22, function()
		UI:AddRollRuleEntry(panel)
	end)
	panel.removeButton = CreateButton(footer, "Remove", 70, 350, -22, function()
		UI:RemoveListEntry(panel)
	end)

	scrollFrame:SetScript("OnVerticalScroll", function(self, offset)
		FauxScrollFrame_OnVerticalScroll(self, offset, ROW_HEIGHT, function()
			UI:RefreshListPanel(panel)
		end)
	end)

	return panel
end

function UI:CreateRollSettingsPanel(parent)
	local panel = CreateFrame("Frame", nil, parent)
	panel:SetPoint("TOPLEFT", 12, CONTENT_TOP)
	panel:SetPoint("BOTTOMRIGHT", -12, 12)
	panel:Hide()

	local y = -4
	panel.rollEnabled = CreateCheckbox(panel, "Enable auto-roll in groups", 0, y, function(checked)
		LS.db.rollEnabled = checked
	end)
	y = y - 26

	local greenTitle = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	greenTitle:SetPoint("TOPLEFT", 0, y)
	greenTitle:SetText("|cff" .. QUALITY_COLORS.green .. "Green|r items")
	y = y - 22

	panel.rollGreenEnabled = CreateCheckbox(panel, "Auto-roll green items", 8, y, function(checked)
		LS.db.rollGreenEnabled = checked
	end)
	y = y - 24

	panel.rollGreenPriorityBtn = CreateButton(panel, "Priority: DE first", 200, 220, y, function()
		local order = { "de", "greed", "greed_only" }
		local labels = {
			de = "Priority: DE first",
			greed = "Priority: Greed first",
			greed_only = "Priority: Greed only (no DE)",
		}
		local current = LS.db.rollGreenPriority or "de"
		local index = 1
		for i, value in ipairs(order) do
			if value == current then
				index = i
				break
			end
		end
		index = (index % #order) + 1
		LS.db.rollGreenPriority = order[index]
		panel.rollGreenPriorityBtn:SetText(labels[order[index]])
	end)
	y = y - 30

	local blueTitle = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	blueTitle:SetPoint("TOPLEFT", 0, y)
	blueTitle:SetText("|cff" .. QUALITY_COLORS.blue .. "Blue|r equipment")
	y = y - 22

	panel.rollBlueEnabled = CreateCheckbox(panel, "Auto-greed blue equipment", 8, y, function(checked)
		LS.db.rollBlueEnabled = checked
	end)
	y = y - 24
	panel.rollBlueUnusableOnly = CreateCheckbox(panel, "Only when you cannot equip it", 8, y, function(checked)
		LS.db.rollBlueUnusableOnly = checked
	end)
	y = y - 24

	local armorLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	armorLabel:SetPoint("TOPLEFT", 8, y)
	armorLabel:SetText("Armor types:")
	y = y - 20

	panel.rollBlueCloth = CreateCheckbox(panel, "Cloth", 16, y, function(checked)
		LS.db.rollBlueArmor = LS.db.rollBlueArmor or {}
		LS.db.rollBlueArmor.cloth = checked
	end)
	panel.rollBlueLeather = CreateCheckbox(panel, "Leather", 120, y, function(checked)
		LS.db.rollBlueArmor = LS.db.rollBlueArmor or {}
		LS.db.rollBlueArmor.leather = checked
	end)
	panel.rollBlueMail = CreateCheckbox(panel, "Mail", 230, y, function(checked)
		LS.db.rollBlueArmor = LS.db.rollBlueArmor or {}
		LS.db.rollBlueArmor.mail = checked
	end)
	panel.rollBluePlate = CreateCheckbox(panel, "Plate", 340, y, function(checked)
		LS.db.rollBlueArmor = LS.db.rollBlueArmor or {}
		LS.db.rollBlueArmor.plate = checked
	end)
	y = y - 30

	local epicTitle = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	epicTitle:SetPoint("TOPLEFT", 0, y)
	epicTitle:SetText("|cff" .. QUALITY_COLORS.purple .. "Epic|r items")
	y = y - 22

	panel.rollEpicDEUnusable = CreateQualityCheckbox(
		panel,
		QUALITY_COLORS.purple,
		"epic",
		" equipment you can't use (DE)",
		8,
		y,
		function(checked)
			LS.db.rollEpicDEUnusable = checked
		end
	)
	y = y - 30

	local recipeTitle = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	recipeTitle:SetPoint("TOPLEFT", 0, y)
	recipeTitle:SetText("Recipes")
	y = y - 22

	panel.rollRecipeNeedUsable = CreateCheckbox(panel, "Need on recipes you can learn", 8, y, function(checked)
		LS.db.rollRecipeNeedUsable = checked
	end)
	y = y - 24
	panel.rollRecipeGreedUnusable = CreateCheckbox(panel, "Greed on recipes you cannot use", 8, y, function(checked)
		LS.db.rollRecipeGreedUnusable = checked
	end)
	y = y - 30

	local help = panel:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
	help:SetPoint("TOPLEFT", 0, y)
	help:SetWidth(480)
	help:SetJustifyH("LEFT")
	help:SetText(
		"Roll rules list overrides everything. If nothing matches, you roll manually.\n"
			.. "Green: DE first by default, or choose Greed first / Greed only (no DE)."
	)

	panel.Refresh = function()
		panel.rollEnabled:SetChecked(LS.db.rollEnabled)
		panel.rollGreenEnabled:SetChecked(LS.db.rollGreenEnabled)
		panel.rollBlueEnabled:SetChecked(LS.db.rollBlueEnabled)
		panel.rollBlueUnusableOnly:SetChecked(LS.db.rollBlueUnusableOnly)
		panel.rollBlueCloth:SetChecked(LS.db.rollBlueArmor and LS.db.rollBlueArmor.cloth)
		panel.rollBlueLeather:SetChecked(LS.db.rollBlueArmor and LS.db.rollBlueArmor.leather)
		panel.rollBlueMail:SetChecked(LS.db.rollBlueArmor and LS.db.rollBlueArmor.mail)
		panel.rollBluePlate:SetChecked(LS.db.rollBlueArmor and LS.db.rollBlueArmor.plate)
		panel.rollRecipeNeedUsable:SetChecked(LS.db.rollRecipeNeedUsable)
		panel.rollRecipeGreedUnusable:SetChecked(LS.db.rollRecipeGreedUnusable)
		panel.rollEpicDEUnusable:SetChecked(LS.db.rollEpicDEUnusable)
		local labels = {
			de = "Priority: DE first",
			greed = "Priority: Greed first",
			greed_only = "Priority: Greed only (no DE)",
		}
		panel.rollGreenPriorityBtn:SetText(labels[LS.db.rollGreenPriority or "de"] or labels.de)
	end

	return panel
end

function UI:RemoveListEntry(panel)
	if not panel.selectedID then
		LS:Print("Select an item from the list to remove.")
		return
	end
	if LS:RemoveFromList(panel.listRef, panel.selectedID) then
		LS:Print("Removed item from " .. panel.listName .. ".")
		panel.selectedID = nil
		UI:RefreshListPanel(panel)
	end
end

local MACRO_LINE_ROWS = 4

function UI:RefreshMacroLinePanel(panel)
	if not panel or not panel.listRef then
		return
	end
	local list = panel.listRef
	local scrollFrame = panel.scrollFrame
	local offset = FauxScrollFrame_GetOffset(scrollFrame)
	local total = #list
	FauxScrollFrame_Update(scrollFrame, total, MACRO_LINE_ROWS, ROW_HEIGHT)

	for i = 1, MACRO_LINE_ROWS do
		local row = panel.rows[i]
		local index = offset + i
		local line = list[index]
		if line then
			row.text:SetText(line)
			if panel.selectedIndex == index then
				row.text:SetTextColor(1, 1, 0)
			else
				row.text:SetTextColor(1, 1, 1)
			end
			row:Show()
		else
			row:Hide()
		end
	end
end

function UI:AddMacroLine(panel)
	local text = LS:Trim(panel.addBox:GetText() or "")
	if text == "" then
		LS:Print("Enter a macro line to add.")
		return
	end
	table.insert(panel.listRef, text)
	panel.addBox:SetText("")
	panel.selectedIndex = nil
	UI:RefreshMacroLinePanel(panel)
	if not InCombatLockdown() then
		for _, button in ipairs({ LuhUtilitiesMountButton, LuhUtilitiesMountButton2, LuhUtilitiesMountButton3 }) do
			if button then
				GoGo_FillButton(button)
			end
		end
	end
end

function UI:RemoveMacroLine(panel)
	if not panel.selectedIndex then
		LS:Print("Select a macro line to remove.")
		return
	end
	table.remove(panel.listRef, panel.selectedIndex)
	panel.selectedIndex = nil
	UI:RefreshMacroLinePanel(panel)
end

function UI:CreateMacroLinePanel(parent, name, listKey, anchorPoint, anchorTo, x, y, width, height)
	local panel = CreateFrame("Frame", nil, parent)
	panel:SetSize(width, height)
	panel:SetPoint(anchorPoint, anchorTo, anchorPoint, x, y)
	panel.listKey = listKey
	panel.listRef = LS.db.mount[listKey]
	panel.selectedIndex = nil

	local title = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	title:SetPoint("TOPLEFT", 0, 0)
	title:SetText(listKey == "customLinesBefore" and "Macro lines before mount" or "Macro lines after mount")

	local scrollFrame = CreateFrame("ScrollFrame", name .. "Scroll", panel, "FauxScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", 0, -16)
	scrollFrame:SetPoint("BOTTOMRIGHT", -24, 44)
	panel.scrollFrame = scrollFrame

	panel.rows = {}
	for i = 1, MACRO_LINE_ROWS do
		local row = CreateFrame("Button", nil, panel)
		row:SetHeight(ROW_HEIGHT)
		row:SetPoint("TOPLEFT", scrollFrame, "TOPLEFT", 2, -((i - 1) * ROW_HEIGHT))
		row:SetPoint("RIGHT", scrollFrame, "RIGHT", -2, 0)
		row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
		row.text = row:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		row.text:SetPoint("LEFT", 2, 0)
		row.text:SetPoint("RIGHT", -2, 0)
		row.text:SetJustifyH("LEFT")
		row.index = i
		row:SetScript("OnClick", function(self)
			local offset = FauxScrollFrame_GetOffset(scrollFrame)
			local index = offset + self.index
			if panel.listRef[index] then
				panel.selectedIndex = index
				UI:RefreshMacroLinePanel(panel)
			end
		end)
		panel.rows[i] = row
	end

	panel.addBox = CreateEditBox(panel, width - 140, 0, -height + 22)
	panel.addBox:SetMaxLetters(200)
	CreateButton(panel, "Add", 50, width - 108, -height + 22, function()
		UI:AddMacroLine(panel)
	end)
	CreateButton(panel, "Remove", 60, width - 54, -height + 22, function()
		UI:RemoveMacroLine(panel)
	end)

	scrollFrame:SetScript("OnVerticalScroll", function(self, offset)
		FauxScrollFrame_OnVerticalScroll(self, offset, ROW_HEIGHT, function()
			UI:RefreshMacroLinePanel(panel)
		end)
	end)

	return panel
end

local function ParseMountFavoriteInput(text)
	if not text or text == "" then
		return nil
	end
	local link = string.match(text, "|H([^|]+)|h")
	if link then
		local _, id = strsplit(":", link)
		return tonumber(id)
	end
	return tonumber(text)
end

function UI:CreateMountPanel(parent)
	local panel = CreateFrame("Frame", nil, parent)
	panel:SetPoint("TOPLEFT", 12, CONTENT_TOP)
	panel:SetPoint("BOTTOMRIGHT", -12, 12)
	panel:Hide()

	local help = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	help:SetPoint("TOPLEFT", 0, 0)
	help:SetWidth(500)
	help:SetJustifyH("LEFT")
	help:SetText("Set keybinds under Key Bindings > LuhUtilities Mount. Paste mount spell/item links to add favorites.")

	local y = -36
	panel.autoDismount = CreateCheckbox(panel, "Auto-dismount on taxi / errors", 0, y, function(checked)
		LS.db.mount.autodismount = checked
		if GoGo_Panel_UpdateViews then
			GoGo_Panel_UpdateViews()
		end
	end)
	y = y - 24
	panel.druidClickForm = CreateCheckbox(panel, "Druid: single click travel forms", 0, y, function(checked)
		LS.db.mount.DruidClickForm = checked
	end)
	y = y - 24
	panel.druidFlightForm = CreateCheckbox(panel, "Druid: prefer flight forms over mounts", 0, y, function(checked)
		LS.db.mount.DruidFlightForm = checked
	end)
	y = y - 24
	panel.genericFastFlyer = CreateCheckbox(panel, "Treat 310% and 280% flyers the same", 0, y, function(checked)
		LS.db.mount.genericfastflyer = checked
	end)
	y = y - 24
	panel.globalPrefMount = CreateCheckbox(panel, "Use global mount favorites (not per-zone)", 0, y, function(checked)
		LS.db.mount.GlobalPrefMount = checked
		UI:RefreshMountPanel(panel)
	end)
	y = y - 24
	panel.disableMountNotice = CreateCheckbox(panel, "Disable unknown mount notices", 0, y, function(checked)
		LS.db.mount.DisableMountNotice = checked
	end)

	local favLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	favLabel:SetPoint("TOPLEFT", 260, -36)
	favLabel:SetText("Favorite mounts")

	panel.favBox = CreateEditBox(panel, 180, 260, -52)
	panel.favBox:SetMaxLetters(120)

	CreateButton(panel, "Add", 50, 448, -52, function()
		local id = ParseMountFavoriteInput(panel.favBox:GetText())
		if not id then
			LS:Print("Paste a mount spell or item link.")
			return
		end
		local ok, err = LS:AddMountFavorite(id)
		if ok then
			panel.favBox:SetText("")
			UI:RefreshMountPanel(panel)
			LS:Print("Added mount favorite.")
		else
			LS:Print(err or "Could not add favorite.")
		end
	end)

	CreateButton(panel, "Clear", 50, 448, -78, function()
		LS:ClearMountFavorites()
		UI:RefreshMountPanel(panel)
		LS:Print("Cleared mount favorites.")
	end)

	panel.favList = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	panel.favList:SetPoint("TOPLEFT", 260, -84)
	panel.favList:SetWidth(240)
	panel.favList:SetJustifyH("LEFT")
	panel.favList:SetText("")

	panel.linesBefore = UI:CreateMacroLinePanel(panel, "LuhMountBefore", "customLinesBefore", "TOPLEFT", panel, 0, -188, 250, 120)
	panel.linesAfter = UI:CreateMacroLinePanel(panel, "LuhMountAfter", "customLinesAfter", "TOPLEFT", panel, 260, -188, 250, 120)

	return panel
end

function UI:RefreshMountPanel(panel)
	if not panel then
		return
	end
	local m = LS.db.mount
	panel.autoDismount:SetChecked(m.autodismount)
	panel.druidClickForm:SetChecked(m.DruidClickForm)
	panel.druidFlightForm:SetChecked(m.DruidFlightForm)
	panel.genericFastFlyer:SetChecked(m.genericfastflyer)
	panel.globalPrefMount:SetChecked(m.GlobalPrefMount)
	panel.disableMountNotice:SetChecked(m.DisableMountNotice)

	panel.linesBefore.listRef = m.customLinesBefore
	panel.linesAfter.listRef = m.customLinesAfter
	UI:RefreshMacroLinePanel(panel.linesBefore)
	UI:RefreshMacroLinePanel(panel.linesAfter)

	local favText = ""
	if m.GlobalPrefMount then
		if m.GlobalPrefMounts and GoGo_GetIDName then
			favText = "Global: " .. (GoGo_GetIDName(m.GlobalPrefMounts) or "?")
		else
			favText = "Global: (none)"
		end
	else
		local zone = GetRealZoneText() or "?"
		local zoneFavs = m[zone]
		if zoneFavs and GoGo_GetIDName then
			favText = zone .. ": " .. GoGo_GetIDName(zoneFavs)
		else
			favText = zone .. ": (none)"
		end
	end
	panel.favList:SetText(favText)
end

function LS:RefreshMountUI()
	if self.frame and self.frame.mountPanel then
		UI:RefreshMountPanel(self.frame.mountPanel)
	end
end

local BLACKLIST_FOOTER_HEIGHT = 108

function UI:CreateBlacklistPanel(parent)
	local panel = CreateFrame("Frame", nil, parent)
	panel:SetPoint("TOPLEFT", 12, CONTENT_TOP)
	panel:SetPoint("BOTTOMRIGHT", -12, 12)
	panel:Hide()
	panel.isBlacklistPanel = true
	panel.selectedKey = nil
	panel.searchText = ""

	panel.enabled = CreateCheckbox(panel, "Enable blacklist alerts", 0, -4, function(checked)
		LS.db.blacklist.enabled = checked
	end)

	local searchLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	searchLabel:SetPoint("TOPLEFT", 0, -32)
	searchLabel:SetText("Search")

	panel.searchBox = CreateSearchBox(panel, 220, 0, -48, function(text)
		panel.searchText = text
		UI:RefreshBlacklistPanel(panel)
	end)

	local scrollFrame = CreateFrame("ScrollFrame", "LuhUtilitiesBlacklistScroll", panel, "FauxScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", 0, -72)
	scrollFrame:SetPoint("BOTTOMRIGHT", -28, BLACKLIST_FOOTER_HEIGHT + 8)
	panel.scrollFrame = scrollFrame

	panel.rows = {}
	for i = 1, LIST_ROWS do
		local row = CreateFrame("Button", nil, panel)
		row:SetHeight(ROW_HEIGHT)
		row:SetPoint("TOPLEFT", scrollFrame, "TOPLEFT", 4, -((i - 1) * ROW_HEIGHT))
		row:SetPoint("RIGHT", scrollFrame, "RIGHT", -4, 0)
		row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
		row.text = row:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		row.text:SetPoint("LEFT", 4, 0)
		row.text:SetPoint("RIGHT", -4, 0)
		row.text:SetJustifyH("LEFT")
		row.index = i
		row:SetScript("OnClick", function(self)
			local filtered = LS:GetFilteredBlacklist(panel.searchText)
			local offset = FauxScrollFrame_GetOffset(scrollFrame)
			local entry = filtered[offset + self.index]
			if entry then
				panel.selectedKey = entry.key
				UI:RefreshBlacklistPanel(panel)
			end
		end)
		panel.rows[i] = row
	end

	local footer = CreateFrame("Frame", nil, panel)
	footer:SetPoint("BOTTOMLEFT", 0, 0)
	footer:SetPoint("BOTTOMRIGHT", 0, 0)
	footer:SetHeight(BLACKLIST_FOOTER_HEIGHT)
	panel.footer = footer

	local hint = footer:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
	hint:SetPoint("TOPLEFT", 0, -2)
	hint:SetWidth(500)
	hint:SetJustifyH("LEFT")
	hint:SetText("Player name or Name-Realm. Target someone and use Add Target, or type /lu bl add [note]")

	panel.nameBox = CreateEditBox(footer, 180, 0, -20)
	panel.nameBox:SetMaxLetters(48)
	local nameLabel = footer:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	nameLabel:SetPoint("BOTTOMLEFT", panel.nameBox, "TOPLEFT", 0, 2)
	nameLabel:SetText("Player")

	panel.noteBox = CreateEditBox(footer, 300, 0, -48)
	panel.noteBox:SetMaxLetters(200)
	local noteLabel = footer:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	noteLabel:SetPoint("BOTTOMLEFT", panel.noteBox, "TOPLEFT", 0, 2)
	noteLabel:SetText("Note")

	CreateButton(footer, "Add", 50, 190, -20, function()
		local name, realm = LS:ParsePlayerInput(panel.nameBox:GetText())
		local note = LS:Trim(panel.noteBox:GetText())
		if not name then
			LS:Print("Enter a player name or Name-Realm.")
			return
		end
		local ok, err = LS:AddBlacklistPlayer(name, realm, note)
		if ok then
			panel.nameBox:SetText("")
			panel.noteBox:SetText("")
			panel.selectedKey = LS:NormalizePlayerKey(name, realm)
			UI:RefreshBlacklistPanel(panel)
			LS:Print("Blacklisted " .. name .. ".")
		else
			LS:Print(err or "Could not add player.")
		end
	end)

	CreateButton(footer, "Add Target", 80, 248, -20, function()
		local name, realm = LS:GetTargetPlayer()
		if not name then
			LS:Print("Target a player first.")
			return
		end
		local note = LS:Trim(panel.noteBox:GetText())
		local ok, err = LS:AddBlacklistPlayer(name, realm, note)
		if ok then
			panel.noteBox:SetText("")
			panel.selectedKey = LS:NormalizePlayerKey(name, realm)
			UI:RefreshBlacklistPanel(panel)
			LS:Print("Blacklisted " .. name .. ".")
		else
			LS:Print(err or "Could not add player.")
		end
	end)

	CreateButton(footer, "Remove", 70, 336, -20, function()
		if not panel.selectedKey then
			LS:Print("Select a player from the list to remove.")
			return
		end
		if LS:RemoveBlacklistPlayer(panel.selectedKey) then
			panel.selectedKey = nil
			UI:RefreshBlacklistPanel(panel)
			LS:Print("Removed player from blacklist.")
		end
	end)

	scrollFrame:SetScript("OnVerticalScroll", function(self, offset)
		FauxScrollFrame_OnVerticalScroll(self, offset, ROW_HEIGHT, function()
			UI:RefreshBlacklistPanel(panel)
		end)
	end)

	return panel
end

function UI:RefreshBlacklistPanel(panel)
	if not panel then
		return
	end
	panel.enabled:SetChecked(LS.db.blacklist.enabled ~= false)
	local filtered = LS:GetFilteredBlacklist(panel.searchText)
	local scrollFrame = panel.scrollFrame
	local offset = FauxScrollFrame_GetOffset(scrollFrame)
	local visibleRows = math.min(LIST_ROWS, math.max(1, math.floor((scrollFrame:GetHeight() or (ROW_HEIGHT * LIST_ROWS)) / ROW_HEIGHT)))
	FauxScrollFrame_Update(scrollFrame, table.getn(filtered), visibleRows, ROW_HEIGHT)

	for i = 1, LIST_ROWS do
		local row = panel.rows[i]
		if i > visibleRows then
			row:Hide()
		else
			row:Show()
			local entry = filtered[offset + i]
			if entry then
				local display = entry.name or "?"
				if entry.realm and entry.realm ~= "" then
					display = display .. "-" .. entry.realm
				end
				local note = entry.note or ""
				if note ~= "" then
					if string.len(note) > 40 then
						note = string.sub(note, 1, 37) .. "..."
					end
					display = display .. "  —  " .. note
				end
				row.text:SetText(display)
				if panel.selectedKey == entry.key then
					row:LockHighlight()
				else
					row:UnlockHighlight()
				end
			else
				row.text:SetText("")
				row:UnlockHighlight()
			end
		end
	end
end

function UI:ShowTab(frame, tabName)
	frame.settingsPanel:Hide()
	frame.whitelistPanel:Hide()
	frame.sellListPanel:Hide()
	frame.restockPanel:Hide()
	frame.rollPanel:Hide()
	frame.rollRulesPanel:Hide()
	frame.mountPanel:Hide()
	frame.blacklistPanel:Hide()

	SetTabSelected(frame.tabSettings, tabName == "settings")
	SetTabSelected(frame.tabWhitelist, tabName == "whitelist")
	SetTabSelected(frame.tabSellList, tabName == "selllist")
	SetTabSelected(frame.tabRestock, tabName == "restock")
	SetTabSelected(frame.tabRoll, tabName == "roll")
	SetTabSelected(frame.tabRollRules, tabName == "rollrules")
	SetTabSelected(frame.tabMount, tabName == "mount")
	SetTabSelected(frame.tabBlacklist, tabName == "blacklist")

	if tabName == "settings" then
		frame.settingsPanel:Show()
	elseif tabName == "whitelist" then
		frame.whitelistPanel:Show()
		UI:RefreshListPanel(frame.whitelistPanel)
	elseif tabName == "selllist" then
		frame.sellListPanel:Show()
		UI:RefreshListPanel(frame.sellListPanel)
	elseif tabName == "restock" then
		frame.restockPanel:Show()
		UI:RefreshListPanel(frame.restockPanel)
	elseif tabName == "roll" then
		frame.rollPanel:Show()
		if frame.rollPanel.Refresh then
			frame.rollPanel:Refresh()
		end
	elseif tabName == "mount" then
		frame.mountPanel:Show()
		UI:RefreshMountPanel(frame.mountPanel)
	elseif tabName == "blacklist" then
		frame.blacklistPanel:Show()
		UI:RefreshBlacklistPanel(frame.blacklistPanel)
	else
		frame.rollRulesPanel:Show()
		UI:RefreshListPanel(frame.rollRulesPanel)
	end
end

function LS:InitUI()
	if self.frame then
		return
	end

	local frame = CreateFrame("Frame", "LuhUtilitiesOptionsFrame", UIParent)
	frame:SetSize(PANEL_WIDTH, PANEL_HEIGHT)
	frame:SetPoint("CENTER")
	frame:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		tile = true,
		tileSize = 32,
		edgeSize = 32,
		insets = { left = 11, right = 12, top = 12, bottom = 11 },
	})
	frame:SetBackdropColor(0, 0, 0, 1)
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", frame.StartMoving)
	frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
	frame:Hide()
	frame:SetFrameStrata("DIALOG")
	self.frame = frame

	local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOP", 0, -16)
	title:SetText("LuhUtilities")

	local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", -6, -6)
	close:SetScript("OnClick", function()
		frame:Hide()
	end)

	local tabBackdrop = {
		bgFile = "Interface\\Buttons\\WHITE8x8",
		tile = false,
	}

	local TAB_WIDTH = 54
	local function MakeTab(label, index, tabName)
		local tab = CreateFrame("Button", nil, frame)
		tab:SetSize(TAB_WIDTH, TAB_HEIGHT)
		tab:SetPoint("TOPLEFT", 12 + ((index - 1) * (TAB_WIDTH + 4)), TAB_TOP)
		tab:SetBackdrop(tabBackdrop)
		tab:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
		local text = tab:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		text:SetPoint("CENTER")
		text:SetText(label)
		tab:SetScript("OnClick", function()
			UI:ShowTab(frame, tabName)
		end)
		return tab
	end

	frame.tabSettings = MakeTab("Settings", 1, "settings")
	frame.tabWhitelist = MakeTab("Whitelist", 2, "whitelist")
	frame.tabSellList = MakeTab("Sell", 3, "selllist")
	frame.tabRestock = MakeTab("Restock", 4, "restock")
	frame.tabRoll = MakeTab("Roll", 5, "roll")
	frame.tabRollRules = MakeTab("Roll List", 6, "rollrules")
	frame.tabMount = MakeTab("Mount", 7, "mount")
	frame.tabBlacklist = MakeTab("BL", 8, "blacklist")

	frame.settingsPanel = CreateFrame("Frame", nil, frame)
	frame.settingsPanel:SetPoint("TOPLEFT", 12, CONTENT_TOP)
	frame.settingsPanel:SetPoint("BOTTOMRIGHT", -12, 12)

	local y = -8
	frame.enabled = CreateCheckbox(frame.settingsPanel, "Enable auto-sell at vendors", 8, y, function(checked)
		LS.db.enabled = checked
	end)
	y = y - 28
	frame.sellGrey = CreateQualityCheckbox(frame.settingsPanel, QUALITY_COLORS.grey, "grey", " items", 8, y, function(checked)
		LS.db.sellGrey = checked
	end)
	y = y - 28
	frame.sellWhiteEquip = CreateQualityCheckbox(frame.settingsPanel, QUALITY_COLORS.white, "white", " equipment", 8, y, function(checked)
		LS.db.sellWhiteEquip = checked
	end)
	y = y - 28
	frame.sellGreenSoulboundEquip = CreateQualityCheckbox(
		frame.settingsPanel,
		QUALITY_COLORS.green,
		"green",
		" soulbound equipment",
		8,
		y,
		function(checked)
			LS.db.sellGreenSoulboundEquip = checked
		end
	)
	y = y - 28
	frame.sellBlueSoulboundNonEquip = CreateQualityCheckbox(
		frame.settingsPanel,
		QUALITY_COLORS.blue,
		"blue",
		" soulbound equipment you can't use",
		8,
		y,
		function(checked)
			LS.db.sellBlueSoulboundNonEquip = checked
		end
	)
	y = y - 28
	frame.restockEnabled = CreateCheckbox(frame.settingsPanel, "Enable auto-restock at vendors", 8, y, function(checked)
		LS.db.restockEnabled = checked
	end)
	y = y - 28
	frame.showChat = CreateCheckbox(frame.settingsPanel, "Show sold/bought items in chat", 8, y, function(checked)
		LS.db.showChat = checked
	end)

	local help = frame.settingsPanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	help:SetPoint("TOPLEFT", 8, y - 36)
	help:SetWidth(460)
	help:SetJustifyH("LEFT")
	help:SetText(
		"Priority: whitelist blocks selling, sell list always sells (unless whitelisted), then checkbox rules apply.\n\n"
			.. "Safety: quest items, keys, and items with no vendor price are never sold.\n\n"
			.. "Slash: /lu | /ls | /lu toggle | /lu sell | /lu restock"
	)

	frame.whitelistPanel = UI:CreateListPanel(frame, "LuhUtilitiesWhitelist", "whitelist")
	frame.whitelistPanel.listRef = LS.db.whitelist

	frame.sellListPanel = UI:CreateListPanel(frame, "LuhUtilitiesSellList", "sell list")
	frame.sellListPanel.listRef = LS.db.sellList

	frame.restockPanel = UI:CreateRestockPanel(frame, "LuhUtilitiesRestock")
	frame.restockPanel.listRef = LS.db.restockList

	frame.rollPanel = UI:CreateRollSettingsPanel(frame)
	frame.rollRulesPanel = UI:CreateRollRulesPanel(frame, "LuhUtilitiesRollRules")
	frame.rollRulesPanel.listRef = LS.db.rollForceList
	frame.mountPanel = UI:CreateMountPanel(frame)
	frame.blacklistPanel = UI:CreateBlacklistPanel(frame)

	UI:ShowTab(frame, "settings")
	self:RefreshUI()
end

function LS:RefreshUI()
	if not self.frame then
		return
	end

	local f = self.frame
	f.enabled:SetChecked(self.db.enabled)
	f.sellGrey:SetChecked(self.db.sellGrey)
	f.sellWhiteEquip:SetChecked(self.db.sellWhiteEquip)
	f.sellGreenSoulboundEquip:SetChecked(self.db.sellGreenSoulboundEquip)
	f.sellBlueSoulboundNonEquip:SetChecked(self.db.sellBlueSoulboundNonEquip)
	f.restockEnabled:SetChecked(self.db.restockEnabled)
	f.showChat:SetChecked(self.db.showChat)

	f.whitelistPanel.listRef = self.db.whitelist
	f.sellListPanel.listRef = self.db.sellList
	f.restockPanel.listRef = self.db.restockList
	f.rollRulesPanel.listRef = self.db.rollForceList
	UI:RefreshListPanel(f.whitelistPanel)
	UI:RefreshListPanel(f.sellListPanel)
	UI:RefreshListPanel(f.restockPanel)
	UI:RefreshListPanel(f.rollRulesPanel)
	if f.rollPanel and f.rollPanel.Refresh then
		f.rollPanel:Refresh()
	end
	if f.mountPanel then
		UI:RefreshMountPanel(f.mountPanel)
	end
	if f.blacklistPanel then
		UI:RefreshBlacklistPanel(f.blacklistPanel)
	end
end

function LS:ToggleUI()
	if not self.frame then
		self:InitUI()
	end
	if self.frame:IsShown() then
		self.frame:Hide()
	else
		self:RefreshUI()
		self.frame:Show()
	end
end

function LS:InitMinimap()
	if self.minimapButton then
		return
	end

	local button = CreateFrame("Button", "LuhUtilitiesMinimapButton", Minimap)
	button:SetSize(32, 32)
	button:SetFrameStrata("MEDIUM")
	button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

	local icon = button:CreateTexture(nil, "BACKGROUND")
	icon:SetSize(20, 20)
	icon:SetPoint("CENTER")
	icon:SetTexture("Interface\\Icons\\INV_Misc_Coin_01")

	local border = button:CreateTexture(nil, "OVERLAY")
	border:SetSize(54, 54)
	border:SetPoint("TOPLEFT")
	border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

	button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	button:SetScript("OnClick", function(_, btn)
		if btn == "LeftButton" then
			LS:ToggleUI()
		else
			LS:ToggleEnabled()
		end
	end)

	button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetText("LuhUtilities")
		GameTooltip:AddLine("Left-click: settings", 1, 1, 1)
		GameTooltip:AddLine("Right-click: toggle auto-sell", 1, 1, 1)
		GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	button:RegisterForDrag("LeftButton")
	button:SetScript("OnDragStart", function()
		button:SetScript("OnUpdate", function()
			local mx, my = Minimap:GetCenter()
			local px, py = GetCursorPosition()
			local scale = Minimap:GetEffectiveScale()
			px, py = px / scale, py / scale
			LS.db.minimap.angle = math.deg(math.atan2(py - my, px - mx))
			LS:UpdateMinimapPosition()
		end)
	end)
	button:SetScript("OnDragStop", function()
		button:SetScript("OnUpdate", nil)
	end)

	self.minimapButton = button
	self:UpdateMinimapPosition()
	self:UpdateMinimapVisibility()
end

function LS:UpdateMinimapPosition()
	if not self.minimapButton then
		return
	end
	local angle = math.rad(self.db.minimap.angle or 220)
	local radius = 80
	local x = math.cos(angle) * radius
	local y = math.sin(angle) * radius
	self.minimapButton:ClearAllPoints()
	self.minimapButton:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

function LS:UpdateMinimapVisibility()
	if not self.minimapButton then
		return
	end
	if self.db.minimap.hide then
		self.minimapButton:Hide()
	else
		self.minimapButton:Show()
	end
end
