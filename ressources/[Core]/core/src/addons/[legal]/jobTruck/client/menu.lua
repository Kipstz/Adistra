
TruckJob = {}


function TruckJob.OpenMainMenu()

    local mainMenuJobTruck = RageUI.CreateMenu("", "Livraison de marchandises", 8, 200)
    local mainMenuLongTrajet = RageUI.CreateSubMenu(mainMenuJobTruck, "", "Liste des longs trajets")

    local open = false

    mainMenuJobTruck.Closed = function()
        open = false
    end

    if open then
        RageUI.CloseAll()
        RageUI.Visible(mainMenuJobTruck, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(mainMenuJobTruck, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(mainMenuJobTruck, true, true, true, function()


                    if TruckJob.imGayDataFDP then 
                        RageUI.ButtonWithStyle("Long Trajet", nil, { RightLabel = "→→→" }, false, function(Hovered, Active, Selected)
                        end, mainMenuLongTrajet)
                    else
                        RageUI.ButtonWithStyle("Long Trajet", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        end, mainMenuLongTrajet)
                    end

                    if TruckJob.imGayDataFDP then 
                        RageUI.ButtonWithStyle("Arrêter la mission en cours", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                RageUI.CloseAll()
                                TruckJob.imGayDataFDP = false
                                RemoveBlip(TruckJob.destBlip)
                                Framework.Game.DeleteVehicle(TruckJob.vehicle)  
                                TriggerServerEvent("core:jobTruck:stopMission")
                            end
                        end)
                    end
                end)

                RageUI.IsVisible(mainMenuLongTrajet, true, true, true, function()
                    for k,v in pairs(Config['jobTruck'].GlobalMissions.LongTrajet) do
                        RageUI.ButtonWithStyle(v.label, "~g~"..v.price.." $", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                TriggerServerEvent('core:jobTruck:startMissionServer')
                                RageUI.CloseAll()
                                TruckJob.startMission(v)
                            end
                        end)
                    end
                end)
            end
        end)
    end
end

CreateThread(function()
    local blip = AddBlipForCoord(Config['jobTruck'].PositionPNJ)
    SetBlipSprite(blip, 85)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 6)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Transport Routier")
    EndTextCommandSetBlipName(blip)

    ZoneManager:createZoneWithMarker(Config['jobTruck'].PositionPNJ, 10, 10.5, {
        onPress = {control = 38, action = function(zone)
            TruckJob.OpenMainMenu()
        end}
    })
end)