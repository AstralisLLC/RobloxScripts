local Camera = game.Workspace.CurrentCamera
local Mouse = game.Players.LocalPlayer:GetMouse()
local Players = game.Players
local LocalPlayer = Players.LocalPlayer

local PlayersList = {}

for _, v in Players:GetPlayers() do
    if v ~= LocalPlayer then
        table.insert(PlayersList, v)
    end
end

Players.PlayerAdded:Connect(function(player)
    table.insert(PlayersList, player)
end)

Players.PlayerRemoving:Connect(function(player)
    for i, v in ipairs(PlayersList) do
        if v == player then
            table.remove(PlayersList, i)
            break
        end
    end
end)

local circle = nil


local Enabled = false

local fov = 75 -- Change this to change aimbot fov

local targetPart = "Head"

local function drawFov()
    local fovCircle = Drawing.new("Circle")
    fovCircle.Position = Camera.ViewportSize / Vector2.new(2, 2)
    fovCircle.Radius = fov
    fovCircle.Color = Color3.fromRGB(255, 255, 255)
    fovCircle.Thickness = 1
    fovCircle.Transparency = 1
    fovCircle.NumSides = 100
    fovCircle.Filled = false
    fovCircle.Visible = true

    circle = fovCircle
end

local function getClosestToCenter()
    local target = nil
    local closest = math.huge

    for _, v in PlayersList do
        if v == LocalPlayer then continue end
        if not v.Character then continue end
        if not v.Character:FindFirstChild(targetPart) then continue end

        local Vector, OnScreen = Camera:WorldToViewportPoint(v.Character[targetPart].Position)
        local Distance = (Vector2.new(Vector.X, Vector.Y) - (Camera.ViewportSize / Vector2.new(2, 2))).Magnitude

        if OnScreen and Distance < closest and Distance <= fov then
            closest = Distance
            target = v.Character[targetPart]
        end
    end
    return target
end

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        Enabled = true
    end
end)
game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        Enabled = false
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if circle then
        circle:Remove()
        circle = nil
    end
    drawFov()
    if not Enabled then return end

    local target = getClosestToCenter()
    if not target then return end

    local targetPosition = Camera:WorldToViewportPoint(target.Position)
    local screenCenter = Camera.ViewportSize / Vector2.new(2, 2)
    local delta = Vector2.new(targetPosition.X, targetPosition.Y) - screenCenter

    mousemoverel(delta.X, delta.Y) -- Move the mouse relative to the target's position
end)