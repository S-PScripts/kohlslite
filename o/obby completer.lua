-- Obby completer script
-- Created for No Jump Obby but could work for others

start_at = 1 -- where it should start teleporting from
number_of_checkpoints = 241 -- set this to the number of checkpoints in the game
teleport_time = 0.5 -- slightly increased time for safety
local player = game.Players.LocalPlayer

local function teleport_to_checkpoints()
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    local checkpoints = workspace:WaitForChild("Checkpoints")
    local ending = false

    for i = start_at, number_of_checkpoints do
        local checkpoint = checkpoints:FindFirstChild(tostring(i))

        if checkpoint then
            repeat
                task.wait(0.1)
            until character and character:FindFirstChild("HumanoidRootPart")

            hrp.CFrame = checkpoint.CFrame + Vector3.new(0, 3, 0)

            task.wait(teleport_time)

        else
            print("Checkpoint " .. i .. " could not be found!")

            ending = true
            break
        end
    end

    if not ending then
        print("Successfully completed all checkpoints!")
    else
        print("Stopped at checkpoint " .. start_at + number_of_checkpoints - 1)
    end
end

teleport_to_checkpoints()
