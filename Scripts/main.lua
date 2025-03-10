--[[
    Author: Igromanru
    Date: 10.03.2025
    Mod Name: UniversalLineTraceMod
]]

local UEHelpers = require("UEHelpers")

local ModName = "UniversalLineTraceMod"
local ModVersion = "1.0.0"
local DebugMode = true

local function Log(Message)
    print(string.format("[%s v%s]: %s\n", ModName, ModVersion, Message))
end

local function LogDebug(Message)
    if DebugMode then
        Log(Message)
    end
end


Log("Starting mod initialization")


Log("Mod loaded successfully")