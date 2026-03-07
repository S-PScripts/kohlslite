--[[
	https://scriptblox.com/script/Prison-Life-Use-laugh-and-dance2-111673
]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local emoteIds = {
    laugh = 129423131,
    dance2 = 182436842
}

local currentTrack = nil
local connections = {}

local function stopCurrentEmote()
    if currentTrack then
        currentTrack:Stop(0.1)
        currentTrack = nil
    end
end

local function playEmote(emoteName)
    stopCurrentEmote()
    
    local emoteId = emoteIds[emoteName:lower()]
    if not emoteId then return end
    
    local char = player.Character
    if not char then return end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://" .. emoteId
    
    local track = hum:LoadAnimation(anim)
    track.Priority = Enum.AnimationPriority.Action4
    track.Looped = (emoteName:lower() == "dance2")
    
    track:Play(0.1)
    currentTrack = track
    
    anim:Destroy()
end

local function cleanupConnections()
    for _, conn in ipairs(connections) do
        conn:Disconnect()
    end
    connections = {}
end

local function setupInterrupts(char)
    cleanupConnections()
    
    local hum = char:WaitForChild("Humanoid", 8)
    if not hum then return end
    
    table.insert(connections, hum.Running:Connect(function(speed)
        if speed > 0.1 then
            stopCurrentEmote()
        end
    end))
    
    table.insert(connections, hum.StateChanged:Connect(function(oldState, newState)
        if newState == Enum.HumanoidStateType.Jumping or
           newState == Enum.HumanoidStateType.Freefall or
           newState == Enum.HumanoidStateType.FallingDown or
           newState == Enum.HumanoidStateType.Dead or
           newState == Enum.HumanoidStateType.Swimming then
            stopCurrentEmote()
        end
    end))
    
    table.insert(connections, RunService.Heartbeat:Connect(function()
        if hum.MoveDirection.Magnitude > 0.05 or hum:GetState() ~= Enum.HumanoidStateType.Running then
            stopCurrentEmote()
        end
    end))
end

player.CharacterAdded:Connect(setupInterrupts)

if player.Character then
    setupInterrupts(player.Character)
end

player.Chatted:Connect(function(message)
    local lower = message:lower()
    local emote = lower:match("^/e%s+(%w+)")
    if emote and emoteIds[emote:lower()] then
        playEmote(emote)
    end
end)
