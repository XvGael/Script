-- made by disprrt

local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Configuration
local config = {
    notification = {
        title = "Auto Parry",
        text = "✅",
        duration = 2,
        button1 = "Yes"
    },
    parry = {
        minDistance = 0.5,
        maxDistance = 100,
        curveRestriction = 1.5,
        debugCurved = true,
        disableVisualizer = false
    },
    visualizer = {
        shape = Enum.PartType.Ball,
        material = Enum.Material.ForceField,
        transparency = 0.8,
        color = Color3.new(1, 1, 1)
    },
    autoParry = {
        key = Enum.KeyCode.F,
        debounceTime = 0.05  -- Increase debounce time to avoid double clicking
    },
    autoSpam = {
        closeDistance = 1,
        farDistance = 2
    }
}

-- Notification
StarterGui:SetCore("SendNotification", config.notification)

-- Utility Functions
local function getBall()
    for _, ball in ipairs(workspace.Balls:GetChildren()) do
        if not ball.Anchored then
            return ball
        end
    end
end

local function isTargeted()
    return character and character:FindFirstChild("Highlight") ~= nil
end

local function getDistanceAndBall()
    local ball = getBall()
    if humanoidRootPart and ball then
        local distance = (humanoidRootPart.Position - ball.Position).Magnitude
        return distance, ball
    end
    return math.huge, nil
end

local function getPing()
    return player:GetNetworkPing() * 1000  -- Convert to milliseconds
end

local function getParryDistance(ball)
    return math.clamp(ball.Velocity.Magnitude / 2.4 + getPing(), config.parry.minDistance, config.parry.maxDistance)
end

local function waitUntilNotTargeted()
    local timeout = false
    spawn(function()
        wait(0.8)
        timeout = true
    end)
    repeat
        RunService.Heartbeat:Wait()
    until not isTargeted() or timeout
end

-- Create Visualizer Circle
local visualizer = Instance.new("Part")
visualizer.Shape = config.visualizer.shape
visualizer.Material = config.visualizer.material
visualizer.Parent = workspace
visualizer.CanCollide = false
visualizer.Anchored = true
visualizer.CastShadow = false
visualizer.Transparency = config.visualizer.transparency

-- State Management
local lastCheckTime = tick()
local alreadyChecked = false
local lastVelocity = nil
local autoSpamActive = false

local function resetCheckState()
    alreadyChecked = false
    character = player.Character or player.CharacterAdded:Wait()
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
end

-- Connect character reset events
player.CharacterAdded:Connect(resetCheckState)
if character then
    character:WaitForChild("Humanoid").Died:Connect(resetCheckState)
end

local function isBallCurving(ball)
    if not lastVelocity then
        lastVelocity = ball.Velocity
        return false
    end
    local velocityChange = (ball.Velocity - lastVelocity).Magnitude
    lastVelocity = ball.Velocity
    local isCurving = velocityChange > config.parry.curveRestriction
    if isCurving and config.parry.debugCurved then
        print("Ball is curving!")
    end
    return isCurving
end

local function updateVisualizer()
    if humanoidRootPart and not config.parry.disableVisualizer then
        visualizer.CFrame = humanoidRootPart.CFrame
        local distance, ball = getDistanceAndBall()
        if ball then
            local parryDist = getParryDistance(ball)
            visualizer.Size = Vector3.new(parryDist, parryDist, parryDist)
        end
    end
end

local function autoSpam()
    while autoSpamActive do
        VirtualInputManager:SendKeyEvent(true, config.autoParry.key, false, nil)
        wait(config.autoParry.debounceTime)
        VirtualInputManager:SendKeyEvent(false, config.autoParry.key, false, nil)
        wait(config.autoParry.debounceTime)
    end
end

local function handleTargeting()
    local distance, ball = getDistanceAndBall()
    if isTargeted() and not alreadyChecked then
        visualizer.Color = ((tick() - lastCheckTime < 0.7 and distance < 1) or distance < 1) and Color3.new(1, 0, 0) or config.visualizer.color
        alreadyChecked = true
        lastCheckTime = tick()
    elseif not isTargeted() then
        alreadyChecked = false
    end

    if ball and ball.Velocity.Magnitude > 0 and isTargeted() and distance < getParryDistance(ball) then
        if isBallCurving(ball) then
            -- Additional logic for curving balls can be implemented here
        end
        VirtualInputManager:SendKeyEvent(true, config.autoParry.key, false, nil)
        wait(config.autoParry.debounceTime)
        VirtualInputManager:SendKeyEvent(false, config.autoParry.key, false, nil)
        waitUntilNotTargeted()
    end
end

local function handleAutoSpam()
    local enemy = getBall()  -- Assuming the ball is the enemy, replace with actual enemy detection if different
    if enemy then
        local distance = (humanoidRootPart.Position - enemy.Position).Magnitude
        if distance <= config.autoSpam.closeDistance and not autoSpamActive then
            autoSpamActive = true
            spawn(autoSpam)
        elseif distance > config.autoSpam.farDistance and autoSpamActive then
            autoSpamActive = false
        end
    end
end

local heartbeatConnection = RunService.Heartbeat:Connect(function()
    updateVisualizer()
    handleTargeting()
    handleAutoSpam()
    visualizer.Transparency = config.parry.disableVisualizer and 1 or config.visualizer.transparency
end)

-- Wait for disable signal
repeat
    RunService.Heartbeat:Wait()
until getgenv().disable

-- Cleanup
heartbeatConnection:Disconnect()
visualizer:Destroy()
autoSpamActive = false
