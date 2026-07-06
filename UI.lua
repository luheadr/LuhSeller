local LS = LuhSeller

local UI = {}
LS.UI = UI

local PANEL_WIDTH = 520
local PANEL_HEIGHT = 480
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

function UI:ShowTab(frame, tabName)
	frame.settingsPanel:Hide()
	frame.whitelistPanel:Hide()
	frame.sellListPanel:Hide()
	frame.restockPanel:Hide()

	SetTabSelected(frame.tabSettings, tabName == "settings")
	SetTabSelected(frame.tabWhitelist, tabName == "whitelist")
	SetTabSelected(frame.tabSellList, tabName == "selllist")
	SetTabSelected(frame.tabRestock, tabName == "restock")

	if tabName == "settings" then
		frame.settingsPanel:Show()
	elseif tabName == "whitelist" then
		frame.whitelistPanel:Show()
		UI:RefreshListPanel(frame.whitelistPanel)
	elseif tabName == "selllist" then
		frame.sellListPanel:Show()
		UI:RefreshListPanel(frame.sellListPanel)
	else
		frame.restockPanel:Show()
		UI:RefreshListPanel(frame.restockPanel)
	end
end

function LS:InitUI()
	if self.frame then
		return
	end

	local frame = CreateFrame("Frame", "LuhSellerOptionsFrame", UIParent)
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
	title:SetText("LuhSeller")

	local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", -6, -6)
	close:SetScript("OnClick", function()
		frame:Hide()
	end)

	local tabBackdrop = {
		bgFile = "Interface\\Buttons\\WHITE8x8",
		tile = false,
	}

	local TAB_WIDTH = 96
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
	frame.tabSellList = MakeTab("Sell List", 3, "selllist")
	frame.tabRestock = MakeTab("Restock", 4, "restock")

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
		" soulbound non-equipment items",
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
			.. "Slash: /ls | /ls toggle | /ls sell | /ls restock"
	)

	frame.whitelistPanel = UI:CreateListPanel(frame, "LuhSellerWhitelist", "whitelist")
	frame.whitelistPanel.listRef = LS.db.whitelist

	frame.sellListPanel = UI:CreateListPanel(frame, "LuhSellerSellList", "sell list")
	frame.sellListPanel.listRef = LS.db.sellList

	frame.restockPanel = UI:CreateRestockPanel(frame, "LuhSellerRestock")
	frame.restockPanel.listRef = LS.db.restockList

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
	UI:RefreshListPanel(f.whitelistPanel)
	UI:RefreshListPanel(f.sellListPanel)
	UI:RefreshListPanel(f.restockPanel)
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

	local button = CreateFrame("Button", "LuhSellerMinimapButton", Minimap)
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
		GameTooltip:SetText("LuhSeller")
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
