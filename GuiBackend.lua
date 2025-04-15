local GUI = {}

GUI.__index = GUI
GUI.__type = "GuiBackend"

GUI.Container = {}
GUI.Container.__index = GUI.Container
GUI.Container.__type = "Container"
GUI.Container.__newindex = function(self, key, value)
    if type(value) == "function" then
        rawset(self, key, value())
    else
        rawset(self, key, value)
    end
end