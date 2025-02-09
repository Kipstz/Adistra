
ClotheShop.Main = RageUI.CreateMenu(Config["shop_clothe"].MenuTitle.MainMenu, Config["shop_clothe"].MenuSubTitle.MainMenu, 8, 200)

ClotheShop.ShopMenu = RageUI.CreateSubMenu(ClotheShop.Main, Config["shop_clothe"].MenuTitle.ShopMenu, Config["shop_clothe"].MenuSubTitle.ShopMenu, 8, 200)
ClotheShop.ClotheGestion = RageUI.CreateSubMenu(ClotheShop.Main, Config["shop_clothe"].MenuTitle.ClotheGestion, Config["shop_clothe"].MenuSubTitle.ClotheGestion, 8, 200)

Indexs = {
    tshirt_1 = 1,
    tshirt_2 = 1,
    torso_1 = 1,
    torso_2 = 1,
    arms = 1,
    arms_1 = 1,
    decals_1 = 1,
    decals_2 = 1,
    chain_1 = 1,
    chain_2 = 1,
    pants_1 = 1,
    pants_2 = 1,
    shoes_1 = 1,
    shoes_2 = 1,
    sac_1 = 1,
    sac_2 = 1,
    gestion = 1,
    bproof_1 = 1,
    bproof_2 = 1,
    makeup_1 = 1,
    makeup_2 = 1,
    makeup_3 = 1,
    makeup_4 = 1
}

ClotheShopMenuIsOpen = false

ClotheShop.Main.Closed = function()
    ClotheShopMenuIsOpen = false

    SkinChanger.DeleteSkinCam()
end

ClotheShop.ShopMenu.Closed = function()
    SkinChanger.DeleteSkinCam()
end

ClotheShop.Main.WidthOffset = 50
ClotheShop.ShopMenu.WidthOffset = 50
ClotheShop.ClotheGestion.WidthOffset = 50

function ClotheShop:OpenMenu()
    ClotheShop.player_money = 0

    for i = 1, #Framework.PlayerData.accounts, 1 do
		if Framework.PlayerData.accounts[i].name == 'money' then
			ClotheShop.player_money = Framework.PlayerData.accounts[i].money
		end
    end
            
    Tshirts = {}
    Tshirts2 = {}
    Vestes = {}
    Vestes2 = {}
    Gants = {}
    Gants2 = {}
    Calques = {}
    Calques2 = {}
    Chaines = {}
    Chaines2 = {}
    Pantalons = {}
    Pantalons2 = {}
    Chaussures = {}
    Chaussures2 = {}
    Sacs = {}
    Sacs2 = {}
    Bproofs = {}
    Bproofs2 = {}
    MakeupTypes = {}
    MakeupOpacities = {}
    MakeupColors1 = {}
    MakeupColors2 = {}
    Chapeaux, Lunettes, Masques, Bracelets = {}, {}, {}, {}

    for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 8)-1 do --Tshirts
        table.insert(Tshirts, i)
    end

    for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 11)-1 do --Vestes
        table.insert(Vestes, i)
    end

    for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 5)-2 do --Gants
        table.insert(Gants, i)
    end

    for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 10)-2 do --Calques
        table.insert(Calques, i)
    end

    for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 4)-1 do --Pantalons
        table.insert(Pantalons, i)
    end

    for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 6)-2 do --Chaussures
        table.insert(Chaussures, i)
    end

    for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 5)-1 do --Sacs
        table.insert(Sacs, i)
    end

    for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 7)-2 do --Chaines
        table.insert(Chaines, i)
    end

    -- for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 9)-1 do --Gilets pare-balles
    --     table.insert(Bproofs, i)
    -- end

    local Bproofs = {} for i = 0 , GetNumberOfPedDrawableVariations(PlayerPedId(), 9) - 1, 1 do table.insert(Bproofs, i) end

    for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 4)-1 do -- Types de maquillage
        table.insert(MakeupTypes, i)
    end
    
    for i = 0, 10 do -- Opacité du maquillage
        table.insert(MakeupOpacities, i)
    end
    
    for i = 0, GetNumMakeupColors() - 1 do -- Couleurs du maquillage
        table.insert(MakeupColors1, i)
        table.insert(MakeupColors2, i)
    end

    for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 0)-1 do table.insert(Chapeaux, i) end
    for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 1)-1 do table.insert(Lunettes, i) end
    for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 2)-1 do table.insert(Masques, i) end
    for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 3)-1 do table.insert(Bracelets, i) end

    if ClotheShopMenuIsOpen then
        RageUI.CloseAll()
        RageUI.Visible(ClotheShop.Main, false)
        ClotheShopMenuIsOpen = false
    else
        RageUI.CloseAll()
        RageUI.Visible(ClotheShop.Main, true)
        ClotheShopMenuIsOpen = true

        ClotheShop.ShopMenu.Closable = false

        CreateThread(function()
            while ClotheShopMenuIsOpen do
                Wait(1)

                RageUI.IsVisible(ClotheShop.Main, true, true, true, function()

                    RageUI.ButtonWithStyle("Accéder au Magasin", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            SkinChanger.CreateSkinCam()
                            SkinChanger.zoomOffset = 0.75
                            SkinChanger.camOffset = 0.15
                        end
                    end, ClotheShop.ShopMenu)

                    RageUI.ButtonWithStyle("Sauvegarde votre Tenue", nil, { RightLabel = "~p~350$" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            if ClotheShop.player_money > 349 then
                                local NomTenue = VisualManager:KeyboardOutput("Nom de la Tenue", "", 25)

                                if tostring(NomTenue) then
                                    TriggerEvent('skinchanger:getSkin', function(skin)
                                        exports["ac"]:ExecuteServerEvent('skinchanger:save', skin)
                                        exports["ac"]:ExecuteServerEvent('shop_clothe:buy', NomTenue, skin)
                                    end)
                                else
                                    Framework.ShowNotification("~r~Veuillez saisir un Nom Valide !")
                                end
                            else
                                Framework.ShowNotification("~r~Vous n'avez pas asser d'argent !")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Gérer vos Tenues", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    end, ClotheShop.ClotheGestion)
                end)

                RageUI.IsVisible(ClotheShop.ShopMenu, true, true, true, function()
                    RageUI.List("T-Shirt 1", Tshirts, Indexs.tshirt_1, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                        if Selected then -- 49 est le code pour la touche F
                            local number = tonumber(VisualManager:KeyboardOutput("Numéro du T-Shirt", "", 3))
                            if number then
                                Indexs.tshirt_1 = number
                                TriggerEvent('skinchanger:change', 'tshirt_1', number-1)
                                Framework.ShowNotification("~g~T-Shirt changé pour : "..number)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                            end
                        end
                    end, function(Index)
                        Indexs.tshirt_1 = Index
                        Tshirts2 = {}

                        SkinChanger.zoomOffset = 0.75
                        SkinChanger.camOffset = 0.15

                        TriggerEvent('skinchanger:change', 'tshirt_1', Index-1) 
                        TriggerEvent('skinchanger:change', 'tshirt_2', 0) 

                        for i = 0, GetNumberOfPedTextureVariations(PlayerPedId(), 8, Index-1)-1 do
                            table.insert(Tshirts2, i)
                        end
                    end)

                    if next(Tshirts2) then
                        RageUI.List("T-Shirt 2", Tshirts2, Indexs.tshirt_2, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                            if Selected then
                                local number = tonumber(VisualManager:KeyboardOutput("Numéro de la variante", "", 3))
                                if number then
                                    Indexs.tshirt_2 = number
                                    TriggerEvent('skinchanger:change', 'tshirt_2', number-1)
                                    Framework.ShowNotification("~g~Variante changée pour : "..number)
                                else
                                    Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                                end
                            end
                        end, function(Index)
                            Indexs.tshirt_2 = Index
    
                            TriggerEvent('skinchanger:change', 'tshirt_2', Index-1) 
                        end)

                        RageUI.Separator()
                    end

                    RageUI.List("Veste 1", Vestes, Indexs.torso_1, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            local number = tonumber(VisualManager:KeyboardOutput("Numéro de la veste", "", 3))
                            if number then
                                Indexs.torso_1 = number
                                TriggerEvent('skinchanger:change', 'torso_1', number-1)
                                Framework.ShowNotification("~g~Veste changée pour : "..number)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                            end
                        end
                    end, function(Index)
                        Indexs.torso_1 = Index
                        Vestes2 = {}

                        SkinChanger.zoomOffset = 0.75
                        SkinChanger.camOffset = 0.15

                        TriggerEvent('skinchanger:change', 'torso_1', Index-1) 
                        TriggerEvent('skinchanger:change', 'torso_2', 0) 

                        for i = 0, GetNumberOfPedTextureVariations(PlayerPedId(), 11, Index-1)-1 do
                            table.insert(Vestes2, i)
                        end
                    end)

                    if next(Vestes2) then
                        RageUI.List("Veste 2", Vestes2, Indexs.torso_2, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                            if Selected then
                                local number = tonumber(VisualManager:KeyboardOutput("Numéro de la variante", "", 3))
                                if number then
                                    Indexs.torso_2 = number
                                    TriggerEvent('skinchanger:change', 'torso_2', number-1)
                                    Framework.ShowNotification("~g~Variante changée pour : "..number)
                                else
                                    Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                                end
                            end
                        end, function(Index)
                            Indexs.torso_2 = Index
    
                            TriggerEvent('skinchanger:change', 'torso_2', Index-1) 
                        end)

                        RageUI.Separator()
                    end

                    RageUI.List("Calques 1", Calques, Indexs.decals_1, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            local number = tonumber(VisualManager:KeyboardOutput("Numéro du calques", "", 3))
                            if number then
                                Indexs.decals_1 = number
                                TriggerEvent('skinchanger:change', 'decals_1', number - 1)
                                Framework.ShowNotification("~g~Calques changée pour : "..number)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                            end
                        end
                    end, function(Index)
                        Indexs.decals_1 = Index
                        Calques2 = {}

                        SkinChanger.zoomOffset = 0.75
                        SkinChanger.camOffset = 0.15

                        TriggerEvent('skinchanger:change', 'decals_1', Index - 1)
                        TriggerEvent('skinchanger:change', 'decals_2', 0)

                        for i = 0, GetNumberOfPedTextureVariations(PlayerPedId(), 11, Index-1)-1 do
                            table.insert(Calques2, i)
                        end
                    end)


                    if next(Calques2) then 
                        RageUI.List("Calques 2", Calques2, Indexs.decals_2, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                            if Selected then
                                local number = tonumber(VisualManager:KeyboardOutput("Numéro de la variante", "", 3))
                                if number then
                                    Indexs.decals_2 = number
                                    TriggerEvent('skinchanger:change', 'decals_2', number - 1)
                                    Framework.ShowNotification("~g~Variante changée pour : "..number)
                                else
                                    Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                                end
                            end
                        end, function(Index)
                            Indexs.decals_2 = Index
                            TriggerEvent('skinchanger:change', 'decals_2', Index - 1)
                        end)
                        RageUI.Separator()
                    end

                    RageUI.List("Gants 1", Gants, Indexs.arms, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            local number = tonumber(VisualManager:KeyboardOutput("Numéro des gants", "", 3))
                            if number then
                                Indexs.arms = number
                                TriggerEvent('skinchanger:change', 'arms', number-1)
                                Framework.ShowNotification("~g~Gants changés pour : "..number)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                            end
                        end
                    end, function(Index)
                        Indexs.arms = Index
                        Gants2 = {}

                        SkinChanger.zoomOffset = 0.75
                        SkinChanger.camOffset = 0.15

                        TriggerEvent('skinchanger:change', 'arms', Index-1) 
                        TriggerEvent('skinchanger:change', 'arms_1', 0) 

                        for i = 0, GetNumberOfPedTextureVariations(PlayerPedId(), 5, Index-1)-1 do
                            table.insert(Gants2, i)
                        end
                    end)

                    if next(Gants2) then
                        RageUI.List("Gants 2", Gants2, Indexs.arms_1, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                            if Selected then
                                local number = tonumber(VisualManager:KeyboardOutput("Numéro de la variante", "", 3))
                                if number then
                                    Indexs.arms_1 = number
                                    TriggerEvent('skinchanger:change', 'arms_1', number-1)
                                    Framework.ShowNotification("~g~Variante changée pour : "..number)
                                else
                                    Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                                end
                            end
                        end, function(Index)
                            Indexs.arms_1 = Index
    
                            TriggerEvent('skinchanger:change', 'arms_1', Index-1) 
                        end)

                        RageUI.Separator()
                    end

                    RageUI.List("Pantalons 1", Pantalons, Indexs.pants_1, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            local number = tonumber(VisualManager:KeyboardOutput("Numéro du pantalon", "", 3))
                            if number then
                                Indexs.pants_1 = number
                                TriggerEvent('skinchanger:change', 'pants_1', number-1)
                                Framework.ShowNotification("~g~Pantalon changé pour : "..number)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                            end
                        end
                    end, function(Index)
                        Indexs.pants_1 = Index
                        Pantalons2 = {}

                        SkinChanger.zoomOffset = 0.8
                        SkinChanger.camOffset = -0.5

                        TriggerEvent('skinchanger:change', 'pants_1', Index-1) 
                        TriggerEvent('skinchanger:change', 'pants_2', 0) 

                        for i = 0, GetNumberOfPedTextureVariations(PlayerPedId(), 4, Index-1)-1 do
                            table.insert(Pantalons2, i)
                        end
                    end)

                    if next(Pantalons2) then
                        RageUI.List("Pantalons 2", Pantalons2, Indexs.pants_2, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                            if Selected then
                                local number = tonumber(VisualManager:KeyboardOutput("Numéro de la variante", "", 3))
                                if number then
                                    Indexs.pants_2 = number
                                    TriggerEvent('skinchanger:change', 'pants_2', number-1)
                                    Framework.ShowNotification("~g~Variante changée pour : "..number)
                                else
                                    Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                                end
                            end
                        end, function(Index)
                            Indexs.pants_2 = Index
    
                            TriggerEvent('skinchanger:change', 'pants_2', Index-1) 
                        end)

                        RageUI.Separator()
                    end

                    RageUI.List("Chaussures 1", Chaussures, Indexs.shoes_1, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            local number = tonumber(VisualManager:KeyboardOutput("Numéro des chaussures", "", 3))
                            if number then
                                Indexs.shoes_1 = number
                                TriggerEvent('skinchanger:change', 'shoes_1', number-1)
                                Framework.ShowNotification("~g~Chaussures changées pour : "..number)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                            end
                        end
                    end, function(Index)
                        Indexs.shoes_1 = Index
                        Chaussures2 = {}

                        SkinChanger.zoomOffset = 0.8
                        SkinChanger.camOffset = -0.8

                        TriggerEvent('skinchanger:change', 'shoes_1', Index-1) 
                        TriggerEvent('skinchanger:change', 'shoes_2', 0) 

                        for i = 0, GetNumberOfPedTextureVariations(PlayerPedId(), 6, Index-1)-1 do
                            table.insert(Chaussures2, i)
                        end
                    end)

                    if next(Chaussures2) then
                        RageUI.List("Chaussures 2", Chaussures2, Indexs.shoes_2, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                            if Selected then
                                local number = tonumber(VisualManager:KeyboardOutput("Numéro de la variante", "", 3))
                                if number then
                                    Indexs.shoes_2 = number
                                    TriggerEvent('skinchanger:change', 'shoes_2', number-1)
                                    Framework.ShowNotification("~g~Variante changée pour : "..number)
                                else
                                    Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                                end
                            end
                        end, function(Index)
                            Indexs.shoes_2 = Index
    
                            TriggerEvent('skinchanger:change', 'shoes_2', Index-1) 
                        end)

                        RageUI.Separator()
                    end

                    RageUI.List("Sac 1", Sacs, Indexs.sac_1, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            local number = tonumber(VisualManager:KeyboardOutput("Numéro du sac", "", 3))
                            if number then
                                Indexs.sac_1 = number
                                TriggerEvent('skinchanger:change', 'bags_1', number-1)
                                Framework.ShowNotification("~g~Sac changé pour : "..number)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                            end
                        end
                    end, function(Index)
                        Indexs.sac_1 = Index
                        Sacs2 = {}

                        SkinChanger.zoomOffset = 0.75
                        SkinChanger.camOffset = 0.0

                        TriggerEvent('skinchanger:change', 'bags_1', Index-1) 
                        TriggerEvent('skinchanger:change', 'bags_2', 0) 

                        for i = 0, GetNumberOfPedTextureVariations(PlayerPedId(), 5, Index-1)-1 do
                            table.insert(Sacs2, i)
                        end
                    end)

                    if next(Sacs2) then
                        RageUI.List("Sac 2", Sacs2, Indexs.sac_2, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                            if Selected then
                                local number = tonumber(VisualManager:KeyboardOutput("Numéro de la variante", "", 3))
                                if number then
                                    Indexs.sac_2 = number
                                    TriggerEvent('skinchanger:change', 'bags_2', number-1)
                                    Framework.ShowNotification("~g~Variante changée pour : "..number)
                                else
                                    Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                                end
                            end
                        end, function(Index)
                            Indexs.sac_2 = Index
                            TriggerEvent('skinchanger:change', 'bags_2', Index-1) 
                        end)
                    end

                    RageUI.List("Gillet par balle 1", Bproofs, Indexs.bproof_1, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            local number = tonumber(VisualManager:KeyboardOutput("Numéro du gilet par balle", "", 3))
                            if number then
                                Indexs.bproof_1 = number
                                TriggerEvent('skinchanger:change', 'bproof_1', number-1)
                                Framework.ShowNotification("~g~Gillet par balle changé pour : "..number)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                            end
                        end
                    end, function(Index)
                        Indexs.bproof_1 = Index
                        Bproofs2 = {}

                        SkinChanger.zoomOffset = 0.75
                        SkinChanger.camOffset = 0.0

                        TriggerEvent('skinchanger:change', 'bproof_1', Index - 1)
                        TriggerEvent('skinchanger:change', 'bproof_2', 0)

                        for i = 0 , GetNumberOfPedTextureVariations(PlayerPedId(), 9, Index - 1) - 1, 1 do
                            table.insert(Bproofs2, i)
                        end
                    end)


                    if next(Bproofs2) then
                        RageUI.List("Gillet par balle 2", Bproofs2, Indexs.bproof_2, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                            if Selected then
                                local number = tonumber(VisualManager:KeyboardOutput("Numéro de la variante", "", 3))
                                if number then
                                    Indexs.bproof_2 = number
                                    TriggerEvent('skinchanger:change', 'bproof_2', number-1)
                                    Framework.ShowNotification("~g~Variante changée pour : "..number)
                                else
                                    Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                                end
                            end
                        end, function(Index)
                            Indexs.bproof_2 = Index
                            TriggerEvent('skinchanger:change', 'bproof_2', Index - 1)
                        end)

                        RageUI.Separator()
                    end

                    RageUI.List("Type de Maquillage", MakeupTypes, Indexs.makeup_1, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            local number = tonumber(VisualManager:KeyboardOutput("Numéro du type de maquillage", "", 3))
                            if number then
                                Indexs.makeup_1 = number
                                TriggerEvent('skinchanger:change', 'makeup_1', number-1)
                                Framework.ShowNotification("~g~Type de maquillage changé pour : "..number)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                            end
                        end
                    end, function(Index)
                        Indexs.makeup_1 = Index

                        SkinChanger.zoomOffset = 0.4
                        SkinChanger.camOffset = 0.65

                        TriggerEvent('skinchanger:change', 'makeup_1', Index-1)
                    end)
                    
                    RageUI.List("Opacité du Maquillage", MakeupOpacities, Indexs.makeup_2, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            local number = tonumber(VisualManager:KeyboardOutput("Numéro de l'opacité", "", 3))
                            if number then
                                Indexs.makeup_2 = number
                                TriggerEvent('skinchanger:change', 'makeup_2', number-1)
                                Framework.ShowNotification("~g~Opacité changée pour : "..number)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                            end
                        end
                    end, function(Index)
                        Indexs.makeup_2 = Index

                        SkinChanger.zoomOffset = 0.4
                        SkinChanger.camOffset = 0.65

                        TriggerEvent('skinchanger:change', 'makeup_2', Index-1)
                    end)
                    
                    RageUI.List("Couleur de Maquillage 1", MakeupColors1, Indexs.makeup_3, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            local number = tonumber(VisualManager:KeyboardOutput("Numéro de la couleur 1", "", 3))
                            if number then
                                Indexs.makeup_3 = number
                                TriggerEvent('skinchanger:change', 'makeup_3', number-1)
                                Framework.ShowNotification("~g~Couleur 1 changée pour : "..number)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                            end
                        end
                    end, function(Index)
                        Indexs.makeup_3 = Index
                        TriggerEvent('skinchanger:change', 'makeup_3', Index-1)
                    end)
                    
                    RageUI.List("Couleur de Maquillage 2", MakeupColors2, Indexs.makeup_4, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            local number = tonumber(VisualManager:KeyboardOutput("Numéro de la couleur 2", "", 3))
                            if number then
                                Indexs.makeup_4 = number
                                TriggerEvent('skinchanger:change', 'makeup_4', number-1)
                                Framework.ShowNotification("~g~Couleur 2 changée pour : "..number)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                            end
                        end
                    end, function(Index)
                        Indexs.makeup_4 = Index
                        TriggerEvent('skinchanger:change', 'makeup_4', Index-1)
                    end)

                    RageUI.Line()

                    RageUI.ButtonWithStyle("~g~Valider le Personnage", nil, { RightLabel = "~p~350$"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            if ClotheShop.player_money > 349 then
                                local SaveDmd = VisualManager:KeyboardOutput("Voulez-vous sauvegarder la Tenue (Oui/Non)", "", 3)

                                if tostring(SaveDmd) and SaveDmd == 'Oui' or SaveDmd == 'Non' or SaveDmd == 'oui' or SaveDmd == 'non' then
                                    if SaveDmd == 'Oui' or SaveDmd == 'oui' then
                                        local NomTenue = VisualManager:KeyboardOutput("Nom de la Tenue", "", 25)

                                        if tostring(NomTenue) then
                                            TriggerEvent('skinchanger:getSkin', function(skin)
                                                exports["ac"]:ExecuteServerEvent('skinchanger:save', skin)
                                                exports["ac"]:ExecuteServerEvent('shop_clothe:buy', NomTenue, skin)
                                            end)
                
                                            SkinChanger.DeleteSkinCam()
                                            RageUI.CloseAll()
                                        else
                                            Framework.ShowNotification("~r~Veuillez saisir un Nom Valide !")
                                        end
                                    else
                                        TriggerEvent('skinchanger:getSkin', function(skin)
                                            exports["ac"]:ExecuteServerEvent('skinchanger:save', skin)
                                            exports["ac"]:ExecuteServerEvent('shop_clothe:pay')
                                        end)
            
                                        SkinChanger.DeleteSkinCam()
                                        RageUI.CloseAll()
                                    end
                                else
                                    Framework.ShowNotification("~r~Veuillez saisir Oui ou Non.")
                                end
                            else
                                SkinChanger.ReloadSkinPlayer()
                                Framework.ShowNotification("~r~Vous n'avez pas assez d'argent !")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Retour", nil, { RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            SkinChanger.ReloadSkinPlayer()
                            SkinChanger.DeleteSkinCam()
                            RageUI.GoBack()
                        end
                    end)
                end)


                RageUI.IsVisible(ClotheShop.ClotheGestion, true, true, true, function()

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