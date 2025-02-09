
local model = GetHashKey("p_ld_stinger_s")

local function RemoveHerse()
    local plyPed = PlayerPedId()
    local vehCoords = GetEntityCoords(GetVehiclePedIsIn(plyPed))

    if DoesObjectOfTypeExistAtCoords(vehCoords, 0.9, model, true) then
       herse = GetClosestObjectOfType(vehCoords, 0.9, model, false, false, false)

       SetEntityAsMissionEntity(herse, true, true)
       DeleteObject(herse)
    end
end

CreateThread(function()    
    while true do
        wait = 2500
        
        if IsPedInAnyVehicle(PlayerPedId()) then
            wait = 1000

            local plyPed = PlayerPedId()
            local vehCoords = GetEntityCoords(GetVehiclePedIsIn(plyPed))
            local doesObj = DoesObjectOfTypeExistAtCoords(vehCoords, 25.0, model, true)

            if doesObj then
                wait = 50

                local doesObj = DoesObjectOfTypeExistAtCoords(vehCoords, 0.9, model, true)

                if doesObj then
                    local car = GetVehiclePedIsIn(plyPed)
                    SetVehicleTyreBurst(car, 0, true, 1000.0)
                    SetVehicleTyreBurst(car, 1, true, 1000.0)
                    SetVehicleTyreBurst(car, 2, true, 1000.0)
                    SetVehicleTyreBurst(car, 3, true, 1000.0)
                    SetVehicleTyreBurst(car, 4, true, 1000.0)
                    SetVehicleTyreBurst(car, 5, true, 1000.0)
                    SetVehicleTyreBurst(car, 6, true, 1000.0)
                    
                    RemoveHerse()
                end
            end
        end

        Wait(wait)
    end
end)