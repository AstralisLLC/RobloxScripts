local Keys = {}

Keys.Codes = {
    ["A"] = Enum.KeyCode.A,
    ["B"] = Enum.KeyCode.B,
    ["C"] = Enum.KeyCode.C,
    ["D"] = Enum.KeyCode.D,
    ["E"] = Enum.KeyCode.E,
    ["F"] = Enum.KeyCode.F,
    ["G"] = Enum.KeyCode.G,
    ["H"] = Enum.KeyCode.H,
    ["I"] = Enum.KeyCode.I,
    ["J"] = Enum.KeyCode.J,
    ["K"] = Enum.KeyCode.K,
    ["L"] = Enum.KeyCode.L,
    ["M"] = Enum.KeyCode.M,
    ["N"] = Enum.KeyCode.N,
    ["O"] = Enum.KeyCode.O,
    ["P"] = Enum.KeyCode.P,
    ["Q"] = Enum.KeyCode.Q,
    ["R"] = Enum.KeyCode.R,
    ["S"] = Enum.KeyCode.S,
    ["T"] = Enum.KeyCode.T,
    ["U"] = Enum.KeyCode.U,
    ["V"] = Enum.KeyCode.V,
    ["W"] = Enum.KeyCode.W,
    ["X"] = Enum.KeyCode.X,
    ["Y"] = Enum.KeyCode.Y,
    ["Z"] = Enum.KeyCode.Z,
    ["0"] = Enum.KeyCode.Zero,
    ["1"] = Enum.KeyCode.One,
    ["2"] = Enum.KeyCode.Two,
    ["3"] = Enum.KeyCode.Three,
    ["4"] = Enum.KeyCode.Four,
    ["5"] = Enum.KeyCode.Five,
    ["6"] = Enum.KeyCode.Six,
    ["7"] = Enum.KeyCode.Seven,
    ["8"] = Enum.KeyCode.Eight,
    ["9"] = Enum.KeyCode.Nine,
    ["LeftAlt"] = Enum.KeyCode.LeftAlt,
    ["RightAlt"] = Enum.KeyCode.RightAlt,
    ["LeftControl"] = Enum.KeyCode.LeftControl,
    ["RightControl"] = Enum.KeyCode.RightControl,
    ["LeftShift"] = Enum.KeyCode.LeftShift,
    ["RightShift"] = Enum.KeyCode.RightShift,
    ["LeftMouseButton"] = Enum.UserInputType.MouseButton1,
    ["RightMouseButton"] = Enum.UserInputType.MouseButton2,
    ["MiddleMouseButton"] = Enum.UserInputType.MouseButton3,
    ["MouseWheelUp"] = Enum.UserInputType.MouseWheel,
    ["MouseWheelDown"] = Enum.UserInputType.MouseWheel,
    ["Escape"] = Enum.KeyCode.Escape,
    ["Tab"] = Enum.KeyCode.Tab,
    ["Enter"] = Enum.KeyCode.Return,
    ["Backspace"] = Enum.KeyCode.Backspace,
    ["Space"] = Enum.KeyCode.Space,
    ["Up"] = Enum.KeyCode.Up,
    ["Down"] = Enum.KeyCode.Down,
    ["Left"] = Enum.KeyCode.Left,
    ["Right"] = Enum.KeyCode.Right,
    ["Insert"] = Enum.KeyCode.Insert,
    ["Delete"] = Enum.KeyCode.Delete,
    ["Home"] = Enum.KeyCode.Home,
    ["End"] = Enum.KeyCode.End,
    ["PageUp"] = Enum.KeyCode.PageUp,
    ["PageDown"] = Enum.KeyCode.PageDown,
    ["F1"] = Enum.KeyCode.F1,
    ["F2"] = Enum.KeyCode.F2,
    ["F3"] = Enum.KeyCode.F3,
    ["F4"] = Enum.KeyCode.F4,
    ["F5"] = Enum.KeyCode.F5,
    ["F6"] = Enum.KeyCode.F6,
    ["F7"] = Enum.KeyCode.F7,
    ["F8"] = Enum.KeyCode.F8,
    ["F9"] = Enum.KeyCode.F9,
    ["F10"] = Enum.KeyCode.F10,
    ["F11"] = Enum.KeyCode.F11,
    ["F12"] = Enum.KeyCode.F12
}


Keys.GetKey = function(keyName)
    return Keys.Codes[keyName] or Enum.KeyCode.Unknown
end

Keys.CreateListener = function(key, callback)
    local keyCode
    if key:IsA("Enum") then
        keyCode = key
    elseif key:IsA("string") then
        keyCode = Keys.GetKey(key)
    else
        error("Invalid key type. Expected Enum or string.")
    end

    local userInputService = game:GetService("UserInputService")
    userInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == keyCode and not gameProcessedEvent then
            callback()
        end
    end)
end

return Keys