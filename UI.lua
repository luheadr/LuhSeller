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
local EMBEDDED_TOP = -32

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

local function MakeSubTab(parent, label, index, width)
	width = width or 86
	local tab = CreateFrame("Button", nil, parent)
	tab:SetSize(width, 22)
	tab:SetPoint("TOPLEFT", ((index - 1) * (width + 4)), 0)
	tab:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		tile = false,
	})
	tab:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
	local text = tab:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	text:SetPoint("CENTER")
	text:SetText(label)
	return tab
end

function UI:ShowVendorSubTab(container, subTab)
	container.activeSubTab = subTab
	container.whitelistPanel:Hide()
	container.sellListPanel:Hide()
	container.restockPanel:Hide()
	SetTabSelected(container.subWhitelist, subTab == "whitelist")
	SetTabSelected(container.subSellList, subTab == "selllist")
	SetTabSelected(container.subRestock, subTab == "restock")
	if subTab == "whitelist" then
		container.whitelistPanel:Show()
		UI:RefreshListPanel(container.whitelistPanel)
	elseif subTab == "selllist" then
		container.sellListPanel:Show()
		UI:RefreshListPanel(container.sellListPanel)
	else
		container.restockPanel:Show()
		UI:RefreshListPanel(container.restockPanel)
	end
end

function UI:ShowRollSubTab(container, subTab)
	container.activeSubTab = subTab
	container.settingsPanel:Hide()
	container.rulesPanel:Hide()
	SetTabSelected(container.subRules, subTab == "rules")
	SetTabSelected(container.subForceList, subTab == "force list")
	if subTab == "rules" then
		container.settingsPanel:Show()
		if container.settingsPanel.Refresh then
			container.settingsPanel:Refresh()
		end
	else
		container.rulesPanel:Show()
		UI:RefreshListPanel(container.rulesPanel)
	end
end

function UI:CreateVendorPanel(parent)
	local container = CreateFrame("Frame", nil, parent)
	container:SetPoint("TOPLEFT", 12, CONTENT_TOP)
	container:SetPoint("BOTTOMRIGHT", -12, 12)
	container:Hide()
	container.activeSubTab = "whitelist"

	local subBar = CreateFrame("Frame", nil, container)
	subBar:SetPoint("TOPLEFT", 0, 0)
	subBar:SetPoint("TOPRIGHT", 0, 0)
	subBar:SetHeight(24)

	container.subWhitelist = MakeSubTab(subBar, "Whitelist", 1, 80)
	container.subSellList = MakeSubTab(subBar, "Sell List", 2, 84)
	container.subRestock = MakeSubTab(subBar, "Restock", 3, 72)

	container.whitelistPanel = UI:CreateListPanel(container, "LuhUtilitiesWhitelist", "whitelist", true)
	container.sellListPanel = UI:CreateListPanel(container, "LuhUtilitiesSellList", "sell list", true)
	container.restockPanel = UI:CreateRestockPanel(container, "LuhUtilitiesRestock", true)

	container.subWhitelist:SetScript("OnClick", function()
		UI:ShowVendorSubTab(container, "whitelist")
	end)
	container.subSellList:SetScript("OnClick", function()
		UI:ShowVendorSubTab(container, "selllist")
	end)
	container.subRestock:SetScript("OnClick", function()
		UI:ShowVendorSubTab(container, "restock")
	end)

	return container
end

function UI:CreateRollPanel(parent)
	local container = CreateFrame("Frame", nil, parent)
	container:SetPoint("TOPLEFT", 12, CONTENT_TOP)
	container:SetPoint("BOTTOMRIGHT", -12, 12)
	container:Hide()
	container.activeSubTab = "rules"

	local subBar = CreateFrame("Frame", nil, container)
	subBar:SetPoint("TOPLEFT", 0, 0)
	subBar:SetPoint("TOPRIGHT", 0, 0)
	subBar:SetHeight(24)

	container.subRules = MakeSubTab(subBar, "Rules", 1, 72)
	container.subForceList = MakeSubTab(subBar, "Force List", 2, 88)

	container.settingsPanel = UI:CreateRollSettingsPanel(container, true)
	container.rulesPanel = UI:CreateRollRulesPanel(container, "LuhUtilitiesRollRules", true)

	container.subRules:SetScript("OnClick", function()
		UI:ShowRollSubTab(container, "rules")
	end)
	container.subForceList:SetScript("OnClick", function()
		UI:ShowRollSubTab(container, "force list")
	end)

	container.Refresh = function()
		if container.settingsPanel.Refresh then
			container.settingsPanel:Refresh()
		end
	end

	return container
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

function UI:CreateListPanel(parent, name, listName, embedded)
	local panel = CreateFrame("Frame", nil, parent)
	if embedded then
		panel:SetPoint("TOPLEFT", 0, EMBEDDED_TOP)
		panel:SetPoint("BOTTOMRIGHT", 0, 0)
	else
		panel:SetPoint("TOPLEFT", 12, CONTENT_TOP)
		panel:SetPoint("BOTTOMRIGHT", -12, 12)
	end
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

function UI:CreateRestockPanel(parent, name, embedded)
	local panel = CreateFrame("Frame", nil, parent)
	if embedded then
		panel:SetPoint("TOPLEFT", 0, EMBEDDED_TOP)
		panel:SetPoint("BOTTOMRIGHT", 0, 0)
	else
		panel:SetPoint("TOPLEFT", 12, CONTENT_TOP)
		panel:SetPoint("BOTTOMRIGHT", -12, 12)
	end
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
					local label = LS.ROLL_BEHAVIOR_LABELS[entry.behavior] or entry.behavior or "?"
					row.text:SetText(string.format("[%d] %s  -> %s", entry.id, entry.name or "Unknown", label))
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

function UI:CreateRollRulesPanel(parent, name, embedded)
	local panel = CreateFrame("Frame", nil, parent)
	if embedded then
		panel:SetPoint("TOPLEFT", 0, EMBEDDED_TOP)
		panel:SetPoint("BOTTOMRIGHT", 0, 0)
	else
		panel:SetPoint("TOPLEFT", 12, CONTENT_TOP)
		panel:SetPoint("BOTTOMRIGHT", -12, 12)
	end
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
	hint:SetText("Force roll: Need / DE-Greed / Pass. DE and Greed both try DE first. Drag item or enter link / ID / name.")

	panel.addBox = CreateEditBox(footer, 200, 0, -22)
	panel.behaviorButton = CreateButton(footer, "DE/Greed", 80, 210, -22, function()
		UI:CycleRollBehavior(panel)
	end)
	panel.addButton = CreateButton(footer, "Add", 60, 330, -22, function()
		UI:AddRollRuleEntry(panel)
	end)
	panel.removeButton = CreateButton(footer, "Remove", 70, 400, -22, function()
		UI:RemoveListEntry(panel)
	end)

	scrollFrame:SetScript("OnVerticalScroll", function(self, offset)
		FauxScrollFrame_OnVerticalScroll(self, offset, ROW_HEIGHT, function()
			UI:RefreshListPanel(panel)
		end)
	end)

	return panel
end

function UI:CreateRollSettingsPanel(parent, embedded)
	local panel = CreateFrame("Frame", nil, parent)
	if embedded then
		panel:SetPoint("TOPLEFT", 0, EMBEDDED_TOP)
		panel:SetPoint("BOTTOMRIGHT", 0, 0)
	else
		panel:SetPoint("TOPLEFT", 12, CONTENT_TOP)
		panel:SetPoint("BOTTOMRIGHT", -12, 12)
	end
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
	y = y - 24
	panel.rollPromptAddToList = CreateCheckbox(panel, "Prompt when manually rolling items", 8, y, function(checked)
		LS.db.rollPromptAddToList = checked
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
		panel.rollPromptAddToList:SetChecked(LS.db.rollPromptAddToList ~= false)
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
local GOSSIP_FOOTER_HEIGHT = 108

function UI:RefreshGossipPanel(panel)
	if not panel then
		return
	end

	panel.gossipEnabled:SetChecked(LS.db.gossipEnabled ~= false)
	panel.gossipPromptAddToList:SetChecked(LS.db.gossipPromptAddToList ~= false)
	panel.gossipRequireAlt:SetChecked(LS.db.gossipRequireAlt ~= false)
	panel.gossipAutoVendor:SetChecked(LS.db.gossipAutoVendor ~= false)
	panel.gossipAutoBanker:SetChecked(LS.db.gossipAutoBanker ~= false)
	panel.gossipAutoTrainer:SetChecked(LS.db.gossipAutoTrainer ~= false)
	panel.gossipAutoTaxi:SetChecked(LS.db.gossipAutoTaxi ~= false)
	panel.gossipAutoStable:SetChecked(LS.db.gossipAutoStable ~= false)
	panel.gossipAutoBattlemaster:SetChecked(LS.db.gossipAutoBattlemaster ~= false)

	if not panel.listRef then
		return
	end

	local filtered = LS:GetFilteredList(panel.listRef, panel.searchText or "")
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
				local option = entry.option or 1
				local optionLabel = entry.optionText or ("Option " .. option)
				row.text:SetText(string.format("[%d] %s  #%d %s", entry.id, entry.name or "Unknown", option, optionLabel))
				local entryKey = entry.key or LS:GossipEntryKey(entry.id, option)
				if panel.selectedKey == entryKey then
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

function UI:CreateGossipPanel(parent)
	local panel = CreateFrame("Frame", nil, parent)
	panel:SetPoint("TOPLEFT", 12, CONTENT_TOP)
	panel:SetPoint("BOTTOMRIGHT", -12, 12)
	panel:Hide()
	panel.isGossipPanel = true
	panel.selectedKey = nil
	panel.searchText = ""
	panel.listRef = LS.db.gossipNPCList
	panel.listName = "auto-gossip list"

	panel.gossipEnabled = CreateCheckbox(panel, "Enable auto-gossip", 0, -4, function(checked)
		LS.db.gossipEnabled = checked
	end)
	panel.gossipPromptAddToList = CreateCheckbox(panel, "Prompt when manually choosing gossip", 0, -28, function(checked)
		LS.db.gossipPromptAddToList = checked
	end)
	panel.gossipRequireAlt = CreateCheckbox(panel, "Require Alt for unknown NPCs", 0, -52, function(checked)
		LS.db.gossipRequireAlt = checked
	end)

	local shiftHint = panel:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
	shiftHint:SetPoint("TOPLEFT", 0, -74)
	shiftHint:SetWidth(500)
	shiftHint:SetJustifyH("LEFT")
	shiftHint:SetText("Hold Shift while opening gossip to skip automation for that NPC.")

	local typeLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	typeLabel:SetPoint("TOPLEFT", 0, -92)
	typeLabel:SetText("Auto-select gossip types:")

	panel.gossipAutoVendor = CreateCheckbox(panel, "Vendor", 8, -110, function(checked)
		LS.db.gossipAutoVendor = checked
	end)
	panel.gossipAutoBanker = CreateCheckbox(panel, "Banker", 120, -110, function(checked)
		LS.db.gossipAutoBanker = checked
	end)
	panel.gossipAutoTrainer = CreateCheckbox(panel, "Trainer", 230, -110, function(checked)
		LS.db.gossipAutoTrainer = checked
	end)
	panel.gossipAutoTaxi = CreateCheckbox(panel, "Flight", 8, -134, function(checked)
		LS.db.gossipAutoTaxi = checked
	end)
	panel.gossipAutoStable = CreateCheckbox(panel, "Stable", 120, -134, function(checked)
		LS.db.gossipAutoStable = checked
	end)
	panel.gossipAutoBattlemaster = CreateCheckbox(panel, "Battlemaster", 230, -134, function(checked)
		LS.db.gossipAutoBattlemaster = checked
	end)

	local searchLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	searchLabel:SetPoint("TOPLEFT", 0, -160)
	searchLabel:SetText("Saved NPCs")

	panel.searchBox = CreateSearchBox(panel, 220, 0, -176, function(text)
		panel.searchText = text
		UI:RefreshGossipPanel(panel)
	end)

	local scrollFrame = CreateFrame("ScrollFrame", "LuhUtilitiesGossipScroll", panel, "FauxScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", 0, -200)
	scrollFrame:SetPoint("BOTTOMRIGHT", -28, GOSSIP_FOOTER_HEIGHT + 8)
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
			local filtered = LS:GetFilteredList(panel.listRef, panel.searchText)
			local offset = FauxScrollFrame_GetOffset(scrollFrame)
			local entry = filtered[offset + self.index]
			if entry then
				local option = entry.option or 1
				panel.selectedKey = entry.key or LS:GossipEntryKey(entry.id, option)
				UI:RefreshGossipPanel(panel)
			end
		end)
		panel.rows[i] = row
	end

	local footer = CreateFrame("Frame", nil, panel)
	footer:SetPoint("BOTTOMLEFT", 0, 0)
	footer:SetPoint("BOTTOMRIGHT", 0, 0)
	footer:SetHeight(GOSSIP_FOOTER_HEIGHT)
	panel.footer = footer

	local hint = footer:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
	hint:SetPoint("TOPLEFT", 0, -2)
	hint:SetWidth(500)
	hint:SetJustifyH("LEFT")
	hint:SetText("Choose a gossip option manually to save it. Auto-select uses option 1 unless saved below.")

	panel.idBox = CreateEditBox(footer, 120, 0, -20)
	panel.idBox:SetMaxLetters(12)
	local idLabel = footer:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	idLabel:SetPoint("BOTTOMLEFT", panel.idBox, "TOPLEFT", 0, 2)
	idLabel:SetText("NPC ID")

	panel.nameBox = CreateEditBox(footer, 220, 130, -20)
	panel.nameBox:SetMaxLetters(48)
	local nameLabel = footer:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	nameLabel:SetPoint("BOTTOMLEFT", panel.nameBox, "TOPLEFT", 0, 2)
	nameLabel:SetText("Name (optional)")

	CreateButton(footer, "Add Target", 90, 360, -20, function()
		local npcId = LS:GetNPCId("target")
		local npcName = UnitName("target")
		if not npcId then
			LS:Print("Target an NPC first.")
			return
		end
		local ok, err = LS:AddToGossipList(npcId, npcName, 1)
		if ok then
			panel.selectedKey = LS:GossipEntryKey(npcId, 1)
			UI:RefreshGossipPanel(panel)
			LS:Print("Added " .. (npcName or npcId) .. " to auto-gossip list.")
		else
			LS:Print(err or "Could not add NPC.")
		end
	end)

	CreateButton(footer, "Add", 50, 360, -48, function()
		local npcId = tonumber(LS:Trim(panel.idBox:GetText() or ""))
		local npcName = LS:Trim(panel.nameBox:GetText() or "")
		if not npcId then
			LS:Print("Enter a numeric NPC ID or use Add Target.")
			return
		end
		if npcName == "" then
			npcName = "NPC " .. npcId
		end
		local ok, err = LS:AddToGossipList(npcId, npcName, 1)
		if ok then
			panel.idBox:SetText("")
			panel.nameBox:SetText("")
			panel.selectedKey = LS:GossipEntryKey(npcId, 1)
			UI:RefreshGossipPanel(panel)
			LS:Print("Added " .. npcName .. " to auto-gossip list.")
		else
			LS:Print(err or "Could not add NPC.")
		end
	end)

	CreateButton(footer, "Remove", 70, 420, -48, function()
		if not panel.selectedKey then
			LS:Print("Select an NPC gossip entry from the list to remove.")
			return
		end
		if LS:RemoveFromGossipList(panel.selectedKey) then
			LS:Print("Removed NPC gossip entry.")
			panel.selectedKey = nil
			UI:RefreshGossipPanel(panel)
		end
	end)

	scrollFrame:SetScript("OnVerticalScroll", function(self, offset)
		FauxScrollFrame_OnVerticalScroll(self, offset, ROW_HEIGHT, function()
			UI:RefreshGossipPanel(panel)
		end)
	end)

	return panel
end

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
	frame.vendorPanel:Hide()
	frame.rollContainer:Hide()
	frame.mountPanel:Hide()
	frame.gossipPanel:Hide()
	frame.blacklistPanel:Hide()

	SetTabSelected(frame.tabSettings, tabName == "settings")
	SetTabSelected(frame.tabVendor, tabName == "vendor")
	SetTabSelected(frame.tabRoll, tabName == "roll")
	SetTabSelected(frame.tabMount, tabName == "mount")
	SetTabSelected(frame.tabGossip, tabName == "gossip")
	SetTabSelected(frame.tabBlacklist, tabName == "blacklist")

	if tabName == "settings" then
		frame.settingsPanel:Show()
	elseif tabName == "vendor" then
		frame.vendorPanel:Show()
		UI:ShowVendorSubTab(frame.vendorPanel, frame.vendorPanel.activeSubTab or "whitelist")
	elseif tabName == "roll" then
		frame.rollContainer:Show()
		UI:ShowRollSubTab(frame.rollContainer, frame.rollContainer.activeSubTab or "rules")
	elseif tabName == "mount" then
		frame.mountPanel:Show()
		UI:RefreshMountPanel(frame.mountPanel)
	elseif tabName == "gossip" then
		frame.gossipPanel:Show()
		UI:RefreshGossipPanel(frame.gossipPanel)
	elseif tabName == "blacklist" then
		frame.blacklistPanel:Show()
		UI:RefreshBlacklistPanel(frame.blacklistPanel)
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
	title:SetText("LuhUtilities  |cff888888v" .. LS.VERSION .. "|r")

	local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", -6, -6)
	close:SetScript("OnClick", function()
		frame:Hide()
	end)

	local tabBackdrop = {
		bgFile = "Interface\\Buttons\\WHITE8x8",
		tile = false,
	}

	local TAB_WIDTH = 56
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
	frame.tabVendor = MakeTab("Vendor", 2, "vendor")
	frame.tabRoll = MakeTab("Roll", 3, "roll")
	frame.tabMount = MakeTab("Mount", 4, "mount")
	frame.tabGossip = MakeTab("Gossip", 5, "gossip")
	frame.tabBlacklist = MakeTab("BL", 6, "blacklist")

	frame.settingsPanel = CreateFrame("Frame", nil, frame)
	frame.settingsPanel:SetPoint("TOPLEFT", 12, CONTENT_TOP)
	frame.settingsPanel:SetPoint("BOTTOMRIGHT", -12, 12)

	local y = -8
	frame.enabled = CreateCheckbox(frame.settingsPanel, "Enable auto-sell at vendors", 8, y, function(checked)
		LS.db.enabled = checked
	end)
	y = y - 30

	local sellHeader = frame.settingsPanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	sellHeader:SetPoint("TOPLEFT", 8, y)
	sellHeader:SetText("Auto-sell rules")
	y = y - 22

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
	y = y - 30

	local generalHeader = frame.settingsPanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	generalHeader:SetPoint("TOPLEFT", 8, y)
	generalHeader:SetText("General")
	y = y - 22

	frame.showChat = CreateCheckbox(frame.settingsPanel, "Show sold/bought items in chat", 8, y, function(checked)
		LS.db.showChat = checked
	end)
	y = y - 24
	frame.sellPromptAddToList = CreateCheckbox(frame.settingsPanel, "Prompt when manually selling items", 8, y, function(checked)
		LS.db.sellPromptAddToList = checked
	end)

	local help = frame.settingsPanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	help:SetPoint("TOPLEFT", 8, y - 32)
	help:SetWidth(480)
	help:SetJustifyH("LEFT")
	help:SetText(
		"Vendor lists: Whitelist blocks selling. Sell list always sells. Restock refills at vendors.\n\n"
			.. "Quest items, keys, and items with no vendor price are never sold.\n\n"
			.. "/lu  /lu toggle  /lu sell  /lu restock  /lu mount  /lu bl"
	)

	frame.vendorPanel = UI:CreateVendorPanel(frame)
	frame.vendorPanel.whitelistPanel.listRef = LS.db.whitelist
	frame.vendorPanel.sellListPanel.listRef = LS.db.sellList
	frame.vendorPanel.restockPanel.listRef = LS.db.restockList

	frame.rollContainer = UI:CreateRollPanel(frame)
	frame.rollContainer.rulesPanel.listRef = LS.db.rollForceList

	frame.mountPanel = UI:CreateMountPanel(frame)
	frame.gossipPanel = UI:CreateGossipPanel(frame)
	frame.gossipPanel.listRef = LS.db.gossipNPCList
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
	f.sellPromptAddToList:SetChecked(self.db.sellPromptAddToList ~= false)

	if f.vendorPanel then
		f.vendorPanel.whitelistPanel.listRef = self.db.whitelist
		f.vendorPanel.sellListPanel.listRef = self.db.sellList
		f.vendorPanel.restockPanel.listRef = self.db.restockList
		if f.vendorPanel:IsShown() then
			UI:ShowVendorSubTab(f.vendorPanel, f.vendorPanel.activeSubTab or "whitelist")
		end
	end
	if f.rollContainer then
		f.rollContainer.rulesPanel.listRef = self.db.rollForceList
		if f.rollContainer.Refresh then
			f.rollContainer:Refresh()
		end
		if f.rollContainer:IsShown() then
			UI:ShowRollSubTab(f.rollContainer, f.rollContainer.activeSubTab or "rules")
		end
	end
	if f.mountPanel then
		UI:RefreshMountPanel(f.mountPanel)
	end
	if f.gossipPanel then
		f.gossipPanel.listRef = self.db.gossipNPCList
		UI:RefreshGossipPanel(f.gossipPanel)
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
