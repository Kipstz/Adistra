
Characters.SelectorMenu = RageUI.CreateMenu(Config["Characters"].MenuTitle.SelectorMenu, Config["Characters"].MenuSubTitle.SelectorMenu, 8, 200)

SelectorMenuIsOpen = false
freecamAutorization = false

Characters.SelectorMenu.Closed = function()
    SelectorMenuIsOpen = false

    local maxAllowedDistance = 50.0
    Citizen.CreateThread(function()
        while(false) do
            Citizen.Wait(5000)

            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local cameraCoords = GetFinalRenderedCamCoord()

            local distance = #(playerCoords - cameraCoords)

            --[[
            if(IsPedInAnyVehicle(playerPed, false)) then
                local vehicle = GetVehiclePedIsIn(playerPed, false)
                if(IsThisModelAHeli(GetEntityModel(vehicle)) or IsThisModelAPlane(GetEntityModel(vehicle))) then
                    maxAllowedDistance = 500.0
                else
                    maxAllowedDistance = 200.0
                end
            else
                maxAllowedDistance = 50.0
            end]]

            DisableIdleCamera(true)
            if(not IsPedInAnyVehicle(playerPed, false)) then
                if(not freecamAutorization and not SelectorMenuIsOpen and not CreatorMenuIsOpen and not SceneFinal and not SceneStart and not ClotheShopMenuIsOpen and not BarberShopMenuIsOpen and not SkinchangerMenuIsOpen and not AmbJob_isDead and not HideInTrunk.inTrunk and not IsPedRagdoll(playerPed)) then
                    if(distance > maxAllowedDistance) then
                        TriggerServerEvent('selector:banFreecam', playerCoords, distance)
                    end
                end
            end
        end
    end)
end

function Characters:OpenSelectorMenu(characters)
    if SelectorMenuIsOpen then
        RageUI.CloseAll()
        RageUI.Visible(Characters.SelectorMenu, false)
        SelectorMenuIsOpen = false
    else
        RageUI.CloseAll()
        RageUI.Visible(Characters.SelectorMenu, true)
        SelectorMenuIsOpen = true

        Characters.SelectorMenu.Closable = false

        local nb = 0

        for k,v in pairs(characters) do
            if v.identity ~= nil then
                nb = nb + 1
            end
        end

        CreateThread(function()
            while SelectorMenuIsOpen do
                Wait(1)

                RageUI.IsVisible(Characters.SelectorMenu, true, true, true, function()

                    for k,v in pairs(characters) do
                        if v.identity ~= nil then
                            local desc = "Nom: ~b~"..v.identity.lastname.."~s~~n~Prénom: ~b~"..v.identity.firstname.."~s~~n~Date de Naissance: ~b~"..v.identity.dateofbirth.."~s~~n~Taille: ~b~"..v.identity.height.."~s~~n~Sexe: ~b~"..v.identity.sex
                            RageUI.ButtonWithStyle("Personnage n°~b~"..k.."~s~", desc, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    TriggerServerEvent('characters:selectedCharacter', v)
    
                                    Framework.TriggerServerCallback('skinchanger:getPlayerSkin', function(skin, jobSkin)
                                        if skin == nil then
                                            TriggerEvent('skinchanger:loadSkin', {sex = 0})
                                        else
                                            TriggerEvent('skinchanger:loadSkin', skin)
                                        end
                                    end)
    
                                    RageUI.CloseAll()
                                end
                            end)
                        end
                    end
                    
                    if nb == 0 then
                        RageUI.ButtonWithStyle("Créer un Nouveau Personnage", desc, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                TriggerServerEvent('characters:createCharacter')
                            end
                        end)
                    end
                end)
            end
        end)
    end
end