-- MAIN VARIABLES --
getgenv().espsettings = {
    ESP = false,
    ESPTeamCheck = { Criminals = true, Guards = true, Inmates = true }, -- teams that will show up in ESP
    names = true, -- show names of players in ESP
    health = true, -- show health of players in ESP
    distance = true, -- show distance player is away from you in ESP
    boxcolors = true, -- use team colour for ESP boxes (off = white)
    namecolors = true -- use team colour for ESP text (off = white)
}

getgenv().aimlock = {
    Aimbot = false,
    TeamCheck = { Criminals = false, Guards = false, Inmates = false }, -- teams aimlock will lock onto
    Target = { Torso = false, Head = true }, -- what part of the player aimbot should toggle

   --[[ ESP = false,
    ESPTeamCheck = { Criminals = false, Guards = false, Inmates = false } ]]
}

getgenv().aballowedguns = {
    ["AK-47"] = true, ["FAL"] = true, ["M4A1"] = true,
    ["M9"] = true, ["MP5"] = true, ["Remington 870"] = true,
    ["Taser"] = true
}

-- VARIABLE SETUP --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ESP --
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

local function makethething()
    local showNames = getgenv().espsettings.names
    local showHealth = getgenv().espsettings.health
    local showDistance = getgenv().espsettings.distance

    local playerName = player.Name
    local playerHealth = math.floor(humanoid.Health)
    local playerDistance = math.floor((root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)

    local labelText = ""

    if showNames then
        labelText = labelText .. playerName
    end

    if showHealth then
        if labelText ~= "" then
            labelText = labelText .. " | "
        end
        labelText = labelText .. "Health: " .. playerHealth
    end

    if showDistance then
        if labelText ~= "" then
            labelText = labelText .. " | "
        end
        labelText = labelText .. "Distance: " .. playerDistance
    end

    return labelText
end

-- Create ESP for a player
local function createESP(player)
    if not espsettings.ESP then return end

    if not espsettings.ESPTeamCheck.Criminals and player.Team and player.Team.Name == "Criminals" then return end
    if not espsettings.ESPTeamCheck.Guards and player.Team and player.Team.Name == "Guards" then return end
    if not espsettings.ESPTeamCheck.Inmates and player.Team and player.Team.Name == "Inmates" then return end
    
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
            if getgenv().espsettings.boxcolors then
                box.Color3 = player.TeamColor.Color
            else
                box.Color3 = Color3.new(1, 1, 1)
            end
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
    if getgenv().espsettings.namecolors then
        textLabel.TextColor3 = player.TeamColor.Color
    else
        textLabel.TextColor3 = Color3.new(1, 1, 1)
    end
    textLabel.TextStrokeTransparency = 0
    textLabel.TextScaled = false
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 14
    
    textLabel.Text = makethething()
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
        local ncolor =  getgenv().espsettings.namecolors and player.TeamColor.Color or Color3.new(1, 1, 1)
        local bcolor =  getgenv().espsettings.boxcolors and player.TeamColor.Color or Color3.new(1, 1, 1)
        if espObjects[player].textLabel then
            espObjects[player].textLabel.TextColor3 = ncolor
        end
        if espObjects[player].limbs then
            for _, box in pairs(espObjects[player].limbs) do
                if box then box.Color3 = bcolor end
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
local function renderStepFunction()
    if not espsettings.ESP then return end
    if next(espObjects) == nil then return end

    local localChar = LocalPlayer.Character
    if not localChar then return end

    local localRoot = localChar:FindFirstChild("HumanoidRootPart")
    if not localRoot then return end

    for player, data in pairs(espObjects) do
        local root = data.root
        local humanoid = data.humanoid
        local label = data.textLabel

        if root and humanoid and label then
            local distance = (root.Position - localRoot.Position).Magnitude
            label.Text = makethething()
        end
    end
end

renderConnection = RunService.RenderStepped:Connect(renderStepFunction)

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
    local lastState = espsettings.ESP
    while true do
        wait(0.1)
        if espsettings.ESP ~= lastState then
            lastState = espsettings.ESP
            if not espsettings.ESP then
                cleanupESP()
            else
                enableESPForAll() -- <-- Apply ESP to currently alive players immediately
                if not renderConnection then
                    renderConnection = RunService.RenderStepped:Connect(renderStepFunction)
                end
            end
        end
    end
end)

-- AIMLOCK --
local function holdingValidGun()
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    return tool and aballowedguns[tool.Name] or false
end

local ESP_Folder = Instance.new("Folder")
ESP_Folder.Name = "ESP_Storage"
ESP_Folder.Parent = CoreGui

local function validTeam(plr)
    if not aimlock.TeamCheck.Criminals and plr.Team and plr.Team.Name == "Criminals" then return false end
    if not aimlock.TeamCheck.Guards and plr.Team and plr.Team.Name == "Guards" then return false end
    if not aimlock.TeamCheck.Inmates and plr.Team and plr.Team.Name == "Inmates" then return false end
    return true
end

local function getTargetPart(char)
    local hum = char:FindFirstChild("Humanoid")
    if not hum or hum.Health <= 0 then return nil end
    if aimlock.Target.Head and char:FindFirstChild("Head") then return char.Head end
    if aimlock.Target.Torso and char:FindFirstChild("Torso") then return char.Torso end
    return nil
end

local function getClosestScreenTarget()
    local best, bestDist = nil, math.huge
    local mousePos = UIS:GetMouseLocation()

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and validTeam(plr) then
            local part = getTargetPart(plr.Character)
            if part then
                local pos, visible = Camera:WorldToViewportPoint(part.Position)
                if visible then
                    local diff = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude

                    local rpc = RaycastParams.new()
                    rpc.FilterType = Enum.RaycastFilterType.Blacklist
                    rpc.FilterDescendantsInstances = {LocalPlayer.Character}

                    local ray = Workspace:Raycast(Camera.CFrame.Position, part.Position - Camera.CFrame.Position, rpc)

                    if not ray or (ray.Instance and ray.Instance:IsDescendantOf(plr.Character)) then
                        if diff < bestDist then
                            bestDist = diff
                            best = plr.Character
                        end
                    end
                end
            end
        end
    end
    return best
end

RunService.RenderStepped:Connect(function()
    if aimlock.Aimbot and holdingValidGun() then
        local target = getClosestScreenTarget()
        if target then
            local part = getTargetPart(target)
            if part then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)
            end
        end
    end
end)

--[[
local function teamAllowed(plr)
    if not plr.Team then return false end
    if plr.Team.Name == "Criminals" and aimlock.ESPTeamCheck.Criminals then return true end
    if plr.Team.Name == "Guards" and aimlock.ESPTeamCheck.Guards then return true end
    if plr.Team.Name == "Inmates" and aimlock.ESPTeamCheck.Inmates then return true end
    return false
end

local function teamColor(plr)
    if not plr.Team then return Color3.new(1,1,1) end
    if plr.Team.Name == "Criminals" then return Color3.fromRGB(255,0,0) end
    if plr.Team.Name == "Guards" then return Color3.fromRGB(0,120,255) end
    if plr.Team.Name == "Inmates" then return Color3.fromRGB(255,140,0) end
    return Color3.new(1,1,1)
end

local function getHighlight(plr)
    local h = ESP_Folder:FindFirstChild(plr.Name)
    if h then return h end
    local Highlight = Instance.new("Highlight")
    Highlight.Name = plr.Name
    Highlight.Parent = ESP_Folder
    return Highlight
end

local function removeHighlight(plr)
    local h = ESP_Folder:FindFirstChild(plr.Name)
    if h then h:Destroy() end
end

Players.PlayerRemoving:Connect(removeHighlight)

RunService.RenderStepped:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChild("Humanoid")

            local teste = true
            if hrp or hum or hum.Health >= 0 then 
                --
            else
                removeHighlight(plr); teste = false
            end
                
            if aimlock.ESP then 
                --
            else
                removeHighlight(plr); teste = false
            end
                
            if teamAllowed(plr) then 
                --
            else
                removeHighlight(plr); teste = false
            end

            if teste then
                local h = getHighlight(plr)
                h.Adornee = plr.Character

                local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
                h.OutlineColor = dist <= 25 and Color3.new(1,1,1) or Color3.new(0,0,0)
                h.FillColor = teamColor(plr)
                h.FillTransparency = 0.5
                h.OutlineTransparency = 0
            else
                --
            end
        end
    end
end)
]]
