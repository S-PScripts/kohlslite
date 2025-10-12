local prefix = "-"
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

local gunAliases = {
    ["m9"] = "M9",
    ["ak-47"] = "AK-47",
    ["ak"] = "AK-47",
    ["ak47"] = "AK-47",
    ["remington"] = "Remington 870",
    ["rem"] = "Remington 870",
    ["shotgun"] = "Remington 870",
    ["m4"] = "M4A1",
    ["m4a1"] = "M4A1"
}

local allGuns = {"M9", "AK-47", "M4A1", "Remington 870"}

local function Notify(text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Gun Pickup";
            Text = text;
            Duration = 2;
        })
    end)
end

local function hasGun(name)
    local backpack = LocalPlayer:WaitForChild("Backpack")
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return backpack:FindFirstChild(name) or char:FindFirstChild(name)
end

local function GrabGun(gun)
    local pad = workspace[gun]
    if not pad then
        warn("Pad not found:", gun)
        return false
    end

    local padCFrame = pad.CFrame
    task.wait(0.125)
    pad.CanCollide = false

    repeat task.wait() until LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local hrp = LocalPlayer.Character.HumanoidRootPart

    pad.CFrame = hrp.CFrame
    task.wait(0.125)

    pad.CFrame = padCFrame
    pad.CanCollide = true

    return true
end

local function GrabGuns(gunsToGrab)
    local obtained = {}
    for _, gun in ipairs(gunsToGrab) do
        if not hasGun(gun) then
            if GrabGun(gun) then
                table.insert(obtained, gun)
            end
            task.wait(0.35)
        end
    end

    if #obtained == 0 then
        Notify("All guns already in inventory!")
    elseif #obtained == 1 then
        Notify("Obtained " .. obtained[1])
    else
        Notify("Obtained all guns!")
    end
end

local function handleCommand(msg)
    local lowerMsg = msg:lower()

    if lowerMsg == prefix.."guns" or lowerMsg == prefix.."allguns" then
        GrabGuns(allGuns)
        return
    end

    if string.sub(lowerMsg, 1, #prefix + 3) == prefix.."gun" then
        local parts = lowerMsg:split(" ")
        local gunArg = parts[2]
        if gunArg and gunAliases[gunArg] then
            GrabGuns({gunAliases[gunArg]})
        else
            print("Unknown gun:", gunArg)
        end
    end
end

game:GetService("TextChatService").MessageReceived:Connect(function(tbl)
    if not tbl.TextSource then return end
    local player = Players:GetPlayerByUserId(tbl.TextSource.UserId)
    if not player or player ~= LocalPlayer then return end

    handleCommand(tbl.Text)
end)

LocalPlayer:GetMouse().KeyDown:Connect(function(key)
    if key:lower() == "g" then
        GrabGuns(allGuns)
    end
end)
