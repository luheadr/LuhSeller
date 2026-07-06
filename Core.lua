local ADDON_NAME = "LuhSeller"

LuhSeller = LuhSeller or {}
local LS = LuhSeller

LS.ADDON_NAME = ADDON_NAME
LS.VERSION = "1.1.0"

local QUALITY_POOR = 0
local QUALITY_COMMON = 1
local QUALITY_UNCOMMON = 2
local QUALITY_RARE = 3

local defaults = {
	enabled = true,
	sellGrey = true,
	sellWhiteEquip = true,
	sellGreenSoulboundEquip = true,
	sellBlueSoulboundNonEquip = true,
	showChat = true,
	restockEnabled = true,
	whitelist = {},
	sellList = {},
	restockList = {},
	minimap = {
		hide = false,
		angle = 220,
	},
}

local function CopyDefaults(src, dest)
	if type(dest) ~= "table" then
		dest = {}
	end
	for k, v in pairs(src) do
		if type(v) == "table" then
			dest[k] = CopyDefaults(v, dest[k])
		elseif dest[k] == nil then
			dest[k] = v
		end
	end
	return dest
end

function LS:Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage("|cff00ccffLuhSeller:|r " .. tostring(msg))
end

function LS:GetItemIDFromLink(link)
	if not link then
		return nil
	end
	local id = link:match("item:(%d+)")
	return id and tonumber(id) or nil
end

function LS:Trim(text)
	if not text then
		return ""
	end
	return (text:gsub("^%s+", ""):gsub("%s+$", ""))
end

function LS:GetItemName(link)
	if not link then
		return nil
	end
	return GetItemInfo(link)
end

function LS:GetItemStackSize(itemID)
	local _, _, _, _, _, _, _, maxStack = GetItemInfo(itemID)
	if maxStack and maxStack > 0 then
		return maxStack
	end
	return 20
end

function LS:ResolveItemInput(input)
	input = self:Trim(input)
	if input == "" then
		return nil
	end

	local id = input:match("item:(%d+)")
	if id then
		id = tonumber(id)
		local name = GetItemInfo(id)
		return id, name or ("Item " .. id)
	end

	if input:match("^%d+$") then
		id = tonumber(input)
		local name = GetItemInfo(id)
		return id, name or ("Item " .. id)
	end

	local name, link = GetItemInfo(input)
	if link then
		return self:GetItemIDFromLink(link), name
	end

	local lower = input:lower()
	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			local bagLink = GetContainerItemLink(bag, slot)
			if bagLink then
				local bagName = GetItemInfo(bagLink)
				if bagName and bagName:lower() == lower then
					return self:GetItemIDFromLink(bagLink), bagName
				end
			end
		end
	end

	return nil
end

function LS:IsOnList(list, itemID)
	if not itemID or not list then
		return false
	end
	for _, entry in ipairs(list) do
		if entry.id == itemID then
			return true
		end
	end
	return false
end

function LS:AddToList(list, itemID, name)
	if not itemID then
		return false, "Could not resolve item."
	end
	if self:IsOnList(list, itemID) then
		return false, "Item is already on the list."
	end
	table.insert(list, { id = itemID, name = name or ("Item " .. itemID) })
	return true
end

function LS:AddToRestockList(itemID, name, quantity)
	if not itemID then
		return false, "Could not resolve item."
	end
	if self:IsOnList(self.db.restockList, itemID) then
		return false, "Item is already on the restock list."
	end
	quantity = tonumber(quantity) or self:GetItemStackSize(itemID)
	if quantity < 1 then
		quantity = 1
	end
	table.insert(self.db.restockList, {
		id = itemID,
		name = name or ("Item " .. itemID),
		quantity = quantity,
	})
	return true
end

function LS:RemoveFromList(list, itemID)
	for index, entry in ipairs(list) do
		if entry.id == itemID then
			table.remove(list, index)
			return true
		end
	end
	return false
end

function LS:GetFilteredList(list, searchText)
	local results = {}
	searchText = self:Trim(searchText):lower()
	for _, entry in ipairs(list) do
		if searchText == "" then
			table.insert(results, entry)
		else
			local idText = tostring(entry.id)
			local nameText = (entry.name or ""):lower()
			if nameText:find(searchText, 1, true) or idText:find(searchText, 1, true) then
				table.insert(results, entry)
			end
		end
	end
	return results
end

function LS:ScanTooltip(bag, slot, patterns)
	local tooltip = LuhSellerScanTooltip
	if not tooltip then
		return false
	end

	tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	tooltip:ClearLines()
	tooltip:SetBagItem(bag, slot)

	local tooltipName = tooltip:GetName()
	for i = 1, tooltip:NumLines() do
		local left = _G[tooltipName .. "TextLeft" .. i]
		local right = _G[tooltipName .. "TextRight" .. i]
		local texts = { left and left:GetText(), right and right:GetText() }
		for _, text in ipairs(texts) do
			if text then
				for _, pattern in ipairs(patterns) do
					if text:find(pattern, 1, true) then
						tooltip:Hide()
						return true
					end
				end
			end
		end
	end

	tooltip:Hide()
	return false
end

function LS:IsQuestItem(link)
	local _, _, _, _, _, itemType = GetItemInfo(link)
	return itemType == "Quest"
end

function LS:IsKeyItem(link)
	local _, _, _, _, _, itemType = GetItemInfo(link)
	return itemType == "Key"
end

function LS:IsEquipment(link)
	local equipSlot = select(9, GetItemInfo(link))
	if not equipSlot or equipSlot == "" or equipSlot == "INVTYPE_NON_EQUIP" then
		return false
	end
	return true
end

function LS:IsSoulbound(bag, slot)
	return self:ScanTooltip(bag, slot, { "Soulbound" })
end

function LS:IsProtectedItem(bag, slot, link)
	if not link then
		return true
	end

	local _, count = GetContainerItemInfo(bag, slot)
	if not count or count < 1 then
		return true
	end

	if self:IsQuestItem(link) then
		return true
	end

	if self:IsKeyItem(link) then
		return true
	end

	local vendorPrice = select(11, GetItemInfo(link))
	if not vendorPrice or vendorPrice <= 0 then
		return true
	end

	return false
end

function LS:ShouldSellItem(bag, slot)
	local db = self.db
	if not db or not db.enabled then
		return false
	end

	local link = GetContainerItemLink(bag, slot)
	if not link then
		return false
	end

	if self:IsProtectedItem(bag, slot, link) then
		return false
	end

	local itemID = self:GetItemIDFromLink(link)
	if self:IsOnList(db.whitelist, itemID) then
		return false
	end

	if self:IsOnList(db.sellList, itemID) then
		return true
	end

	local _, _, quality = GetItemInfo(link)

	if db.sellGrey and quality == QUALITY_POOR then
		return true
	end

	if db.sellWhiteEquip and quality == QUALITY_COMMON and self:IsEquipment(link) then
		return true
	end

	if db.sellGreenSoulboundEquip and quality == QUALITY_UNCOMMON and self:IsEquipment(link) and self:IsSoulbound(bag, slot) then
		return true
	end

	if db.sellBlueSoulboundNonEquip and quality == QUALITY_RARE and not self:IsEquipment(link) and self:IsSoulbound(bag, slot) then
		return true
	end

	return false
end

function LS:CountItemInBags(itemID)
	local total = 0
	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			local link = GetContainerItemLink(bag, slot)
			if link and self:GetItemIDFromLink(link) == itemID then
				local _, count = GetContainerItemInfo(bag, slot)
				total = total + (count or 1)
			end
		end
	end
	return total
end

function LS:FindMerchantItemIndex(itemID)
	for i = 1, GetMerchantNumItems() do
		local link = GetMerchantItemLink(i)
		if link and self:GetItemIDFromLink(link) == itemID then
			return i
		end
	end
	return nil
end

function LS:SellItems()
	if not self.db.enabled or self.isSelling then
		return
	end

	if not MerchantFrame or not MerchantFrame:IsShown() then
		return
	end

	self.isSelling = true

	for bag = 0, 4 do
		local numSlots = GetContainerNumSlots(bag)
		for slot = numSlots, 1, -1 do
			if self:ShouldSellItem(bag, slot) then
				local link = GetContainerItemLink(bag, slot)
				UseContainerItem(bag, slot)
				if self.db.showChat and link then
					self:Print("Sold " .. link)
				end
			end
		end
	end

	self.isSelling = false
end

function LS:RestockItems()
	if not self.db.restockEnabled or self.isRestocking then
		return
	end

	if not MerchantFrame or not MerchantFrame:IsShown() then
		return
	end

	self.isRestocking = true

	for _, entry in ipairs(self.db.restockList) do
		local have = self:CountItemInBags(entry.id)
		local need = entry.quantity - have
		if need > 0 then
			local merchantIndex = self:FindMerchantItemIndex(entry.id)
			if merchantIndex then
				local _, _, _, _, numAvailable = GetMerchantItemInfo(merchantIndex)
				local buyQty = need
				if numAvailable and numAvailable > 0 then
					buyQty = math.min(need, numAvailable)
				end
				if buyQty > 0 then
					BuyMerchantItem(merchantIndex, buyQty)
					if self.db.showChat then
						self:Print("Bought " .. buyQty .. "x " .. (entry.name or entry.id))
					end
				end
			end
		end
	end

	self.isRestocking = false
end

function LS:OnMerchantOpen()
	if not self.sellDelayFrame then
		self.sellDelayFrame = CreateFrame("Frame")
	end

	self.sellDelayFrame.elapsed = 0
	self.sellDelayFrame:SetScript("OnUpdate", function(frame, elapsed)
		frame.elapsed = frame.elapsed + elapsed
		if frame.elapsed < 0.15 then
			return
		end
		frame:SetScript("OnUpdate", nil)
		if MerchantFrame and MerchantFrame:IsShown() then
			LS:SellItems()
			LS:RestockItems()
		end
	end)
end

function LS:ToggleEnabled()
	self.db.enabled = not self.db.enabled
	self:Print(self.db.enabled and "Auto-sell enabled." or "Auto-sell disabled.")
	if self.RefreshUI then
		self:RefreshUI()
	end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("MERCHANT_SHOW")
eventFrame:SetScript("OnEvent", function(_, event, arg1)
	if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
		LuhSellerDB = CopyDefaults(defaults, LuhSellerDB)
		LS.db = LuhSellerDB
		LS:InitUI()
		LS:InitMinimap()
		LS:Print("Loaded v" .. LS.VERSION .. ". Type /ls for settings.")
	elseif event == "MERCHANT_SHOW" then
		LS:OnMerchantOpen()
	end
end)

SLASH_LUHSELLER1 = "/luhseller"
SLASH_LUHSELLER2 = "/ls"
SlashCmdList["LUHSELLER"] = function(msg)
	msg = (msg or ""):lower()
	if msg == "toggle" then
		LS:ToggleEnabled()
	elseif msg == "sell" then
		LS:SellItems()
	elseif msg == "restock" then
		LS:RestockItems()
	else
		LS:ToggleUI()
	end
end
