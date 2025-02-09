
Boutique.MainMenu = RageUI.CreateMenu("Boutique", "Bienvenue sur notre Boutique !", 8, 200)

Boutique.ItemsMenu = RageUI.CreateSubMenu(Boutique.MainMenu, "Boutique", "Véhicules Disponibles:", 8, 200)
Boutique.AutresMenu = RageUI.CreateSubMenu(Boutique.MainMenu, "Boutique", "~b~Boutique En Ligne", 8, 200)
Boutique.CaissesMenu = RageUI.CreateSubMenu(Boutique.MainMenu, "Boutique", "Caisses Disponibles:", 8, 200)
Boutique.CaisseSelected = RageUI.CreateSubMenu(Boutique.CaissesMenu, "Boutique", "Caisse", 8, 200)

local open = false

Boutique.MainMenu.Closed = function()
    open = false
    Boutique:destroyShow()
end

Boutique.ItemsMenu.Closed = function()
    Boutique:destroyShow2()
end

function Boutique:OpenBoutique()
    Boutique.categorySelected = ''
    Boutique.caisseSelected = {}
    
    if open then
        RageUI.CloseAll()
        RageUI.Visible(Boutique.MainMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(Boutique.MainMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(Boutique.MainMenu, true, true, true, function()
                    RageUI.Separator("Vos Coins: ~p~"..Boutique:getCoins())

                    for k,v in pairs(Config['boutique'].Categories) do
                        RageUI.ButtonWithStyle(v.label, v.description,  { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                if Boutique.myLastCoords == nil then
                                    Boutique:setLastCoords(GetEntityCoords(PlayerPedId()))
                                end
                                
                                Boutique.categorySelected = v.name

                                if v.name == 'cars' then
                                    Framework.ShowNotification("Chargement des véhicules ...")
                                    for k,v in pairs(Config['boutique'].Items['cars']) do
                                        RequestModel(GetHashKey(v.model))
                                        if not HasModelLoaded(GetHashKey(v.model)) then
                                            Wait(100)
                                        end
                                    end
                                end
                            end
                        end, Boutique.ItemsMenu)
                    end

                    RageUI.ButtonWithStyle("~b~Boutique En Ligne", nil,  { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end, Boutique.AutresMenu)

                    RageUI.ButtonWithStyle("Caisses", nil,  { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end, Boutique.CaissesMenu)
                end)

                RageUI.IsVisible(Boutique.ItemsMenu, true, true, true, function()

                    for k,v in pairs(Config['boutique'].Items[Boutique.categorySelected]) do
                        RageUI.ButtonWithStyle(v.label, "Acheter →", { RightLabel = "~p~"..v.price.." Coins" }, true, function(Hovered, Active, Selected)
                            if Active then
                                Boutique:spawnItem(v.model, Boutique.categorySelected, v.price)
                            end

                            if Selected then
                                if Boutique.itemLoaded then
                                    if not Boutique.inTimeout then
                                        if Boutique.myCoins >= v.price then
                                            if Boutique.categorySelected == 'cars' then
                                                local newPlate = Concess:GeneratePlate()
                                                SetVehicleNumberPlateText(Boutique.vehicleSpawn, newPlate)
                                                Boutique.vehicleSpawnProps.plate = newPlate
        
                                                exports["ac"]:ExecuteServerEvent('boutique:achat', v, Boutique.categorySelected, { plate = newPlate, vehicle = Boutique.vehicleSpawnProps })
                                                Boutique:setTimeout(15000)
                                            elseif Boutique.categorySelected == 'armes_assaults' or 'armes_pistols' or 'armes_snipers' or 'armes_pompes' or 'armes_meles' then
                                                exports["ac"]:ExecuteServerEvent('boutique:achat', v, Boutique.categorySelected, {})
                                            end
                                        else
                                            Framework.ShowNotification("~r~Vous n'avez pas assez de Coins !")
                                        end
                                    else
                                        Framework.ShowNotification("~r~Veuillez patienter quelques secondes avant un nouvel achat !")
                                    end
                                else
                                    Framework.ShowNotification("~r~Veuillez patienter que le véhicule charge !")
                                end
                            end
                        end)
                    end
                end)

                RageUI.IsVisible(Boutique.AutresMenu, true, true, true, function()
                    RageUI.ButtonWithStyle("Tebex", "https://adistrarp-webstore.tebex.io/",  { RightLabel = "" }, true, function(Hovered, Active, Selected)
                    end)
                end)

                RageUI.IsVisible(Boutique.CaissesMenu, true, true, true, function()

                    for k,v in pairs(Config['boutique'].Caisses) do
                        RageUI.ButtonWithStyle(v.label, nil,  { RightLabel = "~p~Visualiser →~s~" }, true, function(Hovered, Active, Selected)
                            if (Active) then 
                                RenderSprite("Adistra", v.img, 0, 470, 430, 200, 100)
                            end
                            if Selected then
                                Boutique.caisseSelected = v;
                            end
                        end, Boutique.CaisseSelected)
                    end
                end)

                RageUI.IsVisible(Boutique.CaisseSelected, true, true, true, function()
                    if Boutique.caisseSelected ~= nil then
                        RageUI.Separator("↓ ~p~Informations~s~ ↓")

                        RageUI.ButtonWithStyle(Boutique.caisseSelected.label, nil,  { RightLabel = "" }, true, function(Hovered, Active, Selected)
                        end)
    
                        RageUI.ButtonWithStyle("Prix", nil,  { RightLabel = "~p~"..Boutique.caisseSelected.price.." Coins~s~" }, true, function(Hovered, Active, Selected)
                        end)

                        RageUI.ButtonWithStyle("Informations", Boutique.caisseSelected.infos,  { RightLabel = "" }, true, function(Hovered, Active, Selected)
                        end)
    
                        RageUI.Separator("↓ ~p~Actions~s~ ↓")

                        RageUI.ButtonWithStyle("Acheter", nil,  { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then 
                                if Boutique.myCoins >= Boutique.caisseSelected.price then
                                    Boutique:caisse(Boutique.caisseSelected)
                                else
                                    Framework.ShowNotification("~r~Vous n'avez pas assez de Coins !")
                                end
                            end
                        end)
                    end
                end)

            end
        end)
    end
end