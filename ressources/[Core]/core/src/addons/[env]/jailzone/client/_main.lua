
JailZone = {}

JailZone.notifIn = false;
JailZone.zoneIsIn = nil;
JailZone.isInZone = false;

CreateThread(function()
    while true do
        wait = 2500

        if not JailZone:wlJob() then
            local plyPed = PlayerPedId()
            local myCoords = GetEntityCoords(plyPed)

            for k,v in pairs(Config['jailzone'].localisations) do
                local dist = Vdist(myCoords, v.pos)

                if dist < v.radius then
                    wait = 1

                    JailZone.zoneIsIn = k;
                    JailZone.isInZone = true;

                    if not JailZone.notifIn then
                        Framework.ShowNotification("Vous Etes En Jail")

                        JailZone.notifIn = true
                    end

                    for k,v in pairs(Config['jailzone'].disabledKeys) do
                        DisableControlAction(v.group, v.key, true)
                        DisableAllControlActions(1)
                        DisableAllControlActions(2)
                        DisablePlayerFiring(plyPed, true)
                        SetCurrentPedWeapon(plyPed, 'WEAPON_UNARMED', true)
                        RageUI.CloseAll()
                        -- Anti Carkill
                        -- for vehicle in EntityManager:enumVehicles() do
                        --     if not IsVehicleSeatFree(vehicle, -1) then
                        --         SetEntityNoCollisionEntity(plyPed, vehicle, true)
                        --         SetEntityNoCollisionEntity(vehicle, plyPed, true)
                        --     end
                        -- end
                    end
                elseif dist > v.radius and JailZone.zoneIsIn == k then
                    wait = 2500

                    JailZone.isInZone = false;

                    DisablePlayerFiring(plyPed, false)

                    if JailZone.notifIn then
                        Framework.ShowNotification("Vous n'êtes plus en Jail")

                        JailZone.notifIn = false
                    end
                end
            end
        end

        Wait(wait)
    end
end)

function JailZone:wlJob()
    for k,v in pairs(Config['jailzone'].wlJobs) do
        if Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == v then
            return true
        end
    end
    return false
end