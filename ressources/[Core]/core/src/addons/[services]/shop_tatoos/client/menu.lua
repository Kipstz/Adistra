TatoosShop.MainMenu = RageUI.CreateMenu(Config["shop_tatoos"].MenuTitle.MainMenu, Config["shop_tatoos"].MenuSubTitle.MainMenu, 8, 200)

TatoosShop.CategoriesMenu = RageUI.CreateSubMenu(TatoosShop.MainMenu, Config["shop_tatoos"].MenuTitle.CategoryMenu, Config["shop_tatoos"].MenuSubTitle.CategoryMenu, 8, 200)

local open = false;

TatoosShop.MainMenu.Closed = function()
    open = false;
    TatoosShop:reloadTattoos()
    SkinChanger.ReloadSkinPlayer()
end

function TatoosShop:OpenMenu(locIndex)
    TatoosShop.catSelected = ''

    Framework.TriggerServerCallback('skinchanger:getPlayerSkin', function(skin, jobSkin)
        if skin.sex == 0 then
            TatoosShop.mySex = 0
        else
            TatoosShop.mySex = 1
        end
    end)

    if open then
        RageUI.CloseAll()
        Wait(500)
        RageUI.Visible(TatoosShop.MainMenu, false)
        open = false;
    else
        RageUI.CloseAll()
        Wait(500)
        RageUI.Visible(TatoosShop.MainMenu, true)
        open = true;

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(TatoosShop.MainMenu, true, true, true, function()
                    for k,v in pairs(Config["shop_tatoos"].categories) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                TatoosShop.catSelected = v.zone
                            end
                        end, TatoosShop.CategoriesMenu)
                    end

                    -- RageUI.Line()

                    -- RageUI.ButtonWithStyle("Effacer tout mes tatouages", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    --     if Selected then

                    --     end
                    -- end)
                end)

                RageUI.IsVisible(TatoosShop.CategoriesMenu, true, true, true, function()
                    for k,v in pairs(Config["shop_tatoos"].items) do
                        if v.zone == TatoosShop.catSelected and TatoosShop:accessTattoo(TatoosShop.mySex, v.HashNameMale, v.HashNameFemale) then
                            RageUI.ButtonWithStyle("Tatouage N° "..k, nil, { RightLabel = "~g~"..Framework.Math.GroupDigits(v.price).."$" }, true, function(Hovered, Active, Selected)
                                if Active then
                                    local hash = TatoosShop:returnHash(TatoosShop.mySex, v.HashNameMale, v.HashNameFemale)
                                    TatoosShop:changeTattoo(v.collection, hash)
                                end
                                
                                if Selected then
                                    local hash = TatoosShop:returnHash(TatoosShop.mySex, v.HashNameMale, v.HashNameFemale)
                                    local hasTattoo = false;
    
                                    for _,tattoo in pairs(TatoosShop.myTattoos) do
                                        if GetHashKey(v.collection) == GetHashKey(tattoo.collection) and GetHashKey(hash) == GetHashKey(tattoo.nameHash) then
                                            hasTattoo = true
                                        end
                                    end
    
                                    if not hasTattoo then
                                        RageUI.CloseAll()
                                        Wait(500)
                                        Framework.PaymentMethod(tonumber(v.price), function(price, method)
                                            if price and method ~= nil then
                                                table.insert(TatoosShop.myTattoos, {
                                                    collection = v.collection, 
                                                    nameHash = hash
                                                })

                                                Framework.TriggerServerCallback('shop_tattoos:haveMoney', function(hasMoney)
                                                    if not hasMoney then
                                                        for k,v in pairs(TatoosShop.myTattoos) do
                                                            if v.nameHash == hash then
                                                                table.remove(TatoosShop.myTattoos, k)
                                                                TatoosShop:reloadTattoos()
                                                                SkinChanger.ReloadSkinPlayer()
                                                            end
                                                        end
                                                    else
                                                        TatoosShop:reloadTattoos()
                                                        SkinChanger.ReloadSkinPlayer()
                                                    end                
                                                end, {tattoos = TatoosShop.myTattoos, price = tonumber(v.price), method = method})
                                            end
                                        end)
                                    else
                                        Framework.ShowNotification("~r~Vous avez déjà ce tatouage !~s~")
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