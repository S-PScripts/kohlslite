-- KohlsLiteRW

Players = game:GetService("Players")
TextChatService = game:GetService("TextChatService")
LocalPlayer = Players.LocalPlayer

local PREFIX = "."
local commands = {}

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
