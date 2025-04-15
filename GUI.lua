-- Credits To The Original Devs @xz, @goof

local esp = loadstring(game:HttpGet("https://raw.githubusercontent.com/AstralisLLC/RobloxScripts/refs/heads/main/espCompat.lua"))()

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
        print("ESP Is Now : ", val)
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
		"Name",
		"Team",
		"Distance",
        "Health"
	},
	callback = function(v)
        for _, z in pairs(v) do
            print(z)
        end

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