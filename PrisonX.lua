-- PrisonX v1 (WIP: not working!)
-- Coming to ScriptBlox soon.

--[[
Features:
]]


local prefix = "-"

-- Settings
settings = {
	-- When a player dies, it tells you
    killfeed = true,

	-- Respawn in same place upon arrest and make you criminal if you were one
    antiarrest = true,

	-- Remove tased effects
    antitase = true,

	-- Respawn in previous position if you die
    autorespawn = true,

	-- Auto-Mod all guns to have a big range and spread  (pg = powerful gun)
	auto_pg = true,
	
	-- Auto-Mod all guns to shoot really fast (fg = fast gun)
	auto_fg = true,
	auto_fgrate = 0 -- if you want to change it to be slower...
}

-- Notifications
local StarterGui = game:GetService("StarterGui")
local function Notify(text, time)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "PrisonX";
            Text = text;
            Duration = time or 2;
        })
    end)
end

-- Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local RunService = game:GetService("RunService")
local hbeat = RunService.Heartbeat
local rstepped = RunService.RenderStepped
local stepped = RunService.Stepped

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Killfeed = ReplicatedStorage:WaitForChild("Killfeed")

local PlayerGui = LocalPlayer.PlayerGui
local HomeGUI = PlayerGui:WaitForChild("Home")

local Camera = workspace.Camera

local Teams = game:GetService("Teams")
local TeamEvent = workspace:WaitForChild("Remote"):WaitForChild("TeamEvent")

local version = "v1"

-- Teleport Locations
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

-- Teleport to location
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

-- Guns in the game
local allGuns = {"M9", "AK-47", "M4A1", "Remington 870"}

-- Gun Pads
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

-- Fix camera
local function FixCamera()
	HomeGUI.hud.Visible = true
	HomeGUI.intro.Visible = false
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
	Camera.CameraType = Enum.CameraType.Custom
	if LocalPlayer.Character then
		Camera.CameraSubject = LocalPlayer.Character:WaitForChild("Humanoid")
	end
end



-- Check if you already have the gun
local function hasGun(name)
    local backpack = LocalPlayer:WaitForChild("Backpack")
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return backpack:FindFirstChild(name) or char:FindFirstChild(name)
end

-- Grab A Gun
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

-- Grab All Guns
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

function unequip()
    LocalPlayer.Character:FindFirstChild("Humanoid"):UnequipTools()
end

function equip(tool)
    LocalPlayer.Character:FindFirstChild("Humanoid"):EquipTool(tool)
end

-- PLAYER CHECK
function PLAYERCHECK(plr, rt)
    plr = plr:lower()
    for _, v in pairs(game.Players:GetPlayers()) do
        if string.sub(v.Name:lower(), 1, #plr) == plr or string.sub(v.DisplayName:lower(), 1, #plr) == plr then
            Notify("Found "..v.Name)
            if rt then
                return v -- only return Player instance
            else
                return v, v.Name -- return both
            end
        end
    end
    return nil, nil
end

-- Function to modify a gun
local function modGun(gun, mode)
    if gun and gun:GetAttributes() then
        local attrs = gun:GetAttributes()
		if mode == "pg_fg" then
        	attrs.Range = 999999999
        	attrs.Spread = 999999999
			attrs.AutoFire = true
        	attrs.FireRate = auto_fgrate
		elseif mode == "pg" then
			attrs.Range = 999999999
        	attrs.Spread = 999999999
		elseif mode == "fg" then
			attrs.AutoFire = true
        	attrs.FireRate = auto_fgrate
		end
        print(gun, "modded.")
        return true
    end
    return false
end

-- Hook __namecall
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    
    if method == "GetAttributes" then
        local result = oldNamecall(self, ...)

		
		if auto_pg == true and auto_fg == true then
			modGun(self, "pg_fg")
		elseif auto_pg == true then
            modGun(self, "pg")
		elseif auto_fg == true then
			modGun(self, "fg")
		else
			--
		end
        
        return result
    end
    
    return oldNamecall(self, ...)
end)



function tpto(args)
    LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = args
end


-- Kill Feed
Killfeed.ChildAdded:Connect(function(newChild)
    if settings.killfeed == true then
	    print("New killfeed entry:", newChild.Name)
	    Notify(newChild.name, 1)
    end
end)


local normalWS = 16
local normalJP = 50

task.spawn(function()
	while hbeat:Wait() do
		local char = LocalPlayer.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				if hum.WalkSpeed > 0 then
					normalWS = hum.WalkSpeed
				end
				if hum.JumpPower > 0 then
					normalJP = hum.JumpPower
				end
			end
		end
	end
end)

local function die()
	LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
end

local Status = LocalPlayer.Status
local isArrested = Status.isArrested
RunService.Heartbeat:Connect(function()
    if isArrested.Value == true then
		if settings.antiarrest == true then
    		die()
		end
    end
end)

-- Anti Arrest and Anti Tase
LocalPlayer.CharacterAdded:Connect(function(char)
	local humanoid = char:WaitForChild("Humanoid")
	local animator = humanoid:WaitForChild("Animator")

	animator.AnimationPlayed:Connect(function(des)
		-- Anti Arrest
		if settings.antiarrest and des.Animation.AnimationId == "rbxassetid://287112271" then
		--	des:Stop()
		--	des:Destroy()
        --  StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)

        --  local wspeed = normalWS
		--	local jpower = normalJP

			local cpos = char:WaitForChild("HumanoidRootPart").CFrame
			local wascriminal = (LocalPlayer.TeamColor.Name == "Really red")

			task.delay(4.95, function()
				
				LocalPlayer.CharacterAdded:Wait()
				repeat task.wait() until LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

				if wascriminal then
					GrabPad(workspace["Criminals Spawn"]:GetChildren()[7])
				end

				if settings.autorespawn == false then
                	tpto(cpos)
				end
			end)

			--task.delay(0, function()
			--	humanoid.WalkSpeed = wspeed
			--	humanoid.JumpPower = jpower
			-- end)
		end

		-- Anti Tase
		if settings.antitase and des.Animation.AnimationId == "rbxassetid://279227693" then
			des:Stop()
			des:Destroy()
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
			local wspeed = normalWS
			local jpower = normalJP
			hbeat:Wait()
			humanoid.WalkSpeed = wspeed
			humanoid.JumpPower = jpower
		end
	end)
end)

-- Team Setting + Changing
local function SetTeam(team)
	if team == Team.Criminals then
		 SetTeam(Team.Inmates)
		 local crimPad = workspace["Criminals Spawn"]:GetChildren()[7]
         GrabPad(crimPad)
		 repeat task.wait() until LocalPlayer.Team == team
	else
		repeat task.wait()
			TeamEvent:FireServer(team)
    	until LocalPlayer.Team == team
	end
	fixcam()
end

local function ChangeTeam(team)
    SetTeam(Teams.Neutral)
    SetTeam(team)
    reset_cd()
end

-- Check if it is possible to switch teams
local cd_dur = 10
local coolingdown = false

qr_available = true

function reset_cd()	
	if coolingdown == false then
			coolingdown = true
			qr_available = false
			task.wait(cd_dur)
			coolingdown = false
			qr_available = true
	end
end

local function qr_check()
	return qr_available
end

-- Auto Respawn Handling
local lastDeathCFrame = nil
local lastCameraCFrame = nil

local function Teleport(TargetCFrame, Character)
    if not Character then Character = LocalPlayer.Character end
    if not Character then return end

    local RootPart = Character:WaitForChild("HumanoidRootPart")
    RootPart.CFrame = TargetCFrame
    print("Teleport Success!")
end

LocalPlayer.CharacterAdded:Connect(function(char)
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")

    if lastDeathCFrame then
        RunService.Heartbeat:Wait()
        pcall(function()
            Teleport(lastDeathCFrame, char)
        end)
        lastDeathCFrame = nil
    end

	if lastCameraCFrame then
        Camera.CFrame = lastCameraCFrame
        lastCameraCFrame = nil
    end

    hum.Died:Connect(function()
		if settings.autorespawn == false then
			--
		else 
        	local hrp = char:FindFirstChild("HumanoidRootPart")
        	if hrp then
            	lastDeathCFrame = hrp.CFrame
        	end
			lastCameraCFrame = Camera.CFrame

        	if qr_check() then
            	pcall(function()
                	ChangeTeam(LocalPlayer.Team)
            	end)
        	end
		end
    end)
end)

-- Remove collision of doors
function NoDoors()
	local Doors = workspace:FindFirstChild("Doors")
    for i,v in pairs(Doors:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
            v.Transparency = 0.6
        end
    end
	
    local CellDoors = workspace:FindFirstChild("CellDoors")
    for i,v in pairs(CellDoors:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
            v.Transparency = 0.6
        end
    end
end

-- Add collision of doors
function NoDoors()
	local Doors = workspace:FindFirstChild("Doors")
    for i,v in pairs(Doors:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = true
            v.Transparency = 0
        end
    end
	
    local CellDoors = workspace:FindFirstChild("CellDoors")
    for i,v in pairs(CellDoors:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = true
            v.Transparency = 0
        end
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
            SetTeam("Prisoners")
        elseif teamArg == "guards" then
            if #Teams.Guards:GetPlayers() > 7 then
                Notify("The team is full, cannot join!")
		    else
                SetTeam("Guards")
            end
        else
            print("Unknown team:", teamArg)
        end
    end

    if string.sub(lowerMsg, 1, #prefix + 2) == prefix.."iy" then
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end

    if string.sub(lowerMsg, 1, #prefix + 8) == prefix.."killfeed" then
        settings.killfeed = true
        Notify("Enabled Kill Feed.")
    end

    if string.sub(lowerMsg, 1, #prefix + 10) == prefix.."unkillfeed" then
        settings.killfeed = false
        Notify("Disabled Kill Feed.")
    end

    if string.sub(lowerMsg, 1, #prefix + 6) == prefix.."antiar" then
        settings.antiarrest = true
        Notify("Enabled anti-arrest.")
    end

    if string.sub(lowerMsg, 1, #prefix + 8) == prefix.."unantiar" then
        settings.antiarrest = false
        Notify("Disabled anti-arrest.")
    end

    if string.sub(lowerMsg, 1, #prefix + 8) == prefix.."antitase" then
        settings.antitase = true
        Notify("Enabled anti-tase.")
    end

    if string.sub(lowerMsg, 1, #prefix + 10) == prefix.."unantitase" then
        settings.antitase = false
        Notify("Disabled anti-tase.")
    end

    if string.sub(lowerMsg, 1, #prefix + 6) == prefix.."autore" then
        settings.autorespawn = true
        Notify("Enabled auto-respawn.")
    end

    if string.sub(lowerMsg, 1, #prefix + 8) == prefix.."unautore" then
        settings.autorespawn = false
        Notify("Disabled auto-respawn.")
    end

	if string.sub(lowerMsg, 1, #prefix + 7) == prefix.."powguns" then
        auto_pg = true
		Remind("Your guns will now have unlimited range and spread!")
    end
	
	if string.sub(lowerMsg, 1, #prefix + 8) == prefix.."fastguns" then
        auto_fg = true
		Remind("Your guns will now have fast fire-rate.")
    end

	if string.sub(lowerMsg, 1, #prefix + 8) == prefix.."firerate" then
		local parts = lowerMsg:split(" ")
		auto_fgrate = tonumber(parts[2])
		Remind("Firerate of all your guns will now be "..auto_fgrate.." from now on.")
	end
	
	if string.sub(lowerMsg, 1, #prefix + 6) == prefix.."opguns" then
        auto_pg = true
		auto_fg = true
		Remind("Your guns will now be powerful and fast!")
    end

    if string.sub(lowerMsg, 1, #prefix + 3) == prefix.."pkf" then
        for i, v in ipairs(Killfeed:GetChildren()) do
	        print(v.Name)
        end
        Notify("Printed Kill Feed to /console.")
    end

    if string.sub(lowerMsg, 1, #prefix + 6) == prefix.."nodoors" then
    	NoDoors()
		Remind("Removed collision of doors.")
	end

	if string.sub(lowerMsg, 1, #prefix + 7) == prefix.."adddoors" then
    	AddDoors()
		Remind("Added collision of doors.")
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

print("PrisonX executed.")
Notify("PrisonX executed.")
