-- https://scriptblox.com/script/MP5-Prison-Life-Aimbot-ESP-Fixed-V12-73864
-- by profunoficial
-- no gui version

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local getgenv().absettings = {
    Aimbot = false,
    TeamCheck = { Criminals = false, Guards = true, Inmates = false },
    Target = { Torso = false, Head = true },
    ESP = false,
    ESPTeamCheck = { Criminals = false, Guards = false, Inmates = false }
}

local getgenv().aballowedguns = {
    ["AK-47"] = true, ["FAL"] = true, ["M4A1"] = true,
    ["M9"] = true, ["MP5"] = true, ["Remington 870"] = true,
    ["Taser"] = true
}

local function holdingValidGun()
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    return tool and aballowedguns[tool.Name] or false
end

local ESP_Folder = Instance.new("Folder")
ESP_Folder.Name = "ESP_Storage"
ESP_Folder.Parent = CoreGui

local function validTeam(plr)
    if not absettings.TeamCheck.Criminals and plr.Team and plr.Team.Name == "Criminals" then return false end
    if not absettings.TeamCheck.Guards and plr.Team and plr.Team.Name == "Guards" then return false end
    if not absettings.TeamCheck.Inmates and plr.Team and plr.Team.Name == "Inmates" then return false end
    return true
end

local function getTargetPart(char)
    local hum = char:FindFirstChild("Humanoid")
    if not hum or hum.Health <= 0 then return nil end
    if absettings.Target.Head and char:FindFirstChild("Head") then return char.Head end
    if absettings.Target.Torso and char:FindFirstChild("Torso") then return char.Torso end
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
    if absettings.Aimbot and holdingValidGun() then
        local target = getClosestScreenTarget()
        if target then
            local part = getTargetPart(target)
            if part then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)
            end
        end
    end
end)

local function teamAllowed(plr)
    if not plr.Team then return false end
    if plr.Team.Name == "Criminals" and absettings.ESPTeamCheck.Criminals then return true end
    if plr.Team.Name == "Guards" and absettings.ESPTeamCheck.Guards then return true end
    if plr.Team.Name == "Inmates" and absettings.ESPTeamCheck.Inmates then return true end
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
            if not hrp or not hum or hum.Health <= 0 then removeHighlight(plr) continue end
            if not absettings.ESP then removeHighlight(plr) continue end
            if not teamAllowed(plr) then removeHighlight(plr) continue end

            local h = getHighlight(plr)
            h.Adornee = plr.Character

            local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
            h.OutlineColor = dist <= 25 and Color3.new(1,1,1) or Color3.new(0,0,0)
            h.FillColor = teamColor(plr)
            h.FillTransparency = 0.5
            h.OutlineTransparency = 0
        end
    end
end)
