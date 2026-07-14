local LS = LuhUtilities

local AUTO_TYPE_SETTINGS = {
	vendor = "gossipAutoVendor",
	banker = "gossipAutoBanker",
	trainer = "gossipAutoTrainer",
	taxi = "gossipAutoTaxi",
	stablemaster = "gossipAutoStable",
	battlemaster = "gossipAutoBattlemaster",
}

local gossipDefaults = {
	gossipEnabled = true,
	gossipPromptAddToList = true,
	gossipRequireAlt = true,
	gossipAutoVendor = true,
	gossipAutoBanker = true,
	gossipAutoTrainer = true,
	gossipAutoTaxi = true,
	gossipAutoStable = true,
	gossipAutoBattlemaster = true,
	gossipNPCList = {},
}

function LS:InitGossipDefaults()
	for key, value in pairs(gossipDefaults) do
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

function LS:GetNPCId(unit)
	local guid = UnitGUID(unit or "target")
	if not guid then
		return nil
	end
	if string.find(guid, "-") then
		local id = select(6, strsplit("-", guid))
		if not id then
			id = select(5, strsplit("-", guid))
		end
		return tonumber(id)
	end
	if string.sub(guid, 1, 6) == "0xF130" or string.sub(guid, 1, 6) == "0xF140" then
		return tonumber(string.sub(guid, 7, 10), 16)
	end
	return nil
end

function LS:GetGossipType()
	local num = GetNumGossipOptions and GetNumGossipOptions() or 0
	if num == 0 then
		return nil
	end
	local _, gossipType = GetGossipOptions()
	return gossipType
end

function LS:IsShiftKeyDown()
	if IsShiftKeyDown and IsShiftKeyDown() then
		return true
	end
	if IsLeftShiftKeyDown and IsLeftShiftKeyDown() then
		return true
	end
	if IsRightShiftKeyDown and IsRightShiftKeyDown() then
		return true
	end
	return false
end

function LS:HasGossipQuests()
	if (GetNumGossipAvailableQuests and GetNumGossipAvailableQuests() or 0) > 0 then
		return true
	end
	if (GetNumGossipActiveQuests and GetNumGossipActiveQuests() or 0) > 0 then
		return true
	end
	return false
end

function LS:IsOnGossipList(npcId)
	if not npcId or not self.db.gossipNPCList then
		return false
	end
	for _, entry in ipairs(self.db.gossipNPCList) do
		if entry.id == npcId then
			return true
		end
	end
	return false
end

function LS:AddToGossipList(npcId, name)
	if not npcId then
		return false, "Could not resolve NPC."
	end
	if self:IsOnGossipList(npcId) then
		return false, "NPC is already on the gossip list."
	end
	table.insert(self.db.gossipNPCList, {
		id = npcId,
		name = name or ("NPC " .. npcId),
	})
	if self.RefreshGossipUI then
		self:RefreshGossipUI()
	end
	return true
end

function LS:ShouldAutoGossip(npcId, gossipType)
	if not self.db.gossipEnabled then
		return false
	end
	if self:IsShiftKeyDown() then
		return false
	end
	if self:HasGossipQuests() then
		return false
	end
	if (GetNumGossipOptions and GetNumGossipOptions() or 0) == 0 then
		return false
	end

	if npcId and self:IsOnGossipList(npcId) then
		return true
	end

	local settingKey = gossipType and AUTO_TYPE_SETTINGS[gossipType]
	if settingKey and self.db[settingKey] then
		return true
	end

	if self.db.gossipRequireAlt then
		return IsAltKeyDown and IsAltKeyDown()
	end
	return true
end

function LS:PromptAddGossipNPC(npcId, npcName)
	if not self.db.gossipPromptAddToList then
		return
	end
	if not npcId or self:IsOnGossipList(npcId) then
		return
	end
	if self.gossipPromptShown and self.gossipPromptShown[npcId] then
		return
	end

	self.gossipPromptShown = self.gossipPromptShown or {}
	self.gossipPromptShown[npcId] = true

	local displayName = npcName or ("NPC " .. npcId)
	StaticPopup_Show("LUHUTILITIES_ADD_GOSSIP_NPC", displayName, nil, {
		npcId = npcId,
		npcName = displayName,
	})
end

function LS:OnGossipSelected(index)
	if self.gossipInternal then
		return
	end
	local npcId = self:GetNPCId("target")
	local npcName = UnitName("target")
	if npcId then
		self:PromptAddGossipNPC(npcId, npcName)
	end
end

function LS:TryAutoGossip()
	if not self.db.gossipEnabled then
		return
	end
	if self:IsShiftKeyDown() then
		return
	end

	local npcId = self:GetNPCId("target")
	local gossipType = self:GetGossipType()
	if not self:ShouldAutoGossip(npcId, gossipType) then
		return
	end

	self.gossipInternal = true
	SelectGossipOption(1)
	self.gossipInternal = nil

	local npcName = UnitName("target")
	if npcId then
		self:PromptAddGossipNPC(npcId, npcName)
	end
end

function LS:OnGossipShow()
	local frame = CreateFrame("Frame")
	frame.elapsed = 0
	frame:SetScript("OnUpdate", function(f, elapsed)
		f.elapsed = f.elapsed + elapsed
		if f.elapsed < 0.05 then
			return
		end
		f:SetScript("OnUpdate", nil)
		LS:TryAutoGossip()
	end)
end

function LS:InitGossip()
	self:InitGossipDefaults()

	if not StaticPopupDialogs["LUHUTILITIES_ADD_GOSSIP_NPC"] then
		StaticPopupDialogs["LUHUTILITIES_ADD_GOSSIP_NPC"] = {
			text = "Add %s to auto-gossip NPC list?",
			button1 = YES,
			button2 = NO,
			OnAccept = function(_, data)
				if data and data.npcId then
					local ok, err = LS:AddToGossipList(data.npcId, data.npcName)
					if ok then
						LS:Print("Added " .. data.npcName .. " to auto-gossip list.")
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

	if self.gossipFrame then
		return
	end

	if not self.gossipHooked then
		self.gossipHooked = true
		hooksecurefunc("SelectGossipOption", function(index)
			LS:OnGossipSelected(index)
		end)
	end

	self.gossipFrame = CreateFrame("Frame")
	self.gossipFrame:RegisterEvent("GOSSIP_SHOW")
	self.gossipFrame:RegisterEvent("GOSSIP_CLOSED")
	self.gossipFrame:SetScript("OnEvent", function(_, event)
		if event == "GOSSIP_SHOW" then
			LS:OnGossipShow()
		elseif event == "GOSSIP_CLOSED" then
			LS.gossipPromptShown = nil
		end
	end)
end

function LS:RefreshGossipUI()
	if self.frame and self.frame.gossipPanel then
		self.UI:RefreshGossipPanel(self.frame.gossipPanel)
	end
end
