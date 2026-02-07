repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")

local localPlayer = Players.LocalPlayer

local TOOL_NAME = "Key card"
local RETRY_DELAY = 0.294

local function findInRS()
    local toolsFolder = RS:FindFirstChild("Tools")
    if not toolsFolder then return nil end

    for _,v in pairs(toolsFolder:GetDescendants()) do
        if v:IsA("Tool") and v.Name == TOOL_NAME then
            return v
        end
    end
end

local function findInOtherPlayers()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= localPlayer then
            local bp = plr:FindFirstChild("Backpack")
            if bp then
                local tool = bp:FindFirstChild(TOOL_NAME)
                if tool and tool:IsA("Tool") then
                    return tool
                end
            end
        end
    end
end

local function run()
    local backpack = localPlayer:WaitForChild("Backpack")

    if backpack:FindFirstChild(TOOL_NAME) then
        return
    end

    local source = findInRS() or findInOtherPlayers()

    if source then
        local clone = source:Clone()
        clone.Parent = backpack
        print("duadrohub")
        return
    end
end

local function startLoop()
    task.spawn(function()
        while true do
            pcall(run)
            task.wait(RETRY_DELAY)
        end
    end)
end

startLoop()

localPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    startLoop()

    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        hum.Died:Connect(function()
            task.wait(0.5)
            startLoop()
        end)
    end
end)
