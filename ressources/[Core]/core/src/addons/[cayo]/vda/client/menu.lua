
VDA.Main = RageUI.CreateMenu("Vente d'armes", "Catégories Disponibles", 8, 200)

VDA.CategoriesMenu = RageUI.CreateSubMenu(VDA.Main, "Vente d'armes", "Catégories Disponibles", 8, 200)

local open = false

VDA.Main.Closed = function()
    open = false
end

function VDA:OpenMenu(list)
    if open then
        RageUI.CloseAll()
        RageUI.Visible(VDA.Main, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(VDA.Main, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(VDA.Main, true, true, true, function()
                    for k,v in pairs(list.cats) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" },true, function(Hovered, Active, Selected)
                            if Selected then
                                VDA.selectedCat = {
                                    name = v.name,
                                    label = v.label
                                }
                            end
                        end, VDA.CategoriesMenu)
                    end
                end)

                RageUI.IsVisible(VDA.CategoriesMenu, true, true, true, function()
                    for k,item in pairs(list.weapons) do
                        if item.cat == VDA.selectedCat.name then
                            RageUI.ButtonWithStyle(item.label, nil, { RightLabel = "~g~"..Framework.Math.GroupDigits(item.price).."$" },true, function(Hovered, Active, Selected)
                                if Selected then
                                    exports["ac"]:ExecuteServerEvent("vda:buyWeapon", item, tonumber(qte))
                                end
                            end)
                        end
                    end
                end)
            end
        end)
    end
end