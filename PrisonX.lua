-- PrisonX v1.1 by TS2021
-- Credits to github.com/tomatotxt for stuff
-- Credits to github.com/NewMatheusDC for most of the GUI

--[[
Features:
Kill Feed implementation
Anti-arrest
Anti-tase
Auto-respawn
Auto guns
Auto gun mods
Team Switcher
Door Remover
Gun Obtainer
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

	-- Auto guns
	autoguns = true,

	-- Auto-Mod all guns to have a big range and spread  (pg = powerful gun)
	auto_pg = true,
	
	-- Auto-Mod all guns to shoot really fast (fg = fast gun)
	auto_fg = true,
	auto_fgrate = 0, -- if you want to change it to be slower...

	-- Remove doors
	nodoors = true,

	-- Kill aura
	killaura = false,
	killaura_radius = 20, -- kinda broken 
	killaura_sphere = false, -- visual sphere

	-- Arrest aura
	arrestaura = false

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

-- GUI Setup
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "PrisonX",
    Icon = nil,
    LoadingTitle = "PrisonX v1.1",
    LoadingSubtitle = "Created by TS2021",
    ConfigurationSaving = {
        Enabled = false,
    },
    Discord = {
        Enabled = false,
    },
    KeySystem = false,
})

local MainTab = Window:CreateTab("Main Features", nil)
local CombatTab = Window:CreateTab("Combat", nil)
local TeleportTab = Window:CreateTab("Teleport", nil)
local SettingsTab = Window:CreateTab("Settings", nil)


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

local AlreadyFound = {}
local function FindGunSpawner(GunName)
    if AlreadyFound[GunName] ~= nil then
        return AlreadyFound[GunName], true
    end
	for i,v in pairs(workspace:GetChildren()) do
		if v.Name == "TouchGiver" then
			if v:GetAttribute("ToolName") == GunName then
                AlreadyFound[GunName] = v.TouchGiver
				return v.TouchGiver, false
			end
		end
	end
end

local function GetTool(ToolName)
    return LocalPlayer:FindFirstChild("Backpack") and LocalPlayer.Backpack:FindFirstChild(ToolName) or LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(ToolName)
end

local function GetGun(GunName)
    local Giver, Found = FindGunSpawner(GunName)
    if not Found then
        local CloneGiver = Giver:Clone()
        CloneGiver.Parent = Giver.Parent
        Giver.Parent = workspace.Folder
        Giver.CanCollide = false
        Giver.Transparency = 1
    end
	local hrp = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    repeat task.wait()
        Giver.CFrame = hrp.CFrame * CFrame.new(math.random(-2, 2),0,0)
    until GetTool(GunName)
end

-- Fix camera
local function fixcam()
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

local function SwitchToCriminalAndReturn(dih, ocf)
    local crimPad = workspace["Criminals Spawn"].SpawnLocation
    local char = LocalPlayer.Character
    if not char then return end
    hrp = char:WaitForChild("HumanoidRootPart")

	oldCFrame = nil
	if dih == true then
    	oldCFrame = hrp.CFrame  -- store original position
		--print(oldCFrame)
	else
		oldCFrame = ocf
		--print(oldCFrame)
	end

    -- teleport to crim spawn pad
    hrp.CFrame = crimPad.CFrame
    Notify("Teleported to Criminal Spawn...")

    -- wait until team actually changes
    repeat task.wait() until LocalPlayer.Team == Teams.Criminals
    Notify("Now a Criminal!")

    -- return to original position
    hrp.CFrame = oldCFrame
    Notify("Teleported back to original position.")
end


-- Grab All Guns
function GrabGuns(gunsToGrab)
    local obtained = {}
    for _, gun in ipairs(gunsToGrab) do
        if not hasGun(gun) then
            if GetGun(gun) then
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

-- Hook __namecall
local namecall
namecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    
    if method == "GetAttributes" then
        local result = namecall(self, ...)

        if settings.auto_pg and settings.auto_fg then
            result.Range = 999999999
            result.Spread = 999999999
            result.AutoFire = true
            result.FireRate = auto_fgrate
        elseif settings.auto_pg then
            result.Range = 999999999
            result.Spread = 999999999
        elseif settings.auto_fg then
            result.AutoFire = true
            result.FireRate = auto_fgrate
        end

        print(self, "modded")
        return result
    end

    return namecall(self, ...)
end)     

-- Kill aura
local event = ReplicatedStorage:WaitForChild("meleeEvent")

-- Sphere visual
local sphere = Instance.new("Part")
sphere.Shape = Enum.PartType.Ball
sphere.Size = Vector3.new(settings.killaura_radius * 2, settings.killaura_radius * 2, settings.killaura_radius * 2)
sphere.Anchored = true
sphere.CanCollide = false
sphere.Material = Enum.Material.ForceField
sphere.Color = Color3.fromRGB(255, 0, 50)
sphere.Transparency = settings.killaura_radius and 0.6 or 1
sphere.Parent = workspace

RunService.Heartbeat:Connect(function()
    if not settings.killaura then
        sphere.Transparency = 1
        return
    end

	local player = game.Players.LocalPlayer
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Update sphere visuals
    sphere.Size = Vector3.new(settings.killaura_radius * 2, settings.killaura_radius * 2, settings.killaura_radius * 2)
    sphere.Transparency = settings.killaura_radius and 0.6 or 1
    sphere.Position = hrp.Position

    -- Get targets in radius
    local touching = workspace:GetPartBoundsInRadius(hrp.Position, settings.killaura_radius)
    local hitList = {}

    for _, part in ipairs(touching) do
        local model = part.Parent
        local hum = model and model:FindFirstChild("Humanoid")
        if hum then
            local targetPlayer = Players:GetPlayerFromCharacter(model)
            if targetPlayer and targetPlayer ~= player and not hitList[targetPlayer] then
                hitList[targetPlayer] = true
                event:FireServer(targetPlayer)
            end
        end
    end
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


-- Anti tase fix
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

-- Arrest Aura
local aremote = ReplicatedStorage.Remotes.ArrestPlayer

RunService.Heartbeat:Connect(function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if settings.arrestaura == false then return end
		
    for _, plr in Players:GetPlayers() do
        if plr == LocalPlayer then
			--
		else
        	local char = plr.Character
        	if not char then
				--
			else
        		local hrp = char:FindFirstChild("HumanoidRootPart")
        		local hum = char:FindFirstChild("Humanoid")
        		if not hrp or not hum or hum.Health <= 0 then 
					--
				else
        			if (root.Position - hrp.Position).Magnitude <= 10 then
            			task.spawn(function()
                			pcall(aremote.InvokeServer, aremote, plr)
            			end)
					end
				end
        	end
		end
    end
end)

local Humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
function die()
	Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
end

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
			local Humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
			Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
				
			local cpos = char:WaitForChild("HumanoidRootPart").CFrame
			local wascriminal = (LocalPlayer.TeamColor.Name == "Really red")
				
			LocalPlayer.CharacterAdded:Wait()
			repeat task.wait() until LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

			if wascriminal then
				task.wait(1) -- band aid fix 
				SwitchToCriminalAndReturn(false, cpos)
			elseif settings.autorespawn == false then
                tpto(cpos)
			end

			--task.delay(0, function()
			--	humanoid.WalkSpeed = wspeed
			--	humanoid.JumpPower = jpower
			-- end) ]]
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


-- Cooldown tracking
if not _G.TeamCooldown then
    _G.TeamCooldown = 0
end

-- Quick respawn tracking
if not _G.CanQuickRespawn then
    _G.CanQuickRespawn = true
end
local cd_dur = 10
local coolingdown = false

function _G.ResetCooldown()
	if not coolingdown then
		coolingdown = true
		_G.CanQuickRespawn = false
		task.wait(cd_dur)
		_G.CanQuickRespawn = true
		coolingdown = false
	end
end

-- Store last death position and camera
local lastDeathCFrame = nil
local lastCameraCFrame = nil

-- Helper to teleport player
local function Teleport(TargetCFrame, Character)
    if not Character then Character = LocalPlayer.Character end
    if not Character then return end
    local RootPart = Character:WaitForChild("HumanoidRootPart")
    RootPart.CFrame = TargetCFrame
    print("Teleport Success!")
end

-- Check if team can be switched (cooldown)
local function CanSwitchTeam()
    local now = os.time()
    if now < _G.TeamCooldown then
        local remaining = _G.TeamCooldown - now
        Notify("You will be able to switch teams in " .. remaining .. " seconds!")
        return false
    end
    return true
end

-- Core team switch logic
local function SetTeam(targetTeam, skipCooldownCheck)
    -- Skip cooldown if switching to Criminals
    if targetTeam == Teams.Criminals then
        skipCooldownCheck = true
    end

    -- Only respect cooldown for manual switches
    if not skipCooldownCheck then
        if not CanSwitchTeam() then return end
    end

    local current = LocalPlayer.Team

    local function switch(team)
        repeat
            TeamEvent:FireServer(team)
            task.wait(0.2)
        until LocalPlayer.Team == team
    end

    if current == Teams.Inmates then
        if targetTeam == Teams.Guards then
            switch(Teams.Neutral)
            switch(Teams.Guards)
        elseif targetTeam == Teams.Criminals then
			local char = LocalPlayer.Character
    		if not char then return end
    		local hrp = char:WaitForChild("HumanoidRootPart")
			local ocf = hrp.CFrame 
            SwitchToCriminalAndReturn(false, ocf)
        end
    elseif current == Teams.Guards then
        if targetTeam == Teams.Inmates then
            switch(Teams.Neutral)
            switch(Teams.Inmates)
        elseif targetTeam == Teams.Criminals then
			local char = LocalPlayer.Character
    		if not char then return end
    		local hrp = char:WaitForChild("HumanoidRootPart")
    		local ocf = hrp.CFrame 
            switch(Teams.Neutral)
            switch(Teams.Inmates)
			fixcam()
			SwitchToCriminalAndReturn(false, ocf)
        end
    elseif current == Teams.Criminals then
        if targetTeam == Teams.Inmates then
            switch(Teams.Neutral)
            switch(Teams.Inmates)
        elseif targetTeam == Teams.Guards then
            switch(Teams.Neutral)
            switch(Teams.Guards)
        end
    elseif current == Teams.Neutral then
        switch(targetTeam)
    end

    -- Apply cooldown for non-criminal switches
    if targetTeam ~= Teams.Criminals and (targetTeam == Teams.Inmates or targetTeam == Teams.Guards) then
        _G.TeamCooldown = os.time() + 10
        task.spawn(_G.ResetCooldown)
    end

    fixcam()
end

local function ChangeTeam(targetTeam)
    SetTeam(targetTeam)
    task.spawn(_G.ResetCooldown)
end

-- Auto respawn handling
LocalPlayer.CharacterAdded:Connect(function(char)
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")

    -- Teleport to last stored position if it exists
    if lastDeathCFrame then
        task.wait(0.1)
        hrp.CFrame = lastDeathCFrame
    end

    hum.Died:Connect(function()
        if settings.autorespawn == false then return end

        if hrp then
            lastDeathCFrame = hrp.CFrame
        end

        if _G.CanQuickRespawn and os.time() >= _G.TeamCooldown then
            _G.CanQuickRespawn = false
            task.spawn(function()
                local currentTeam = LocalPlayer.Team
                if currentTeam == Teams.Inmates then
                    repeat task.wait() 
                        TeamEvent:FireServer(Teams.Neutral)
                    until LocalPlayer.Team == Teams.Neutral

                    repeat task.wait() 
                        TeamEvent:FireServer(Teams.Inmates)
                    until LocalPlayer.Team == Teams.Inmates
                    fixcam()
                elseif currentTeam == Teams.Guards then
                    repeat task.wait() 
                        TeamEvent:FireServer(Teams.Neutral)
                    until LocalPlayer.Team == Teams.Neutral

                    repeat task.wait() 
                        TeamEvent:FireServer(Teams.Guards)
                    until LocalPlayer.Team == Teams.Guards
                    fixcam()
                elseif currentTeam == Teams.Criminals then
                    Notify("Quick respawn is not available for criminals!")
                end
                _G.CanQuickRespawn = true
            end)
        end
    end)
end)

LocalPlayer:GetMouse().KeyDown:Connect(function(key)
    if key:lower() == "g" then
        for i, v in allGuns do
		--	print(v)
			if v == "M4A1" and plr_pass == false then 
			else
				if not GetTool(v) then
        			GetGun(v)
    			end
			end
		end
    end
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
function AddDoors()
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

function checkRIOT()	
	if game:GetService("MarketplaceService"):UserOwnsGamePassAsync(game.Players.LocalPlayer.UserId, 643697197) then
		return true, "NEW"
	end

	if game:GetService("MarketplaceService"):UserOwnsGamePassAsync(game.Players.LocalPlayer.UserId, 96651) then
		return true, "LEGACY"
	end

	return false, "N/A"
end

plr_pass, type = checkRIOT()

RunService.Heartbeat:Connect(function()
    if settings.autoguns == true then
		for i, v in allGuns do
		--	print(v)
			if v == "M4A1" and plr_pass == false then 
			else
				if not GetTool(v) then
        			GetGun(v)
    			end
			end
		end
	end
	if settings.nodoors == true then
    	NoDoors()
	end
end)

-- Command list
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

    	if teamArg == "criminals" or teamArg == "crims" or teamArg == "crim" or teamArg == "criminal" then
        	ChangeTeam(Teams.Criminals)
    	elseif teamArg == "inmates" or teamArg == "inmate" or teamArg == "prisoner" or teamArg == "prisoners" then
        	ChangeTeam(Teams.Inmates)
    	elseif teamArg == "guards" or teamArg == "guard" then
        	if #Teams.Guards:GetPlayers() > 7 then
            	Notify("The team is full, cannot join!")
        	else
            	ChangeTeam(Teams.Guards)
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

	if string.sub(lowerMsg, 1, #prefix + 8) == prefix.."killaura" then
        settings.killaura = true
        Notify("Enabled killaura.")
    end

    if string.sub(lowerMsg, 1, #prefix + 10) == prefix.."unkillaura" then
        settings.killaura = false
        Notify("Disabled killaura.")
    end

	if string.sub(lowerMsg, 1, #prefix + 6) == prefix.."araura" then
        settings.arrestaura = true
        Notify("Enabled arrestaura - make sure you are on the Guards Team!")
    end

    if string.sub(lowerMsg, 1, #prefix + 8) == prefix.."unaraura" then
        settings.arrestaura = false
        Notify("Disabled arrestaura.")
    end

	if string.sub(lowerMsg, 1, #prefix + 8) == prefix.."kasphere" then
        settings.killaura_sphere = true
        Notify("Kill aura sphere visible.")
    end

    if string.sub(lowerMsg, 1, #prefix + 10) == prefix.."unkasphere" then
        settings.killaura_sphere = false
        Notify("Kill aura sphere invisible.")
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
        settings.auto_pg = true
		Notify("Your guns will now have unlimited range and spread!")
    end

	if string.sub(lowerMsg, 1, #prefix + 9) == prefix.."unpowguns" then
        settings.auto_pg = false
		Notify("Your guns will no longer have unlimited range and spread.")
    end
	
	if string.sub(lowerMsg, 1, #prefix + 8) == prefix.."fastguns" then
        settings.auto_fg = true
		Notify("Your guns will now have fast fire-rate.")
    end

	if string.sub(lowerMsg, 1, #prefix + 10) == prefix.."unfastguns" then
        settings.auto_fg = false
		Notify("Your guns will no longer have fast fire-rate.")
    end

	if string.sub(lowerMsg, 1, #prefix + 8) == prefix.."firerate" then
		local parts = lowerMsg:split(" ")
		settings.auto_fgrate = tonumber(parts[2])
		Notify("Firerate of all your guns will now be "..settings.auto_fgrate..".")
	end

	if string.sub(lowerMsg, 1, #prefix + 8) == prefix.."karadius" then
		local parts = lowerMsg:split(" ")
		settings.killaura_radius = tonumber(parts[2])
		Notify("Kill aura will now be "..settings.killaura_radius..".")
	end

	
	if string.sub(lowerMsg, 1, #prefix + 6) == prefix.."opguns" then
        settings.auto_pg = true
		settings.auto_fg = true
		Notify("Your guns will now be powerful and fast!")
    end

	if string.sub(lowerMsg, 1, #prefix + 8) == prefix.."unopguns" then
        settings.auto_pg = false
		settings.auto_fg = false
		Notify("Your guns will no longer be powerful and fast!")
    end

    if string.sub(lowerMsg, 1, #prefix + 3) == prefix.."pkf" then
        for i, v in ipairs(Killfeed:GetChildren()) do
	        print(v.Name)
        end
        Notify("Printed Kill Feed to /console.")
    end

    if string.sub(lowerMsg, 1, #prefix + 6) == prefix.."nodoors" then
    	settings.nodoors = true
		Notify("Removed collision of doors.")
	end

	if string.sub(lowerMsg, 1, #prefix + 8) == prefix.."adddoors" then
    	settings.nodoors = false
		Notify("Added collision of doors.")
		AddDoors()
	end

	if string.sub(lowerMsg, 1, #prefix + 8) == prefix.."autoguns" then
    	settings.autoguns = true
		Notify("Guns auto given.")
	end

	if string.sub(lowerMsg, 1, #prefix + 10) == prefix.."unautoguns" then
    	settings.autoguns = false
		Notify("Guns no longer auto given.")
	end
end

game:GetService("TextChatService").MessageReceived:Connect(function(tbl)
    if not tbl.TextSource then return end
    local player = Players:GetPlayerByUserId(tbl.TextSource.UserId)
    if not player or player ~= LocalPlayer then return end

    handleCommand(tbl.Text)
end)

--local Humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
--Humanoid:ChangeState(Enum.HumanoidStateType.Dead)



-- GUI --

-- Team Management --
MainTab:CreateSection("Team Management")

MainTab:CreateButton({
    Name = "Switch to Inmates",
    Callback = function()
        ChangeTeam(Teams.Inmates)
    end,
})

MainTab:CreateButton({
    Name = "Switch to Guards",
    Callback = function()
        if #Teams.Guards:GetPlayers() > 7 then
            Notify("The team is full, cannot join!")
        else
            ChangeTeam(Teams.Guards)
        end
    end,
})

MainTab:CreateButton({
    Name = "Switch to Criminals",
    Callback = function()
        ChangeTeam(Teams.Criminals)
    end,
})

-- Weapon Management --
MainTab:CreateSection("Weapon Management")

MainTab:CreateDropdown({
    Name = "Get Specific Gun",
    Options = allGuns,
    Flag = "GunDropdown",
    Callback = function(Option)
        local gun = Option[1]
        print(gun)
        GetGun(gun)
    end,
})

MainTab:CreateButton({
    Name = "Get All Guns",
    Callback = function()
        for i, v in allGuns do
            if v == "M4A1" and plr_pass == false then 
            else
                if not GetTool(v) then
                    GetGun(v)
                end
            end
        end
    end,
})

-- Aura Settings --
CombatTab:CreateSection("Aura Settings")

CombatTab:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = settings.killaura,
    Flag = "KillAuraToggle",
    Callback = function(Value)
        settings.killaura = Value
    end,
})

CombatTab:CreateToggle({
    Name = "Arrest Aura",
    CurrentValue = settings.arrestaura,
    Flag = "ArrestAuraToggle",
    Callback = function(Value)
        settings.arrestaura = Value
    end,
})

CombatTab:CreateToggle({
    Name = "Kill Aura Sphere",
    CurrentValue = settings.killaura_sphere,
    Flag = "KASphereToggle",
    Callback = function(Value)
        settings.killaura_sphere = Value
    end,
})

CombatTab:CreateSlider({
    Name = "Kill Aura Radius",
    Range = {1, 50},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = settings.killaura_radius,
    Flag = "KARadiusSlider",
    Callback = function(Value)
        settings.killaura_radius = Value
    end,
})

-- Weapon Modifications --
CombatTab:CreateSection("Weapon Modifications")

CombatTab:CreateToggle({
    Name = "Powerful Guns",
    CurrentValue = settings.auto_pg,
    Flag = "PowerGunsToggle",
    Callback = function(Value)
        settings.auto_pg = Value
    end,
})

CombatTab:CreateToggle({
    Name = "Fast Guns",
    CurrentValue = settings.auto_fg,
    Flag = "FastGunsToggle",
    Callback = function(Value)
        settings.auto_fg = Value
    end,
})

CombatTab:CreateSlider({
    Name = "Fire Rate",
    Range = {0, 100},
    Increment = 1,
    Suffix = "RPS",
    CurrentValue = settings.auto_fgrate,
    Flag = "FireRateSlider",
    Callback = function(Value)
        settings.auto_fgrate = Value
    end,
})

-- Teleport Section --
local TeleportNames = {}
for name in pairs(Teleports) do
	table.insert(TeleportNames, name)
end
table.sort(TeleportNames)

TeleportTab:CreateSection("Locations")

TeleportTab:CreateDropdown({
    Name = "Teleport To",
    Options = TeleportNames,
    Flag = "TPDropdown",
    Callback = function(Option)
        local locName = Option[1]
        --print("Teleporting to:", locName)
		teleportTo(locName)
    end,
})

-- Automation --
SettingsTab:CreateSection("Automation")

SettingsTab:CreateToggle({
    Name = "Auto Respawn",
    CurrentValue = settings.autorespawn,
    Flag = "AutoRespawnToggle",
    Callback = function(Value)
        settings.autorespawn = Value
    end,
})

SettingsTab:CreateToggle({
    Name = "Auto Guns",
    CurrentValue = settings.autoguns,
    Flag = "AutoGunsToggle",
    Callback = function(Value)
        settings.autoguns = Value
    end,
})

SettingsTab:CreateToggle({
    Name = "No Doors",
    CurrentValue = settings.nodoors,
    Flag = "NoDoorsToggle",
    Callback = function(Value)
        settings.nodoors = Value
        if not Value then
            AddDoors()
        end
    end,
})

-- Protection --
SettingsTab:CreateSection("Protection")

SettingsTab:CreateToggle({
    Name = "Anti Arrest",
    CurrentValue = settings.antiarrest,
    Flag = "AntiArrestToggle",
    Callback = function(Value)
        settings.antiarrest = Value
    end,
})

SettingsTab:CreateToggle({
    Name = "Anti Tase",
    CurrentValue = settings.antitase,
    Flag = "AntiTaseToggle",
    Callback = function(Value)
        settings.antitase = Value
    end,
})

SettingsTab:CreateSection("UI")

SettingsTab:CreateToggle({
    Name = "Kill Feed Notifications",
    CurrentValue = settings.killfeed,
    Flag = "KillFeedToggle",
    Callback = function(Value)
        settings.killfeed = Value
    end,
})

Rayfield:LoadConfiguration()

print("PrisonX executed! Created by TS2021.")
Notify("PrisonX executed.")
