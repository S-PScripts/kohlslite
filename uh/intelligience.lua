--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
if game.PlaceId == 112420803 then
    -- https://www.roblox.com/games/112420803/Kohls-Admin-House-NBC
 
    getgenv().autoregen = false
    getgenv().autoget = false
 
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
    local Window = Library.CreateLib("kohls admin house", "Sentinel")
    local a = Window:NewTab("sussy things")
    local b = Window:NewTab("fun")
 
    local a1 = a:NewSection("sussy things")
    local b1 = b:NewSection("fun")
 
 
    a1:NewToggle("auto regenerate buttons", "_", function(bool)
        getgenv().autoregen = bool
        print(on)
        if bool then
            regen()
        end
    end)
 
    a1:NewToggle("auto get buttons (read info)", "you will crash if you try to do this when punished", function(bool)
        getgenv().autoget = bool
        print(on)
        if bool then
            get()
        end
    end)
 
    a1:NewButton("regenerate buttons", "OMG WHAT??", function()
        for i, v in pairs(game:GetService("Workspace").Terrain["_Game"].Admin.Regen:GetDescendants()) do
            if v.Name == "ClickDetector" and v.Parent then
                fireclickdetector(v)
                wait()
                fireclickdetector(v)
            end
        end
    end)
 
    a1:NewButton("get buttons (read info)", "you will crash if you try to do this when punished", function()
        local player = game.Players.LocalPlayer.Character.HumanoidRootPart
        for i, v in pairs(game:GetService("Workspace").Terrain["_Game"].Admin.Pads:GetDescendants()) do
            if v.Name == "TouchInterest" and v.Parent.Name == "Head" then
                firetouchinterest(player, v.Parent, 0)
                wait()
                firetouchinterest(player, v.Parent, 1)
                wait()
            end
        end
    end)
 
    function regen()
        spawn(function()
            while getgenv().autoregen do
                for i, v in pairs(game:GetService("Workspace").Terrain["_Game"].Admin.Regen:GetDescendants()) do
                    if v.Name == "ClickDetector" and v.Parent then
                        fireclickdetector(v)
                        wait()
                        fireclickdetector(v)
                    end
                end
                wait(.01)
            end
        end)
    end
 
    function get()
        spawn(function()
            while getgenv().autoget do
                local player = game.Players.LocalPlayer.Character.HumanoidRootPart
                for i, v in pairs(game:GetService("Workspace").Terrain["_Game"].Admin.Pads:GetDescendants()) do
                    if v.Name == "TouchInterest" and v.Parent.Name == "Head" then
                        firetouchinterest(player, v.Parent, 0)
                        wait()
                        firetouchinterest(player, v.Parent, 1)
                        wait()
                    end
                end
                wait(.08)
            end
        end)
    end
 
 
end
 
