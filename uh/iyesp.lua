-- ESP.lua
return function()
-- LocalScript in StarterPlayerScripts
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local espObjects = {}

-- Wait until character has necessary parts
local function waitForCharacterParts(char)
    local head = char:WaitForChild("Head", 5)
    local root = char:WaitForChild("HumanoidRootPart", 5)
    local humanoid = char:FindFirstChildWhichIsA("Humanoid")
    if head and root and humanoid then
        return head, root, humanoid
    else
        return nil, nil, nil
    end
end

-- Create ESP for a player
local function createESP(player)
    if player == LocalPlayer then return end -- Do not highlight yourself
    removeESP(player) -- Remove previous ESP if exists

    local char = player.Character
    if not char then return end

    local head, root, humanoid = waitForCharacterParts(char)
    if not head or not root or not humanoid then return end

    local partsToHighlight = {}
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            table.insert(partsToHighlight, part)
        end
    end

    local limbESP = {}
    for _, part in pairs(partsToHighlight) do
        local box = Instance.new("BoxHandleAdornment")
        box.Adornee = part
        box.Size = part.Size
        box.Color3 = player.TeamColor.Color
        box.Transparency = 0.5
        box.AlwaysOnTop = true
        box.ZIndex = 1
        box.Parent = part
        table.insert(limbESP, box)
    end

    -- BillboardGui for name + health + distance
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPName"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 150, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = player.TeamColor.Color
    textLabel.TextStrokeTransparency = 0
    textLabel.TextScaled = false
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 14
    textLabel.Text = player.Name
    textLabel.Parent = billboard
    billboard.Parent = char

    espObjects[player] = {
        billboard = billboard,
        limbs = limbESP,
        textLabel = textLabel,
        humanoid = humanoid,
        root = root
    }

    -- Update health dynamically
    humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if espObjects[player] then
            local distance = math.floor((root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
            espObjects[player].textLabel.Text = string.format("%s | Health: %d | Distance: %d", player.Name, humanoid.Health, distance)
        end
    end)
end

-- Remove ESP
function removeESP(player)
    if espObjects[player] then
        if espObjects[player].billboard then
            espObjects[player].billboard:Destroy()
        end
        if espObjects[player].limbs then
            for _, box in pairs(espObjects[player].limbs) do
                if box then box:Destroy() end
            end
        end
        espObjects[player] = nil
    end
end

-- Update ESP color (team changes)
local function updateESPColor(player)
    if espObjects[player] then
        local color = player.TeamColor.Color
        if espObjects[player].textLabel then
            espObjects[player].textLabel.TextColor3 = color
        end
        if espObjects[player].limbs then
            for _, box in pairs(espObjects[player].limbs) do
                if box then box.Color3 = color end
            end
        end
    end
end

-- Setup player ESP
local function setupPlayer(player)
    player.CharacterAdded:Connect(function()
        createESP(player)
    end)
    player:GetPropertyChangedSignal("TeamColor"):Connect(function()
        updateESPColor(player)
    end)
    if player.Character then
        createESP(player)
    end
end

-- Connect players
Players.PlayerAdded:Connect(setupPlayer)
Players.PlayerRemoving:Connect(removeESP)

-- Initialize existing players
for _, player in pairs(Players:GetPlayers()) do
    setupPlayer(player)
end

-- Update distances every frame
local renderConnection
renderConnection = RunService.RenderStepped:Connect(function()
    local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot then return end

    for player, data in pairs(espObjects) do
        if data.root and data.humanoid and data.textLabel then
            local distance = math.floor((data.root.Position - localRoot.Position).Magnitude)
            data.textLabel.Text = string.format("%s | Health: %d | Distance: %d", player.Name, data.humanoid.Health, distance)
        end
    end
end)

-- Return cleanup function so you can toggle ESP off
return function()
    if renderConnection then
        renderConnection:Disconnect()
    end
    for player, _ in pairs(espObjects) do
        removeESP(player)
    end
end
