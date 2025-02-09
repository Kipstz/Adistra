
Property.coffreMenu = RageUI.CreateMenu("Coffre", "~p~Coffre~s~: Actions", 8, 200)
Property.DepositMenu = RageUI.CreateSubMenu(Property.coffreMenu, "Coffre", "~p~Coffre~s~: Déposer un objet/une arme", 8, 200)
Property.RemoveMenu = RageUI.CreateSubMenu(Property.coffreMenu, "Coffre", "~p~Coffre~s~: Retirer un objet/une arme", 8, 200)

local open = false

Property.coffreMenu.Closed = function()
    open = false
end

Property.coffreIndexs = {
    money = 1,
    b_money = 1
}

function Property:openCoffreMenu(propertyId, coords)
    if open then
        RageUI.CloseAll()
        RageUI.Visible(Property.coffreMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(Property.coffreMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(Property.coffreMenu, true, true, true, function()
                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)
                    if closestPlayer ~= -1 and closestPlayerDistance < 3.5 then
                        Framework.ShowNotification("~r~Action Impossible avec un joueur à proximité !")
                        RageUI.CloseAll()
                    else
                        if Vdist(myCoords, coords) < 3.1 then
                            Framework.ShowNotification("~r~Action Impossible en étant éloigner du coffre !")
                            RageUI.CloseAll()
                        else

                            RageUI.Separator("Argent Liquide: ~g~"..SharedProperty[propertyId].data["coffre"]["accounts"]["money"].."$")
                            RageUI.Separator("Argent Sale: ~r~"..SharedProperty[propertyId].data["coffre"]["accounts"]["black_money"].."$")
        
                            RageUI.List("Gestion Argent Liquide", { "Déposer", "Retirer" }, Property.coffreIndexs.money, nil, {}, true, function(Hovered, Active, Selected, Index)
                                if Selected then
                                    if Index == 1 then
                                        local amount = VisualManager:KeyboardOutput("Quantité", "", 5)
                                        if VisualManager:keyboardIsValid(amount, true) then
                                            exports["ac"]:ExecuteServerEvent('property:depositMoney', propertyId, tonumber(amount))
            
                                            Wait(50)
            
                                            Framework.TriggerServerCallback("property:getCoffreMoney", function(money)
                                                SharedProperty[propertyId].data["coffre"]["accounts"]["money"] = money
                                            end, propertyId)
                                        end
                                    elseif Index == 2 then
                                        local amount = VisualManager:KeyboardOutput("Quantité", "", 5)
                                        if VisualManager:keyboardIsValid(amount, true) then
                                            exports["ac"]:ExecuteServerEvent('property:removeMoney', propertyId, tonumber(amount))
            
                                            Wait(50)
            
                                            Framework.TriggerServerCallback("property:getCoffreMoney", function(money)
                                                SharedProperty[propertyId].data["coffre"]["accounts"]["money"] = money
                                            end, propertyId)
                                        end
                                    end
                                end
                            end, function(Index)
                                Property.coffreIndexs.money = Index
                            end)
        
                            RageUI.List("Gestion Argent Sale", { "Déposer", "Retirer" }, Property.coffreIndexs.b_money, nil, {}, true, function(Hovered, Active, Selected, Index)
                                if Selected then
                                    if Index == 1 then
                                        local amount = VisualManager:KeyboardOutput("Quantité", "", 5)
                                        if VisualManager:keyboardIsValid(amount, true) then
                                            exports["ac"]:ExecuteServerEvent('property:depositMoney2', propertyId, tonumber(amount))
            
                                            Wait(50)
            
                                            Framework.TriggerServerCallback("property:getCoffreMoney2", function(money)
                                                SharedProperty[propertyId].data["coffre"]["accounts"]["black_money"] = money
                                            end, propertyId)
                                        end
                                    elseif Index == 2 then
                                        local amount = VisualManager:KeyboardOutput("Quantité", "", 5)
                                        if VisualManager:keyboardIsValid(amount, true) then
                                            exports["ac"]:ExecuteServerEvent('property:removeMoney2', propertyId, tonumber(amount))
            
                                            Wait(50)
            
                                            Framework.TriggerServerCallback("property:getCoffreMoney2", function(money)
                                                SharedProperty[propertyId].data["coffre"]["accounts"]["black_money"] = money
                                            end, propertyId)
                                        end
                                    end
                                end
                            end, function(Index)
                                Property.coffreIndexs.b_money = Index
                            end)
        
                            RageUI.Line()
        
                            RageUI.ButtonWithStyle("Déposer un objet/une arme", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            end, Property.DepositMenu)
        
                            RageUI.ButtonWithStyle("Retirer un objet/une arme", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    Framework.TriggerServerCallback('property:getCoffre', function(coffre) 
                                        SharedProperty[propertyId].data["coffre"] = coffre
                                    end, propertyId)
                                end
                            end, Property.RemoveMenu)
                        end
                    end
                end)

                
                RageUI.IsVisible(Property.DepositMenu, true, true, true, function()

                    RageUI.Separator("↓   ~p~Mon Inventaire~s~   ↓")

                    for k,v in pairs(Framework.PlayerData.inventory) do
                        if v.count > 0 then
                            RageUI.ButtonWithStyle("[~b~"..v.count.."x~s~] - "..v.label, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local qte = VisualManager:KeyboardOutput("Quantité", "", 5)
                                    if VisualManager:keyboardIsValid(qte, true) then
                                        RageUI.GoBack()

                                        exports["ac"]:ExecuteServerEvent('property:depositCoffre', propertyId, 'item_standard', v, tonumber(qte))
                                    end
                                end
                            end)
                        end
                    end

                    RageUI.Separator("↓   ~p~Mes armes~s~   ↓")

                    for k,v in pairs(Framework.PlayerData.loadout) do
                        RageUI.ButtonWithStyle("[~o~"..v.ammo.."Muns~s~] - "..v.label, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                if not Framework.WeaponisBoutique(v.name) then
                                    RageUI.GoBack()

                                    exports["ac"]:ExecuteServerEvent('property:depositCoffre', propertyId, 'item_weapon', v)
                                else
                                    Framework.ShowNotification("~r~Vous ne pouvez pas déposer une arme boutique !")
                                end
                            end
                        end)
                    end
                end)

                RageUI.IsVisible(Property.RemoveMenu, true, true, true, function()

                    local myCoords = GetEntityCoords(PlayerPedId())
                    local closestPlayer, closestPlayerDistance = Framework.Game.GetClosestPlayer(myCoords)
                    if closestPlayer ~= -1 and closestPlayerDistance < 3.5 then
                        Framework.ShowNotification("~r~Action Impossible avec un joueur à proximité !")
                        RageUI.CloseAll()
                    else
                        if Vdist(myCoords, coords) < 3.1 then
                            Framework.ShowNotification("~r~Action Impossible en étant éloigner du coffre !")
                            RageUI.CloseAll()
                        else
                            RageUI.Separator("↓   ~p~Objets~s~   ↓")

                            for k,v in pairs(SharedProperty[propertyId].data["coffre"]["items"]) do
                                if v.count > 0 then
                                    RageUI.ButtonWithStyle("[~b~"..v.count.."x~s~] - "..v.label, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                                        if Selected then
                                            local qte = VisualManager:KeyboardOutput("Quantité", "", 5)
                                            if VisualManager:keyboardIsValid(qte, true) then
                                                RageUI.GoBack()
        
                                                exports["ac"]:ExecuteServerEvent('property:removeCoffre', propertyId, 'item_standard', v, tonumber(qte))
                                            end
                                        end
                                    end)
                                end
                            end
        
                            RageUI.Separator("↓   ~p~Armes~s~   ↓")
        
                            for k,v in pairs(SharedProperty[propertyId].data["coffre"]["weapons"]) do
                                RageUI.ButtonWithStyle("[~b~"..v.count.."x~s~] - "..v.label, nil, { RightLabel = "~o~"..v.ammo.."Muns~s~" }, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        RageUI.GoBack()
        
                                        exports["ac"]:ExecuteServerEvent('property:removeCoffre', propertyId, 'item_weapon', v)
                                    end
                                end)
                            end
                        end
                    end
                end)

            end
        end)
    end
end