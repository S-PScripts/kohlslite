-- MAIN VARIABLES --
-- ESP Settings
getgenv().espsettings = {
    ESP = false,
    ESPTeamCheck = { Criminals = true, Guards = true, Inmates = true }, -- teams that will show up in ESP
    names = true,     -- show names of players in ESP
    health = true,    -- show health of players in ESP
    distance = true,  -- show distance player is away from you in ESP
    boxcolors = true, -- use team colour for ESP boxes (off = white)
    namecolors = true -- use team colour for ESP text (off = white)
}

-- Aimlock Settings
getgenv().aimlock = {
    Aimbot = false,     -- enables or disables the aimbot entirely; when off, nothing will auto-aim
    Mode = "Crosshair", -- determines how the aimbot aims (Mouse = Aim toward your cursor | Crosshair = Aim toward the centre of the screen)

    -- Team Allowed
    TeamCheck = {
        Criminals = true, -- if true, criminals can be aimed at
        Guards = true,    -- if true, guards can be aimed at
        Inmates = true    -- if true, inmates can be aimed at
    },

    -- Targets
    Target = {
        Head = true,              -- if true, the aimbot can aim at the torso
        Torso = false,            -- if true, the aimbot can aim at the head
        LeftArm = false,          -- if true, the aimbot can aim at the left arm
        RightArm = false,         -- if true, the aimbot can aim at the right arm
        LeftLeg = false,          -- if true, the aimbot can aim at the left leg
        RightLeg = false,         -- if true, the aimbot can aim at the right leg
        HumanoidRootPart = false, -- if true, the aimbot can aim at HRP
        RandomParts = false
    },

    -- FOV Settings
    FOV = {
        Enabled = true,                    -- enables the Field-of-View system; when off, the FOV circle is ignored
        Radius = 200,                      -- sets the size of the FOV circle (in pixels/studs); larger radius means more leniency for auto-aim
        ShowCircle = true,                 -- draws a visible circle around your cursor (or crosshair) showing the aimbot’s reach
        Color = Color3.fromRGB(255, 0, 0), -- sets the color of the FOV circle; ignored if Rainbow is enabled
        Rainbow = true                     -- if on, the FOV circle cycles through colors automatically
    },

    -- Smoothing
    Smooth = {
        Enabled = false, -- smooths the camera movement toward the target, making aimlock less obvious (“legit” style)
        Amount = 0.15    -- adjusts the speed of camera movement toward the target; 0 = instant snap, 1 = extremely slow/very smooth
    },

    -- Checks
    Checks = {
        Weapon = true,     -- only enables aimlock if the player is holding an allowed gun
        Wall = true,       -- only allows aimlock if the target is visible (raycast check)
        Alive = true,      -- only targets players that are alive (health > 0)
        ForceField = true, -- skip players with forcefield
        Vehicle = false,   -- skip players in vehicles

        CriminalsNoInmates = false, -- criminals won't shoot inmates
        InmatesNoCriminals = false, -- inmates won't shoot criminals
        Hostile = true,             -- guards only, hostile inmates
        Trespass = true,            -- guards only, trespassing inmates

        TaserBypassHostile = false,  -- taser ignores hostile check
        TaserBypassTrespass = false, -- taser ignores trespass check
        TaserAlwaysHit = false,
        IfPlayerStill = false,       -- always hit if player isn’t moving
        StillThreshold = 0.5         -- how long the player needs to be still for
    },

    -- Hit Chance and Miss Spread
    Hit = {
        HitChance = 100,              -- percent chance to hit
        HitChanceAutoOnly = false,    -- only automatic weapons
        MissSpread = 5,               -- distance to miss if shot misses
        ShotgunNaturalSpread = false, -- let shotgun spread naturally
        ShotgunGameHandled = false    -- let game handle shotgun spread
    },
    
    -- Target Stickiness / Prioritize Closest
    Targeting = {
        PrioritizeClosest = false,      -- target closest to cursor
        TargetStickiness = false,       -- stick to a target for a duration
        TargetStickinessDuration = 0.6, -- duration in seconds
        TargetStickinessRandom = false, -- randomize stickiness
        TargetStickinessMin = 0.3,
        TargetStickinessMax = 0.7
    },

    -- Shields / Special Handling
    Shield = {
        ShieldBreaker = false,    -- aim at shields instead of missing
        ShieldFrontAngle = 0.3,   -- lower = wider shield coverage
        ShieldRandomHead = false, -- randomly hit head instead of shield
        ShieldHeadChance = 30     -- percent chance to hit head
    },
    
    -- Activation
    Activation = {
        Hold = false,        -- if on, aimlock only works while the activation key is pressed
        Key = Enum.KeyCode.E -- sets which key will toggle or hold aimlock
    },

    -- Performance
    Update = {
        MaxDistance = 2000 -- maximum distance (in studs) that aimlock will target players; beyond this range, players will be ignored
    },

    -- Visuals
    Visuals = {
        ShowTargetLine = false
    },

    -- Autoshoot
    Autoshoot = {
        Enabled = true,
        Delay = 0.12,
        StartDelay = 0.2
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
local GuiService = game:GetService("GuiService")
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
if getgenv().aimlock.Aimbot then
    FOVCircle.Visible = true
else
    FOVCircle.Visible = false
end
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(255, 0, 0) -- initial color
FOVCircle.Radius = aimlock.FOV.Radius
FOVCircle.Thickness = 2

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
    local teamAllowed = aimlock.TeamCheck[plr.Team.Name] == true
    if not teamAllowed then return false end

    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    local isTaser = tool and tool.Name == "Taser"

    if not isTaser or not aimlock.Checks.TaserBypassHostile then
        if aimlock.Checks.Hostile and plr:GetAttribute("Hostile") ~= true then
            return false
        end
    end

    if not isTaser or not aimlock.Checks.TaserBypassTrespass then
        if aimlock.Checks.Trespass and plr:GetAttribute("Trespass") ~= true then
            return false
        end
    end

    if aimlock.Checks.CriminalsNoInmates and LocalPlayer:GetAttribute("Criminal") and plr:GetAttribute("Inmate") then
        return false
    end
    if aimlock.Checks.InmatesNoCriminals and LocalPlayer:GetAttribute("Inmate") and plr:GetAttribute("Criminal") then
        return false
    end

    if aimlock.Checks.Vehicle then
        local char = plr.Character
        if char then
            for _, seat in ipairs(char:GetDescendants()) do
                if seat:IsA("VehicleSeat") then
                    return false
                end
            end
        end
    end

    if aimlock.Checks.ForceField then
        local char = plr.Character
        if char and char:FindFirstChildOfClass("ForceField") then
            return false
        end
    end


    return true
end

local function getTargetPart(char)
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if aimlock.Checks.Alive and (not hum or hum.Health <= 0) then return nil end

    local partsList = {}
    if aimlock.Target.Head then table.insert(partsList, "Head") end
    if aimlock.Target.Torso then table.insert(partsList, "Torso") end
    if aimlock.Target.LeftArm then table.insert(partsList, "Left Arm") end
    if aimlock.Target.RightArm then table.insert(partsList, "Right Arm") end
    if aimlock.Target.LeftLeg then table.insert(partsList, "Left Leg") end
    if aimlock.Target.RightLeg then table.insert(partsList, "Right Leg") end
    if aimlock.Target.HumanoidRootPart then table.insert(partsList, "HumanoidRootPart") end

    if aimlock.Target.RandomParts then
        local index = math.random(1, #partsList)
        local partName = partsList[index]
        return char:FindFirstChild(partName)
    else
        for _, partName in ipairs(partsList) do
            local part = char:FindFirstChild(partName)
            if part then return part end
        end
    end
    return nil
end

local function canSee(part, character)
    if not aimlock.Checks.Wall then
        return true
    end

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {
        LocalPlayer.Character,
        character
    }

    local ray = Workspace:Raycast(
        Camera.CFrame.Position,
        part.Position - Camera.CFrame.Position,
        params
    )

    return (not ray) or ray.Instance:IsDescendantOf(character)
end

local function getBestTarget()
    local bestPart = nil
    local bestDist = aimlock.Targeting.PrioritizeClosest and math.huge or aimlock.FOV.Radius or math.huge

    local guiInset = GuiService:GetGuiInset()
    local referencePos =
    aimlock.Mode == "Mouse"
        and (UIS:GetMouseLocation() - Vector2.new(guiInset.X, guiInset.Y))
        or Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

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
                        if aimlock.Targeting.PrioritizeClosest then
                            if dist < bestDist and canSee(part, plr.Character) then
                                bestDist = dist
                                bestPart = part
                            end
                        else
                            if canSee(part, plr.Character) then
                                bestPart = part
                                break
                            end
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

local rng = Random.new()
local lastTarget = nil
local stickTime = 0
local lastShot = 0

local function isPlayerStill(humanoid)
    if not aimlock.Checks.IfPlayerStill then return true end
    if not humanoid or not humanoid.RootPart then return true end
    return humanoid.RootPart.Velocity.Magnitude <= aimlock.Checks.StillThreshold
end

local function passesHitChance(toolName)
    local hitChance = aimlock.Hit.HitChance
    if hitChance >= 100 then return true end

    local chance = rng:NextInteger(1,100)
    if aimlock.Hit.HitChanceAutoOnly and toolName ~= "Taser" then
        return chance <= hitChance
    elseif toolName == "Taser" and aimlock.Hit.TaserAlwaysHit then
        return true
    else
        return chance <= hitChance
    end
end

-- Apply miss spread
local function applyMissSpread(pos)
    local spread = aimlock.Hit.MissSpread
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if not tool then return pos end

    if aimlock.Hit.ShotgunNaturalSpread and tool.Name:find("Shotgun") then
        return pos -- game handles spread naturally
    end
    if aimlock.Hit.ShotgunGameHandled and tool.Name:find("Shotgun") then
        return pos -- game handles spread
    end

    if spread and spread > 0 then
        return pos + Vector3.new(
            rng:NextNumber(-spread, spread)/10,
            rng:NextNumber(-spread, spread)/10,
            rng:NextNumber(-spread, spread)/10
        )
    end
    return pos
end

-- Check shield logic
local function checkShield(part, char)
    if aimlock.Shield.ShieldBreaker then
        local shield = char:FindFirstChild("RiotShieldPart")
        if shield and shield:IsA("BasePart") then
            local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local theirHRP = char:FindFirstChild("HumanoidRootPart")
            if myHRP and theirHRP then
                local toMe = (myHRP.Position - theirHRP.Position).Unit
                local look = theirHRP.CFrame.LookVector
                if toMe:Dot(look) > aimlock.Shield.ShieldFrontAngle then
                    if aimlock.Shield.ShieldRandomHead and math.random(1,100) <= aimlock.Shield.ShieldHeadChance then
                        return char:FindFirstChild("Head")
                    end
                    return shield
                end
            end
        end
    end
    return part
end

-- Stickiness helper
local function getStickyTarget(best)
    if aimlock.Targeting.TargetStickiness and lastTarget then
        stickTime = stickTime + RunService.RenderStepped:Wait()
        local duration = aimlock.Targeting.TargetStickinessDuration
        if aimlock.Targeting.TargetStickinessRandom then
            duration = rng:NextNumber(aimlock.Targeting.TargetStickinessMin, aimlock.Targeting.TargetStickinessMax)
        end
        if stickTime < duration then
            return lastTarget
        end
        stickTime = 0
    end
    lastTarget = best
    return best
end

-- Autoshoot
local lastShot = 0
local shootStart = tick() + (aimlock.Autoshoot.StartDelay or 0)

local function tryShoot()
    if aimlock.Autoshoot.Enabled and tick() >= shootStart then
        if tick() - lastShot >= (aimlock.Autoshoot.Delay or 0.12) then
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Handle") then
                tool:Activate()
                lastShot = tick()
            end
        end
    end
end

local TargetLine = Drawing.new("Line")
TargetLine.Visible = false
TargetLine.Color = Color3.fromRGB(0,255,0)
TargetLine.Thickness = 2

-- Main RenderStepped
RunService.RenderStepped:Connect(function()
    -- FOV Circle Update
    if aimlock.FOV.Enabled and aimlock.FOV.ShowCircle then
        local guiInset = GuiService:GetGuiInset()
        local mousePos = UIS:GetMouseLocation() - Vector2.new(guiInset.X, guiInset.Y)
        FOVCircle.Visible = true
        FOVCircle.Position = aimlock.Mode == "Mouse" and mousePos or Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        FOVCircle.Radius = aimlock.FOV.Radius
        FOVCircle.Color = aimlock.FOV.Rainbow and Color3.fromHSV(tick()%5/5,1,1) or aimlock.FOV.Color
    else
        FOVCircle.Visible = false
    end

    -- Exit if aimbot disabled or not holding valid gun
    if not aimlock.Aimbot or not holdingValidGun() then return end

    -- Target acquisition
    local bestPart = getBestTarget()
    if not bestPart then return end

    if aimlock.Visuals.ShowTargetLine and bestPart then
        local screenPos = Camera:WorldToViewportPoint(bestPart.Position)
        local guiInset = GuiService:GetGuiInset()
        local startPos = aimlock.Mode == "Mouse" and (UIS:GetMouseLocation() - Vector2.new(guiInset.X, guiInset.Y))
                     or Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        TargetLine.From = startPos
        TargetLine.To = Vector2.new(screenPos.X, screenPos.Y)
        TargetLine.Visible = true
    else
        TargetLine.Visible = false
    end
        
    local char = bestPart.Parent
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if aimlock.Checks.Alive and (not hum or hum.Health <= 0) then return end
    if not isPlayerStill(hum) then return end

    -- Shield / miss / hit chance
    bestPart = checkShield(bestPart, char)
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if not passesHitChance(tool and tool.Name) then return end

    local finalPos = applyMissSpread(bestPart.Position)

    -- Smooth or instant aim
    local camPos = Camera.CFrame.Position
    local goalCFrame = CFrame.new(camPos, finalPos)
    if aimlock.Smooth.Enabled then
        Camera.CFrame = Camera.CFrame:Lerp(goalCFrame, aimlock.Smooth.Amount)
    else
        Camera.CFrame = goalCFrame
    end

    -- Autoshoot
    tryShoot()
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
