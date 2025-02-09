
CookiesJob.F6Menu = RageUI.CreateMenu("Cookies & Co", "~p~Cookies & Co~s~: Actions", 8, 200)

CookiesJob.InteractionsCitoyens = RageUI.CreateSubMenu(CookiesJob.F6Menu, "Cookies & Co", "~p~Cookies & Co~s~: Interactions Citoyens", 8, 200)

CookiesJob.GestionsObjets = RageUI.CreateSubMenu(CookiesJob.F6Menu, "Cookies & Co", "~p~Cookies & Co~s~: Gestion Objets", 8, 200)

CookiesJob.AutresMenu = RageUI.CreateSubMenu(CookiesJob.F6Menu, "Cookies & Co", "~p~Cookies & Co~s~: Autres", 8, 200)

local open = false

CookiesJob.F6Menu.Closed = function()
    open = false
end

CookiesJob.ServiceCheck = false

CookiesJob.OpenF6Menu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(CookiesJob.F6Menu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(CookiesJob.F6Menu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(CookiesJob.F6Menu, true, true, true, function()
                    RageUI.Checkbox("Prise de Service", nil, CookiesJob.ServiceCheck, {}, function(Hovered, Active, Selected, Checked)
                        if Selected then
                            CookiesJob.ServiceCheck = Checked
                            if Framework.PlayerData.identity ~= nil then
                                identity = (Framework.PlayerData.identity.firstname.." "..Framework.PlayerData.identity.lastname)
                            else
                                identity = GetPlayerName(PlayerId())
                            end

                            if Checked then        
                                Framework.TriggerServerCallback("service:enableService", function(canTakeService, maxInService, inServiceCount)
                                    if canTakeService then
                                        local notification = {
                                            title = "Cuisinier",
                                            subject = "~o~Prise de Service",
                                            msg = "Le Cuisinier ~g~"..identity.." ~s~a ~o~Pris ~s~son ~b~Service ~s~!",
                                            banner = 'CHAR_LSCUSTOM',
                                            iconType = 1
                                        }
        
                                        TriggerServerEvent("service:notifyAllInService", notification, 'cookies')
                                    else
                                        Framework.ShowNotification("~r~Il y'a trop de mécanos en Service, ~b~" .. inServiceCount .. '/' .. maxInService)
                                    end
                                end, 'cookies')
                            else
                                local notification = {
                                    title = "Mécano",
                                    subject = "~r~Fin de Service",
                                    msg = "Le mécano ~g~"..identity.." ~s~a ~r~Quitter ~s~son ~b~Service ~s~!",
                                    banner = 'CHAR_LSCUSTOM',
                                    iconType = 1
                                }
    
                                TriggerServerEvent("service:notifyAllInService", notification, 'cookies')
    
                                TriggerServerEvent("service:disableService", 'cookies')
                            end
                        end
                    end)

                    if CookiesJob.ServiceCheck then
                        local myCoords = GetEntityCoords(PlayerPedId())
                        local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)
                        local closestVeh, closestVehDistance = Framework.Game.GetClosestVehicle(myCoords)

                        RageUI.Line()
    
                        RageUI.ButtonWithStyle("Interactions Citoyens", nil, { RightLabel = "→→→" }, closestPlayer ~= -1 and closestPlayerDistance < 3, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end, CookiesJob.InteractionsCitoyens)
    
                        RageUI.ButtonWithStyle("Gestions Objets", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end, CookiesJob.GestionsObjets)
    
                        RageUI.ButtonWithStyle("Autres", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end, CookiesJob.AutresMenu)
                    end

                end)

                RageUI.IsVisible(CookiesJob.InteractionsCitoyens, true, true, true, function()
                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)
            
                    RageUI.Separator("↓   Actions   ↓")

                    RageUI.ButtonWithStyle("Mettre une facture", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local raison = VisualManager:KeyboardOutput("Raison de la facture", "", 50)
                            local amount = VisualManager:KeyboardOutput("Montant de la facture", "", 15)

                            if tostring(raison) and tonumber(amount) then
                                exports["ac"]:ExecuteServerEvent('billing:sendBill', GetPlayerServerId(closestPlayer), 'cookies', raison, amount)
                            else
                                Framework.ShowNotification("~r~Arguments Invalide !")
                            end
                        end
                    end)

                end)

                RageUI.IsVisible(CookiesJob.GestionsObjets, true, true, true, function()

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
            end
        end)
    end
end