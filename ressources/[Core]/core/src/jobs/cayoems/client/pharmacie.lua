
CayoEmsJob.PharmacieMenu = RageUI.CreateMenu("Ambulance", "~p~Ambulance~s~: Pharmacie", 8, 200)

CayoEmsJob.BuyStockMenu = RageUI.CreateSubMenu(CayoEmsJob.PharmacieMenu, "Ambulance", "~p~Ambulance~s~: Acheter un objet", 8, 200)

CayoEmsJob.DepotMenu = RageUI.CreateSubMenu(CayoEmsJob.PharmacieMenu, "Ambulance", "~p~Ambulance~s~: Déposer un objet", 8, 200)

local open = false

CayoEmsJob.PharmacieMenu.Closed = function()
    open = false
end

CayoEmsJob.OpenPharmacieMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(CayoEmsJob.PharmacieMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(CayoEmsJob.PharmacieMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)
                
                RageUI.IsVisible(CayoEmsJob.PharmacieMenu, true, true, true, function()

                    RageUI.Separator("↓   Gestion du Stock   ↓")

                    if Framework.PlayerData.jobs['job'].grade_name == 'boss' then
                        RageUI.ButtonWithStyle("Acceder au Catalogue du Fournisseur", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                        end, CayoEmsJob.BuyStockMenu)
                    end

                    RageUI.ButtonWithStyle("Déposer un Item", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                    end, CayoEmsJob.DepotMenu)

                    RageUI.Separator("↓   Stock   ↓")

                    if AmbulanceJob_Stock ~= nil and AmbulanceJob_Stock.items then
                        for k,v in pairs(AmbulanceJob_Stock.items) do
                            if v.count and v.count > 0 then
                                RageUI.ButtonWithStyle(v.label, "~r~ENTRER ~s~pour retirer cette Item", { RightLabel = "~b~x"..v.count }, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        local qte = VisualManager:KeyboardOutput("Quantité à retirer", "", 10)
    
                                        if tonumber(qte) then
                                            TriggerServerEvent("CayoEmsJob:remove", v.item, tonumber(qte))
                                        else
                                            Framework.ShowNotification("Veuillez saisir une quantité valide !")
                                        end
                                    end
                                end)
                            end
                        end
                    end

                end)

                RageUI.IsVisible(CayoEmsJob.BuyStockMenu, true, true, true, function()

                    RageUI.ButtonWithStyle("Acheter des Bandages", nil, { RightLabel = "~g~100$" }, true, function(Hovered, Active, Selected)
                        if Selected then 
                            local qte = VisualManager:KeyboardOutput("Quantité", "", 10)

                            if tonumber(qte) then
                                TriggerServerEvent("CayoEmsJob:buy", 'bandage', tonumber(qte), tonumber((100 * qte)))
                            else
                                Framework.ShowNotification("Veuillez saisir une quantité valide !")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Acheter des Medikit", nil, { RightLabel = "~g~200$" }, true, function(Hovered, Active, Selected)
                        if Selected then 
                            local qte = VisualManager:KeyboardOutput("Quantité", "", 10)

                            if tonumber(qte) then
                                TriggerServerEvent("CayoEmsJob:buy", 'medikit', tonumber(qte), tonumber((200 * qte)))
                            else
                                Framework.ShowNotification("Veuillez saisir une quantité valide !")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Acheter des Défibrillateur", nil, { RightLabel = "~g~350$" }, true, function(Hovered, Active, Selected)
                        if Selected then 
                            local qte = VisualManager:KeyboardOutput("Quantité", "", 10)

                            if tonumber(qte) then
                                TriggerServerEvent("CayoEmsJob:buy", 'defibrillateur', tonumber(qte), tonumber((1500 * qte)))
                            else
                                Framework.ShowNotification("Veuillez saisir une quantité valide !")
                            end
                        end
                    end)

                end)

                RageUI.IsVisible(CayoEmsJob.DepotMenu, true, true, true, function()
                    for k,v in pairs(Framework.PlayerData.inventory) do
                        if v.count > 0 then
                            RageUI.ButtonWithStyle(v.label, nil, { RightLabel = v.count}, true, function(Hovered, Active, Selected)
                                if Selected then 
                                    local qte = VisualManager:KeyboardOutput("Quantité à déposer", "", 10)
        
                                    if tonumber(qte) then
                                        TriggerServerEvent("CayoEmsJob:add", v.name, tonumber(qte))
                                    else
                                        Framework.ShowNotification("Veuillez saisir une quantité valide !")
                                    end
                                end
                            end)
                        end
                    end
                end)
            
            end
        end)
    end
end

RegisterNetEvent("CayoEmsJob:updateStock")
AddEventHandler("CayoEmsJob:updateStock", function(data)
    AmbulanceJob_Stock = data
end)