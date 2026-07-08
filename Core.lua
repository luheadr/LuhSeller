local ADDON_NAME = "LuhUtilities"

LuhUtilities = LuhUtilities or {}
local LS = LuhUtilities

LS.ADDON_NAME = ADDON_NAME
LS.VERSION = "1.4.2"

local ARMOR_TYPES = {
	cloth = true,
	leather = true,
	mail = true,
	plate = true,
}

local soulboundPatterns

local function GetSoulboundPatterns()
	if not soulboundPatterns then
		soulboundPatterns = {}
		if ITEM_SOULBOUND then
			table.insert(soulboundPatterns, ITEM_SOULBOUND)
		end
		table.insert(soulboundPatterns, "Soulbound")
	end
	return soulboundPatterns
end

local function GetPlayerArmorTypes()
	local _, class = UnitClass("player")
	class = class or ""
	local level = UnitLevel("player")

	if class == "WARRIOR" or class == "PALADIN" or class == "DEATHKNIGHT" then
		return ARMOR_TYPES
	end
	if class == "HUNTER" or class == "SHAMAN" then
		if level >= 40 then
			return { cloth = true, leather = true, mail = true }
		end
		return { cloth = true, leather = true }
	end
	if class == "ROGUE" or class == "DRUID" then
		return { cloth = true, leather = true }
	end
	return { cloth = true }
end

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

LS.mountDefaults = {
	version = "1.4.2",
	autodismount = true,
	DisableUpdateNotice = true,
	DisableMountNotice = false,
	genericfastflyer = false,
	DruidClickForm = true,
	DruidFlightForm = false,
	GlobalPrefMount = false,
	GlobalPrefMounts = {},
	UnknownMounts = {},
	customLinesBefore = {},
	customLinesAfter = {},
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

LS.CopyDefaults = CopyDefaults

function LS:Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage("|cff00ccffLuhUtilities:|r " .. tostring(msg))
end

function LS:FormatMoney(copper)
	copper = math.floor(copper or 0)
	local gold = math.floor(copper / 10000)
	local silver = math.floor((copper % 10000) / 100)
	local cop = copper % 100
	if gold > 0 then
		return string.format("%dg %ds %dc", gold, silver, cop)
	elseif silver > 0 then
		return string.format("%ds %dc", silver, cop)
	end
	return string.format("%dc", cop)
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

function LS:ScanTooltip(bag, slot, patterns, link)
	local tooltip = LuhUtilitiesScanTooltip
	if not tooltip then
		return false
	end

	tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	tooltip:ClearLines()

	if bag ~= nil and slot ~= nil then
		tooltip:SetBagItem(bag, slot)
	end

	if tooltip:NumLines() == 0 and link then
		tooltip:ClearLines()
		tooltip:SetHyperlink(link)
	end

	tooltip:Show()

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

function LS:GetArmorType(link)
	local _, _, _, _, _, itemType, itemSubType = GetItemInfo(link)
	if itemType ~= "Armor" or not itemSubType then
		return nil
	end
	local armorType = itemSubType:lower()
	if ARMOR_TYPES[armorType] then
		return armorType
	end
	return nil
end

function LS:CanPlayerEquipItem(link)
	local itemID = self:GetItemIDFromLink(link)
	if itemID and IsEquippableItem(itemID) == 1 then
		return true
	end
	if link and IsEquippableItem(link) == 1 then
		return true
	end
	return false
end

function LS:IsArmorTypeUsableByPlayer(armorType)
	if not armorType then
		return true
	end
	local allowed = GetPlayerArmorTypes()
	return allowed[armorType] == true
end

function LS:GetBagItemQuality(bag, slot, link)
	local _, _, quality = GetItemInfo(link)
	if quality ~= nil then
		return quality
	end
	local _, _, _, qualityFromBag = GetContainerItemInfo(bag, slot)
	return qualityFromBag
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

function LS:IsSoulbound(bag, slot, link)
	link = link or GetContainerItemLink(bag, slot)
	return self:ScanTooltip(bag, slot, GetSoulboundPatterns(), link)
end

function LS:IsUnusableEquipment(link)
	if not self:IsEquipment(link) then
		return false
	end

	local armorType = self:GetArmorType(link)
	if armorType and not self:IsArmorTypeUsableByPlayer(armorType) then
		return true
	end

	return not self:CanPlayerEquipItem(link)
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
	quality = quality or self:GetBagItemQuality(bag, slot, link)

	if db.sellGrey and quality == QUALITY_POOR then
		return true
	end

	if db.sellWhiteEquip and quality == QUALITY_COMMON and self:IsEquipment(link) then
		return true
	end

	if db.sellGreenSoulboundEquip and quality == QUALITY_UNCOMMON and self:IsEquipment(link) and self:IsSoulbound(bag, slot, link) then
		return true
	end

	if db.sellBlueSoulboundNonEquip and quality == QUALITY_RARE and self:IsSoulbound(bag, slot, link) and self:IsUnusableEquipment(link) then
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

	local soldCopper = 0
	local soldCount = 0

	for bag = 0, 4 do
		local numSlots = GetContainerNumSlots(bag)
		for slot = numSlots, 1, -1 do
			if self:ShouldSellItem(bag, slot) then
				local link = GetContainerItemLink(bag, slot)
				local _, count = GetContainerItemInfo(bag, slot)
				local vendorPrice = select(11, GetItemInfo(link)) or 0
				count = count or 1

				UseContainerItem(bag, slot)

				soldCopper = soldCopper + (vendorPrice * count)
				soldCount = soldCount + 1

				if self.db.showChat and link then
					self:Print("Sold " .. link)
				end
			end
		end
	end

	if soldCount > 0 then
		self:Print(string.format("Sold %d item(s) for %s.", soldCount, self:FormatMoney(soldCopper)))
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
				local _, _, _, stackSize, numAvailable = GetMerchantItemInfo(merchantIndex)
				stackSize = stackSize or 1
				local stacksToBuy = math.ceil(need / stackSize)
				if numAvailable and numAvailable > 0 then
					stacksToBuy = math.min(stacksToBuy, numAvailable)
				end
				if stacksToBuy > 0 then
					BuyMerchantItem(merchantIndex, stacksToBuy)
					if self.db.showChat then
						local itemsBought = stacksToBuy * stackSize
						self:Print("Bought " .. itemsBought .. "x " .. (entry.name or entry.id))
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
		if LuhUtilitiesDB == nil and LuhSellerDB ~= nil then
			LuhUtilitiesDB = LuhSellerDB
		end
		LuhUtilitiesDB = CopyDefaults(defaults, LuhUtilitiesDB)
		if not LuhUtilitiesDB.mount then
			LuhUtilitiesDB.mount = {}
		end
		CopyDefaults(LS.mountDefaults, LuhUtilitiesDB.mount)
		LS.db = LuhUtilitiesDB
		if LS.InitMount then
			LS:InitMount()
		end
		LS:InitRoll()
		LS:InitUI()
		LS:InitMinimap()
		LS:Print("Loaded v" .. LS.VERSION .. ". Type /lu for settings.")
	elseif event == "MERCHANT_SHOW" then
		LS:OnMerchantOpen()
	end
end)

local function SlashHandler(msg)
	msg = (msg or ""):lower()
	if msg == "toggle" then
		LS:ToggleEnabled()
	elseif msg == "sell" then
		LS:SellItems()
	elseif msg == "restock" then
		LS:RestockItems()
	elseif msg == "mount" then
		LS:ToggleUI()
		if LS.frame and LS.UI then
			LS.UI:ShowTab(LS.frame, "mount")
		end
	elseif msg == "mounttest" then
		if GoGo_DoPlayerEnteringWorld then
			GoGo_DoPlayerEnteringWorld()
		end
		local count = GoGo_Variables and GoGo_Variables.MountList and table.getn(GoGo_Variables.MountList) or 0
		local spellCount = GoGo_Variables and GoGo_Variables.MountSpellList and table.getn(GoGo_Variables.MountSpellList) or 0
		local companionCount = (GetNumCompanions and GetNumCompanions("MOUNT")) or 0
		local journal = (C_MountJournal and C_MountJournal.GetMountIDs) and "yes" or "no"
		local key1 = GetBindingKey("LUHMOUNT")
		LS:Print("Mounts known: " .. count .. " (spells: " .. spellCount .. ", companions API: " .. companionCount .. ", journal: " .. journal .. ")" .. (key1 and (", keybind: " .. key1) or ", no keybind"))
	else
		LS:ToggleUI()
	end
end

SLASH_LUHUTILITIES1 = "/luhutilities"
SLASH_LUHUTILITIES2 = "/lu"
SlashCmdList["LUHUTILITIES"] = SlashHandler

SLASH_LUHSELLER1 = "/luhseller"
SLASH_LUHSELLER2 = "/ls"
SlashCmdList["LUHSELLER"] = SlashHandler
