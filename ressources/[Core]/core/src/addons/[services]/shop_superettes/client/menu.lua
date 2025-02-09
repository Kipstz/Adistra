
Superettes.MainMenu = RageUI.CreateMenu(Config["shop_superettes"].MenuTitle.MainMenu, Config["shop_superettes"].MenuSubTitle.MainMenu, 8, 200)

Superettes.CategoriesMenu = RageUI.CreateSubMenu(Superettes.MainMenu, Config["shop_superettes"].MenuTitle.CategoryMenu, Config["shop_superettes"].MenuSubTitle.CategoryMenu, 8, 200)

local open = false

Superettes.MainMenu.Closed = function()
    open = false
end

function Superettes:OpenMenu(locIndex)
    Superettes.catSelected = ''

    if open then
        RageUI.CloseAll()
        RageUI.Visible(Superettes.MainMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(Superettes.MainMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(Superettes.MainMenu, true, true, true, function()
                    for k,v in pairs(Config["shop_superettes"].categories) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                Superettes.catSelected = v.name
                            end
                        end, Superettes.CategoriesMenu)
                    end
                end)

                RageUI.IsVisible(Superettes.CategoriesMenu, true, true, true, function()
                    for k,v in pairs(Config["shop_superettes"].items) do
                        if v.cat == Superettes.catSelected then
                            RageUI.ButtonWithStyle("[PRIX: ~g~"..v.price.."$ ~s~] - "..v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local qte = VisualManager:KeyboardOutput("Quantité", "", 3)

                                    if VisualManager:keyboardIsValid(qte, true) then
                                        RageUI.CloseAll()
                                        Framework.PaymentMethod(tonumber(v.price*qte), function(price, method)
                                            if price and method ~= nil then
                                                Framework.TriggerServerCallback('shop_superettes:haveMoney', function(hasMoney)
                                                end, {name = v.name, count = qte, price = tonumber(v.price), method = method})
                                            end
                                        end)
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