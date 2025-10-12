local prefix = "-"
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

local Teleports = {
	nspawn = CFrame.new(879, 28, 2349);
	cells = CFrame.new(918.9735107421875, 99.98998260498047, 2451.423583984375);
	nexus = CFrame.new(877.929688, 99.9899826, 2373.57031, 0.989495575, 1.64841456e-08, 0.144563332, -3.13438235e-08, 1, 1.00512544e-07, -0.144563332, -1.0398788e-07, 0.989495575);
	armory = CFrame.new(836.130432, 99.9899826, 2284.55908, 0.999849498, 5.64007507e-08, -0.0173475463, -5.636889e-08, 1, 2.3254485e-09, 0.0173475463, -1.34723666e-09, 0.999849498);
	yard = CFrame.new(787.560425, 97.9999237, 2468.32056, -0.999741256, -7.32754017e-08, -0.0227459427, -7.49895506e-08, 1, 7.45077955e-08, 0.0227459427, 7.6194226e-08, -0.999741256);
	crimbase = CFrame.new(-864.760071, 94.4760284, 2085.87671, 0.999284029, 1.78674284e-08, 0.0378339142, -1.85715123e-08, 1, 1.82584365e-08, -0.0378339142, -1.89479969e-08, 0.999284029);
	cafe = CFrame.new(884.492798, 99.9899368, 2293.54907, -0.0628612712, -2.14097344e-08, -0.998022258, -9.52544568e-08, 1, -1.54524784e-08, 0.998022258, 9.40947018e-08, -0.0628612712);
	kitchen = CFrame.new(936.633118, 99.9899368, 2224.77148, -0.00265917974, -9.30829671e-08, 0.999996483, -3.28682326e-08, 1, 9.29958901e-08, -0.999996483, -3.26208252e-08, -0.00265917974);
	roof = CFrame.new(918.694092, 139.709427, 2266.60986, -0.998788536, -7.55880691e-08, -0.0492084064, -7.8453354e-08, 1, 5.62961198e-08, 0.0492084064, 6.00884817e-08, -0.998788536);
	vents = CFrame.new(933.55376574342, 121.534234671875, 2232.7952174975);
	office = CFrame.new(706.1928465, 103.14982749, 2344.3957382525);
	ytower = CFrame.new(786.731873, 125.039917, 2587.79834, -0.0578307845, 8.82393678e-08, 0.998326421, 6.09781523e-08, 1, -8.48549675e-08, -0.998326421, 5.59688687e-08, -0.0578307845);
	gtower = CFrame.new(505.551605, 125.039917, 2127.41138, -0.99910152, 5.44945458e-08, 0.0423811078, 5.36830491e-08, 1, -2.02856469e-08, -0.0423811078, -1.79922726e-08, -0.99910152);
	garage = CFrame.new(618.705566, 98.039917, 2469.14136, 0.997341573, 1.85835844e-08, -0.0728682056, -1.79448154e-08, 1, 9.42077172e-09, 0.0728682056, -8.0881204e-09, 0.997341573);
	sewers = CFrame.new(917.123657, 78.6990509, 2297.05298, -0.999281704, -9.98203404e-08, -0.0378962979, -1.01324503e-07, 1, 3.77708638e-08, 0.0378962979, 4.15835579e-08, -0.999281704);
	neighborhood = CFrame.new(-281.254669, 54.1751289, 2484.75513, 0.0408788249, 3.26279768e-08, 0.999164104, -3.88249717e-08, 1, -3.10668256e-08, -0.999164104, -3.75225433e-08, 0.0408788249);
	gas = CFrame.new(-497.284821, 54.3937759, 1686.3175, 0.585129559, -4.33374865e-08, -0.810939848, 5.33533938e-13, 1, -5.34406759e-08, 0.810939848, 3.12692876e-08, 0.585129559);
	deadend = CFrame.new(-979.852478, 54.1750259, 1382.78967, 0.0152699631, 8.88235174e-09, 0.999883413, 6.75286884e-08, 1, -9.9146682e-09, -0.999883413, 6.76722109e-08, 0.0152699631);
	store = CFrame.new(455.089508, 11.4253607, 1222.89746, 0.99995482, -3.92535604e-09, 0.00950394664, 2.84450263e-09, 1, 1.1374032e-07, -0.00950394664, -1.13708147e-07, 0.99995482);
	roadend = CFrame.new(1060.81995, 67.5668106, 1847.08923, 0.0752086118, -1.01192255e-08, -0.997167826, 4.30985886e-10, 1, -1.01154605e-08, 0.997167826, 3.31004502e-10, 0.0752086118);
	trapbuilding = CFrame.new(-306.715485, 84.2401199, 1984.13367, -0.802221119, 5.70582088e-08, -0.597027004, 4.81801123e-08, 1, 3.08312771e-08, 0.597027004, -4.0313255e-09, -0.802221119);
	mansion = CFrame.new(-315.790436, 64.5724411, 1840.83521, 0.80697298, -4.47871713e-08, 0.590588331, 1.14004006e-08, 1, 6.02574701e-08, -0.590588331, -4.18932053e-08, 0.80697298);
	trapbase = CFrame.new(-943.973145, 94.1287613, 1919.73694, 0.025614135, -1.48015129e-08, 0.999671876, 1.00375175e-07, 1, 1.22345032e-08, -0.999671876, 1.00028863e-07, 0.025614135);
	buildingroof = CFrame.new(-317.689331, 118.838821, 2009.28186, 0.749499857, 2.48145682e-09, 0.662004471, 3.51757373e-10, 1, -4.14664703e-09, -0.662004471, 3.34077632e-09, 0.749499857);
}

local function teleportTo(location)
	local cframe = Teleports[location:lower()]
	if not cframe then
		warn("Location not found:", location)
		return
	end

	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then
		warn("Character not ready!")
		return
	end

	char.HumanoidRootPart.CFrame = cframe
	Notify("Teleported to:", location)
end

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

local function GrabPad(pad)
    if not pad then
        warn("Pad not found")
        return
    end

    local padCFrame = pad.CFrame
    task.wait(0.125)
    
    pcall(function() pad.CanCollide = false end)

    repeat task.wait() until LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local hrp = LocalPlayer.Character.HumanoidRootPart

    pad.CFrame = hrp.CFrame
    task.wait(0.125)

    pad.CFrame = padCFrame
    pcall(function() pad.CanCollide = true end)

    Notify("Touched pad:", pad.Name)
end

local function JoinTeam(team)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function callConnections(signal)
    if not signal then return false end
    local conns = getconnections(signal)
    if not conns or #conns == 0 then return false end
    for _, c in ipairs(conns) do
        if c.Function then
            pcall(c.Function)
        end
    end
    return true
end

local switchButton = LocalPlayer.PlayerGui:WaitForChild("Home", 2)
switchButton = switchButton.hud.MenuButton.MenuFrame:WaitForChild("respawn")

local clicked = callConnections(switchButton.Activated) or callConnections(switchButton.MouseButton1Click)
if not clicked then
    --return warn("Could not click Switch Team button")
end
--print("Switch Team button clicked")

local menu = LocalPlayer.PlayerGui:WaitForChild("Home").intro
repeat task.wait() until menu.Visible

local teamsGui = menu.Content.menus:WaitForChild("teamsGui")
local prisoners = teamsGui:WaitForChild(team)
local prisonersButton = prisoners:WaitForChild("Button")
repeat task.wait() until prisonersButton.Visible

local success = callConnections(prisonersButton.Activated) or callConnections(prisonersButton.MouseButton1Click)
if success then
    Notify("Joined team")
    --print("Join Prisoners button clicked")
else
    --warn("Could not click Join Prisoners button")
end
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

    if string.sub(lowerMsg, 1, #prefix + 2) == prefix.."lc" then
		local parts = lowerMsg:split(" ")
		local location = parts[2]
		if location then
			teleportTo(location)
		else
			print("No location provided.")
		end
	end

    if string.sub(lowerMsg, 1, #prefix + 4) == prefix.."team" then
        local parts = lowerMsg:split(" ")
        local teamArg = parts[2]
        if not teamArg then return end

        if teamArg == "criminal" or teamArg == "crim" then
            local crimPad = workspace["Criminals Spawn"]:GetChildren()[7]
            GrabPad(crimPad)
        elseif teamArg == "inmate" then
            JoinTeam("Prisoners")
        elseif teamArg == "guards" then
            if #game:GetService("Teams").Guards:GetPlayers() > 7 then
                Notify("The team is full, cannot join!")
		    else
                JoinTeam("Guards")
            end
        else
            print("Unknown team:", teamArg)
        end
    end


    if string.sub(lowerMsg, 1, #prefix + 2) == prefix.."iy" then
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
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
