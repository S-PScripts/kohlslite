local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local hookedTools = {}

local tools = {
    ["M4A1"] = {
        ReloadSound = "rbxassetid://142491708",
        ShootSound   = "rbxassetid://150544849"
    },
    ["AK-47"] = {
        ReloadSound = "rbxassetid://142491708",
        ShootSound   = "rbxassetid://153230498"
    },
    ["M9"] = {
        ReloadSound = "rbxassetid://138084889",
        ShootSound   = "rbxassetid://134436500"
    },
    ["Remington 870"] = {
        ReloadSound = "rbxassetid://145081845",
        ShootSound   = "rbxassetid://138083993"
    },
    ["M700"] = {
        ReloadSound = "rbxassetid://97852355",
        ShootSound   = "rbxassetid://406722373"
    },
    ["MP5"] = {
        ReloadSound = "rbxassetid://142491708",
    },
    ["FAL"] = {
        ReloadSound = "rbxassetid://142491708",
    },
}

RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char then return end

    for toolName, sounds in pairs(tools) do
        local tool = char:FindFirstChild(toolName)
        if tool and not hookedTools[tool] then
            hookedTools[tool] = true

            -- Hook new sounds dynamically
            tool.DescendantAdded:Connect(function(obj)
                if obj:IsA("Sound") then
                    for soundName, id in pairs(sounds) do
                        if obj.Name == soundName then
                            obj.SoundId = id
                        end
                    end
                end
            end)

            -- Update existing sounds immediately
            for _, obj in ipairs(tool:GetDescendants()) do
                if obj:IsA("Sound") then
                    for soundName, id in pairs(sounds) do
                        if obj.Name == soundName then
                            obj.SoundId = id
                        end
                    end
                end
            end
        end
    end
end)
