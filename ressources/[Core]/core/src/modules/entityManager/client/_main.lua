local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
}

HD_Cls.createClass("EntityManager", function(cls)
    local class = cls

    function class:EnumerateEntities(initFunc, moveFunc, disposeFunc)
        return coroutine.wrap(function()
            local iter, id = initFunc()
            if not id or id == 0 then
                disposeFunc(iter)
                return
            end
    
            local enum = {handle = iter, destructor = disposeFunc}
            setmetatable(enum, entityEnumerator)
    
            local next = true
            repeat
                coroutine.yield(id)
                next, id = moveFunc(iter)
            until not next
    
            enum.destructor, enum.handle = nil, nil
            disposeFunc(iter)
        end)
    end

    function class:EnumerateEntitiesWithinDistance(entities, isPlayerEntities, coords, maxDistance)
        local nearbyEntities = {}
    
        if coords then
            coords = vector3(coords.x, coords.y, coords.z)
        else
            local plyPed = PlayerPedId()
            coords = GetEntityCoords(plyPed)
        end
    
        for k, entity in pairs(entities) do
            local distance = #(coords - GetEntityCoords(entity))
    
            if distance <= maxDistance then
                nearbyEntities[#nearbyEntities + 1] = isPlayerEntities and k or entity
            end
        end
    
        return nearbyEntities
    end
    
    function class:enumObjects()
        return class:EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
    end
    
    function class:enumPeds()
        return class:EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
    end
    
    function class:enumVehicles()
        return class:EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
    end
    
    function class:enumVehiclesWithinDistance(entities, isPlayerEntities, coords, maxDistance)
        return class:EnumerateEntitiesWithinDistance(entities, isPlayerEntities, coords, maxDistance)
    end
    
    function class:enumPickcups()
        return class:EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
    end

    function class:createPed(model, coords, heading, freeze)
        RequestModel(model)
        while not HasModelLoaded(model) do RequestModel(model) Wait(10) end

		local ped = CreatePed(1, model, coords, heading, 0, 0)
		SetEntityAsMissionEntity(ped, 0, 0)
        SetBlockingOfNonTemporaryEvents(ped)
        SetEntityInvincible(ped, 1)
        if freeze then
            Wait(5000)
            SetEntityCoords(ped, coords)
            FreezeEntityPosition(ped, 1)
        end
        return ped
    end

    function class:getFrontVehicle(ped)
        local entCoords = GetEntityCoords(ped, false)
        local offset = GetOffsetFromEntityInWorldCoords(ped, 0.0, 4.0, 0.0)
        local ray = StartShapeTestRay(entCoords, offset, 2, ped, 0)
        local _, _, _, _, result = GetShapeTestResult(ray)
    
        return result
    end

    return class
end)