local LS = LuhUtilities

local ALERT_SOUND = "Interface\\AddOns\\LuhUtilities\\Sounds\\blacklist_alert.wav"
local ALERT_COOLDOWN = 30
local SCAN_DELAY = 0.35

local alertFrame
local scanDelayFrame
local alertTimes = {}

local function SplitNameRealm(fullName)
	if not fullName or fullName == "" then
		return nil, nil
	end
	local name, realm = string.match(fullName, "^([^%-]+)%-(.+)$")
	if name and realm then
		return name, realm
	end
	return fullName, GetRealmName()
end

function LS:IsBlacklistEnabled()
	return self.db.blacklist and self.db.blacklist.enabled ~= false
end

function LS:NormalizePlayerKey(name, realm)
	name = self:Trim(name or "")
	realm = self:Trim(realm or "")
	if name == "" then
		return nil
	end
	if realm == "" then
		realm = GetRealmName() or ""
	end
	return string.lower(name) .. "-" .. string.lower(realm)
end

function LS:ParsePlayerInput(input)
	input = self:Trim(input)
	if input == "" then
		return nil
	end
	local name, realm = SplitNameRealm(input)
	if not name then
		return nil
	end
	return name, realm
end

function LS:GetBlacklistList()
	if not self.db.blacklist then
		self.db.blacklist = { enabled = true, players = {} }
	end
	if not self.db.blacklist.players then
		self.db.blacklist.players = {}
	end
	return self.db.blacklist.players
end

function LS:FindBlacklistEntry(fullName)
	if not fullName or fullName == "" then
		return nil
	end
	local name, realm = SplitNameRealm(fullName)
	if not name then
		return nil
	end

	for _, entry in ipairs(self:GetBlacklistList()) do
		if entry.key and entry.key == self:NormalizePlayerKey(name, realm) then
			return entry
		end
	end

	local lowerName = string.lower(name)
	local myRealm = string.lower(GetRealmName() or "")
	for _, entry in ipairs(self:GetBlacklistList()) do
		if string.lower(entry.name or "") == lowerName then
			local entryRealm = string.lower(entry.realm or myRealm)
			local theirRealm = string.lower(realm or myRealm)
			if entryRealm == theirRealm or entryRealm == myRealm or theirRealm == myRealm then
				return entry
			end
		end
	end

	return nil
end

function LS:GetBlacklistEntry(key)
	for _, entry in ipairs(self:GetBlacklistList()) do
		if entry.key == key then
			return entry
		end
	end
	return nil
end

function LS:IsBlacklisted(fullName)
	if not self:IsBlacklistEnabled() then
		return false
	end
	return self:FindBlacklistEntry(fullName) ~= nil
end

function LS:AddBlacklistPlayer(name, realm, note)
	name = self:Trim(name or "")
	note = self:Trim(note or "")
	if name == "" then
		return false, "Player name is required."
	end
	if not realm or realm == "" then
		realm = GetRealmName() or ""
	end
	local key = self:NormalizePlayerKey(name, realm)
	if self:GetBlacklistEntry(key) or self:FindBlacklistEntry(name .. "-" .. realm) or self:FindBlacklistEntry(name) then
		return false, "Player is already on the blacklist."
	end
	table.insert(self:GetBlacklistList(), {
		key = key,
		name = name,
		realm = realm,
		note = note,
	})
	if self.RefreshBlacklistUI then
		self:RefreshBlacklistUI()
	end
	return true
end

function LS:RemoveBlacklistPlayer(key)
	if not key then
		return false
	end
	local list = self:GetBlacklistList()
	for i, entry in ipairs(list) do
		if entry.key == key then
			table.remove(list, i)
			if self.RefreshBlacklistUI then
				self:RefreshBlacklistUI()
			end
			return true
		end
	end
	return false
end

function LS:GetFilteredBlacklist(searchText)
	local list = self:GetBlacklistList()
	searchText = string.lower(self:Trim(searchText or ""))
	if searchText == "" then
		return list
	end
	local filtered = {}
	for _, entry in ipairs(list) do
		local haystack = string.lower((entry.name or "") .. " " .. (entry.realm or "") .. " " .. (entry.note or ""))
		if string.find(haystack, searchText, 1, true) then
			table.insert(filtered, entry)
		end
	end
	return filtered
end

function LS:GetTargetPlayer()
	if not UnitExists("target") then
		return nil
	end
	local name = UnitName("target")
	if not name then
		return nil
	end
	if UnitIsPlayer and not UnitIsPlayer("target") then
		return nil
	end
	return SplitNameRealm(name)
end

function LS:PlayBlacklistAlert()
	local played
	if PlaySoundFile then
		played = PlaySoundFile(ALERT_SOUND)
	end
	PlaySound("RaidWarning")
	if not played and PlaySound then
		PlaySound("ReadyCheck")
	end
end

function LS:AlertBlacklist(fullName, entry, context)
	if not self:IsBlacklistEnabled() then
		return
	end
	entry = entry or self:FindBlacklistEntry(fullName)
	if not entry then
		return
	end

	local name, realm = SplitNameRealm(fullName)
	if not name then
		name = entry.name
		realm = entry.realm
	end

	local key = entry.key or self:NormalizePlayerKey(name, realm)
	local now = GetTime()
	if alertTimes[key] and (now - alertTimes[key]) < ALERT_COOLDOWN then
		return
	end
	alertTimes[key] = now

	local displayName = entry.name or name
	if entry.realm and entry.realm ~= "" then
		displayName = displayName .. "-" .. entry.realm
	end

	local where = context or "nearby"
	self:PlayBlacklistAlert()
	self:Print("|cffff4444BLACKLIST ALERT|r (" .. where .. "): |cffffcc00" .. displayName .. "|r")
	local note = entry.note
	if note and note ~= "" then
		self:Print("Note: " .. note)
	else
		self:Print("Note: (no note)")
	end
end

function LS:CheckPlayerName(fullName, context)
	if not fullName or fullName == "" then
		return
	end
	local entry = self:FindBlacklistEntry(fullName)
	if entry then
		self:AlertBlacklist(fullName, entry, context)
	end
end

function LS:CheckPlayerUnit(unit, context)
	if not UnitExists(unit) then
		return
	end
	if UnitIsPlayer and not UnitIsPlayer(unit) then
		return
	end
	local name = UnitName(unit)
	self:CheckPlayerName(name, context)
end

function LS:ScanForBlacklistedPlayers()
	if not self:IsBlacklistEnabled() then
		return
	end

	self:CheckPlayerUnit("target", "target")

	local numRaid = GetNumRaidMembers and GetNumRaidMembers() or 0
	if numRaid > 0 then
		for i = 1, numRaid do
			local raidName = GetRaidRosterInfo(i)
			if raidName then
				self:CheckPlayerName(raidName, "raid")
			end
		end
		return
	end

	local numParty = GetNumPartyMembers and GetNumPartyMembers() or 0
	for i = 1, numParty do
		self:CheckPlayerUnit("party" .. i, "party")
		local partyName = UnitName("party" .. i)
		if partyName then
			self:CheckPlayerName(partyName, "party")
		end
	end
end

function LS:ScheduleBlacklistScan()
	if not scanDelayFrame then
		scanDelayFrame = CreateFrame("Frame")
	end
	scanDelayFrame.elapsed = 0
	scanDelayFrame:SetScript("OnUpdate", function(self, elapsed)
		self.elapsed = self.elapsed + elapsed
		if self.elapsed < SCAN_DELAY then
			return
		end
		self:SetScript("OnUpdate", nil)
		LS:ScanForBlacklistedPlayers()
	end)
end

function LS:HandleBlacklistSlash(msg)
	msg = self:Trim(msg or "")
	if msg == "" then
		self:ToggleUI()
		if self.frame and self.UI then
			self.UI:ShowTab(self.frame, "blacklist")
		end
		return
	end

	local cmd = string.match(msg, "^(%S+)") or ""
	local rest = self:Trim(string.sub(msg, string.len(cmd) + 1))
	cmd = string.lower(cmd)

	if cmd == "add" or cmd == "addtarget" then
		local name, realm
		local note = ""
		if cmd == "addtarget" or (cmd == "add" and rest == "" and UnitExists("target") and (not UnitIsPlayer or UnitIsPlayer("target"))) then
			name, realm = self:GetTargetPlayer()
		elseif UnitExists("target") and (not UnitIsPlayer or UnitIsPlayer("target")) then
			name, realm = self:GetTargetPlayer()
			note = rest
		else
			local splitAt = string.find(rest, "%s")
			if splitAt then
				name, realm = self:ParsePlayerInput(string.sub(rest, 1, splitAt - 1))
				note = self:Trim(string.sub(rest, splitAt + 1))
			else
				name, realm = self:ParsePlayerInput(rest)
			end
		end
		if not name then
			self:Print("Usage: /lu bl add <name> [note]  or target someone and /lu bl add [note]")
			return
		end
		local ok, err = self:AddBlacklistPlayer(name, realm, note)
		if ok then
			self:Print("Blacklisted " .. name .. (realm and realm ~= "" and ("-" .. realm) or "") .. ".")
		else
			self:Print(err or "Could not add player.")
		end
		return
	end

	if cmd == "remove" or cmd == "del" then
		if rest == "" then
			self:Print("Usage: /lu bl remove <name>")
			return
		end
		local name, realm = self:ParsePlayerInput(rest)
		if not name then
			self:Print("Could not parse player name.")
			return
		end
		local key = self:NormalizePlayerKey(name, realm)
		if self:RemoveBlacklistPlayer(key) then
			self:Print("Removed " .. name .. " from blacklist.")
		else
			self:Print("Player not found on blacklist.")
		end
		return
	end

	if cmd == "scan" or cmd == "test" then
		self:Print("Blacklist enabled: " .. tostring(self:IsBlacklistEnabled()) .. ", entries: " .. table.getn(self:GetBlacklistList()))
		for _, entry in ipairs(self:GetBlacklistList()) do
			self:Print("  " .. (entry.key or "?") .. " => " .. (entry.name or "?") .. " — " .. (entry.note or ""))
		end
		if UnitExists("target") then
			local tname = UnitName("target")
			self:Print("Target: " .. tostring(tname) .. " | match: " .. tostring(self:FindBlacklistEntry(tname) ~= nil))
		end
		self:ScanForBlacklistedPlayers()
		return
	end

	self:Print("Blacklist: /lu bl | add <name> [note] | add (with target) [note] | remove <name> | test")
end

function LS:InitBlacklist()
	if self.blacklistInitialized then
		return
	end
	self.blacklistInitialized = true

	if not self.db.blacklist then
		self.db.blacklist = {}
	end
	if self.CopyDefaults then
		self.CopyDefaults(self.blacklistDefaults, self.db.blacklist)
	end
	if self.db.blacklist.enabled == nil then
		self.db.blacklist.enabled = true
	end

	if not alertFrame then
		alertFrame = CreateFrame("Frame")
		alertFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
		alertFrame:RegisterEvent("PARTY_MEMBERS_CHANGED")
		alertFrame:RegisterEvent("RAID_ROSTER_UPDATE")
		alertFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
		alertFrame:SetScript("OnEvent", function(_, event)
			if event == "PLAYER_ENTERING_WORLD" then
				LS:ScheduleBlacklistScan()
			else
				LS:ScheduleBlacklistScan()
			end
		end)
	end

	self:ScheduleBlacklistScan()
end

function LS:RefreshBlacklistUI()
	if self.frame and self.frame.blacklistPanel then
		self.UI:RefreshBlacklistPanel(self.frame.blacklistPanel)
	end
end
