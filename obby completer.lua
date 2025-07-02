-- for no jump obby
-- well, this probably works for other games like it as well
-- it could be better but idgaf

start_at = 1 -- where it should start teleporting from
number_of_checkpoints = 241 -- set this to the number of checkpoints in the game
teleport_time = 0.2 -- time before teleporting to each checkpoint
local player = game.Players.LocalPlayer

local function teleport_to_checkpoints()
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")
	local checkpoints = workspace:WaitForChild("Checkpoints")

	for i = start_at, number_of_checkpoint do
		local checkpoint = checkpoints:FindFirstChild(tostring(i))
		if checkpoint then
			hrp.CFrame = checkpoint.CFrame + Vector3.new(0, 3, 0)
			wait(teleport_time)
		end
	end
end

teleport_to_checkpoints()
