-- KohlsLite
-- Created by ScriptingProgrammer (Roblox) / ts2021 (Discord) / S-PScripts (GitHub)

-- Prefix
getgenv().theprefix = "."

-- Autorun commands
getgenv().autoruncmds = {".antirocket me", ".tnok", ".antikill me"} --".antimsg me"

-- KL Starter GUI
getgenv().kohlsgui = false -- Simple GUI with instructions telling you how to use the script.

-- Autocrasher related
getgenv().autocrasher = false -- Turn this on and it will autocrash KAH's servers.
getgenv().playertoken = ' ' -- You must get this. Go to  kohlslite.pages.dev/Assets/PLAYERTOKEN.lua for instructions.
getgenv().acgames = "All" -- What KAH games you want to crash ("All" for NBC and BC, "NBC" for NBC only, "BC" for BC only).
getgenv().whitelistedppl = {"ScriptingProgrammer"} -- It will not crash servers that have whitelisted players.
getgenv().perm = false -- If you don't have the perm gamepass, turn this on and it will give you a pad.
getgenv().acmode = "Dog" -- How you want to crash the server (Dog, Freeze, Shield).
getgenv().customcmds = {"h \n\n\n\n\n crashed by roblox \n\n\n\n\n"} -- Custom messages that run before the crash

-- Loadstring
loadstring(game:HttpGet("https://kohlslite.pages.dev/source.lua"))()
