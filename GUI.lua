-- Credits To The Original Devs @xz, @goof

local esp = loadstring(game:HttpGet("https://raw.githubusercontent.com/AstralisLLC/RobloxScripts/refs/heads/main/espCompat.lua"))()
local aimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/AstralisLLC/RobloxScripts/refs/heads/main/aimbot.lua"))()

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
    AimTab = Window:AddTab("Aimbot"),
    LocalTab = Window:AddTab("Local"),
	Settings = library:CreateSettingsTab(Window),
}


local sections = {
    LegitSec = tabs.AimTab:AddSection("Legit", 1),
    RageSec = tabs.AimTab:AddSection("Rage", 2),
	MovementSec = tabs.LocalTab:AddSection("Movement", 1),
	VisualSec = tabs.LocalTab:AddSection("Placeholder", 2),
}

--//-------AIMBOT-------\\--

sections.LegitSec:AddSeparator({
    text = "Legit Aimbot"
})

sections.LegitSec:AddToggle({
    enabled = true,
    text = "Toggle Aimbot",
    flag = "aimbotToggle",
    tooltip = "Toggles Aimbot, keybind is MouseButton2",
    risky = false,
    callback = function(val)
        print("Aimbot Is Now : ", val)
        aimbot.Toggled = val
    end
})

sections.LegitSec:AddToggle({
    enabled = true,
    text = "Draw FOV",
    flag = "drawFov",
    tooltip = "Toggles Aimbot FOV Circle",
    risky = false,
    callback = function(val)
        aimbot.DrawFov = val
        if val then
            aimbot.ToggleFov = true
        else
            aimbot.ToggleFov = false
        end
    end
})

sections.LegitSec:AddSlider({
    text = "Aimbot FOV",
    flag = "aimbotFov",
    suffix = "FOV",
    value = 75,
    min = 1,
    max = 500,
    increment = 1,
    tooltip = "Changes the aimbot fov",
    risky = true,
    callback = function(fov)
        aimbot.fov = fov
        print("Aimbot FOV Is Now : ", fov)
    end
})

sections.LegitSec.AddSlider({
    text = "FOV Circle Sides",
    flag = "fovSides",
    suffix = "Sides",
    value = 100,
    min = 3,
    max = 200,
    increment = 1,
    tooltip = "Changes the number of sides on the fov circle, may cause performance drop",
    risky = false,
    callback = function(sides)
        aimbot.numSides = sides
        print("FOV Circle Sides Is Now : ", sides)
    end
})

sections.LegitSec:AddColor({
    enabled = true,
    text = "Fov Color",
    flag = "fovColorPick",
    tooltip = "Color Picker For Fov Circle",
    color = Color3.new(1, 1, 1),
    trans = 0,
    open = false,
    callback = function(c)
        print("Fov Color Is Now : ", c)
        aimbot.FovColor = c
    end
})

sections.RageSec:AddSeparator({
    text = "SilentAim"
})


--//-------MOVEMENT-------\\--

sections.MovementSec:AddSeparator({
	text = "WalkSpeed"
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

--//-------VISUALS-------\\--

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

--//-------MISC-------\\--

sections.VisualSec:AddSeparator({
    text = "Misc"
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