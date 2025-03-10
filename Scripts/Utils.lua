--[[
    Author: Igromanru
    Date: 10.03.2025
]]

ModName = "UniversalLineTraceMod"
ModVersion = "1.0.0"

---Prints message with mod information and line break to console
---@param Message string
function Log(Message)
    print(string.format("[%s v%s]: %s\n", ModName, ModVersion, Message))
end

---Returns FVector as string format "X: %f, Y: %f, Z: %f"
---@param Vector FVector
---@return string
function VectorToString(Vector)
    return string.format("X, Y, Z: %f, %f, %f", Vector.X, Vector.Y, Vector.Z)
end

local Actor_Class = CreateInvalidObject()
---@return UClass
function GetStaticClassActor()
    if not Actor_Class:IsValid() then
        Actor_Class = StaticFindObject("/Script/Engine.Actor") ---@cast Actor_Class UClass
    end
    return Actor_Class
end

local StaticMeshComponent_Class = CreateInvalidObject()
---@return UClass
function GetStaticClassStaticMeshComponent()
    if not StaticMeshComponent_Class:IsValid() then
        StaticMeshComponent_Class = StaticFindObject("/Script/Engine.StaticMeshComponent") ---@cast StaticMeshComponent_Class UClass
    end
    return StaticMeshComponent_Class
end

local SkeletalMeshComponent_Class = CreateInvalidObject()
---@return UClass
function GetStaticClassSkeletalMeshComponent()
    if not SkeletalMeshComponent_Class:IsValid() then
        SkeletalMeshComponent_Class = StaticFindObject("/Script/Engine.SkeletalMeshComponent") ---@cast SkeletalMeshComponent_Class UClass
    end
    return SkeletalMeshComponent_Class
end