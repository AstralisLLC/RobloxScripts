local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = game.Workspace.CurrentCamera
local ViewPortSize = Camera.ViewportSize
local Lighting = game:GetService("Lighting")

local fbEnabled = false

local Color = Color3.fromRGB(145, 0, 255)
local Thickness = 2
local Transparency = 1
local Filled = false

local Tracers = true
local TracerColor = Color3.fromRGB(0, 255, 255)

local useDisplayName = true
local Teamcheck = false

local Drawings = {}

local watermarkPos = Vector2.new(10, 10)
local watermarkSize = Vector2.new(200, 25)

local crosshairSize = 10
local crosshairWidth = 2

local textBounds = Vector2.zero

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Keys = loadstring(game:HttpGet("https://raw.githubusercontent.com/AstralisLLC/RobloxScripts/refs/heads/main/keys.lua"))()

local PlayerList = {}
local PlayerUtils = {}

PlayerUtils.GetPlayerFromName = function(Name)
    local playerToReturn:Player = nil
    for _, player in ipairs(PlayerList) do
        if player.Name == Name then
            playerToReturn = player
            break
        end
    end
    return playerToReturn or nil
end

PlayerUtils.GetCharacterFromPlayer = function(player:Player)
    local characterToReturn:Model = nil
    for _, p in ipairs(PlayerList) do
        if p == player then
            characterToReturn = p.Character
            break
        end
    end
    return characterToReturn or nil
end

PlayerUtils.GetPlayerFromCharacter = function(character:Model)
    local playerToReturn:Player = nil
    for _, player in ipairs(PlayerList) do
        if player.Character == character then
            playerToReturn = player
            break
        end
    end
    return playerToReturn or nil
end

PlayerUtils.GetDisplayNameFromCharacter = function(character:Model)
    local playerToReturn:Player = nil
    for _, player in ipairs(PlayerList) do
        if player.Character == character then
            playerToReturn = player
            break
        end
    end
    return playerToReturn.DisplayName or nil
end

PlayerUtils.GetPlayerTeamFromCharacter = function(character:Model)
    local playerToReturn:Player = nil
    for _, player in ipairs(PlayerList) do
        if player.Character == character then
            playerToReturn = player
            break
        end
    end
    return playerToReturn.Team or nil
end

for _, v in Players:GetPlayers() do
    if v ~= LocalPlayer then
        table.insert(PlayerList, v)
    end
end

Players.PlayerAdded:Connect(function(player)
    table.insert(PlayerList, player)
end)

Players.PlayerRemoving:Connect(function(player)
    for i, v in ipairs(PlayerList) do
        if v == player then
            table.remove(PlayerList, i)
            break
        end
    end
end)


-- Clone a function or object, used for debugging or getting around detections
local function cloneref(o) return o end

if not Drawing then
    print("Drawing library not found, please stop using shitsploits")
    return
end

local function getWorldspaceBounds(Character:Model)
    local Pos:CFrame, Size:Vector3 = Character:GetBoundingBox()
    local Normalized:Vector3 = Size / 2

    local WorlspaceCorners = {
        Pos.Position + Vector3.new(Normalized.X, Normalized.Y, Normalized.Z),
        Pos.Position + Vector3.new(-Normalized.X, Normalized.Y, Normalized.Z),
        Pos.Position + Vector3.new(Normalized.X, Normalized.Y, -Normalized.Z),
        Pos.Position + Vector3.new(-Normalized.X, Normalized.Y, -Normalized.Z),
        Pos.Position + Vector3.new(Normalized.X, -Normalized.Y, Normalized.Z),
        Pos.Position + Vector3.new(-Normalized.X, -Normalized.Y, Normalized.Z),
        Pos.Position + Vector3.new(Normalized.X, -Normalized.Y, -Normalized.Z),
        Pos.Position + Vector3.new(-Normalized.X, -Normalized.Y, -Normalized.Z)
    }

    return WorlspaceCorners
end

-- Draws text on the screen with an offset, positive by default
local function drawTextWithOffset(Text:string, Size:number, Position:Vector2, Color:Color3, Offset:Vector2, OffsetType:string?)
    local text = Drawing.new("Text")
    text.Text = Text
    text.Size = Size
    if OffsetType == "CenterX" then
        Offset = Vector2.new(-text.TextBounds.X/2 + Offset.X, Offset.Y)
    elseif OffsetType == "CenterY" then
        Offset = Vector2.new(Offset.X, -text.TextBounds.X/2 + Offset.Y)
    elseif OffsetType == "AlignRight" then
        Offset = Vector2.new(-text.TextBounds.X + Offset.X, Offset.Y)
    elseif OffsetType == "AlignCenter" then
        Offset = Vector2.new(-text.TextBounds.X/2 + Offset.X, -text.TextBounds.Y/2 + Offset.Y)
    end
    text.Position = Position + Offset
    text.Color = Color
    text.Outline = true
    text.Visible = true

    table.insert(Drawings, text)
    return text
end

local function drawEspBox(Position: Vector2, Size: Vector2, Filled: boolean?, Color: Color3)
    local Box = Drawing.new("Square")
    Box.Position = Position
    Box.Size = Size
    Box.Color = Color
    Box.Thickness = Thickness
    Box.Transparency = Transparency
    Box.Filled = Filled or false
    Box.Visible = true

    table.insert(Drawings, Box)
end

local function getBoundingBox(Character: Model)
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    local screenPos, onScreen = Camera:WorldToViewportPoint(Character.HumanoidRootPart.Position)

    if not onScreen then
        return
    end

    local Name = "Player"
    if useDisplayName then
        Name = PlayerUtils.GetDisplayNameFromCharacter(Character) or "Player"
    else
        local player = PlayerUtils.GetPlayerFromCharacter(Character)
        if player then
            Name = player.Name
        else
            print("No player?")
            Name = "Player"
        end
    end

    local Team = "No team"
    if PlayerUtils.GetPlayerTeamFromCharacter(Character) then
        Team = PlayerUtils.GetPlayerTeamFromCharacter(Character).Name or "Unknown"
    end

    -- Get worldspace bounds and project them to screen space
    local WorldspaceCorners = getWorldspaceBounds(Character)
    local ScreenCorners = {}
    for _, corner in ipairs(WorldspaceCorners) do
        local screenCorner, isVisible = Camera:WorldToViewportPoint(corner)
        if not isVisible then
            return
        end
        table.insert(ScreenCorners, Vector2.new(screenCorner.X, screenCorner.Y))
    end

    -- Calculate the top-left corner and size of the bounding box
    local minX, minY = math.huge, math.huge
    local maxX, maxY = -math.huge, -math.huge
    for _, corner in ipairs(ScreenCorners) do
        minX = math.min(minX, corner.X)
        minY = math.min(minY, corner.Y)
        maxX = math.max(maxX, corner.X)
        maxY = math.max(maxY, corner.Y)
    end

    local BoxPosition = Vector2.new(minX, minY)
    local BoxSize = Vector2.new(maxX - minX, maxY - minY)

    -- Draw the box
    drawEspBox(BoxPosition, BoxSize, false, Color)

    -- Draw player name and team on the left side of the box
    drawTextWithOffset(Name .. " | " .. Team, 12, BoxPosition, Color3.fromRGB(255, 255, 255), Vector2.new(-2, 0), "AlignRight")

    -- Draw player health and distance on the right side of the box
    local distance = math.floor((Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
    drawTextWithOffset("Distance: " .. distance .. " | Health: " .. math.floor((Character.Humanoid.Health / Character.Humanoid.MaxHealth) * 100) .. "%", 12, Vector2.new(BoxPosition.X, BoxPosition.Y), Color3.fromRGB(255, 255, 255), Vector2.new(BoxSize.X + 2, 0), nil)
end

local function drawWatermarkContainer()
    local container = Drawing.new("Square")
    container.Size = textBounds + Vector2.new(4, 4) or watermarkSize + Vector2.new(4, 4)
    container.Position = watermarkPos
    container.Color = Color3.fromRGB(0, 0, 0)
    container.Thickness = 1
    container.Filled = true
    container.Visible = true

    local containerOutline = Drawing.new("Square")
    containerOutline.Size = textBounds + Vector2.new(4, 4) or watermarkSize + Vector2.new(4, 4)
    containerOutline.Position = watermarkPos - Vector2.new(1, 1)
    containerOutline.Color = Color3.fromRGB(255, 255, 255)
    containerOutline.Thickness = 1
    containerOutline.Visible = true

    table.insert(Drawings, container)
    table.insert(Drawings, containerOutline)
end

local function drawWatermark()
    local text = Drawing.new("Text")
    text.Text = "<ESP V2 | DEV BUILD>"
    text.Size = 12
    text.Position = watermarkPos + Vector2.new(2, 2)
    text.Color = Color3.new(0.7, 0, 1)
    text.Outline = true
    text.Visible = true

    table.insert(Drawings, text)
    textBounds = text.TextBounds
end


local function clearDrawings()
    for _, v in Drawings do
        v:Remove()
    end
    Drawings = {}
end

Lighting.Changed:Connect(function(prop)
    if prop ~= "Ambient" and fbEnabled == true then return end
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
end)

RunService.RenderStepped:Connect(function()
    clearDrawings()

    for _, plr: Player in PlayerList do
        if plr == LocalPlayer then continue end
        if not plr.Character or not plr.Character.HumanoidRootPart then continue end
        getBoundingBox(plr.Character)
    end

    drawWatermarkContainer()
    drawWatermark()
end)

local vert = Drawing.new("Line")
vert.Color = Color3.new(0,1,0)
vert.Width = crosshairWidth
vert.From = Vector2.new(ViewPortSize.X/2, ViewPortSize.Y/2 - (crosshairSize / 2))
vert.To = Vector2.new(ViewPortSize.X/2, ViewPortSize.Y/2 + (crosshairSize / 2))
vert.Visible = true

local horiz = Drawing.new("Line")
horiz.Color = Color3.new(0,1,0)
horiz.Width = crosshairWidth
horiz.From = Vector2.new(ViewPortSize.X/2 - (crosshairSize / 2), ViewPortSize.Y/2)
horiz.To = Vector2.new(ViewPortSize.X/2 + (crosshairSize / 2), ViewPortSize.Y/2)
horiz.Visible = true

-- Toggle for fullbright
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if input.KeyCode == Keys.GeyKey("RightAlt") then
        fbEnabled = not fbEnabled
        Lighting.Ambient = fbEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    end
end)