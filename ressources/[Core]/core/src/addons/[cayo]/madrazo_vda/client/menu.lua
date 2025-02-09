
Madrazo_VDA.Main = RageUI.CreateMenu("Vente d'armes", "Catégories Disponibles", 8, 200)

Madrazo_VDA.CategoriesMenu = RageUI.CreateSubMenu(Madrazo_VDA.Main, "Vente d'armes", "Catégories Disponibles", 8, 200)

local open = false

Madrazo_VDA.Main.Closed = function()
    open = false
end

function Madrazo_VDA:OpenMenu(list)
    if open then
        RageUI.CloseAll()
        RageUI.Visible(Madrazo_VDA.Main, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(Madrazo_VDA.Main, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(Madrazo_VDA.Main, true, true, true, function()
                    for k,v in pairs(list.cats) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" },true, function(Hovered, Active, Selected)
                            if Selected then
                                Madrazo_VDA.selectedCat = {
                                    name = v.name,
                                    label = v.label
                                }
                            end
                        end, Madrazo_VDA.CategoriesMenu)
                    end
                end)

                RageUI.IsVisible(Madrazo_VDA.CategoriesMenu, true, true, true, function()
                    for k,item in pairs(list.weapons) do
                        if item.cat == Madrazo_VDA.selectedCat.name then
                            RageUI.ButtonWithStyle(item.label, nil, { RightLabel = "~g~"..Framework.Math.GroupDigits(item.price).."$" },true, function(Hovered, Active, Selected)
                                if Selected then
                                    if item.cat ~= 'items' then
                                        exports["ac"]:ExecuteServerEvent("madrazo_vda:buyWeapon", item, tonumber(qte))
                                    else
                                        local qte = VisualManager:KeyboardOutput("Quantité", "", 10)
    
                                        if tonumber(qte) then
                                            exports["ac"]:ExecuteServerEvent("madrazo_vda:buyItem", item, tonumber(qte))
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