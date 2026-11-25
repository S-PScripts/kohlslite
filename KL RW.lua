-- KohlsLiteRW

local SCRIPTNAME = "KOHLSLITE"
local KLVERSION = "alpha v1"

Players = game:GetService("Players")
TextChatService = game:GetService("TextChatService")
RunService = game:GetService("RunService")
StarterGui = game:GetService("StarterGui")
LocalPlayer = Players.LocalPlayer

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

local activeConnections = {}

function isWhitelisted(plr)
	return plr == LocalPlayer or table.find(ag_settings.gearWhitelisted, plr.Name) ~= nil
end

function check_antigear(plr)
	if isWhitelisted(plr) then return end
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
			if charOwner and isWhitelisted(charOwner) then
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
	
local PREFIX = "."
local commands = {}

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

function addcmd(config)
    commands[config.name:lower()] = config
    
    if config.alias then
        for _, aliasName in ipairs(config.alias) do
            commands[aliasName:lower()] = config
        end
    end
end

addcmd {
    name = "test",
    alias = {"cmdtest", "testcmd"},
    description = "Prints test message",
    func = function(sender, args)
        print("test")
        if args[1] then
            print(args[1].. " is here!")
        end
    end
}

addcmd {
    name = "notify",
    alias = {"remind"},
    description = "Notify test message",
    func = function(sender, args)
        notify("test")
        if args[1] then
            notify(args[1].. " is here!")
        end
    end
}

addcmd {
    name = "kick",
    alias = {"selfkick"},
    description = "Kick yourself from the game",
    func = function(sender, args)
        local mk = prompt("Kick yourself from the game?")
		if mk then
			LocalPlayer:Kick(args[1] or "You have been kicked.")
		end
    end
}

addcmd {
    name = "cmds",
    alias = {"cmdlist"},
    description = "Prints command list",
    func = function(sender, args)
		for _, v in commands do
			if _ == v.name:lower() then
				print(v.name .. " - " .. v.description)
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
