-- Make sure the toggle exists
getgenv().esp = false

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local espObjects = {}
local renderConnection

-- Cleanup function
local function cleanupESP()
    if renderConnection then
        renderConnection:Disconnect()
        renderConnection = nil
    end
    for player, _ in pairs(espObjects) do
        if espObjects[player].billboard then espObjects[player].billboard:Destroy() end
        if espObjects[player].limbs then
            for _, box in pairs(espObjects[player].limbs) do
                if box then box:Destroy() end
            end
        end
    end
    espObjects = {}
end

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

-- Remove ESP for a single player
function removeESP(player)
    if espObjects[player] then
        if espObjects[player].billboard then espObjects[player].billboard:Destroy() end
        if espObjects[player].limbs then
            for _, box in pairs(espObjects[player].limbs) do
                if box then box:Destroy() end
            end
        end
        espObjects[player] = nil
    end
end

-- Create ESP for a player
local function createESP(player)
    if not getgenv().esp then return end
    if player == LocalPlayer then return end
    removeESP(player)

    local char = player.Character
    if not char then return end

    local head, root, humanoid = waitForCharacterParts(char)
    if not head or not root or not humanoid then return end

    -- Highlight all limbs
    local limbESP = {}
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") then
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
    textLabel.Text = string.format("%s | Health: %d | Distance: %d", player.Name, humanoid.Health, math.floor((root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude))
    textLabel.Parent = billboard
    billboard.Parent = char

    espObjects[player] = {
        billboard = billboard,
        limbs = limbESP,
        textLabel = textLabel,
        humanoid = humanoid,
        root = root
    }
end

-- Update ESP color
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

-- Setup player
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

for _, player in pairs(Players:GetPlayers()) do
    setupPlayer(player)
end

-- RenderStepped for distance updates
renderConnection = RunService.RenderStepped:Connect(function()
    if not getgenv().esp then return end

    local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot then return end

    for player, data in pairs(espObjects) do
        local root = data.root
        local humanoid = data.humanoid
        local label = data.textLabel

        if root and humanoid and label then
            local distance = (root.Position - localRoot.Position).Magnitude
            label.Text = string.format("%s | Health: %d | Distance: %d",player.Name,math.floor(humanoid.Health),math.floor(distance))
        end
    end
end)


-- Function to enable ESP for all players
local function enableESPForAll()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            createESP(player)
        end
    end
end

-- Listen for global toggle change
spawn(function()
    local lastState = getgenv().esp
    while true do
        wait(0.1)
        if getgenv().esp ~= lastState then
            lastState = getgenv().esp
            if not getgenv().esp then
                cleanupESP()
            else
                enableESPForAll() -- <-- Apply ESP to currently alive players immediately
            end
        end
    end
end)
