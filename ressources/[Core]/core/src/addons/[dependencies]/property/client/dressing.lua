
Property.dressingMenu = RageUI.CreateMenu("Dressing", "~p~Dressing~s~: Actions", 8, 200)

local open = false

Property.dressingMenu.Closed = function()
    open = false
end

function Property:openDressingMenu()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(Property.dressingMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(Property.dressingMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(Property.dressingMenu, true, true, true, function()

                    for k,v in pairs(ClotheShop.myOutfits) do
                        RageUI.List(v.name, { "Mettre", "Supprimer" }, Indexs.gestion, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                            if Selected then
                                if Index == 1 then
                                    TriggerEvent('skinchanger:getSkin', function(skin)
                                        TriggerEvent('skinchanger:loadClothes', skin, v.outfit)
                                    end)
                                else
                                    exports["ac"]:ExecuteServerEvent("shop_clothe:deleteOutfit", v.id)

                                    RageUI.GoBack()
                                end
                            end
                        end, function(Index, Selected)
                            Indexs.gestion = Index
                        end)
                    end

                end)
            end
        end)
    end
end