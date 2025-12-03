-- add an anti-cheat, devs
prefix = "-"

game.TextChatService.MessageReceived:Connect(function(tbl)
    task.wait(0)
    local msg

    if not tbl.TextSource then return end
    local player = game:GetService("Players"):GetPlayerByUserId(tbl.TextSource.UserId)
    if not player then return end
    if player ~= game.Players.LocalPlayer then return end
    msg = tbl.Text

    if string.sub(msg:lower(), 1, #prefix + 6) == prefix..'vision' then
           show_em()
    end
end)

function show_em()
for _, child in pairs(workspace:GetChildren()) do
    local glassWeak = child:FindFirstChild("glass_weak")
    if glassWeak then
        local glassPanel = glassWeak:FindFirstChild("glass_panel_weak")
        if glassPanel and glassPanel:IsA("BasePart") then
            glassPanel.BrickColor = BrickColor.new("Bright red")
        end
    end
end 

for _, child in pairs(workspace:GetChildren()) do
    local glassTempered = child:FindFirstChild("glass_tempered")
    if glassTempered then
        local glassPanel = glassTempered:FindFirstChild("glass_panel")
        if glassPanel and glassPanel:IsA("BasePart") then
            glassPanel.BrickColor = BrickColor.new("Bright green")
        end
    end
end
end

game.Players.LocalPlayer:GetMouse().KeyDown:connect(function(key)
        task.wait(0)
        if key:lower() == "k" then
                	show_em()
        end
end)
