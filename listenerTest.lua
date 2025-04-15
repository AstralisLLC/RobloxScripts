local Keys = loadstring(game:HttpGet("https://raw.githubusercontent.com/AstralisLLC/RobloxScripts/refs/heads/main/keys.lua"))()

Keys.CreateListener("Test", "Enter", function()
    print("Listener \'test\' triggered!")
end)