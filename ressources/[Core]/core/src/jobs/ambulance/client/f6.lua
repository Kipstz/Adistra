local comaCalls = {}
AmbulanceJob.F6Menu = RageUI.CreateMenu("Ambulance", "~p~Ambulance~s~: Actions", 8, 200)

AmbulanceJob.comaCallsList = RageUI.CreateSubMenu(AmbulanceJob.F6Menu, "Ambulance", "~p~Ambulance~s~: Liste des appels", 8, 200)
AmbulanceJob.InteractionsCitoyens = RageUI.CreateSubMenu(AmbulanceJob.F6Menu, "Ambulance", "~p~Ambulance~s~: Interactions Citoyens", 8, 200)

AmbulanceJob.GestionsObjets = RageUI.CreateSubMenu(AmbulanceJob.F6Menu, "Ambulance", "~p~Ambulance~s~: Gestion Objets", 8, 200)

AmbulanceJob.AutresMenu = RageUI.CreateSubMenu(AmbulanceJob.F6Menu, "Ambulance", "~p~Ambulance~s~: Autres", 8, 200)

local open = false

AmbulanceJob.F6Menu.Closed = function()
    open = false
end

Ambulance_Indexs = {
    Soins = 1,
}

AmbulanceJob.ServiceCheck = false

AmbulanceJob.OpenF6Menu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(AmbulanceJob.F6Menu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(AmbulanceJob.F6Menu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(AmbulanceJob.F6Menu, true, true, true, function()
                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)

                    RageUI.Checkbox("Prise de Service", nil, AmbulanceJob.ServiceCheck, {}, function(Hovered, Active, Selected, Checked)
                        if Selected then
                            AmbulanceJob.ServiceCheck = Checked
                            if Framework.PlayerData.identity ~= nil then
                                identity = (Framework.PlayerData.identity.firstname.." "..Framework.PlayerData.identity.lastname)
                            else
                                identity = GetPlayerName(PlayerId())
                            end
                            
                            if Checked then        
                                Framework.TriggerServerCallback("service:enableService", function(canTakeService, maxInService, inServiceCount)
                                    if canTakeService then
                                        local notification = {
                                            title = "~b~EMS",
                                            subject = "~o~Prise de Service",
                                            msg = "Le médecin ~g~"..identity.." ~s~a ~o~Pris ~s~son ~b~Service ~s~!",
                                            banner = 'CHAR_EMS',
                                            iconType = 1
                                        }
        
                                        TriggerServerEvent("service:notifyAllInService", notification, 'ambulance')
                                    else
                                        Framework.ShowNotification("~r~Il y'a trop de médecins en Service, ~b~" .. inServiceCount .. '/' .. maxInService)
                                    end
                                end, 'ambulance')
                            else
                                local notification = {
                                    title = "~b~EMS",
                                    subject = "~r~Fin de Service",
                                    msg = "Le médecin ~g~"..identity.." ~s~a ~r~Quitter ~s~son ~b~Service ~s~!",
                                    banner = 'CHAR_EMS',
                                    iconType = 1
                                }
    
                                TriggerServerEvent("service:notifyAllInService", notification, 'ambulance')
    
                                TriggerServerEvent("service:disableService", 'ambulance')
                            end
                        end
                    end)

                    if AmbulanceJob.ServiceCheck then
                        RageUI.Line()

                        RageUI.ButtonWithStyle("Liste des appels", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        end, AmbulanceJob.comaCallsList)

                        RageUI.ButtonWithStyle("Interactions Citoyens", nil, { RightLabel = "→→→" }, (closestPlayer ~= -1 and closestPlayerDistance < 3), function(Hovered, Active, Selected)
                        end, AmbulanceJob.InteractionsCitoyens)
    
                        RageUI.ButtonWithStyle("Gestions Objets", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        end, AmbulanceJob.GestionsObjets)
    
                        -- RageUI.ButtonWithStyle("Autres", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        -- end, AmbulanceJob.AutresMenu)
                    end

                end)

                RageUI.IsVisible(AmbulanceJob.comaCallsList, true, true, true, function()
                    RageUI.Separator("↓   Liste des appels   ↓")

                    for i, position in pairs(comaCalls) do
                        local callDetails = string.format("Prendre l'appel coma #%d", i)
                        RageUI.ButtonWithStyle(callDetails, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                SetNewWaypoint(position.x, position.y)
                                Framework.ShowNotification("Point GPS défini pour l'appel #"..i)
                                TriggerServerEvent('ambulanceJob:takeCall', i)
                                comaCalls[i] = nil
                            end
                        end)
                    end
                end)
                RageUI.IsVisible(AmbulanceJob.InteractionsCitoyens, true, true, true, function()
                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)

                    RageUI.Separator("↓   Actions   ↓")

                    RageUI.ButtonWithStyle("Mettre/Sortir du Véhicule", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            exports["ac"]:ExecuteServerEvent("AmbulanceJob:MettreSortirVeh", GetPlayerServerId(closestPlayer))
                        end
                    end)

                    RageUI.List("Soigner une Blessure", { "Legère", "Moyenne", "Importante" }, Ambulance_Indexs.Soins, nil, {}, true, function(Hovered, Active, Selected, Index)
                        Ambulance_Indexs.Soins = Index

                        if Selected then
                            exports["ac"]:ExecuteServerEvent("AmbulanceJob:Heal", PlayerPedId(), GetPlayerServerId(closestPlayer), Index)
                        end
                    end)

                    RageUI.ButtonWithStyle("Réanimer la Personne", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            AmbulanceJob.reaPlayer(closestPlayer, GetPlayerServerId(closestPlayer))
                        end
                    end)

                    RageUI.ButtonWithStyle("Mettre une facture", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local raison = VisualManager:KeyboardOutput("Raison de la facture", "", 50)
                            local amount = VisualManager:KeyboardOutput("Montant de facture", "", 15)

                            if tostring(raison) and tonumber(amount) then
                                exports["ac"]:ExecuteServerEvent('billing:sendBill', GetPlayerServerId(closestPlayer), 'ambulance', raison, amount)
                            else
                                Framework.ShowNotification("~r~Arguments Invalide !")
                            end
                        end
                    end)
                end)

                RageUI.IsVisible(AmbulanceJob.GestionsObjets, true, true, true, function()

                    RageUI.ButtonWithStyle("Plot", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local plyPed = PlayerPedId()
                            local coords, forward = GetEntityCoords(plyPed), GetEntityForwardVector(plyPed)
                            local objCoords = (coords + forward * 1.0)
            
                            Framework.Game.SpawnObject('prop_roadcone02a', objCoords, function(obj)
                                SetEntityHeading(obj, GetEntityHeading(plyPed))
                                PlaceObjectOnGroundProperly(obj)
                            end)
                        end
                    end)

                end)

                -- RageUI.IsVisible(AmbulanceJob.AutresMenu, true, true, true, function()

                -- end)
            end
        end)
    end
end

RegisterNetEvent("AmbulanceJob:MettreSortirVeh")
AddEventHandler("AmbulanceJob:MettreSortirVeh", function()
    local plyPed = PlayerPedId()
    local vehicle = Framework.Game.GetClosestVehicle()

    if not MisInVeh then
        local maxSieges, SiegeLibre = GetVehicleMaxNumberOfPassengers(vehicle)

        for i=maxSieges-1,0,-1 do
            if IsVehicleSeatFree(vehicle, i) then
                SiegeLibre = i
                break
            end
        end

        if SiegeLibre then
            TaskWarpPedIntoVehicle(plyPed, vehicle, SiegeLibre)
        else
            Framework.ShowNotification("~r~Aucune Place Disponible !")
        end
    else
        TaskLeaveVehicle(plyPed, vehicle, 16)
    end

    MisInVeh = not MisInVeh
end)

RegisterNetEvent("AmbulanceJob:Heal")
AddEventHandler("AmbulanceJob:Heal", function(target, type)
    AmbulanceJob.HealPlayer(target, type)
end)

AmbulanceJob.HealPlayer = function(target, type)
    local plyPed = PlayerPedId()
	local maxHealth = GetEntityMaxHealth(plyPed)

    local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01'

    if target ~= nil then
        Framework.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(target, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
            
            Wait(500)
    
            while IsEntityPlayingAnim(target, lib, anim, 3) do
                Wait(1)
    
                DisableAllControlActions(0)
            end
        end)
    end
    
    if type == 1 then
        local health = GetEntityHealth(plyPed)
        local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 8))

        SetEntityHealth(plyPed, newHealth)
    elseif type == 2 then
        local health = GetEntityHealth(plyPed)
        local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 4))

        SetEntityHealth(plyPed, newHealth)
    elseif type == 3 then
        local health = GetEntityHealth(plyPed)

        SetEntityHealth(plyPed, maxHealth)
    end
end

RegisterNetEvent("AmbulanceJob:updateCalls")
AddEventHandler("AmbulanceJob:updateCalls", function(data)
    comaCalls = data
end)