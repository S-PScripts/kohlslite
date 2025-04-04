-- This is like some template

--[[
 ________  ________  ___  ________  ________  ________      ___    ___ 
|\   __  \|\   __  \|\  \|\   ____\|\   __  \|\   ___  \   |\  \  /  /|
\ \  \|\  \ \  \|\  \ \  \ \  \___|\ \  \|\  \ \  \\ \  \  \ \  \/  / /
 \ \   ____\ \   _  _\ \  \ \_____  \ \  \\\  \ \  \\ \  \  \ \    / / 
  \ \  \___|\ \  \\  \\ \  \|____|\  \ \  \\\  \ \  \\ \  \  /     \/  
   \ \__\    \ \__\\ _\\ \__\____\_\  \ \_______\ \__\\ \__\/  /\   \  
    \|__|     \|__|\|__|\|__|\_________\|_______|\|__| \|__/__/ /\ __\ 
                            \|_________|                   |__|/ \|__| a1.0

View the source here: https://prisonx.pages.dev/source.lua
PrisonX is updated here: https://github.com/S-PScripts/prisonx/blob/main/source.lua
Debugged with: https://glot.io/new/lua

PrisonX is a free, open-source script for the Roblox game created by Aesthetical, Prison Life.
This script was created by ScriptingProgrammer (Roblox) / ts2021 (Discord) / S-PScripts (GitHub).

You can play PL here: https://www.roblox.com/games/155615604/Prison-Life

This script is not updated much due to school and other interests, but I'll still add more stuff to come.
]]

-- Script name = PrisonX
getgenv().scriptname = "PrisonX"

-- Notifications
local function Remind(msg, length)
        game.StarterGui:SetCore("SendNotification", {
                Title = "PrisonX a1.0",
                Text = msg,
                Duration = length or 1
        })
end;

-- Check if PrisonX is already executed
if getgenv().plxexec then 
        return 
        Remind("You've already executed KohlsLite!") 
end

if game.PlaceId ~= 155615604 then
        local response = Instance.new("BindableFunction")
        function response.OnInvoke(answer)
            if answer == "Yes" then
                game:GetService("TeleportService"):Teleport(112420803, game:GetService("Players").LocalPlayer) -- nbc join only.
            end
        end
        game:GetService("StarterGui"):SetCore("SendNotification",
            {
                Title = "PrisonX Manager",
                Text = "You are not in Prison Life. Would you like to join it?",
                Duration = math.huge,
                Callback = response,
                Button1 = "Yes",
                Button2 = "No"
            }
        )
        return
    end
end

-- Loader
if not game:IsLoaded() then
    local notLoaded = Instance.new("Message")
    notLoaded.Parent = game:GetService("CoreGui")
    notLoaded.Text = "PrisonX is waiting for the game to load..."
    game.Loaded:Wait()
    notLoaded:Destroy()
end

--loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()

-- Don't touch this!
getgenv().plxexec = true

-- The prefix you are using for PrisonX. This can be of any length.
getgenv().deprefix = "." 

-- The version of PrisonX
getgenv().plxversion = "a1.0"

-- Chat function
local function Chat(msg)
      game.Players:Chat(msg)
end

-- Speak function
local function Speak(msg)
    game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
end

-- Prefix checker
local prefix 

if getgenv().theprefix then
   	prefix = getgenv().theprefix
else
	prefix = getgenv().deprefix
end

-- Defaults (you can change these)
local defaults = {}

-- Mobile checker
local IsOnMobile = table.find({Enum.Platform.IOS, Enum.Platform.Android}, game:GetService("UserInputService"):GetPlatform()) -- From Infinite Yield

-- Stats when loading
local Stats = {}
Stats.starttime = os.clock()

-- Start up scripts
local function startupScripts()
     	if not getgenv().autoruncmds then
        	for i = 1, #defaults do
             		Chat(defaults[i]) 
         	end
	else
        	for i = 1, #getgenv().autoruncmds do
             		Chat(getgenv().autoruncmds[i])
         	end
     	end
end

print("PrisonX executed! Version: "..getgenv().plxversion)

game.Players.LocalPlayer.Chatted:Connect(function(msg)
end)
