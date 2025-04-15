local esp = {}

esp.LocalPlayer = game:GetService("Players").LocalPlayer
esp.Camera = game.Workspace.CurrentCamera
esp.ViewPortSize = esp.Camera.ViewportSize

esp.Enabled = false
esp.Color = Color3.new(1, 0, 0)
esp.Thickness = 2
esp.Transparency = 1
esp.Filled = false

esp.useDisplayName = true
esp.Teamcheck = false

esp.Drawings = {}

esp.textBounds = Vector2.zero

esp.Players = game:GetService("Players")
esp.RunService = game:GetService("RunService")

esp.Flags = {
    ["Name"] = false,
    ["Team"] = false,
    ["Health"] = false,
    ["Distance"] = false
}

esp.UpdateFlags = function(tableOfFlags)
    for _, v in pairs(esp.Flags) do
        esp.Flags[v] = false
    end
    for _, flag in pairs(tableOfFlags) do
        print(flag)
        if esp.Flags[flag] then
            esp.Flags[flag] = true
        end
    end
end

esp.PlayerList = {}
esp.PlayerUtils = {}

esp.PlayerUtils.GetPlayerFromName = function(Name)
    local playerToReturn:Player = nil
    for _, player in ipairs(esp.PlayerList) do
        if player.Name == Name then
            playerToReturn = player
            break
        end
    end
    return playerToReturn or nil
end

esp.PlayerUtils.GetCharacterFromPlayer = function(player:Player)
    local characterToReturn:Model = nil
    for _, p in ipairs(esp.PlayerList) do
        if p == player then
            characterToReturn = p.Character
            break
        end
    end
    return characterToReturn or nil
end

esp.PlayerUtils.GetPlayerFromCharacter = function(character:Model)
    local playerToReturn:Player = nil
    for _, player in ipairs(esp.PlayerList) do
        if player.Character == character then
            playerToReturn = player
            break
        end
    end
    return playerToReturn or nil
end

esp.PlayerUtils.GetDisplayNameFromCharacter = function(character:Model)
    local playerToReturn:Player = nil
    for _, player in ipairs(esp.PlayerList) do
        if player.Character == character then
            playerToReturn = player
            break
        end
    end
    return playerToReturn.DisplayName or nil
end

esp.PlayerUtils.GetPlayerTeamFromCharacter = function(character:Model)
    local playerToReturn:Player = nil
    for _, player in ipairs(esp.PlayerList) do
        if player.Character == character then
            playerToReturn = player
            break
        end
    end
    return playerToReturn.Team or nil
end

for _, v in esp.Players:GetPlayers() do
    if v ~= esp.LocalPlayer then
        table.insert(esp.PlayerList, v)
    end
end

esp.Players.PlayerAdded:Connect(function(player)
    table.insert(esp.PlayerList, player)
end)

esp.Players.PlayerRemoving:Connect(function(player)
    for i, v in ipairs(esp.PlayerList) do
        if v == player then
            table.remove(esp.PlayerList, i)
            break
        end
    end
end)

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

    table.insert(esp.Drawings, text)
    return text
end

local function drawEspBox(Position: Vector2, Size: Vector2, Filled: boolean?, Color: Color3)
    local Box = Drawing.new("Square")
    Box.Position = Position
    Box.Size = Size
    Box.Color = Color
    Box.Thickness = esp.Thickness
    Box.Transparency = esp.Transparency
    Box.Filled = Filled or false
    Box.Visible = true

    table.insert(esp.Drawings, Box)

    local Outline = Drawing.new("Square")
    Outline.Position = Position - Vector2.new(1, 1)
    Outline.Size = Size + Vector2.new(2, 2)
    Outline.Color = Color3.fromRGB(0, 0, 0)
    Outline.Thickness = 1
    Outline.Transparency = esp.Transparency
    Outline.Filled = false
    Outline.Visible = true
    table.insert(esp.Drawings, Outline)

    local Inline = Drawing.new("Square")
    Inline.Position = Position + Vector2.new(1, 1)
    Inline.Size = Size - Vector2.new(2, 2)
    Inline.Color = Color3.fromRGB(0, 0, 0)
    Inline.Thickness = 1
    Inline.Transparency = esp.Transparency
    Inline.Filled = false
    Inline.Visible = true
    table.insert(esp.Drawings, Inline)

end

local function getBoundingBox(Character: Model)
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    local screenPos, onScreen = esp.Camera:WorldToViewportPoint(Character.HumanoidRootPart.Position)

    if not onScreen then
        return
    end

    local Name = "Player"
    if esp.useDisplayName then
        Name = esp.PlayerUtils.GetDisplayNameFromCharacter(Character) or "Player"
    else
        local player = esp.PlayerUtils.GetPlayerFromCharacter(Character)
        if player then
            Name = player.Name
        else
            print("No player?")
            Name = "Player"
        end
    end

    local Team = "No team"
    if esp.PlayerUtils.GetPlayerTeamFromCharacter(Character) then
        Team = esp.PlayerUtils.GetPlayerTeamFromCharacter(Character).Name or "Unknown"
    end

    -- Get worldspace bounds and project them to screen space
    local WorldspaceCorners = getWorldspaceBounds(Character)
    local ScreenCorners = {}
    for _, corner in ipairs(WorldspaceCorners) do
        local screenCorner, isVisible = esp.Camera:WorldToViewportPoint(corner)
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
    drawEspBox(BoxPosition, BoxSize, false, esp.Color)

    -- Draw player name and team on the left side of the box
    if table.find(esp.Flags, "Name") and not table.find(esp.Flags, "Team") then
        drawTextWithOffset(Name, 12, Vector2.new(BoxPosition.X, BoxPosition.Y), Color3.fromRGB(255, 255, 255), Vector2.new(0, -BoxSize.Y/2), "AlignCenter")
    elseif table.find(esp.Flags, "Team") and not table.find(esp.Flags, "Name") then
        drawTextWithOffset(Team, 12, Vector2.new(BoxPosition.X, BoxPosition.Y), Color3.fromRGB(255, 255, 255), Vector2.new(0, -BoxSize.Y/2), "AlignCenter")
    elseif table.find(esp.Flags, "Name") and table.find(esp.Flags, "Team") then
        drawTextWithOffset(Name .. " | " .. Team, 12, Vector2.new(BoxPosition.X, BoxPosition.Y), Color3.fromRGB(255, 255, 255), Vector2.new(0, -BoxSize.Y/2), "AlignCenter")
    end

    -- Draw player health and distance on the right side of the box
    local distance = math.floor((Character.HumanoidRootPart.Position - esp.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
    if table.find(esp.Flags, "Health") and not table.find(esp.Flags, "Distance") then
        drawTextWithOffset("Health: " .. math.floor((Character.Humanoid.Health / Character.Humanoid.MaxHealth) * 100) or 0 .. "%", 12, Vector2.new(BoxPosition.X + BoxSize.X, BoxPosition.Y), Color3.fromRGB(255, 255, 255), Vector2.new(0, -BoxSize.Y/2), "AlignCenter")
    elseif table.find(esp.Flags, "Distance") and not table.find(esp.Flags, "Health") then
        drawTextWithOffset("Distance: " .. distance, 12, Vector2.new(BoxPosition.X, BoxPosition.Y), Color3.fromRGB(255, 255, 255), Vector2.new(BoxSize.X + 2, 0), nil)
    elseif table.find(esp.Flags, "Health") and table.find(esp.Flags, "Distance") then
        drawTextWithOffset("Distance: " .. distance .. " | Health: " .. math.floor((Character.Humanoid.Health / Character.Humanoid.MaxHealth) * 100) .. "%", 12, Vector2.new(BoxPosition.X, BoxPosition.Y), Color3.fromRGB(255, 255, 255), Vector2.new(BoxSize.X + 2, 0), nil)
    end
end

esp.clearDrawings = function()
    for _, v in esp.Drawings do
        v:Remove()
    end
    esp.Drawings = {}
end

esp.RunService.RenderStepped:Connect(function()
    esp.clearDrawings()

    if esp.Enabled == false then
        return
    end

    for _, plr: Player in esp.PlayerList do
        if plr == esp.LocalPlayer then continue end
        if not plr.Character or not plr.Character.HumanoidRootPart then continue end
        getBoundingBox(plr.Character)
    end
end)

getgenv().Config = {
	Invite = "informant.wtf",
	Version = "0.0",
}

getgenv().luaguardvars = {
	DiscordName = "username#0000",
}

local vars = {
    NotiText = "Enter desired notification text",
    chamsEnabled = false,
    chamsColor = Color3.fromRGB(255, 0, 0),
    WS = 16,
    WS_ENABLED = false,
    Jump = 50,
    ORIGINAL_WS = game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed or game:GetService("Players").LocalPlayer.CharacterAdded:Wait().Humanoid.WalkSpeed,
    ORIGINAL_JUMP = game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower or game:GetService("Players").LocalPlayer.CharacterAdded:Wait().Humanoid.JumpPower,
}

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/drillygzzly/Other/main/1"))()

library:init() -- Initalizes Library Do Not Delete This

local Window = library.NewWindow({
	title = "Shitware.lol",
	size = UDim2.new(0, 525, 0, 650)
})

local tabs = {
    LocalTab = Window:AddTab("Local"),
	Settings = library:CreateSettingsTab(Window),
}


local sections = {
	MovementSec = tabs.LocalTab:AddSection("Movement", 1),
	VisualSec = tabs.LocalTab:AddSection("Placeholder", 2),
}

sections.MovementSec:AddSeparator({
	text = "Separator"
})

sections.MovementSec:AddBind({
	text = "Toggle WalkSpeed",
	flag = "toggleWs",
	nomouse = true,
	noindicator = true,
	tooltip = "Sets the WalkSpeed keybind",
	mode = "toggle",
	bind = Enum.KeyCode.Q,
	risky = true,
	callback = function(v)
	    print("Key pressed, ws is now: ", v)
        vars.WS_ENABLED = v
	end
})

sections.MovementSec:AddSlider({
	text = "WalkSpeed", 
	flag = 'wsSlider', 
	suffix = "WS", 
	value = 16,
	min = 1, 
	max = 128,
	increment = 1,
	tooltip = "Changes the desired walkspeed",
	risky = true,
	callback = function(ws) 
		print("WalkSpeed Is Now : ".. ws)
        vars.WS = ws
	end
})

sections.VisualSec:AddSeparator({
    text = "Chams"
})

sections.VisualSec:AddToggle({
	enabled = true,
	text = "Toggle Chams",
	flag = "chamsToggle",
	tooltip = "Toggleschams",
	risky = false, -- turns text to red and sets label to risky
	callback = function(val)
        print("Chams Is Now : ", val)
        vars.chamsEnabled = val
	end
})

sections.VisualSec:AddColor({
    enabled = true,
    text = "Chams Color",
    flag = "chamsColorPick",
    tooltip = "Color Picker For Chams",
    color = Color3.new(255, 0, 0),
    trans = 0,
    open = false,
    callback = function(c)
        print("Chams Color Is Now : ", c)
        vars.chamsColor = c
    end
})

sections.VisualSec:AddSeparator({
    text = "ESP"
})

sections.VisualSec:AddToggle({
    enabled = true,
    text = "Toggle ESP",
    flag = "espToggle",
    tooltip = "Toggles ESP",
    risky = false,
    callback = function(val)
        esp.Enabled = val
    end
})

sections.VisualSec:AddColor({
    enabled = true,
    text = "ESP Color",
    flag = "espColorPick",
    tooltip = "Color Picker For ESP",
    color = Color3.new(1, 0, 0),
    trans = 0,
    open = false,
    callback = function(c)
        print("ESP Color Is Now : ", c)
        esp.Color = c
    end
})

sections.VisualSec:AddList({
	enabled = true,
	text = "ESP Flags",
	flag = "flagsSelector",
	multi = true,
	tooltip = "Selects Flags For ESP",
    risky = false,
    dragging = false,
    focused = false,
	value = nil,
	values = {
		["Name"] = "Name",
		["Team"] = "Team",
		["Distance"] = "Distance",
        ["Health"] = "Health"
	},
	callback = function(v)
        esp.UpdateFlags(v)
	end
})

sections.VisualSec:AddBox({
    enabled = true,
    focused = true,
    text = "Textbox",
    input = "Enter desired notification text",
	flag = "notiText",
	risky = false,
	callback = function(txt)
	    vars.NotiText = txt
	end
})

sections.VisualSec:AddButton({
	enabled = true,
	text = "Send Notification",
	flag = "notiButton",
	tooltip = "Sends a notification with the text defined above",
	risky = false,
	confirm = false, -- shows confirm button
	callback = function(v)
	    library:SendNotification(vars.NotiText, 5, Color3.new(255, 0, 0))
	end
})

sections.VisualSec:AddText({
    enabled = true,
    text = "Text1",
    flag = "Text_1",
    risky = false,
})

library:SendNotification("Loaded Shitware.wtf!", 5, Color3.new(1,0,0))

esp.RunService.RenderStepped:Connect(function()
    if vars.WS_ENABLED then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = vars.WS
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = vars.ORIGINAL_WS
    end

    if vars.chamsEnabled then
        for _,v in pairs(workspace:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Name ~= game.Players.LocalPlayer.Name then
                local highlight = Instance.new("Highlight", v)
                highlight.FillColor = vars.chamsColor
                highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0.5
            end
        end
    else
        for _,v in pairs(workspace:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Name ~= game.Players.LocalPlayer.Name then
                local highlight = v:FindFirstChildOfClass("Highlight")
                if highlight then
                    highlight:Destroy()
                end
            end
        end
    end
end)