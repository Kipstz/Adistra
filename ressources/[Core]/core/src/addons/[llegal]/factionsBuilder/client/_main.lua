
Factions = {}
SharedFactions = {}

Factions.started = false

CreateThread(function()
    while not Factions.started do
        Wait(1)
    end

    -- if next(SharedFactions) then
    --     for k,v in pairs(SharedFactions) do
    --         if v.params.blip.active then
    --             local blip = AddBlipForCoord(v.params.blip.pos.x, v.params.blip.pos.y, v.params.blip.pos.z)
    
    --             SetBlipSprite(blip, v.params.blip.sprite)
    --             SetBlipColour(blip, v.params.blip.couleur)
    --             SetBlipScale(blip, v.params.blip.taille)
    --             SetBlipAsShortRange(blip, true)

    --             BeginTextCommandSetBlipName('STRING')
    --             AddTextComponentSubstringPlayerName(v.params.blip.name)
    --             EndTextCommandSetBlipName(blip)
    --         end

    --         if v.params.zone.active then
    --             local zone = AddBlipForRadius(v.params.zone.pos.x, v.params.zone.pos.y, v.params.zone.pos.z, 1000.0)

    --             SetBlipSprite(zone, 1)
    --             SetBlipColour(zone, v.params.zone.couleur)
    --             SetBlipAlpha(zone, 150) 
    --         end
    --     end
    -- end

    while true do
        wait = 1600

        local plyPed = PlayerPedId()
        local myCoords = GetEntityCoords(plyPed)

        for k,v in pairs(SharedFactions) do
            if Framework.PlayerData.jobs and Framework.PlayerData.jobs['job2'].name == v.name and v.coords ~= nil then
                -- GARAGE --
                local dist2 = Vdist(myCoords, vector3(v.coords.garage.posMenu.x, v.coords.garage.posMenu.y, v.coords.garage.posMenu.z))

                if dist2 < 15 and dist2 > 1.5 then
                    wait = 1 
    
                    DrawMarker(27, v.coords.garage.posMenu.x, v.coords.garage.posMenu.y, v.coords.garage.posMenu.z-0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 255, 0, 1, 0, 1)
                elseif dist2 < 1.5 then
                    wait = 1
                    
                    Framework.ShowHelpNotification("~INPUT_CONTEXT~ pour accéder au Garage")
    
                    if IsControlJustPressed(0, 38) then
                        Factions.OpenGarageMenu(v.coords.garage, v.name)
                    end
                end
                
                -- DELETER --
                local dist3 = Vdist(myCoords, vector3(v.coords.garage.posDeleter.x, v.coords.garage.posDeleter.y, v.coords.garage.posDeleter.z))

                if IsPedInAnyVehicle(plyPed) then
                    local vehicle = GetVehiclePedIsIn(plyPed)
    
                    if GetPedInVehicleSeat(vehicle, -1) == plyPed then
                        if dist3 < 15 and dist3 > 1.5 then
                            wait = 1 
            
                            DrawMarker(27, v.coords.garage.posDeleter.x, v.coords.garage.posDeleter.y, v.coords.garage.posDeleter.z-0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 255, 0, 1, 0, 1)
                        elseif dist3 < 1.5 then
                            wait = 1
                            
                            Framework.ShowHelpNotification("~INPUT_CONTEXT~ pour ranger le véhicule")
            
                            if IsControlJustPressed(0, 38) then
                                Factions.StoreVehicle(v.name, vehicle)
                            end
                        end
                    end
                end
                
                -- GESTION --
                local dist4 = Vdist(myCoords, vector3(v.coords.coffre.posMenu.x, v.coords.coffre.posMenu.y, v.coords.coffre.posMenu.z))

                if dist4 < 15 and dist4 > 1.5 then
                    wait = 1 
    
                    DrawMarker(27, v.coords.coffre.posMenu.x, v.coords.coffre.posMenu.y, v.coords.coffre.posMenu.z-0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 255, 0, 1, 0, 1)
                elseif dist4 < 1.5 then
                    wait = 1
                    
                    Framework.ShowHelpNotification("~INPUT_CONTEXT~ pour accéder a la Gestion")
    
                    if IsControlJustPressed(0, 38) then
                        Factions.OpenGestionMenu(v.name)
                    end
                end
            end
        end

        Wait(wait)
    end
end)

