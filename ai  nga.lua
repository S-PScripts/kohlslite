-- idk


local function handleChat(tbl)
    task.wait(0)

    if tbl.TextSource then
        local player = game:GetService("Players"):GetPlayerByUserId(tbl.TextSource.UserId)
        if not player then return end
        if player ~= game.Players.LocalPlayer then return end

        local msg = tbl.Text

        if string.sub(msg:lower(), 1, #prefix + 5) == prefix..'kcmds' then
            CMDPrint()
            Remind("Check your console by running /console!")
        end

    end
end

game.TextChatService.MessageReceived:Connect(handleChat)

local function Chat(msg)
    local fakeMsg = {
        Text = msg,
        TextSource = {
            UserId = game.Players.LocalPlayer.UserId
        }
    }

    handleChat(fakeMsg)
end
