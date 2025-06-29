-- for no jump obby
local player = game.Players.LocalPlayer

local function teleport_to_checkpoints()
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")
	local checkpoints = workspace:WaitForChild("Checkpoints")

	for i = 1, 241 do
		local checkpoint = checkpoints:FindFirstChild(tostring(i))
		if checkpoint then
			hrp.CFrame = checkpoint.CFrame + Vector3.new(0, 3, 0)
			wait(0.2)
		end
	end
end

teleport_to_checkpoints()
