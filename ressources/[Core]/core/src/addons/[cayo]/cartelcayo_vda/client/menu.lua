
CartelCayo_VDA.Main = RageUI.CreateMenu("Vente d'armes", "Catégories Disponibles", 8, 200)

CartelCayo_VDA.CategoriesMenu = RageUI.CreateSubMenu(CartelCayo_VDA.Main, "Vente d'armes", "Catégories Disponibles", 8, 200)

local open = false

CartelCayo_VDA.Main.Closed = function()
    open = false
end

function CartelCayo_VDA:OpenMenu(list)
    if open then
        RageUI.CloseAll()
        RageUI.Visible(CartelCayo_VDA.Main, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(CartelCayo_VDA.Main, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(CartelCayo_VDA.Main, true, true, true, function()
                    for k,v in pairs(list.cats) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" },true, function(Hovered, Active, Selected)
                            if Selected then
                                CartelCayo_VDA.selectedCat = {
                                    name = v.name,
                                    label = v.label
                                }
                            end
                        end, CartelCayo_VDA.CategoriesMenu)
                    end
                end)

                RageUI.IsVisible(CartelCayo_VDA.CategoriesMenu, true, true, true, function()
                    for k,item in pairs(list.weapons) do
                        if item.cat == CartelCayo_VDA.selectedCat.name then
                            RageUI.ButtonWithStyle(item.label, nil, { RightLabel = "~g~"..Framework.Math.GroupDigits(item.price).."$" },true, function(Hovered, Active, Selected)
                                if Selected then
                                    if item.cat ~= 'items' then
                                        exports["ac"]:ExecuteServerEvent("cartelcayo_vda:buyWeapon", item, tonumber(qte))
                                    else
                                        local qte = VisualManager:KeyboardOutput("Quantité", "", 10)
    
                                        if tonumber(qte) then
                                            exports["ac"]:ExecuteServerEvent("cartelcayo_vda:buyItem", item, tonumber(qte))
                                        else
                                            Framework.ShowNotification("~r~Veuillez saisir une Quantité valide !")
                                        end
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