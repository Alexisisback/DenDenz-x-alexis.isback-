local a = game:GetService("VirtualInputManager")
local b = game:GetService("RunService")
local c = game:GetService("Players").LocalPlayer
local d = loadstring(game:HttpGet("https://raw.githubusercontent.com/Alexisisback/Universal-/main/DenDenz%20x%20Alexis.isback"))()

local e = false
local ping = game:GetService("Stats"):FindFirstChild("Network"):FindFirstChild("ServerStatsItem"):FindFirstChild("Data Ping") -- Obtiene el ping

local function getFrameTime()
    local lastFrame = tick()
    game:GetService("RunService").RenderStepped:Connect(function()
        local currentFrame = tick()
        fps = currentFrame - lastFrame
        lastFrame = currentFrame
    end)
end

getFrameTime()

spawn(function()
    b.PreRender:Connect(function()
        if not getgenv().f then return end

        local g = d.FindTargetBall()
        if not g then return end

        local velocity = g.AssemblyLinearVelocity
        if g:FindFirstChild('zoomies') then 
            velocity = g.zoomies.VectorVelocity
        end

        local latency = ping:GetValue() / 1000 -- Calcula la latencia en segundos
        local predictedPosition = d.PredictFuturePosition(g, latency + fps)  -- Predice la posición futura en base a la latencia y FPS

        local j = c.Character.PrimaryPart.Position
        local direction = (j - predictedPosition).Unit
        local distance = c:DistanceFromCharacter(predictedPosition)
        local dotProduct = direction:Dot(velocity.Unit)
        local velocityMagnitude = velocity.Magnitude

        if dotProduct > 0 then
            local adjustedDistance = distance - 5
            local predictionRatio = adjustedDistance / velocityMagnitude

            if d.IsPlayerTarget(g) and predictionRatio <= 0.30 and not e then
                a:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                wait(0.01)
                e = true
            end
        else
            e = false
        end
    end)
end)
