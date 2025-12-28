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
    -- Master switch
    Aimbot = true,

    -- Aim mode
    Mode = "Mouse", -- "Mouse" or "Crosshair"

    -- Team filtering
    TeamCheck = {
        Criminals = true,
        Guards = true,
        Inmates = true
    },

    -- Target part priority
    Target = {
        Head = true,
        Torso = false
    },

    -- Field of View
    FOV = {
        Enabled = true,
        Radius = 200,      -- pixels
        ShowCircle = true,
        Color = Color3.fromRGB(255, 0, 0),
        Rainbow = true
    },

    -- Smoothing (legit vs rage)
    Smooth = {
        Enabled = true,
        Amount = 0.15     -- 0 = instant snap, 1 = very slow
    },

    -- Safety checks
    Checks = {
        Weapon = true,    -- holdingValidGun()
        Wall = true,      -- raycast visibility
        Alive = true
    },

    -- Activation
    Activation = {
        Hold = false,     -- true = hold key, false = toggle
        Key = Enum.KeyCode.E
    },

    -- Performance
    Update = {
        MaxDistance = 2000 -- studs (optional)
    }
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

local function makethething(player)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChild("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    
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
    
    textLabel.Text = makethething(player)
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
            label.Text = makethething(player)
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
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Transparency = 0.5
FOVCircle.Color = Color3.fromRGB(255, 0, 0) -- initial color
FOVCircle.Thickness = 2
FOVCircle.NumSides = 64

local function holdingValidGun()
    if not aimlock.Checks.Weapon then
        return true
    end

    local char = LocalPlayer.Character
    if not char then return false end

    local tool = char:FindFirstChildOfClass("Tool")
    return tool and aballowedguns[tool.Name] or false
end

local function validTeam(plr)
    if not plr.Team then return false end
    return aimlock.TeamCheck[plr.Team.Name] == true
end

local function getTargetPart(char)
    local hum = char:FindFirstChild("Humanoid")
    if aimlock.Checks.Alive and hum.Health <= 0 then
        return nil
    end

    if aimlock.Target.Head and char:FindFirstChild("Head") then
        return char.Head
    end

    if aimlock.Target.Torso and char:FindFirstChild("Torso") then
        return char.Torso
    end

    return nil
end

local function canSee(part, character)
    if not aimlock.Checks.Wall then
        return true
    end

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = { LocalPlayer.Character }

    local ray = Workspace:Raycast(
        Camera.CFrame.Position,
        part.Position - Camera.CFrame.Position,
        params
    )

    return (not ray) or ray.Instance:IsDescendantOf(character)
end

local function getBestTarget()
    local bestPart = nil
    local bestDist = aimlock.FOV.Enabled and aimlock.FOV.Radius or math.huge

    local guiInset = game:GetService("GuiService"):GetGuiInset()
    local referencePos = UIS:GetMouseLocation() - Vector2.new(guiInset.X, guiInset.Y)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer
            and plr.Character
            and validTeam(plr) then

            local part = getTargetPart(plr.Character)
            if part then
                local dist3D = (part.Position - Camera.CFrame.Position).Magnitude
                if not (aimlock.Update.MaxDistance and dist3D > aimlock.Update.MaxDistance) then
                    local pos, visible = Camera:WorldToViewportPoint(part.Position)
                    if visible then
                        local dist = (Vector2.new(pos.X, pos.Y) - referencePos).Magnitude
                        if dist < bestDist and canSee(part, plr.Character) then
                            bestDist = dist
                            bestPart = part
                        end
                    end
                end
            end
        end
    end

    return bestPart
end

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == aimlock.Activation.Key then
        if aimlock.Activation.Hold then
            aimlock.Aimbot = true
        else
            aimlock.Aimbot = not aimlock.Aimbot
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if aimlock.Activation.Hold and input.KeyCode == aimlock.Activation.Key then
        aimlock.Aimbot = false
    end
end)


RunService.RenderStepped:Connect(function()
    if not aimlock.Aimbot then return end
    if not holdingValidGun() then return end

    if aimlock.FOV.Enabled and aimlock.FOV.ShowCircle then
        FOVCircle.Visible = true
        local guiInset = game:GetService("GuiService"):GetGuiInset()
        local mousePos = UIS:GetMouseLocation() - Vector2.new(guiInset.X, guiInset.Y)

        FOVCircle.Position = aimlock.Mode == "Mouse"
            and mousePos
            or Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

        FOVCircle.Radius = aimlock.FOV.Radius
        if aimlock.FOV.Rainbow then
            FOVCircle.Color = Color3.fromHSV(tick()%5/5, 1, 1)
        else
            FOVCircle.Color = aimlock.FOV.Color
        end
    else
        FOVCircle.Visible = false
    end

    local targetPart = getBestTarget()
    if not targetPart then return end

    local camPos = Camera.CFrame.Position
    local goalCFrame = CFrame.new(camPos, targetPart.Position)

    if aimlock.Smooth.Enabled then
        Camera.CFrame = Camera.CFrame:Lerp(
            goalCFrame,
            aimlock.Smooth.Amount
        )
    else
        Camera.CFrame = goalCFrame
    end
end)

--[[
local ESP_Folder = Instance.new("Folder")
ESP_Folder.Name = "ESP_Storage"
ESP_Folder.Parent = CoreGui

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
