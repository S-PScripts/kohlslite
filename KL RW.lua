-- KohlsLiteRW by TS2021
-- For Kohls Admin House X
-- How KohlsLite should have been if I was smart
-- NOTE: This will NOT be a full remake as that would genuinely take MONTHS

if not game:IsLoaded() then game.Loaded:Wait() end

local SCRIPTNAME = "KOHLSLITE"
local KLVERSION = "RW"
local PREFIX = "."

-- SERVICES
Players = game:GetService("Players")
TextChatService = game:GetService("TextChatService")
RunService = game:GetService("RunService")
StarterGui = game:GetService("StarterGui")
LocalPlayer = Players.LocalPlayer

local activeConnections = {}

-- anti gear settings
local ag_settings = {
	antigear = false,		-- prevent players from using any tool unless contained in whiteListedGears
	blgears = false, 		-- prevent players from using tools in bannedGears 
	bannedGears = {			-- gears that are not allowed to be used (when blgears is enabled)
		"VampireVanquisher",
		"testing"
	},
	whiteListedGears = {    -- gears that are allowed to be used even when antigear is true
		"LinkedSword",
		"testing2"
	},
	gearWhitelisted = {}, 	-- players who bypass antigear and blgears
	aglogs = true,          -- prints + notifies when gearban triggered
}

local msettings = {
	joinlogs = true, 		-- join/leave logs
}

local main_frame = {
	legacyBehaviour = true  -- in this refactor it will not be coded as 'antigear and unantigear', just 'antigear true/false'
}

-- Anti-X lists
local antis_applied = {
	antijail = {},
	antipunish = {},
	antikill = {},
}

function prompt(msg)
    local choice = nil
    local response = Instance.new("BindableFunction")

    function response.OnInvoke(answer)
        choice = (answer == "Yes")
    end

    StarterGui:SetCore("SendNotification", {
        Title = SCRIPTNAME .. " Manager",
        Text = msg,
        Duration = math.huge,
        Callback = response,
        Button1 = "Yes",
        Button2 = "No"
    })

    repeat task.wait() until choice ~= nil

    response:Destroy()
    return choice
end
	
function notify(msg, time)
    game.StarterGui:SetCore("SendNotification", {
                Title = SCRIPTNAME.. " " .. KLVERSION,
                Text = msg,
                Duration = time or 1
     })
end

function Chat(msg)
	TextChatService.TextChannels.RBXGeneral:SendAsync(msg)
end

local commands = {}
function addcmd(config)
    commands[config.name:lower()] = config
    
    if config.alias then
        for _, aliasName in ipairs(config.alias) do
            commands[aliasName:lower()] = config
        end
    end
end

local function getPlayer(plr)
	plr = plr:lower()
	local players = Players:GetPlayers()

	for _, v in ipairs(players) do -- exact username match
		if v.Name:lower() == plr or v.DisplayName:lower() == plr then
			return v
		end
	end

	for _, v in ipairs(players) do -- partial username match
		if string.sub(v.Name:lower(), 1, #plr) == plr then
			return v
		end
	end

	for _, v in ipairs(players) do -- partial display name match
		if string.sub(v.DisplayName:lower(), 1, #plr) == plr then
			return v
		end
	end

	return nil
end

function parse_boolean(bol)
	if type(bol) ~= "string" then return nil end
	bol = bol:lower()
	
	if bol == "true" or bol == "enabled" or bol == "on" then
		return true
	elseif bol == "false" or bol == "disabled" or bol == "off" then
		return false
	end
	return nil
end

addcmd {
    name = "gearwhitelist",
	name_arg = "gearwhitelist <player>",
    alias = {"gearwl", "gwl"},
    description = "Gear-whitelist a player",
    func = function(sender, args)
        if not args[1] then return notify("Enter the username or display name of the player to whitelist.") end
		
		local RealPlr = getPlayer(args[1])
		if not RealPlr then return notify("Unable to find player starting with: ".. args[1]) end
		if RealPlr == LocalPlayer then return notify("You don't need to whitelist yourself as you are whitelisted by default.") end
				
		if not isGearWL(RealPlr) then
			table.insert(ag_settings.gearWhitelisted, RealPlr.Name)
			notify(RealPlr.Name .. " has been whitelisted.")
		else
			notify(RealPlr.Name .. " is already gear-whitelisted.")
		end
    end
}

addcmd {
    name = "ungearwhitelist",
	name_arg = "ungearwhitelist <player>",
    alias = {"ungearwl", "ungwl"},
    description = "Remove gear-whitelist from a player",
    func = function(sender, args)
        if not args[1] then return notify("Enter the username or display name of the player to un-whitelist.") end
		
		local RealPlr = getPlayer(args[1])
		if not RealPlr then return notify("Unable to find player starting with: ".. args[1]) end
		if RealPlr == LocalPlayer then return notify("You cannot un-whitelist yourself.") end

		local idx = table.find(ag_settings.gearWhitelisted, RealPlr.Name)
		if idx then
			table.remove(ag_settings.gearWhitelisted, idx)
			notify(RealPlr.Name .. " has been un-whitelisted.")
			check_antigear(RealPlr)
		else
			notify(RealPlr.Name .. " is not already gear-whitelisted.")
		end
    end
}

addcmd {
    name = "gearban",
	name_arg = "gearban <player>",
    alias = {"gban"},
    description = "Prevents a player using tools via the Portable Justice",
    func = function(sender, args)
		if not args[1] then return notify("Enter the username or display name of the player to gearban.") end

		local RealPlr = getPlayer(args[1])
		if not RealPlr then return notify("Unable to find player starting with: ".. args[1]) end
		if RealPlr == LocalPlayer then 
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
			notify("You have been gearbanned.")
		else
			if StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack) == false then
				return notify("Ungearban yourself BEFORE trying to gearban someone.")
			end
			gearban_player(RealPlr)
		end
	end
}

addcmd {
    name = "ungearban",
	name_arg = "ungearban <player>",
    alias = {"ungb", "ungban"},
    description = "Ungearbans a player via the Dagger Of Shattered Dimensions",
	func = function(sender, args)
		if not args[1] then return notify("Enter the username or display name of the player to ungearban.") end

		local RealPlr = getPlayer(args[1])
		if not RealPlr then return notify("Unable to find player starting with: ".. args[1]) end
		if RealPlr == LocalPlayer then 
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
			notify("You have been ungearbanned.")
		else
			if StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack) == false then
				return notify("Ungearban YOURSELF before trying to ungearban someone.")
			end
			ungearban_player(RealPlr)
		end
	end
}

addcmd {
    name = "joinlogs",
	name_arg = "joinlogs <true/false>",
    alias = {"jlogs"},
    description = "Enables/disables join/leave logs",
	func = function(sender, args)
		local att = parse_boolean(args and args[1])

		if att ~= nil then
			if att == msettings.jlogs then
				return notify("Join logs has already been " .. (msettings.jlogs and "enabled" or "disabled"))
			end
			msettings.jlogs = att
			notify("Join logs has been " .. (msettings.jlogs and "enabled" or "disabled"))
		elseif main_frame.legacyBehaviour then
			msettings.jlogs = not ag_settings.aglogs
			notify("Join logs has been " .. (msettings.jlogs and "enabled" or "disabled"))
		else
			notify("Please add the 2nd argument: true/false")
		end
	end
}

-- i don't want this to be 2000 lines of code like how kl was
function resolve_targets(sender, target_str)
	if not target_str or target_str == "me" then
		return {sender}
	elseif target_str == "all" then
		return Players:GetPlayers()
	elseif target_str == "others" then
		local list = {}
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= sender then
				table.insert(list, p)
			end
		end
		return list
	else
		local found = getPlayer(target_str)
		return found and {found} or nil
	end
end

function reg_plr_anti(anti_type, aliases)
	local key = "anti" .. anti_type:lower()

	addcmd {
		name = key,
		name_arg = key .. " <player/all/others> <true/false>",
		alias = aliases or {},
		description = "Adds or removes " .. key .. " on player(s)",
		func = function(sender, args)
			local list = antis_applied[key]
			local arg1 = args and args[1] and args[1]:lower()
			local arg2 = args and args[2] and args[2]:lower()

			local target_str = "me"
			local state = nil

			local arg1_bool = parse_boolean(arg1)
			if arg1_bool ~= nil then
				state = arg1_bool
			elseif arg1 then
				target_str = arg1
				if arg2 then
					state = parse_boolean(arg2)
					if state == nil then
						return notify("Invalid boolean: use true/false")
					end
				end
			end

			local targets = resolve_targets(sender, target_str)
			if not targets or #targets == 0 then
				return notify("Player not found: " .. tostring(target_str))
			end

			local changed = {}
			for _, plr in ipairs(targets) do
				local idx = table.find(list, plr.Name)
				local desired = state

				if desired == nil then
					if not main_frame.legacyBehaviour then
						return notify("Please add the 2nd argument: true/false")
					end
					desired = (idx == nil)
				end

				if desired and not idx then
					table.insert(list, plr.Name)
					table.insert(changed, plr.Name .. " (enabled)")
				elseif not desired and idx then
					table.remove(list, idx)
					table.insert(changed, plr.Name .. " (disabled)")
				end
			end

			if #changed == 0 then
				notify("No changes made (target(s) already in that state)")
			else
				notify(key .. " updated: " .. table.concat(changed, ", "))
			end
		end
	}
end

addcmd {
	name = "anti",
	name_arg = "anti<type> <player/all/others> <true/false>",
	alias = {},
	description = "Adds or removes an anti to a player",
	func = function(sender, args)
		notify("Please specify an anti type (e.g. antikill).")
	end
}

-- power of Gemini
reg_plr_anti("jail")
reg_plr_anti("punish")
reg_plr_anti("kill")

function register_bool_cmd(tbl, key, label, description, aliases, custom_arg)
	local cmd_name = type(key) == "table" and key[1] or key
	local tbl_key  = type(key) == "table" and key[2] or key

	addcmd {
		name = cmd_name,
		name_arg = custom_arg or (cmd_name .. " <true/false>"),
		alias = aliases or {},
		description = description or ("Enables/disables " .. label),
		func = function(sender, args)
			local att = parse_boolean(args and args[1])

			if att ~= nil then
				if att == tbl[tbl_key] then
					return notify(label .. " is already " .. (tbl[tbl_key] and "enabled" or "disabled"))
				end
				tbl[tbl_key] = att
			elseif main_frame.legacyBehaviour then
				tbl[tbl_key] = not tbl[tbl_key]
			else
				return notify("Please add the 2nd argument: true/false")
			end

			notify(label .. " has been " .. (tbl[tbl_key] and "enabled" or "disabled"))
		end
	}
end

register_bool_cmd(ag_settings, "antigear", "Anti-gear", "Enables/disables anti-gear (prevent players from using any tools, unless whitelisted)")
register_bool_cmd(ag_settings, {"bltools", "blgears"}, "Blacklisted tool access", "Enables/disables blacklisted tool access")
register_bool_cmd(ag_settings, {"antigearlogs", "aglogs"}, "Anti gear logs", "Enables/disables anti gear/blacklisted tool logs", {"alogs"}, "alogs <true/false>")

addcmd {
    name = "kick",
	name_arg = "kick",
    alias = {"selfkick"},
    description = "Kick yourself from the game",
    func = function(sender, args)
		local reason = #args > 0 and table.concat(args, " ") or "You have been kicked."
        local mk = prompt("Kick yourself from the game?")
		if mk then
			LocalPlayer:Kick(reason)
		end
    end
}

addcmd {
    name = "cmdlist",
	name_arg = "cmdlist",
    alias = {"cmds"},
    description = "Prints command list",
    func = function(sender, args)
		for _, v in commands do
			if _ == v.name:lower() then
				print(v.name_arg .. " - " .. v.description)
			end
		end
    end
}

TextChatService.MessageReceived:Connect(function(tbl)
    if not tbl.TextSource then return end
    local player = Players:GetPlayerByUserId(tbl.TextSource.UserId)
    if player ~= LocalPlayer then return end
    local msg = tbl.Text

    if msg:sub(1, #PREFIX) ~= PREFIX then return end
    local content = msg:sub(#PREFIX + 1)
	local args = content:split(" ")
	local cmdName = table.remove(args, 1):lower()
	local command = commands[cmdName]

	if command and command.func then
		command.func(player, args)
	end
end)









function isGearWL(plr)
	return plr == LocalPlayer or table.find(ag_settings.gearWhitelisted, plr.Name) ~= nil
end

function check_antigear(plr)
	if isGearWL(plr) then return end
	if not (ag_settings.antigear or ag_settings.blgears) then return end

	local backpack = plr:FindFirstChild("Backpack")
	local char = plr.Character
	
	if backpack then
		for _, item in ipairs(backpack:GetChildren()) do
			if item:IsA("Tool") and table.find(ag_settings.bannedGears, item.Name) and not table.find(ag_settings.whiteListedGears, item.Name) then
				Chat("ungear " .. plr.Name)
				if ag_settings.aglogs then
					notify(plr.Name .. " had a blacklisted tool: " .. item.Name)
					print(plr.Name .. " had a blacklisted tool: " .. item.Name)
				end
				return
			end
		end
	end

	if char then
		for _, item in ipairs(char:GetChildren()) do
			if item:IsA("Tool") and table.find(ag_settings.bannedGears, item.Name) and not table.find(ag_settings.whiteListedGears, item.Name) then
				Chat("ungear " .. plr.Name)
				if ag_settings.aglogs then
					notify(plr.Name .. " had a blacklisted tool: " .. item.Name)
					print(plr.Name .. " had a blacklisted tool: " .. item.Name)
				end
				return
			end
		end
	end
end


function build_gear_bl(plr)
	local function hookBackpack(bp)
		if not bp:IsA("Backpack") then return end
		check_antigear(plr)
		table.insert(activeConnections[plr], bp.ChildAdded:Connect(function(child)
			if child:IsA("Tool") then
				check_antigear(plr)
			end
		end))
	end

	local function hookCharacter(char)
		check_antigear(plr)
		table.insert(activeConnections[plr], char.ChildAdded:Connect(function(child)
			if child:IsA("Tool") then
				check_antigear(plr)
			end
		end))
		
		local bp = plr:FindFirstChildOfClass("Backpack") or plr:WaitForChild("Backpack", 5)
		if bp then hookBackpack(bp) end
	end

	table.insert(activeConnections[plr], plr.CharacterAdded:Connect(hookCharacter))
	if plr.Character then
		task.spawn(hookCharacter, plr.Character)
	end
end

function setupPlayer(plr)
	if plr == LocalPlayer then return end
	if msettings.joinlogs then
		print(plr.Name .. " joined the server.")
		notify(plr.Name .. " joined the server.")
	end

	destroyPlayer(plr)
	activeConnections[plr] = {}

	build_gear_bl(plr)
end

function destroyPlayer(plr)
	if activeConnections[plr] then
		for _, conn in ipairs(activeConnections[plr]) do
			conn:Disconnect()
		end
		activeConnections[plr] = nil
	end

	if msettings.joinlogs then
		print(plr.Name .. " left the server.")
		notify(plr.Name .. " left the server.")
	end
end

for _, v in ipairs(Players:GetPlayers()) do
	setupPlayer(v)
end

plrAdded = Players.PlayerAdded:Connect(setupPlayer)
plrRemoved = Players.PlayerRemoving:Connect(destroyPlayer)

antigear_ws = workspace.DescendantAdded:Connect(function(obj)
	if obj:IsA("Tool") then
		task.defer(function()
			local charOwner = obj.Parent and Players:GetPlayerFromCharacter(obj.Parent)
			if charOwner and isGearWL(charOwner) then
				return
			end

			if ag_settings.antigear then
				Chat("ungear others"); Chat("clr")
				if ag_settings.aglogs then
					notify("Tool found on workspace with anti-gear on.")
					print("Tool found on workspace with anti-gear on.")
				end
				return
			end
			if ag_settings.blgears and table.find(ag_settings.bannedGears, obj.Name) then
				Chat("ungear others"); Chat("clr")
				if ag_settings.aglogs then
					notify("Blacklisted tool found on workspace: " .. obj.Name)
					print("Blacklisted tool found on workspace: " .. obj.Name)
				end
			end
		end)
	end
end)

function gear_role(gearid, gn)
	if not LocalPlayer:FindFirstChildOfClass("Backpack") then return false end
	Chat("gear me ".. gearid)
	local tool = LocalPlayer.Backpack:WaitForChild(gn, 3)
	return tool
end

function gearban_player(plr)
	if not LocalPlayer.Character then return notify("No character found to perform gearban on ".. plr.Name) end				
    local pos = LocalPlayer.Character.HumanoidRootPart.CFrame
		
    local tool = gear_role(82357101, "PortableJustice")
    if not tool then return notify("Time-out in obtaining Portable Justice; do you have admin?") end

	if not plr.Character then return notify(plr.Name .. " is missing Character; cannot perform gearban") end
	Chat("unff " .. plr.Name)
	Chat("speed " ..plr.Name.. " 0")

	LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame

    tool.Parent = LocalPlayer.Character
    tool.MouseClick:FireServer(plr.Character)
    task.wait(1)     
	
	Chat("reload ".. plr.Name)
    tool:Destroy()
    LocalPlayer.Character.HumanoidRootPart.CFrame = pos
    Chat("ungear me")

	notify("Succesfully gearbanned ".. plr.Name)
end

function ungearban_player(plr)
	if not LocalPlayer.Character then return notify("No character found to perform ungearban on ".. plr.Name) end				
    local pos = LocalPlayer.Character.HumanoidRootPart.CFrame

	local tool = gear_role(71037101, "DaggerOfShatteredDimensions")
    if not tool then return notify("Time-out in obtaining DOSD; do you have admin?") end

	if not plr.Character then return notify(plr.Name .. " is missing Character; cannot perform ungearban") end
	Chat("speed " ..plr.Name.. " 0")

	LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame

    tool.Parent = LocalPlayer.Character
    task.wait(0.5)
    LocalPlayer.Character.DaggerOfShatteredDimensions.Remote:FireServer(Enum.KeyCode.Q)
    task.wait(1.5)
	
	Chat("reload ".. plr.Name)
    tool:Destroy()
    LocalPlayer.Character.HumanoidRootPart.CFrame = pos
    Chat("ungear me")

	notify("Succesfully ungearbanned ".. plr.Name)
end

notify(SCRIPTNAME .. KLVERSION .. " EXECUTED SUCCESSFULLY.")
print(SCRIPTNAME .. KLVERSION .. " EXECUTED SUCCESSFULLY.")
print("Prefix: " .. PREFIX)
print("To see the command list, run " .. PREFIX .. "cmdlist")
