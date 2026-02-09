local Teams = game:GetService("Teams")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TeamEvent = ReplicatedStorage.Remotes:WaitForChild("RequestTeamChange")
TeamEvent:InvokeServer(Teams.Neutral)

-- that simple bitch!
