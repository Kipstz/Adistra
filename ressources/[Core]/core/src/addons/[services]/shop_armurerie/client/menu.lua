
Armurerie.Main = RageUI.CreateMenu(Config["shop_armurerie"].MenuTitle.MainMenu, Config["shop_armurerie"].MenuSubTitle.MainMenu, 8, 200)
Armurerie.categorieMenu = RageUI.CreateSubMenu(Armurerie.Main, Config["shop_armurerie"].MenuTitle.MainMenu, Config["shop_armurerie"].MenuSubTitle.MainMenu, 8, 200)

local open = false

Armurerie.Main.Closed = function()
    open = false
end

Armurerie.categorySelected = ''
Armurerie.hasPPA = false

function Armurerie:OpenMenu()
    Framework.TriggerServerCallback('shop_armurerie:checkLicense', function(result)
        Armurerie.hasPPA = result
    end)

    if open then
        RageUI.CloseAll()
        RageUI.Visible(Armurerie.Main, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(Armurerie.Main, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(Armurerie.Main, true, true, true, function()

                    for k,v in pairs(Config['shop_armurerie'].categories) do
                        if v.needPPA and not Armurerie.hasPPA then
                            RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, false, function(Hovered, Active, Selected)
                            end)
                        else
                            RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    Armurerie.categorySelected = v.name
                                end
                            end, Armurerie.categorieMenu)
                        end
                    end

                    if not Armurerie.hasPPA then
                        RageUI.Line()

                        RageUI.ButtonWithStyle("Acheter le PPA", nil, { RightLabel = "~g~"..Framework.Math.GroupDigits(Config['shop_armurerie'].pricePPA).."$~s~" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                exports["ac"]:ExecuteServerEvent('shop_armurerie:buyPPA')

                                Wait(500)

                                Framework.TriggerServerCallback('shop_armurerie:checkLicense', function(result)
                                    Armurerie.hasPPA = result
                                end)
                            end
                        end)
                    end
                end)

                RageUI.IsVisible(Armurerie.categorieMenu, true, true, true, function()

                    for k,v in pairs(Config['shop_armurerie'].items) do
                        if v.cat == Armurerie.categorySelected then
                            RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "~g~"..Framework.Math.GroupDigits(v.price).."$~s~" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    if Armurerie.categorySelected ~= 'others' then
                                        exports["ac"]:ExecuteServerEvent('shop_armurerie:buy', {name = v.name, price = v.price}, tonumber(qte))
                                    else
                                        v.action()
                                    end
                                end
                            end, Armurerie.categorieMenu)
                        end
                    end
                end)
            end
        end)
    end
end