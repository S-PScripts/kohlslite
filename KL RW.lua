-- KohlsLiteRW

local SCRIPTNAME = "KOHLSLITE"
local KLVERSION = "alpha v1"

Players = game:GetService("Players")
TextChatService = game:GetService("TextChatService")
RunService = game:GetService("RunService")
StarterGui = game:GetService("StarterGui")
LocalPlayer = Players.LocalPlayer

local antigear = false
local bannedGears = {}
local gearWhitelist = {}

bancon = RunService.RenderStepped:Connect(function()
end
	
local PREFIX = "."
local commands = {}

function prompt(msg: string)
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
	
function notify(msg: string, time)
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
