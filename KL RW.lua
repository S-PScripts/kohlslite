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
	antigear = false,		-- prevent players from using any tool unless gear whitelisted
	blGears = false, 		-- prevent players from using tools in bannedGears unless gear whitelisted (if enabled)
	bannedGears = {			-- gears that are not allowed
		"VampireVanquisher",
		"testing"
	},
	gearWhitelisted = {} 	-- bypass antigear and blGears
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
	if not (ag_settings.antigear or ag_settings.blGears) then return end

	local backpack = plr:FindFirstChild("Backpack")
	local char = plr.Character
	
	local bpTool = backpack and backpack:FindFirstChildOfClass("Tool")
	local chTool = char and char:FindFirstChildOfClass("Tool")
	
	if ag_settings.antigear then
		if bpTool or chTool then
			Chat("ungear " .. plr.Name)
			notify(plr.Name .. " triggered anti-gear.")
			print(plr.Name .. " triggered anti-gear.")
			return
		end
	end

	if ag_settings.blGears then
		if backpack then
			for _, item in ipairs(backpack:GetChildren()) do
				if item:IsA("Tool") and table.find(ag_settings.bannedGears, item.Name) then
					Chat("ungear " .. plr.Name)
					notify(plr.Name .. " had a blacklisted tool: " .. item.Name)
					print(plr.Name .. " had a blacklisted tool: " .. item.Name)
					return
				end
			end
		end

		if char then
			for _, item in ipairs(char:GetChildren()) do
				if item:IsA("Tool") and table.find(ag_settings.bannedGears, item.Name) then
					Chat("ungear " .. plr.Name)
					notify(plr.Name .. " had a blacklisted tool: " .. item.Name)
					print(plr.Name .. " had a blacklisted tool: " .. item.Name)
					return
				end
			end
		end
	end
end

function setupPlayer(plr)
	if plr == LocalPlayer then return end
	
	destroyPlayer(plr)
	activeConnections[plr] = {}

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

function destroyPlayer(plr)
	if activeConnections[plr] then
		for _, conn in ipairs(activeConnections[plr]) do
			conn:Disconnect()
		end
		activeConnections[plr] = nil
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
				notify("Tool found on workspace with anti-gear on.")
				print("Tool found on workspace with anti-gear on.")
				return
			end
			if ag_settings.blGears and table.find(ag_settings.bannedGears, obj.Name) then
				Chat("ungear others"); Chat("clr")
				notify("Blacklisted tool found on workspace: " .. obj.Name)
				print("Blacklisted tool found on workspace: " .. obj.Name)
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
