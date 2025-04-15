local this = {}

local Keys = loadstring(game:HttpGet("https://raw.githubusercontent.com/AstralisLLC/RobloxScripts/refs/heads/main/keys.lua"))()
local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local TweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0)

this.Keys = Keys -- To make accessible in other scripts

-- Generate a frame based on function inputs
this.Init = function(title:string, color:Color3, textColor:Color3, font:Enum.Font)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 700, 0, 600)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.BackgroundColor3 = color
    frame.BackgroundTransparency = 0.2
    frame.Parent = PlayerGui

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Text = title
    textLabel.TextColor3 = textColor
    textLabel.BackgroundTransparency = 1
    textLabel.Font = font
    textLabel.TextSize = 12
    textLabel.Parent = frame

    local tabsList = Instance.new("Frame")
    tabsList.Size = UDim2.new(1, 0, 0.2, 0)
    tabsList.Position = UDim2.new(0, 0, 0, 0)
    tabsList.BackgroundTransparency = 1
    tabsList.Parent = frame
    Instance.new("UIListLayout", tabsList).SortOrder = Enum.SortOrder.LayoutOrder

    local dropShadow = Instance.new("Frame")
    dropShadow.Size = UDim2.new(1.2, 0, 1.2, 0)
    dropShadow.Position = UDim2.new(-0.2, 0, -0.2, 0)
    dropShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    dropShadow.BackgroundTransparency = 0.5
    dropShadow.ZIndex = -1
    dropShadow.Parent = frame
    Instance.new("UICorner", dropShadow).CornerRadius = UDim.new(0, 10)

    return frame
end

-- Generate a button based on function inputs
this.CreateButton = function(frame:Instance, layoutOrder:number, text:string, color:Color3, textColor:Color3, font:Enum.Font, callback:() -> ())
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 200, 0, 50)
    button.Position = UDim2.new(0.5, -100, 0.5, -25)
    button.BackgroundColor3 = color
    button.TextColor3 = textColor
    button.Text = text
    button.Font = font
    button.TextSize = 12
    button.LayoutOrder = layoutOrder
    button.Parent = frame
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 5)

    button.MouseButton1Click:Connect(function()
        callback()
        TweenService:Create(button, TweenInfo, {BackgroundColor3 = color + Color3.new(0.25, 0.25, 0.25)}):Play()
        task.wait(0.5)
        TweenService:Create(button, TweenInfo, {BackgroundTransparency = 0}):Play()
    end)
end



return this