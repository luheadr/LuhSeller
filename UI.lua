local LS = LuhSeller

local UI = {}
LS.UI = UI

local PANEL_WIDTH = 500
local PANEL_HEIGHT = 460
local ROW_HEIGHT = 20
local LIST_ROWS = 10

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

local function CreateButton(parent, label, width, x, y, onClick)
	local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	button:SetSize(width, 22)
	button:SetPoint("TOPLEFT", x, y)
	button:SetText(label)
	button:SetScript("OnClick", onClick)
	return button
end

local function CreateEditBox(parent, width, x, y, instructions)
	local box = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
	box:SetAutoFocus(false)
	box:SetSize(width, 20)
	box:SetPoint("TOPLEFT", x, y)
	box:SetMaxLetters(120)
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

	if instructions then
		local hint = parent:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
		hint:SetPoint("TOPLEFT", box, "BOTTOMLEFT", 0, -2)
		hint:SetWidth(width)
		hint:SetJustifyH("LEFT")
		hint:SetText(instructions)
	end

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

function UI:CreateListPanel(parent, name)
	local panel = CreateFrame("Frame", nil, parent)
	panel:SetPoint("TOPLEFT", 12, -56)
	panel:SetPoint("BOTTOMRIGHT", -12, 12)
	panel:Hide()

	panel.selectedID = nil
	panel.searchText = ""

	local searchLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	searchLabel:SetPoint("TOPLEFT", 0, 0)
	searchLabel:SetText("Search")

	panel.searchBox = CreateSearchBox(panel, 220, 0, -16, function(text)
		panel.searchText = text
		UI:RefreshListPanel(panel)
	end)

	local scrollFrame = CreateFrame("ScrollFrame", name .. "Scroll", panel, "FauxScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", 0, -44)
	scrollFrame:SetSize(450, ROW_HEIGHT * LIST_ROWS + 4)
	panel.scrollFrame = scrollFrame

	panel.rows = {}
	for i = 1, LIST_ROWS do
		local row = CreateFrame("Button", nil, panel)
		row:SetSize(450, ROW_HEIGHT)
		row:SetPoint("TOPLEFT", scrollFrame, "TOPLEFT", 8, -((i - 1) * ROW_HEIGHT))
		row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")

		row.text = row:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		row.text:SetPoint("LEFT", 4, 0)
		row.text:SetWidth(430)
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

	panel.addBox = CreateEditBox(
		panel,
		300,
		0,
		-(ROW_HEIGHT * LIST_ROWS + 58),
		"Drag item here, or enter item link / ID / name"
	)

	panel.addButton = CreateButton(panel, "Add", 70, 310, -(ROW_HEIGHT * LIST_ROWS + 58), function()
		UI:AddListEntry(panel)
	end)

	panel.removeButton = CreateButton(panel, "Remove", 80, 390, -(ROW_HEIGHT * LIST_ROWS + 58), function()
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

	FauxScrollFrame_Update(scrollFrame, #filtered, LIST_ROWS, ROW_HEIGHT)

	for i = 1, LIST_ROWS do
		local row = panel.rows[i]
		local entry = filtered[offset + i]
		row:Show()
		if entry then
			row.text:SetText(string.format("[%d] %s", entry.id, entry.name or "Unknown"))
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

	SetTabSelected(frame.tabSettings, tabName == "settings")
	SetTabSelected(frame.tabWhitelist, tabName == "whitelist")
	SetTabSelected(frame.tabSellList, tabName == "selllist")

	if tabName == "settings" then
		frame.settingsPanel:Show()
	elseif tabName == "whitelist" then
		frame.whitelistPanel:Show()
		UI:RefreshListPanel(frame.whitelistPanel)
	else
		frame.sellListPanel:Show()
		UI:RefreshListPanel(frame.sellListPanel)
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

	local function MakeTab(label, x, tabName)
		local tab = CreateFrame("Button", nil, frame)
		tab:SetSize(120, 24)
		tab:SetPoint("TOPLEFT", x, -42)
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

	frame.tabSettings = MakeTab("Settings", 16, "settings")
	frame.tabWhitelist = MakeTab("Whitelist", 142, "whitelist")
	frame.tabSellList = MakeTab("Sell List", 268, "selllist")

	frame.settingsPanel = CreateFrame("Frame", nil, frame)
	frame.settingsPanel:SetPoint("TOPLEFT", 12, -72)
	frame.settingsPanel:SetPoint("BOTTOMRIGHT", -12, 12)

	local y = -8
	frame.enabled = CreateCheckbox(frame.settingsPanel, "Enable auto-sell at vendors", 8, y, function(checked)
		LS.db.enabled = checked
	end)
	y = y - 28
	frame.sellGrey = CreateCheckbox(frame.settingsPanel, "Sell grey items", 8, y, function(checked)
		LS.db.sellGrey = checked
	end)
	y = y - 28
	frame.sellWhiteEquip = CreateCheckbox(frame.settingsPanel, "Sell white equipment", 8, y, function(checked)
		LS.db.sellWhiteEquip = checked
	end)
	y = y - 28
	frame.sellGreenSoulboundEquip = CreateCheckbox(frame.settingsPanel, "Sell green soulbound equipment", 8, y, function(checked)
		LS.db.sellGreenSoulboundEquip = checked
	end)
	y = y - 28
	frame.showChat = CreateCheckbox(frame.settingsPanel, "Show sold items in chat", 8, y, function(checked)
		LS.db.showChat = checked
	end)

	local help = frame.settingsPanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	help:SetPoint("TOPLEFT", 8, y - 36)
	help:SetWidth(430)
	help:SetJustifyH("LEFT")
	help:SetText(
		"Priority: whitelist blocks selling, sell list always sells (unless whitelisted), then checkbox rules apply.\n\n"
			.. "Safety: quest items, keys, and items with no vendor price are never sold.\n\n"
			.. "Slash: /ls or /luhseller | /ls toggle | /ls sell"
	)

	frame.whitelistPanel = UI:CreateListPanel(frame, "LuhSellerWhitelist")
	frame.whitelistPanel.listRef = LS.db.whitelist
	frame.whitelistPanel.listName = "whitelist"

	frame.sellListPanel = UI:CreateListPanel(frame, "LuhSellerSellList")
	frame.sellListPanel.listRef = LS.db.sellList
	frame.sellListPanel.listName = "sell list"

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
	f.showChat:SetChecked(self.db.showChat)

	f.whitelistPanel.listRef = self.db.whitelist
	f.sellListPanel.listRef = self.db.sellList
	UI:RefreshListPanel(f.whitelistPanel)
	UI:RefreshListPanel(f.sellListPanel)
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
