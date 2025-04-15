local Players = game:GetService("Players")
local LocalPlayer = game.Players.LocalPlayer

local TeamCheck = true -- Teamcheck toggle
local hitboxExtender = true -- Hitbox extender toggle
local hbeSize = 4 -- Change this to change headsize, 4 works best

local function addHighlight(Model : Model)
    local target = game.Players:GetPlayerFromCharacter(Model)
    if TeamCheck and target.Team == LocalPlayer.Team then
        if Model:FindFirstChild("HHHLLL") then
            Model:FindFirstChild("HHHLLL"):Destroy()
            return
        else
            return
        end
    end
    if Model:FindFirstChild("HHHLLL") then return end
    print("Doing highlight for " .. game.Players:GetPlayerFromCharacter(Model).Name)
    local hl = Instance.new("Highlight")

    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.FillColor = Color3.fromRGB(0, 255, 255)
    hl.FillTransparency = 0.8
    hl.OutlineColor = Color3.new(0, 0, 0)
    hl.OutlineTransparency = 0
    hl.Name = "HHHLLL"
    hl.Parent = Model
end

while task.wait(0.5) do
    for i, v in game.Players:GetPlayers() do
        if not v.Character then continue end
        if v == LocalPlayer then continue end
        addHighlight(v.Character)
        if hitboxExtender == false then continue end
        local Head = v.Character:FindFirstChild("Head")
        if not Head or Head == nil then
            print("No head")
            continue
        end
        print("Doing hitbox extender for "..v.Name)
        Head.Size = Vector3.new(hbeSize, hbeSize, hbeSize)
    end
end

