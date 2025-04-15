local camera = game.Workspace.CurrentCamera

local vps = camera.ViewportSize

local drawings = {}

local watermarkPos = Vector2.new(10, 10)
local watermarkSize = Vector2.new(200, 25)

local textBounds = Vector2.zero


local function clearDrawings()
    for _, v in drawings do
        v:Remove()
    end
    drawings = {}
end

local function chroma()
    local hue = tick() % 5 / 5
    return Color3.fromHSV(hue, 1, 1)
end

local function drawWatermarkContainer()
    local container = Drawing.new("Square")
    container.Size = textBounds + Vector2.new(2, 2) or watermarkSize + Vector2.new(2, 2)
    container.Position = watermarkPos
    container.Color = Color3.fromRGB(0, 0, 0)
    container.Thickness = 1
    container.Filled = true
    container.Visible = true

    local containerOutline = Drawing.new("Square")
    containerOutline.Size = textBounds + Vector2.new(2, 2) or watermarkSize + Vector2.new(2, 2)
    containerOutline.Position = watermarkPos - Vector2.new(1, 1)
    containerOutline.Color = Color3.fromRGB(255, 255, 255)
    containerOutline.Thickness = 1
    containerOutline.Visible = true

    table.insert(drawings, containerOutline)
end

local function drawWatermark()
    local text = Drawing.new("Text")
    text.Text = "<ESP V2 | DEV BUILD>"
    text.Size = 30
    text.Position = watermarkPos + Vector2.new(1, 1)
    text.Color = chroma()
    text.Outline = true
    text.Visible = true

    table.insert(drawings, text)
    textBounds = text.TextBounds
end

game:GetService("RunService").RenderStepped:Connect(function()
    clearDrawings()
    drawWatermarkContainer()
    drawWatermark()
end)