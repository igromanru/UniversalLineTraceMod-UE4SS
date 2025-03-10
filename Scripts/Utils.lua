
local UEHelpers = require("UEHelpers")
GetKismetSystemLibrary = UEHelpers.GetKismetSystemLibrary
GetKismetMathLibrary = UEHelpers.GetKismetMathLibrary
GetPlayerController = UEHelpers.GetPlayerController
GetActorFromHitResult = UEHelpers.GetActorFromHitResult

ModName = "UniversalLineTraceMod"
ModVersion = "1.0.0"
DebugMode = false

---Prints message with mod information and line break to console
---@param Message string
function Log(Message)
    print(string.format("[%s v%s]: %s\n", ModName, ModVersion, Message))
end

---Prints message with `Log` function, if `DebugMode` is enabled
---@param Message string
function LogDebug(Message)
    if DebugMode then
        Log(Message)
    end
end

---Converts meters to UE units (centimeter)
---@param Meters number
---@return number
local function MToUnits(Meters)
    return Meters * 100
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

---Calculates start and end location of line trace based on player camera location and forward vector, if player controller is valid
---@param TraceLengthInM number? Default: 20 meters
---@return UObject?, FVector?, FVector?
function GetWorldContextAndStartAndEndLocation(TraceLengthInM)
    TraceLengthInM = TraceLengthInM or 20

    local playerController = GetPlayerController()
    if playerController and playerController:IsValid() and playerController.PlayerCameraManager:IsValid() then
        local cameraManager = playerController.PlayerCameraManager
        local lookDirection = cameraManager:GetActorForwardVector()
        local lookDirOffset = GetKismetMathLibrary():Multiply_VectorFloat(lookDirection, MToUnits(TraceLengthInM))
        local startLocation = cameraManager:GetCameraLocation()
        local endLocation = GetKismetMathLibrary():Add_VectorVector(startLocation, lookDirOffset)
        local worldContext = playerController ---@type UObject
        if playerController.Pawn:IsValid() then
            -- Set Pawn as WorldContext to ignore own player with bIgnoreSelf parameter
            worldContext = playerController.Pawn
        end
        return worldContext, startLocation, endLocation
    end
    return nil, nil, nil
end