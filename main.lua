--[[
___  __    ________  ___  ___  ___       ________  ___       ___  _________  _______      
|\  \|\  \ |\   __  \|\  \|\  \|\  \     |\   ____\|\  \     |\  \|\___   ___\\  ___ \ 
\ \  \/  /|\ \  \|\  \ \  \\\  \ \  \    \ \  \___|\ \  \    \ \  \|___ \  \_\ \   __/|    
 \ \   ___  \ \  \\\  \ \   __  \ \  \    \ \_____  \ \  \    \ \  \   \ \  \ \ \  \_|/__  
  \ \  \\ \  \ \  \\\  \ \  \ \  \ \  \____\|____|\  \ \  \____\ \  \   \ \  \ \ \  \_|\ \ 
   \ \__\\ \__\ \_______\ \__\ \__\ \_______\____\_\  \ \_______\ \__\   \ \__\ \ \_______\
    \|__| \|__|\|_______|\|__|\|__|\|_______|\_________\|_______|\|__|    \|__|  \|_______| 

A script for agspureiam's game Kohls Admin House
Created by ScriptingProgrammer (Roblox) / ts2021 (Discord) / S-PScripts (GitHub)
View the source here: https://kohlslite.pages.dev/source.lua
]]

-- Prefix
getgenv().theprefix = "."

-- Autorun commands
getgenv().autoruncmds = {".antirocket me", ".tnok", ".antikill me"} --".antimsg me"

-- Run these commands when the user joins
getgenv().run_on_sight = {
		["ScriptingProgrammer"] = {".lua print('da owner joined so coolz')"}
	}

-- KL Starter GUI
getgenv().kohlsgui = false -- Simple GUI with instructions telling you how to use the script.

-- Autocrasher related (put KL in autoexecute)
getgenv().autocrasher = false -- Turn this on and it will autocrash KAH's servers.
getgenv().playertoken = ' ' -- You must get this. Go to  kohlslite.pages.dev/Assets/PLAYERTOKEN.lua for instructions.
getgenv().acgames = "All" -- What KAH games you want to crash ("All" for NBC and BC, "NBC" for NBC only, "BC" for BC only).
getgenv().whitelistedppl = {"ScriptingProgrammer"} -- It will not crash servers that have whitelisted players.
getgenv().perm = false -- If you don't have the perm gamepass, turn this on and it will give you a pad.
getgenv().acmode = "Dog" -- How you want to crash the server (Dog, Freeze, Shield).
getgenv().customcmds = {"h \n\n\n\n\n crashed by roblox \n\n\n\n\n"} -- Custom messages that run before the crash

-- Loadstring
loadstring(game:HttpGet("https://kohlslite.pages.dev/source.lua"))()

-- More settings can be found in the script's source itself.
