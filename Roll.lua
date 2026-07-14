local LS = LuhUtilities

LS.ROLL_PASS = 0
LS.ROLL_NEED = 1
LS.ROLL_GREED = 2
LS.ROLL_DE = 3

LS.ROLL_BEHAVIORS = { "need", "greed", "pass", "de" }

LS.ROLL_BEHAVIOR_LABELS = {
	need = "Need",
	greed = "Greed (DE first)",
	pass = "Pass",
	de = "DE",
}

local BEHAVIOR_TO_ROLL = {
	pass = LS.ROLL_PASS,
	need = LS.ROLL_NEED,
	greed = LS.ROLL_GREED,
	de = LS.ROLL_DE,
}

local rollDefaults = {
	rollEnabled = true,
	rollGreenEnabled = true,
	rollGreenPriority = "de", -- "de", "greed", or "greed_only"
	rollBlueEnabled = true,
	rollBlueUnusableOnly = true,
	rollBlueArmor = {
		cloth = true,
		leather = true,
		mail = true,
		plate = true,
	},
	rollRecipeNeedUsable = true,
	rollRecipeGreedUnusable = true,
	rollEpicDEUnusable = false,
	rollForceList = {},
	rollPromptAddToList = true,
}

function LS:InitRollDefaults()
	for key, value in pairs(rollDefaults) do
		if self.db[key] == nil then
			if type(value) == "table" then
				local copy = {}
				for k, v in pairs(value) do
					copy[k] = v
				end
				self.db[key] = copy
			else
				self.db[key] = value
			end
		elseif type(value) == "table" then
			for k, v in pairs(value) do
				if self.db[key][k] == nil then
					self.db[key][k] = v
				end
			end
		end
	end
end

function LS:InGroup()
	return (GetNumRaidMembers() or 0) > 0 or (GetNumPartyMembers() or 0) > 0
end

function LS:IsRecipe(link)
	local _, _, _, _, _, itemType, itemSubType = GetItemInfo(link)
	if itemType == "Recipe" then
		return true
	end
	if itemSubType and itemSubType:find("Recipe") then
		return true
	end
	return false
end

function LS:GetRollForceBehavior(itemID)
	if not itemID or not self.db.rollForceList then
		return nil
	end
	for _, entry in ipairs(self.db.rollForceList) do
		if entry.id == itemID then
			return entry.behavior
		end
	end
	return nil
end

function LS:AddToRollForceList(itemID, name, behavior)
	if not itemID then
		return false, "Could not resolve item."
	end
	behavior = (behavior or "greed"):lower()
	if not BEHAVIOR_TO_ROLL[behavior] then
		return false, "Invalid roll behavior."
	end
	if self:GetRollForceBehavior(itemID) then
		return false, "Item is already on the roll rules list."
	end
	table.insert(self.db.rollForceList, {
		id = itemID,
		name = name or ("Item " .. itemID),
		behavior = behavior,
	})
	return true
end

function LS:BehaviorToRollType(behavior)
	return BEHAVIOR_TO_ROLL[(behavior or ""):lower()]
end

function LS:CanRoll(rollID, rollType)
	local _, _, _, _, _, canNeed, canGreed, canDisenchant = GetLootRollItemInfo(rollID)
	if rollType == LS.ROLL_NEED then
		return canNeed
	elseif rollType == LS.ROLL_GREED then
		return canGreed
	elseif rollType == LS.ROLL_DE then
		return canDisenchant
	end
	return true
end

function LS:ResolveDEFirstRoll(rollID)
	local _, _, _, _, _, _, canGreed, canDisenchant = GetLootRollItemInfo(rollID)
	if canDisenchant then
		return LS.ROLL_DE
	end
	if canGreed then
		return LS.ROLL_GREED
	end
	return nil
end

function LS:ResolveGreenRoll(rollID)
	local _, _, _, _, _, _, canGreed, canDisenchant = GetLootRollItemInfo(rollID)
	local priority = self.db.rollGreenPriority or "de"

	if priority == "greed_only" then
		if canGreed then
			return LS.ROLL_GREED
		end
		return nil
	end

	if priority == "greed" then
		if canGreed then
			return LS.ROLL_GREED
		end
		if canDisenchant then
			return LS.ROLL_DE
		end
		return nil
	end

	if canDisenchant then
		return LS.ROLL_DE
	end
	if canGreed then
		return LS.ROLL_GREED
	end
	return nil
end

function LS:ShouldRollGreedBlue(link, canGreed)
	if not canGreed or not self.db.rollBlueEnabled then
		return false
	end
	if not self:IsEquipment(link) then
		return false
	end
	if self.db.rollBlueUnusableOnly and not self:IsUnusableEquipment(link) then
		return false
	end

	local armorType = self:GetArmorType(link)
	if armorType then
		local armorSettings = self.db.rollBlueArmor or {}
		if not armorSettings[armorType] then
			return false
		end
	end

	return true
end

function LS:ResolveRoll(rollID)
	if not self.db.rollEnabled or not self:InGroup() then
		return nil
	end

	local link = GetLootRollItemLink(rollID)
	if not link then
		return nil
	end

	local itemID = self:GetItemIDFromLink(link)
	local forceBehavior = self:GetRollForceBehavior(itemID)
	if forceBehavior then
		if forceBehavior == "greed" then
			return self:ResolveDEFirstRoll(rollID)
		end
		return self:BehaviorToRollType(forceBehavior)
	end

	local _, _, _, quality, _, canNeed, canGreed, canDisenchant = GetLootRollItemInfo(rollID)

	if self:IsRecipe(link) then
		if self.db.rollRecipeNeedUsable and IsUsableItem(itemID) and canNeed then
			return LS.ROLL_NEED
		end
		if self.db.rollRecipeGreedUnusable and not IsUsableItem(itemID) and canGreed then
			return LS.ROLL_GREED
		end
		return nil
	end

	if self.db.rollGreenEnabled and quality == 2 then
		return self:ResolveGreenRoll(rollID)
	end

	if quality == 3 and self:ShouldRollGreedBlue(link, canGreed) then
		return LS.ROLL_GREED
	end

	if self.db.rollEpicDEUnusable and quality == 4 and canDisenchant and self:IsUnusableEquipment(link) then
		return LS.ROLL_DE
	end

	return nil
end

function LS:RollTypeToBehavior(rollType)
	for behavior, value in pairs(BEHAVIOR_TO_ROLL) do
		if value == rollType then
			return behavior
		end
	end
	return nil
end

function LS:MarkAutoRoll(rollID)
	self.autoRollIDs = self.autoRollIDs or {}
	self.autoRollIDs[tonumber(rollID)] = true
end

function LS:ClearAutoRoll(rollID)
	if self.autoRollIDs then
		self.autoRollIDs[tonumber(rollID)] = nil
	end
end

function LS:ScheduleClearAutoRoll(rollID)
	rollID = tonumber(rollID)
	if not rollID then
		return
	end
	local frame = CreateFrame("Frame")
	frame.rollID = rollID
	frame.elapsed = 0
	frame:SetScript("OnUpdate", function(f, elapsed)
		f.elapsed = f.elapsed + elapsed
		if f.elapsed < 0.5 then
			return
		end
		f:SetScript("OnUpdate", nil)
		LS:ClearAutoRoll(f.rollID)
	end)
end

function LS:IsAutoRoll(rollID)
	return self.autoRollIDs and self.autoRollIDs[tonumber(rollID)] == true
end

function LS:PromptAddRollRule(rollID, rollType)
	if self:IsAutoRoll(rollID) then
		return
	end
	if not self.db.rollPromptAddToList then
		return
	end
	rollType = tonumber(rollType)
	if rollType == nil then
		return
	end

	local link = GetLootRollItemLink(rollID)
	local itemID = self:GetItemIDFromLink(link)
	if not itemID or self:GetRollForceBehavior(itemID) then
		return
	end

	local behavior = self:RollTypeToBehavior(rollType)
	if not behavior then
		return
	end

	local itemName = GetItemInfo(itemID) or link or ("Item " .. itemID)
	local behaviorLabel = LS.ROLL_BEHAVIOR_LABELS[behavior] or behavior

	StaticPopup_Show("LUHUTILITIES_ADD_ROLL_RULE", link or itemName, behaviorLabel, {
		itemID = itemID,
		itemName = itemName,
		behavior = behavior,
	})
end

function LS:PrintRollMessage(rollID, rollType)
	if not self.db.showChat then
		return
	end
	local link = GetLootRollItemLink(rollID)
	local label = "Pass"
	for behavior, value in pairs(BEHAVIOR_TO_ROLL) do
		if value == rollType then
			label = LS.ROLL_BEHAVIOR_LABELS[behavior] or behavior
			break
		end
	end
	self:Print("Rolled " .. label .. " on " .. (link or "item") .. ".")
end

function LS:ClearPendingRoll(rollID)
	if self.pendingRollConfirm then
		self.pendingRollConfirm[rollID] = nil
	end
end

function LS:OnConfirmLootRoll(_, rollID, rollType)
	rollType = tonumber(rollType)
	if not self.pendingRollConfirm or self.pendingRollConfirm[rollID] ~= rollType then
		if self.pendingManualRoll then
			self.pendingManualRoll[rollID] = nil
		end
		return
	end

	self.skipConfirmLootRollHook = true
	ConfirmLootRoll(rollID, rollType)
	self.skipConfirmLootRollHook = nil
	if StaticPopup_Hide then
		StaticPopup_Hide("CONFIRM_LOOT_ROLL")
	end

	self:ClearPendingRoll(rollID)
	self.internalRoll = nil
	self:ScheduleClearAutoRoll(rollID)
	self:PrintRollMessage(rollID, rollType)
end

function LS:OnConfirmDisenchantRoll(_, rollID, rollType)
	rollType = tonumber(rollType) or LS.ROLL_DE
	if not self.pendingRollConfirm or self.pendingRollConfirm[rollID] ~= LS.ROLL_DE then
		if self.pendingManualRoll then
			self.pendingManualRoll[rollID] = nil
		end
		return
	end

	self.skipConfirmLootRollHook = true
	ConfirmLootRoll(rollID, rollType)
	self.skipConfirmLootRollHook = nil
	if StaticPopup_Hide then
		StaticPopup_Hide("CONFIRM_DISENCHANT_ROLL")
	end

	self:ClearPendingRoll(rollID)
	self.internalRoll = nil
	self:ScheduleClearAutoRoll(rollID)
	self:PrintRollMessage(rollID, rollType)
end

function LS:OnCancelLootRoll(_, rollID)
	self:ClearPendingRoll(rollID)
	self.internalRoll = nil
	self:ScheduleClearAutoRoll(rollID)
	if self.pendingManualRoll then
		self.pendingManualRoll[rollID] = nil
	end
end

function LS:PerformRoll(rollID, rollType)
	if rollType == nil then
		return
	end
	if not self:CanRoll(rollID, rollType) then
		return
	end

	self.pendingRollConfirm = self.pendingRollConfirm or {}
	self.pendingRollConfirm[rollID] = rollType
	self.internalRoll = tonumber(rollID)
	self:MarkAutoRoll(rollID)

	RollOnLoot(rollID, rollType)

	-- Rolls that do not bind on loot skip the confirm event.
	local frame = CreateFrame("Frame")
	frame.rollID = rollID
	frame.rollType = rollType
	frame.elapsed = 0
	frame:SetScript("OnUpdate", function(f, elapsed)
		f.elapsed = f.elapsed + elapsed
		if f.elapsed < 0.15 then
			return
		end
		f:SetScript("OnUpdate", nil)
		if LS.pendingRollConfirm and LS.pendingRollConfirm[f.rollID] == f.rollType then
			LS:ClearPendingRoll(f.rollID)
			LS.internalRoll = nil
			LS:ScheduleClearAutoRoll(f.rollID)
			LS:PrintRollMessage(f.rollID, f.rollType)
		end
	end)
end

function LS:ScheduleRoll(rollID)
	local rollType = self:ResolveRoll(rollID)
	if rollType == nil then
		return
	end

	local frame = CreateFrame("Frame")
	frame.elapsed = 0
	frame:SetScript("OnUpdate", function(self, elapsed)
		self.elapsed = self.elapsed + elapsed
		if self.elapsed < 0.1 then
			return
		end
		self:SetScript("OnUpdate", nil)
		LS:PerformRoll(rollID, rollType)
	end)
end

function LS:OnStartLootRoll(_, rollID)
	self:ScheduleRoll(rollID)
end

function LS:InitRoll()
	self:InitRollDefaults()

	if not StaticPopupDialogs["LUHUTILITIES_ADD_ROLL_RULE"] then
		StaticPopupDialogs["LUHUTILITIES_ADD_ROLL_RULE"] = {
			text = "Add %s to roll rules as %s?",
			button1 = YES,
			button2 = NO,
			OnAccept = function(_, data)
				if data and data.itemID then
					local ok, err = LS:AddToRollForceList(data.itemID, data.itemName, data.behavior)
					if ok then
						LS:Print("Added " .. (data.itemName or data.itemID) .. " to roll rules (" .. (data.behavior or "?") .. ").")
						if LS.RefreshUI then
							LS:RefreshUI()
						end
					elseif err then
						LS:Print(err)
					end
				end
			end,
			timeout = 0,
			whileDead = 1,
			hideOnEscape = 1,
			preferredIndex = 3,
		}
	end

	if not self.rollHooked then
		self.rollHooked = true
		self.pendingManualRoll = {}
		self.autoRollIDs = {}

		hooksecurefunc("RollOnLoot", function(rollID, rollType)
			rollID = tonumber(rollID)
			rollType = tonumber(rollType)
			if not rollID or rollType == nil then
				return
			end
			if LS:IsAutoRoll(rollID) or tonumber(LS.internalRoll) == rollID then
				return
			end
			LS.pendingManualRoll[rollID] = rollType
			local frame = CreateFrame("Frame")
			frame.elapsed = 0
			frame.rollID = rollID
			frame.rollType = rollType
			frame:SetScript("OnUpdate", function(f, elapsed)
				f.elapsed = f.elapsed + elapsed
				if f.elapsed < 0.35 then
					return
				end
				f:SetScript("OnUpdate", nil)
				if LS:IsAutoRoll(f.rollID) then
					LS.pendingManualRoll[f.rollID] = nil
					return
				end
				if LS.pendingManualRoll and LS.pendingManualRoll[f.rollID] == f.rollType then
					LS.pendingManualRoll[f.rollID] = nil
					LS:PromptAddRollRule(f.rollID, f.rollType)
				end
			end)
		end)

		hooksecurefunc("ConfirmLootRoll", function(rollID, rollType)
			rollID = tonumber(rollID)
			if not rollID then
				return
			end
			if LS.skipConfirmLootRollHook or LS:IsAutoRoll(rollID) then
				return
			end
			if LS.pendingManualRoll then
				LS.pendingManualRoll[rollID] = nil
			end
			LS:PromptAddRollRule(rollID, rollType)
		end)
	end

	if self.rollFrame then
		return
	end

	self.rollFrame = CreateFrame("Frame")
	self.rollFrame:RegisterEvent("START_LOOT_ROLL")
	self.rollFrame:RegisterEvent("CONFIRM_LOOT_ROLL")
	self.rollFrame:RegisterEvent("CONFIRM_DISENCHANT_ROLL")
	self.rollFrame:RegisterEvent("CANCEL_LOOT_ROLL")
	self.rollFrame:SetScript("OnEvent", function(_, event, ...)
		if event == "START_LOOT_ROLL" then
			LS:OnStartLootRoll(event, ...)
		elseif event == "CONFIRM_LOOT_ROLL" then
			LS:OnConfirmLootRoll(event, ...)
		elseif event == "CONFIRM_DISENCHANT_ROLL" then
			LS:OnConfirmDisenchantRoll(event, ...)
		elseif event == "CANCEL_LOOT_ROLL" then
			LS:OnCancelLootRoll(event, ...)
		end
	end)
end
