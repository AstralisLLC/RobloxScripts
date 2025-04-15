local aimbot = {}

aimbot.Camera = game.Workspace.CurrentCamera
aimbot.Players = game.Players
aimbot.LocalPlayer = aimbot.Players.LocalPlayer
aimbot.ToggleFov = false
aimbot.Toggled = false
aimbot.Enabled = false
aimbot.FovColor = Color3.new(1,1,1)
aimbot.numSides = 100
aimbot.fov = 75 -- Change this to change aimbot fov
aimbot.targetPart = "Head"
aimbot.circle = nil

aimbot.PlayersList = {}

for _, v in aimbot.Players:GetPlayers() do
    if v ~= aimbot.LocalPlayer then
        table.insert(aimbot.PlayersList, v)
    end
end

aimbot.Players.PlayerAdded:Connect(function(player)
    table.insert(aimbot.PlayersList, player)
end)

aimbot.Players.PlayerRemoving:Connect(function(player)
    for i, v in ipairs(aimbot.PlayersList) do
        if v == player then
            table.remove(aimbot.PlayersList, i)
            break
        end
    end
end)






aimbot.drawFov = function()
    local fovCircle = Drawing.new("Circle")
    fovCircle.Position = aimbot.Camera.ViewportSize / Vector2.new(2, 2)
    fovCircle.Radius = aimbot.fov
    fovCircle.Color = aimbot.FovColor
    fovCircle.Thickness = 1
    fovCircle.Transparency = 1
    fovCircle.NumSides = aimbot.numSides
    fovCircle.Filled = false
    fovCircle.Visible = true

    aimbot.circle = fovCircle
end

local function getClosestToCenter()
    local target = nil
    local closest = math.huge

    for _, v in aimbot.PlayersList do
        if v == aimbot.LocalPlayer then continue end
        if not v.Character then continue end
        if not v.Character:FindFirstChild(aimbot.targetPart) then continue end

        local Vector, OnScreen = aimbot.Camera:WorldToViewportPoint(v.Character[aimbot.targetPart].Position)
        local Distance = (Vector2.new(Vector.X, Vector.Y) - (aimbot.Camera.ViewportSize / Vector2.new(2, 2))).Magnitude

        if OnScreen and Distance < closest and Distance <= aimbot.fov then
            closest = Distance
            target = v.Character[aimbot.targetPart]
        end
    end
    return target
end

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aimbot.Enabled = true
    end
end)
game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aimbot.Enabled = false
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if aimbot.circle then
        aimbot.circle:Remove()
        aimbot.circle = nil
    end
    if aimbot.ToggleFov then
        aimbot.drawFov()
    end
    if aimbot.Toggled and aimbot.Enabled then

        local target = getClosestToCenter()
        if not target then return end

        local targetPosition = aimbot.Camera:WorldToViewportPoint(target.Position)
        local screenCenter = aimbot.Camera.ViewportSize / Vector2.new(2, 2)
        local delta = Vector2.new(targetPosition.X, targetPosition.Y) - screenCenter

        mousemoverel(delta.X, delta.Y) -- Move the mouse relative to the target's position
    end
end)

return aimbot