-- ============ VEHICLE MOD ============
local carContainer = workspace:WaitForChild("CarContainer")
local listcars = {}
local carNameLookup = {}

local function refreshCarList()
    listcars = {}
    carNameLookup = {}
    for _, car in ipairs(carContainer:GetChildren()) do
        local seat = car:FindFirstChild("VehicleSeat", true)
        if seat and car:FindFirstChild("Wheels") and not seat.Occupant then
            table.insert(listcars, car.Name)
            carNameLookup[car.Name] = car
        end
    end
end

local currentCar = nil
local seatConnection = nil

local function getCarFromSeat(seat)
    local model = seat
    local iterations = 0
    while model and model.Parent and model.Parent ~= carContainer do
        model = model.Parent
        iterations += 1
        if iterations > 20 then
            return nil
        end
    end
    if model and model.Parent == carContainer then
        return model
    end
    return nil
end

local function updateCurrentCar(_, seatPart)
    if seatPart and seatPart:IsA("VehicleSeat") then
        currentCar = getCarFromSeat(seatPart)
    else
        currentCar = nil
    end
end

local function hookCharacterSeat(char)
    task.spawn(function()
        local humanoid = char:WaitForChild("Humanoid", 5)
        if not humanoid or not char.Parent then return end

        if seatConnection then
            seatConnection:Disconnect()
            seatConnection = nil
        end

        currentCar = nil
        seatConnection = humanoid.Seated:Connect(updateCurrentCar)
    end)
end

if player.Character then
    hookCharacterSeat(player.Character)
end
player.CharacterAdded:Connect(hookCharacterSeat)

local function findLocalCar()
    return currentCar
end

local function flipCarVertical()
    local car = findLocalCar()
    if not car then return end
    local main = car:FindFirstChild("Body") and car.Body:FindFirstChild("Main")
    if not main then return end
    car.PrimaryPart = main
    local curCF = main.CFrame
    local x, y, z = curCF:ToEulerAnglesYXZ()
    local flipped = CFrame.new(curCF.Position) * CFrame.Angles(x + math.pi, y, z)
    car:PivotTo(flipped)
end

local function teleportCarToMe(carName)
    local car = carNameLookup[carName]
    if not car or not car:IsA("Model") then return false end

    local character = player.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end

    local body = car:FindFirstChild("Body")
    local main = body and body:FindFirstChild("Main")
    if not main then return false end

    local vehicleSeat = car:FindFirstChild("VehicleSeat", true)
    if not vehicleSeat then return false end

    local targetPos = humanoidRootPart.Position + Vector3.new(0, 3, 0)
    local curCF = main.CFrame
    local x, y, z = curCF:ToEulerAnglesYXZ()
    local targetCFrame = CFrame.new(targetPos) * CFrame.Angles(x, y, z)

    local partData = {}
    for _, v in ipairs(car:GetDescendants()) do
        if v:IsA("BasePart") then
            table.insert(partData, { part = v, wasAnchored = v.Anchored, wasCanCollide = v.CanCollide })
            v.Anchored = true
            v.CanCollide = false
        end
    end

    car.PrimaryPart = main

    local characterParts = {}
    for _, v in ipairs(character:GetDescendants()) do
        if v:IsA("BasePart") then
            table.insert(characterParts, { part = v, wasCanCollide = v.CanCollide })
            v.CanCollide = false
        end
    end

    local success = false
    for attempt = 1, 20 do
        pcall(function() car:PivotTo(targetCFrame) end)
        task.wait()
        local distance = (main.Position - targetPos).Magnitude
        if distance < 5 then
            success = true
            break
        end
        if attempt % 5 == 0 then
            targetCFrame = CFrame.new(targetPos + Vector3.new(math.random(-2, 2), 0, math.random(-2, 2))) * CFrame.Angles(x, y, z)
        end
    end

    task.spawn(function()
        for attempt = 1, 20 do
            if not character or not character:FindFirstChild("HumanoidRootPart") then break end
            pcall(function() character:PivotTo(vehicleSeat.CFrame + Vector3.new(0, 1, 0)) end)
            task.wait()
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp and (hrp.Position - vehicleSeat.Position).Magnitude < 3 then
                break
            end
        end
    end)

    task.wait(0.2)

    local restoreConnection
    restoreConnection = RunService.RenderStepped:Connect(function()
        restoreConnection:Disconnect()
        for _, data in ipairs(characterParts) do
            if data.part and data.part.Parent then
                data.part.CanCollide = data.wasCanCollide
            end
        end
        for _, data in ipairs(partData) do
            if data.part and data.part.Parent then
                data.part.Anchored = data.wasAnchored
                data.part.CanCollide = data.wasCanCollide
            end
        end
    end)

    return success
end

getgenv().FlipVehicle = function()
    flipCarVertical()
end

getgenv().RefreshCarList = function()
    refreshCarList()
    return listcars
end

getgenv().BringCar = function(carName)
    if carName then
        teleportCarToMe(carName)
    end
end

getgenv().TeleportToCar = function(carName)
    local car = carNameLookup[carName]
    if car then
        local vehicleseat = car:FindFirstChild("VehicleSeat", true)
        if vehicleseat and player.Character then
            player.Character:MoveTo(vehicleseat.Position)
        end
    end
end

-- ============ VEHICLE FLY ============
task.spawn(function()
    local MOVE_STEP = 1
    local TOL = 0.1
    local baseY, targetY, lastSlider = nil, nil, nil
    while true do
        task.wait()
        if not Settings.VehicleFlyEnabled then
            baseY, targetY, lastSlider = nil, nil, nil
            if workspace:FindFirstChild("CarPart") then
                workspace.CarPart:Destroy()
            end
            continue
        end

        local car = findLocalCar()
        if not car then
            if workspace:FindFirstChild("CarPart") then
                workspace.CarPart:Destroy()
            end
            baseY, targetY, lastSlider = nil, nil, nil
            continue
        end

        local main = car:FindFirstChild("Body") and car.Body:FindFirstChild("Main")
        if not main then continue end
        car.PrimaryPart = main
        local curCF = main.CFrame
        local curPos = curCF.Position
        local sliderVal = Settings.VehicleFlyHeight or 0

        if not workspace:FindFirstChild("CarPart") then
            local p = Instance.new("Part")
            p.Size = Vector3.new(100, 1, 100)
            p.Name = "CarPart"
            p.Anchored = true
            p.CanCollide = true
            p.Material = Enum.Material.SmoothPlastic
            p.Color = Color3.fromRGB(100, 100, 100)
            p.Transparency = 1
            p.Parent = workspace
        end

        if not baseY then
            baseY = curPos.Y
            targetY = baseY + sliderVal
            lastSlider = sliderVal
        elseif sliderVal ~= lastSlider then
            targetY = baseY + sliderVal
            lastSlider = sliderVal
        end

        if curPos.Y < targetY - TOL then
            local x, y, z = curCF:ToEulerAnglesYXZ()
            local newY = math.min(curPos.Y + MOVE_STEP, targetY)
            car:PivotTo(CFrame.new(Vector3.new(curPos.X, newY, curPos.Z)) * CFrame.Angles(x, y, z))
        elseif curPos.Y > targetY + TOL then
            local x, y, z = curCF:ToEulerAnglesYXZ()
            local newY = math.max(curPos.Y - MOVE_STEP, targetY)
            car:PivotTo(CFrame.new(Vector3.new(curPos.X, newY, curPos.Z)) * CFrame.Angles(x, y, z))
        end
    end
end)

RunService.Heartbeat:Connect(function()
    pcall(function()
        local carPart = workspace:FindFirstChild("CarPart")
        if not carPart then return end
        local car = findLocalCar()
        if not car or not car:FindFirstChild("Wheels") then return end
        local wheel = car.Wheels:FindFirstChildWhichIsA("BasePart")
        if not wheel then return end
        carPart.Position = Vector3.new(wheel.Position.X, wheel.Position.Y - 1.3, wheel.Position.Z)
    end)
end)

-- ============ VEHICLE SPEED ============
local VehicleTorqueDefault = 5
local VehicleTurnSpeedDefault = 5

RunService.RenderStepped:Connect(function()
    local car = findLocalCar()
    if car then
        local rwd = car:FindFirstChild("RWD")
        local lw = car:FindFirstChild("LW") and car.LW:FindFirstChild("VS")
        local rw = car:FindFirstChild("RW") and car.RW:FindFirstChild("VS")
        local vehicleseat = car:FindFirstChild("Body") and car.Body:FindFirstChild("VehicleSeat")
        if rwd and lw and rw and vehicleseat then
            if Settings.VehicleMaxSpeedEnabled then
                local maxSpeed = Settings.VehicleMaxSpeed or 110
                rwd.MaxSpeed = maxSpeed
                lw.MaxSpeed = maxSpeed
                rw.MaxSpeed = maxSpeed
                vehicleseat.MaxSpeed = maxSpeed

                rwd.Torque = VehicleTorqueDefault
                lw.Torque = VehicleTorqueDefault
                rw.Torque = VehicleTorqueDefault
                vehicleseat.Torque = VehicleTorqueDefault

                rwd.TurnSpeed = VehicleTurnSpeedDefault
                lw.TurnSpeed = VehicleTurnSpeedDefault
                rw.TurnSpeed = VehicleTurnSpeedDefault
                vehicleseat.TurnSpeed = VehicleTurnSpeedDefault
            else
                rwd.TurnSpeed = 1
                lw.TurnSpeed = 1
                rw.TurnSpeed = 1
                vehicleseat.TurnSpeed = 1
            end
        end
    end
end)
