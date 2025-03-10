--[[
    Author: Igromanru
    Date: 10.03.2025
    Mod Name: UniversalLineTraceMod
]]

require("Utils")

ModVersion = "1.0.0"
DebugMode = true

local CollisionChannel = 0 ---@type ECollisionChannel|ETraceTypeQuery|EObjectTypeQuery
local TraceLengthInM = 50 ---@type number meters

Log("Starting mod initialization")

---@param HitResult FHitResult
local function LogHitResult(HitResult)
    if not HitResult then return end

    local hitActor = GetActorFromHitResult(HitResult)
    if hitActor:IsValid() then
        Log("Object Name: " .. hitActor:GetFullName())
        Log("Class Name: " .. hitActor:GetClass():GetFullName())
        if hitActor:IsA(GetStaticClassActor()) then
            ---@cast hitActor AActor
            Log("Location: " .. VectorToString(hitActor:K2_GetActorLocation()))
        elseif hitActor:IsA(GetStaticClassStaticMeshComponent()) or hitActor:IsA(GetStaticClassSkeletalMeshComponent()) then
            ---@cast hitActor UMeshComponent
            Log("Location: " .. VectorToString(hitActor:K2_GetComponentLocation()))
            local owner = hitActor:GetOwner()
            if owner:IsValid() then
                Log("Owner: " .. owner:GetFullName())
                Log("Owner class: " .. owner:GetClass():GetFullName())
            end
        end
    end
end

local function LineTraceByChannel()
    local worldContext, startLocation, endLocation = GetWorldContextAndStartAndEndLocation(TraceLengthInM)
    if worldContext and startLocation and endLocation then
        local actorsToIgnore = {}---@type TArray<AActor>
        local outHitResult = {} ---@cast outHitResult FHitResult
        local traceColor = { R = 0, G = 0, B = 0, A = 0 } ---@type FLinearColor
        if GetKismetSystemLibrary():LineTraceSingle(worldContext, startLocation, endLocation, CollisionChannel, false, actorsToIgnore, 0, outHitResult, true, traceColor, traceColor, 0.0) then
            Log("Hit object with collision channel: " .. CollisionChannel)
            LogHitResult(outHitResult)
        else
            Log("No hit for collision channel: " .. CollisionChannel)
        end
    end
end

local function LineTraceByObject()
    local worldContext, startLocation, endLocation = GetWorldContextAndStartAndEndLocation(TraceLengthInM)
    if worldContext and startLocation and endLocation then
        local traceObjects = { CollisionChannel } ---@type TArray<EObjectTypeQuery>
        local actorsToIgnore = {} ---@type TArray<AActor>
        local outHitResult = {} ---@cast outHitResult FHitResult
        local traceColor = { R = 0, G = 0, B = 0, A = 0 } ---@type FLinearColor
        if GetKismetSystemLibrary():LineTraceSingleForObjects(worldContext, startLocation, endLocation, traceObjects, false, actorsToIgnore, 0, outHitResult, true, traceColor, traceColor, 0.0) then
            Log("Hit object collision type: " .. CollisionChannel)
            LogHitResult(outHitResult)
        else
            Log("No hit for collision object: " .. CollisionChannel)
        end
    end
end

---@param Step integer Step by which CollisionChannel will be increased (Default: 1)
local function SwitchCollisionChannel(Step)
    Step = Step or 1
    
    CollisionChannel = CollisionChannel + Step
    if CollisionChannel < 0 then
        CollisionChannel = 33 + CollisionChannel
    elseif CollisionChannel > 32 then
        CollisionChannel = CollisionChannel - 32
    end
    Log("Collision Type: " .. CollisionChannel)
end

RegisterKeyBind(Key.F3, function()
    ExecuteInGameThread(function()
        LineTraceByChannel()
    end)
end)

RegisterKeyBind(Key.F4, function()
    ExecuteInGameThread(function()
        LineTraceByObject()
    end)
end)

RegisterKeyBind(Key.PAGE_UP, function()
    SwitchCollisionChannel(1)
end)

RegisterKeyBind(Key.PAGE_DOWN, function()
    SwitchCollisionChannel(-1)
end)


Log("Mod loaded successfully")