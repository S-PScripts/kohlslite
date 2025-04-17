-- KohlsLite for NP/LEGACY
-- This is based off KohlsEco since it has a better structure. I never used the structure for normal KohlsLite since it would take me too long to remake
-- This doesn't have as many features because I can't be bothered

-- Prefix (can be changed) --
getgenv().klnp_prefix = "." 

-- Version (don't change this) --
getgenv().klnp_version = "v0.00 Alpha"

-- Variables for Chatted --
local admin = {klnp_prefix = klnp_prefix, klnp_version = klnp_version}
local commands = {}
local descriptions = {}

-- Variables for credits --
local creditables = {}
local creddesc = {}

-- Chat function --
local function Chat(msg)
	game:GetService("Players"):Chat(msg)
end

-- Remind function --
local function Remind(text, num)
	if num == nil then 
		num = 1 
	end
	game:GetService("StarterGui"):SetCore("SendNotification",
		{
			Title = "KohlsLite NP",
			Text = text,
			Duration = num
		}
	)
end

-- LocalPlayer variables --
local lplr = game:GetService("Players").LocalPlayer
local lp = game:GetService("Players").LocalPlayer

-- Execution check --
getgenv().klnp_executed = false

if getgenv().klnp_executed then 
	return Remind("KohlsECO is already executed.")
end

-- Gamepass checker --
local function gamepassCheck()
	local hasPerm = false
	local hasPersons = false

	if game:GetService("MarketplaceService"):UserOwnsGamePassAsync(lplr.UserId, 66254) then
		hasPerm = true
	elseif game:GetService("MarketplaceService"):UserOwnsGamePassAsync(lplr.UserId, 64354) then
		hasPerm = true
	else
		-- 
	end

	if game:GetService("MarketplaceService"):UserOwnsGamePassAsync(lplr.UserId, 35748) then
		hasPersons = true
	elseif game:GetService("MarketplaceService"):UserOwnsGamePassAsync(lplr.UserId, 37127) then
		hasPersons = true
	else
		--
	end

	return {hasPerm, hasPersons}
end

local gamepassData = gamepassCheck()
local hasPerm = gamepassData[1]
local hasPersons = gamepassData[2]

-- Command adder --
-- From Shortcut v2 NEW (https://github.com/Tech-187/Lua-scripts/blob/main/Shortcut__v2_src2.lua)
local debounce = tick()
function addcommand(information)
	local cmdName = information.name
	local cmdAlias = information.aliases
	local cmdFunction = information.funct
	local cmdDescription = information.description

	commands[cmdName] = cmdName
	descriptions[cmdName] = cmdDescription

	connections[#connections + 1] = 
		game.Players.LocalPlayer.Chatted:Connect(function(msg)
			if 0.5 > tick() - debounce then return else debounce = tick() end
				msg = msg:lower()
				args = msg:split(" ")
				if args[1] == admin.klnp_prefix .. cmdName then
					cmdFunction()
				end

				for _, alias in ipairs(cmdAlias) do
					if args[1] == admin.klnp_prefix .. alias then
					cmdFunction()
					break
				end
			end
		end)
end

function addcredit(cName, cDescription)
	creditables[cName] = cName
	creddesc[cName] = cDescription
end


-- Player finder --
local function getPlayer(p)
	for i, v in game.Players:GetPlayers() do
		if v.Name:lower():sub(1, p:len()) == p:lower() or v.DisplayName:lower():sub(1, p:len()) == p:lower() then
			return v
		end
	end
end

-- Command list --
addcommand({
	name = "cmds", -- not sure why in scv2 new it doesn't use the system that was created!
	aliases = {"commands"},
	description = "print out the commands for KohlsLite NP",
	funct = function()
		Remind("Check your console for the list of commands [/console]")
		print("Commands:")
		print("\n\")
		for i, v in pairs(commands) do
			dupe = v.. " - ".. descriptions[v]
			print(dupe)
		end
	end
})

-- Information --
addcommand({
	name = "help", 
	aliases = {},
	description = "print out information about KohlsECO",
	funct = function()
		print("Information:")
		print("\n\n\n")
		print("You are using KohlsLite NP by ScriptingProgrammer/ts2021/S-PScripts. This script has been maintained since 2025.")
		print("For help, please contact me on Discord at ts2021.")
		print("The version you are using is "..admin.klnp_version..".")
	end
})

-- Credits --
addcredit("ScriptingProgrammer (Roblox) / ts2021x (Discord)/ S-PScripts (GitHub)",
	"created KohlsLite and KohlsLite NP"
)

addcredit("trollfacenan",
	"creating the base for this script"
)


getgenv().klnp_executed = true
