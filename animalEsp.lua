local Camera = game.Workspace.CurrentCamera
local Drawings = {}

-- Draws text on the screen with an offset, positive by default
local function drawTextWithOffset(Text:string, Size:number, Position:Vector2, Color:Color3, Offset:Vector2, OffsetType:string?)
    local text = Drawing.new("Text")
    text.Text = Text
    text.Size = Size
    if OffsetType == "CenterX" then
        Offset = Vector2.new(-text.TextBounds.X/2, Offset.Y)
    elseif OffsetType == "CenterY" then
        Offset = Vector2.new(Offset.X, -text.TextBounds.X/2)
    end
    text.Position = Position + Offset
    text.Color = Color
    text.Outline = true
    text.Visible = true

    table.insert(Drawings, text)
    return text
end

-- Get screen position
local function getScreenPosition(Position:Vector3)
    local Vector, OnScreen = Camera:WorldToViewportPoint(Position)
    local Distance = (Camera.CFrame.Position - Position).Magnitude
    return OnScreen, Vector2.new(Vector.X, Vector.Y), Distance
end

-- Loop workspace for animals
local function loopAnimals()
    for _, v in game.Workspace:FindFirstChild("Animals"):GetChildren() do
        if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
            local OnScreen, Position, Distance = getScreenPosition(v.HumanoidRootPart.Position)
            local s = v.Name:split("{")
            if OnScreen then
                drawTextWithOffset(s[1] .. " | Distance: " .. Distance, 12, Position, Color3.fromRGB(255, 255, 255), Vector2.new(0, -10), "CenterX")
            end
        end
    end
end

game:GetService("RunService").RenderStepped:Connect(function()
    for _, v in Drawings do
        v:Remove()
    end
    Drawings = {}
    loopAnimals()
end)