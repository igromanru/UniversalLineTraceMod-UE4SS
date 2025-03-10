--[[
    Author: Igromanru
    Date: 10.03.2025
]]

local UEHelpers = require("UEHelpers")
local GetKismetSystemLibrary = UEHelpers.GetKismetSystemLibrary
local GetKismetMathLibrary = UEHelpers.GetKismetMathLibrary
local GetPlayerController = UEHelpers.GetPlayerController

require("ECollisionChannel")

---Converts meters to UE units (centimeter)
---@param Meters number
---@return number
local function MToUnits(Meters)
    return Meters * 100
end

---Calculates start and end location of line trace based on player camera location and forward vector, if player controller is valid
---@param TraceLengthInM number? Default: 50 meters
---@return UObject?, FVector?, FVector?
local function GetWorldContextAndStartAndEndLocation(TraceLengthInM)
    TraceLengthInM = TraceLengthInM or 50

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

---@class TraceUtils
TraceUtils = {}

---Fires a raycast from the camera's location that collides with first object based on a chosen collision channel.
---@param TraceChannel ECollisionChannel|ETraceTypeQuery|number|nil Default: WorldStatic
---@param TraceLengthInM number?  Default: 50 meters
---@return FHitResult? HitResult Returns `nil` if nothing was hit
function TraceUtils.LineTraceByChannel(TraceChannel, TraceLengthInM)
    TraceChannel = TraceChannel or ECollisionChannel.ECC_WorldStatic
    TraceLengthInM = TraceLengthInM or 50

    local worldContext, startLocation, endLocation = GetWorldContextAndStartAndEndLocation(TraceLengthInM)
    if worldContext and startLocation and endLocation then
        local actorsToIgnore = {} ---@type TArray<AActor>
        local outHitResult = {} ---@cast outHitResult FHitResult
        local traceColor = { R = 0, G = 0, B = 0, A = 0 } ---@type FLinearColor
        if GetKismetSystemLibrary():LineTraceSingle(worldContext, startLocation, endLocation, TraceChannel, false, actorsToIgnore, 0, outHitResult, true, traceColor, traceColor, 0.0) then
            return outHitResult
        end
    end
    return nil
end

---Fires a raycast from the camera's location, colliding with the first object based on its collision type.
---@param ObjectTypeQuery ECollisionChannel|EObjectTypeQuery|number|nil Default: WorldStatic
---@param TraceLengthInM number?  Default: 50 meters
---@return FHitResult? HitResult Returns `nil` if nothing was hit
function TraceUtils.LineTraceByObject(ObjectTypeQuery, TraceLengthInM)
    ObjectTypeQuery = ObjectTypeQuery or ECollisionChannel.ECC_WorldStatic
    TraceLengthInM = TraceLengthInM or 50

    local worldContext, startLocation, endLocation = GetWorldContextAndStartAndEndLocation(TraceLengthInM)
    if worldContext and startLocation and endLocation then
        local traceObjects = { ObjectTypeQuery } ---@type TArray<EObjectTypeQuery>
        local actorsToIgnore = {} ---@type TArray<AActor>
        local outHitResult = {} ---@cast outHitResult FHitResult
        local traceColor = { R = 0, G = 0, B = 0, A = 0 } ---@type FLinearColor
        if GetKismetSystemLibrary():LineTraceSingleForObjects(worldContext, startLocation, endLocation, traceObjects, false, actorsToIgnore, 0, outHitResult, true, traceColor, traceColor, 0.0) then
            return outHitResult
        end
    end
    return nil
end

return TraceUtils