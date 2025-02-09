
ZoneSafe = {}

ZoneSafe.notifIn = false;
ZoneSafe.zoneIsIn = nil;
ZoneSafe.isInZone = false;

CreateThread(function()
    while true do
        wait = 2500

        if not ZoneSafe:wlJob() then
            local plyPed = PlayerPedId()
            local myCoords = GetEntityCoords(plyPed)

            for k,v in pairs(Config['zonesafe'].localisations) do
                local dist = Vdist(myCoords, v.pos)

                if dist < v.radius then
                    wait = 1

                    ZoneSafe.zoneIsIn = k;
                    ZoneSafe.isInZone = true;

                    if not ZoneSafe.notifIn then
                        Framework.ShowNotification("Vous êtes dans une zone sécurisée")

                        ZoneSafe.notifIn = true
                    end

                    for k,v in pairs(Config['zonesafe'].disabledKeys) do
                        DisableControlAction(v.group, v.key, true)
                        -- LocalPlayer:setGodMode(true)
                        DisablePlayerFiring(plyPed, true)
                        SetCurrentPedWeapon(plyPed, 'WEAPON_UNARMED', true)

                        -- Anti Carkill
                        -- for vehicle in EntityManager:enumVehicles() do
                        --     if not IsVehicleSeatFree(vehicle, -1) then
                        --         SetEntityNoCollisionEntity(plyPed, vehicle, true)
                        --         SetEntityNoCollisionEntity(vehicle, plyPed, true)
                        --     end
                        -- end
                    end
                elseif dist > v.radius and ZoneSafe.zoneIsIn == k then
                    wait = 2500

                    ZoneSafe.isInZone = false;

                    DisablePlayerFiring(plyPed, false)

                    if ZoneSafe.notifIn then
                        Framework.ShowNotification("Vous n'êtes plus dans une zone sécurisée")

                        ZoneSafe.notifIn = false
                    end
                end
            end
        end

        Wait(wait)
    end
end)

function ZoneSafe:wlJob()
    for k,v in pairs(Config['zonesafe'].wlJobs) do
        if Framework.PlayerData.jobs and Framework.PlayerData.jobs['job'].name == v then
            return true
        end
    end
    return false
end

exports('isInSafeZone', function()
    return ZoneSafe.isInZone
end)