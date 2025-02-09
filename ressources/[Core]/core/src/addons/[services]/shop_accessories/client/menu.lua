AccessoriesShop.Main = RageUI.CreateMenu(Config["shop_accessories"].MenuTitle.MainMenu, Config["shop_accessories"].MenuSubTitle.MainMenu, 8, 200)

AccessoriesShop.MasquesMenu = RageUI.CreateSubMenu(AccessoriesShop.Main, Config["shop_accessories"].MenuTitle.MainMenu, Config["shop_accessories"].MenuSubTitle.MasquesMenu, 8, 200)
AccessoriesShop.ChapeauxMenu = RageUI.CreateSubMenu(AccessoriesShop.Main, Config["shop_accessories"].MenuTitle.MainMenu, Config["shop_accessories"].MenuSubTitle.MasquesMenu, 8, 200)
AccessoriesShop.LunettesMenu = RageUI.CreateSubMenu(AccessoriesShop.Main, Config["shop_accessories"].MenuTitle.MainMenu, Config["shop_accessories"].MenuSubTitle.LunettesMenu, 8, 200)
AccessoriesShop.MontresMenu = RageUI.CreateSubMenu(AccessoriesShop.Main, Config["shop_accessories"].MenuTitle.MainMenu, Config["shop_accessories"].MenuSubTitle.MontresMenu, 8, 200)
AccessoriesShop.BraceletsMenu = RageUI.CreateSubMenu(AccessoriesShop.Main, Config["shop_accessories"].MenuTitle.MainMenu, Config["shop_accessories"].MenuSubTitle.BraceletsMenu, 8, 200)

AccessoriesShop.Indexs = {
    mask_1 = 1,
    mask_2 = 1,
    helmet_1 = 1,
    helmet_2 = 1,
    glasses_1 = 1,
    glasses_2 = 1,
    watches_1 = 1,
    watches_2 = 1,
    bracelets_1 = 1,
    bracelets_2 = 1,
    gestion = 1
}

local open = false

AccessoriesShop.Main.Closed = function()
    open = false
    SkinChanger.ReloadSkinPlayer()
end

function AccessoriesShop:OpenMenu()
    AccessoriesShop.player_money = 0

    for i = 1, #Framework.PlayerData.accounts, 1 do
		if Framework.PlayerData.accounts[i].name == 'money' then
			AccessoriesShop.player_money = Framework.PlayerData.accounts[i].money
		end
    end

    Masques = {}
    Masques2 = {}
    Chapeaux = {}
    Chapeaux2 = {}
    Lunettes = {}
    Lunettes2 = {}
    Montre = {}
    Montre2 = {}
    Bracelets = {}
    Bracelets2 = {}

    for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 1) - 2 do
        table.insert(Masques, i)
    end

    for i = 0, GetNumberOfPedPropDrawableVariations(PlayerPedId(), 0) - 1 do
        table.insert(Chapeaux, i)
    end

    for i = 0, GetNumberOfPedPropDrawableVariations(PlayerPedId(), 1) - 1 do
        table.insert(Lunettes, i)
    end

    for i = 0, GetNumberOfPedPropDrawableVariations(PlayerPedId(), 7)-2 do
        table.insert(Montre, i)
    end

    for i = 0, GetNumberOfPedPropDrawableVariations(PlayerPedId(), 6)-2 do
        table.insert(Bracelets, i)
    end

    if open then
        RageUI.CloseAll()
        RageUI.Visible(AccessoriesShop.Main, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(AccessoriesShop.Main, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(AccessoriesShop.Main, true, true, true, function()

                    RageUI.ButtonWithStyle("Masques", nil, { RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    end, AccessoriesShop.MasquesMenu)

                    RageUI.ButtonWithStyle("Chapeaux", nil, { RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    end, AccessoriesShop.ChapeauxMenu)

                    RageUI.ButtonWithStyle("Lunettes", nil, { RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    end, AccessoriesShop.LunettesMenu)

                    RageUI.ButtonWithStyle("Montres", nil, { RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    end, AccessoriesShop.MontresMenu)

                    RageUI.ButtonWithStyle("Bracelets", nil, { RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    end, AccessoriesShop.BraceletsMenu)

                end)

                RageUI.IsVisible(AccessoriesShop.MasquesMenu, true, true, true, function()

                    RageUI.List("Masque 1", Masques, AccessoriesShop.Indexs.mask_1, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            local number = tonumber(VisualManager:KeyboardOutput("Numéro du masque", "", 3))
                            if number then
                                AccessoriesShop.Indexs.mask_1 = number
                                TriggerEvent('skinchanger:change', 'mask_1', number-1)
                                Framework.ShowNotification("~g~Masque changé pour : "..number)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                            end
                        end
                    end, function(Index)
                        AccessoriesShop.Indexs.mask_1 = Index
                        Masques2 = {}

                        SkinChanger.zoomOffset = 0.75
                        SkinChanger.camOffset = 0.0

                        TriggerEvent('skinchanger:change', 'mask_1', Index-1) 
                        TriggerEvent('skinchanger:change', 'mask_2', 0) 

                        for i = 0, GetNumberOfPedTextureVariations(PlayerPedId(), 1, Index-1)-1 do
                            table.insert(Masques2, i)
                        end
                    end)

                    if next(Masques2) then
                        RageUI.List("Masque 2", Masques2, AccessoriesShop.Indexs.mask_2, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                            if Selected then
                                local number = tonumber(VisualManager:KeyboardOutput("Numéro de la variante", "", 3))
                                if number then
                                    AccessoriesShop.Indexs.mask_2 = number
                                    TriggerEvent('skinchanger:change', 'mask_2', number-1)
                                    Framework.ShowNotification("~g~Variante changée pour : "..number)
                                else
                                    Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                                end
                            end
                        end, function(Index)
                            AccessoriesShop.Indexs.mask_2 = Index
    
                            TriggerEvent('skinchanger:change', 'mask_2', Index-1) 
                        end)
                    end

                    RageUI.Line()

                    RageUI.ButtonWithStyle("~g~Acheter l'accessoire", nil, { RightLabel = "~p~700$"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            if AccessoriesShop.player_money > 149 then
                                local NomAccessorie = VisualManager:KeyboardOutput("Quel nom voulez-vous donner ?", "", 25)

                                if tostring(NomAccessorie) then
                                    exports["ac"]:ExecuteServerEvent('shop_accessories:buy', NomAccessorie, 'mask', (AccessoriesShop.Indexs.mask_1 - 1), (AccessoriesShop.Indexs.mask_2 - 1))
                                
                                    SkinChanger.DeleteSkinCam()

                                    RageUI.GoBack()
                                else
                                    Framework.ShowNotification("~r~Veuillez saisir un Nom Valide !")
                                end
                            else
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

                RageUI.IsVisible(AccessoriesShop.ChapeauxMenu, true, true, true, function()

                    RageUI.List("Chapeau 1", Chapeaux, AccessoriesShop.Indexs.helmet_1, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            local number = tonumber(VisualManager:KeyboardOutput("Numéro du chapeau", "", 3))
                            if number then
                                AccessoriesShop.Indexs.helmet_1 = number
                                TriggerEvent('skinchanger:change', 'helmet_1', number-1)
                                Framework.ShowNotification("~g~Chapeau changé pour : "..number)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                            end
                        end
                    end, function(Index)
                        AccessoriesShop.Indexs.helmet_1 = Index
                        Chapeaux2 = {}

                        SkinChanger.zoomOffset = 0.75
                        SkinChanger.camOffset = 0.0

                        TriggerEvent('skinchanger:change', 'helmet_1', Index-1) 
                        TriggerEvent('skinchanger:change', 'helmet_2', 0) 

                        for i = 0, GetNumberOfPedPropTextureVariations(PlayerPedId(), 0, Index - 1)-1 do
                            table.insert(Chapeaux2, i)
                        end
                    end)

                    if next(Chapeaux2) then
                        RageUI.List("Chapeau 2", Chapeaux2, AccessoriesShop.Indexs.helmet_2, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                            if Selected then
                                local number = tonumber(VisualManager:KeyboardOutput("Numéro de la variante", "", 3))
                                if number then
                                    AccessoriesShop.Indexs.helmet_2 = number
                                    TriggerEvent('skinchanger:change', 'helmet_2', number-1)
                                    Framework.ShowNotification("~g~Variante changée pour : "..number)
                                else
                                    Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                                end
                            end
                        end, function(Index)
                            AccessoriesShop.Indexs.helmet_2 = Index
    
                            TriggerEvent('skinchanger:change', 'helmet_2', Index-1) 

                        end)
                    end

                    RageUI.Line()

                    RageUI.ButtonWithStyle("~g~Acheter l'accessoire", nil, { RightLabel = "~p~700$"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            if AccessoriesShop.player_money > 149 then
                                local NomAccessorie = VisualManager:KeyboardOutput("Quel nom voulez-vous donner ?", "", 25)

                                if tostring(NomAccessorie) then
                                    exports["ac"]:ExecuteServerEvent('shop_accessories:buy', NomAccessorie, 'helmet', (AccessoriesShop.Indexs.helmet_1 - 1), (AccessoriesShop.Indexs.helmet_2 - 1))
                                
                                    SkinChanger.DeleteSkinCam()

                                    RageUI.GoBack()
                                else
                                    Framework.ShowNotification("~r~Veuillez saisir un Nom Valide !")
                                end
                            else
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

                RageUI.IsVisible(AccessoriesShop.LunettesMenu, true, true, true, function()

                    RageUI.List("Lunettes 1", Lunettes, AccessoriesShop.Indexs.glasses_1, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            local number = tonumber(VisualManager:KeyboardOutput("Numéro des lunettes", "", 3))
                            if number then
                                AccessoriesShop.Indexs.glasses_1 = number
                                TriggerEvent('skinchanger:change', 'glasses_1', number-1)
                                Framework.ShowNotification("~g~Lunettes changées pour : "..number)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                            end
                        end
                    end, function(Index)
                        AccessoriesShop.Indexs.glasses_1 = Index
                        Lunettes2 = {}

                        SkinChanger.zoomOffset = 0.75
                        SkinChanger.camOffset = 0.0

                        TriggerEvent('skinchanger:change', 'glasses_1', Index-1) 
                        TriggerEvent('skinchanger:change', 'glasses_2', 0) 

                        for i = 0, GetNumberOfPedPropTextureVariations(PlayerPedId(), 1, Index-1)-1 do
                            table.insert(Lunettes2, i)
                        end
                    end)
                    if next(Lunettes2) then
                        RageUI.List("Lunettes 2", Lunettes2, AccessoriesShop.Indexs.glasses_2, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                            if Selected then
                                local number = tonumber(VisualManager:KeyboardOutput("Numéro de la variante", "", 3))
                                if number then
                                    AccessoriesShop.Indexs.glasses_2 = number
                                    TriggerEvent('skinchanger:change', 'glasses_2', number-1)
                                    Framework.ShowNotification("~g~Variante changée pour : "..number)
                                else
                                    Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                                end
                            end
                        end, function(Index)
                            AccessoriesShop.Indexs.glasses_2 = Index
                            TriggerEvent('skinchanger:change', 'glasses_2', Index-1) 
                        end)
                    end

                    RageUI.Line()

                    RageUI.ButtonWithStyle("~g~Acheter l'accessoire", nil, { RightLabel = "~p~700$"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            if AccessoriesShop.player_money > 149 then
                                local NomAccessorie = VisualManager:KeyboardOutput("Quel nom voulez-vous donner ?", "", 25)

                                if tostring(NomAccessorie) then
                                    exports["ac"]:ExecuteServerEvent('shop_accessories:buy', NomAccessorie, 'glasses', (AccessoriesShop.Indexs.glasses_1 - 1), (AccessoriesShop.Indexs.glasses_2 - 1))
                                
                                    SkinChanger.DeleteSkinCam()

                                    RageUI.GoBack()
                                else
                                    Framework.ShowNotification("~r~Veuillez saisir un Nom Valide !")
                                end
                            else
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

                RageUI.IsVisible(AccessoriesShop.MontresMenu, true, true, true, function()

                    RageUI.List("Montre 1", Montre, AccessoriesShop.Indexs.watches_1, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            local number = tonumber(VisualManager:KeyboardOutput("Numéro de la montre", "", 3))
                            if number then
                                AccessoriesShop.Indexs.watches_1 = number
                                TriggerEvent('skinchanger:change', 'watches_1', number-1)
                                Framework.ShowNotification("~g~Montre changée pour : "..number)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                            end
                        end
                    end, function(Index)
                        AccessoriesShop.Indexs.watches_1 = Index
                        Montre2 = {}
    
                        SkinChanger.zoomOffset = 0.75
                        SkinChanger.camOffset = 0.15
    
                        TriggerEvent('skinchanger:change', 'watches_1', Index-1) 
                        TriggerEvent('skinchanger:change', 'watches_2', 0) 
    
                        for i = 0, GetNumberOfPedTextureVariations(PlayerPedId(), 10, Index-1)-1 do
                            table.insert(Montre2, i)
                        end
                    end)
    
                    if next(Montre2) then
                        RageUI.List("Montre 2", Montre2, AccessoriesShop.Indexs.watches_2, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                            if Selected then
                                local number = tonumber(VisualManager:KeyboardOutput("Numéro de la variante", "", 3))
                                if number then
                                    AccessoriesShop.Indexs.watches_2 = number
                                    TriggerEvent('skinchanger:change', 'watches_2', number-1)
                                    Framework.ShowNotification("~g~Variante changée pour : "..number)
                                else
                                    Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                                end
                            end
                        end, function(Index)
                            AccessoriesShop.Indexs.watches_2 = Index
                            TriggerEvent('skinchanger:change', 'watches_2', Index-1) 
                        end)
                    end

                    RageUI.Line()

                    RageUI.ButtonWithStyle("~g~Acheter l'accessoire", nil, { RightLabel = "~p~700$"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            if AccessoriesShop.player_money > 149 then
                                local NomAccessorie = VisualManager:KeyboardOutput("Quel nom voulez-vous donner ?", "", 25)

                                if tostring(NomAccessorie) then
                                    exports["ac"]:ExecuteServerEvent('shop_accessories:buy', NomAccessorie, 'watches', (AccessoriesShop.Indexs.watches_1 - 1), (AccessoriesShop.Indexs.watches_2 - 1))
                                
                                    SkinChanger.DeleteSkinCam()

                                    RageUI.GoBack()
                                else
                                    Framework.ShowNotification("~r~Veuillez saisir un Nom Valide !")
                                end
                            else
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

                RageUI.IsVisible(AccessoriesShop.BraceletsMenu, true, true, true, function()
    
                    RageUI.List("Bracelets 1", Bracelets, AccessoriesShop.Indexs.bracelets_1, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                        if Selected then
                            local number = tonumber(VisualManager:KeyboardOutput("Numéro du bracelet", "", 3))
                            if number then
                                AccessoriesShop.Indexs.bracelets_1 = number
                                TriggerEvent('skinchanger:change', 'bracelets_1', number-1)
                                Framework.ShowNotification("~g~Bracelet changé pour : "..number)
                            else
                                Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                            end
                        end
                    end, function(Index)
                        AccessoriesShop.Indexs.bracelets_1 = Index
                        Bracelets2 = {}
    
                        SkinChanger.zoomOffset = 0.75
                        SkinChanger.camOffset = 0.15
    
                        TriggerEvent('skinchanger:change', 'bracelets_1', Index-1) 
                        TriggerEvent('skinchanger:change', 'bracelets_2', 0) 
    
                        for i = 0, GetNumberOfPedTextureVariations(PlayerPedId(), 10, Index-1)-1 do
                            table.insert(Bracelets2, i)
                        end
                    end)
    
                    if next(Bracelets2) then
                        RageUI.List("Bracelets 2", Bracelets2, AccessoriesShop.Indexs.bracelets_2, nil, { RightLabel = "" }, true, function(Hovered, Active, Selected, Index)
                            if Selected then
                                local number = tonumber(VisualManager:KeyboardOutput("Numéro de la variante", "", 3))
                                if number then
                                    AccessoriesShop.Indexs.bracelets_2 = number
                                    TriggerEvent('skinchanger:change', 'bracelets_2', number-1)
                                    Framework.ShowNotification("~g~Variante changée pour : "..number)
                                else
                                    Framework.ShowNotification("~r~Veuillez saisir un numéro valide !")
                                end
                            end
                        end, function(Index)
                            AccessoriesShop.Indexs.bracelets_2 = Index
                            TriggerEvent('skinchanger:change', 'bracelets_2', Index-1) 
                        end)
                    end

                    RageUI.Line()

                    RageUI.ButtonWithStyle("~g~Acheter l'accessoire", nil, { RightLabel = "~p~700$"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            if AccessoriesShop.player_money > 149 then
                                local NomAccessorie = VisualManager:KeyboardOutput("Quel nom voulez-vous donner ?", "", 25)

                                if tostring(NomAccessorie) then
                                    exports["ac"]:ExecuteServerEvent('shop_accessories:buy', NomAccessorie, 'bracelets', (AccessoriesShop.Indexs.bracelets_1 - 1), (AccessoriesShop.Indexs.bracelets_2 - 1))
                                
                                    SkinChanger.DeleteSkinCam()

                                    RageUI.GoBack()
                                else
                                    Framework.ShowNotification("~r~Veuillez saisir un Nom Valide !")
                                end
                            else
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
            end
        end)
    end
end