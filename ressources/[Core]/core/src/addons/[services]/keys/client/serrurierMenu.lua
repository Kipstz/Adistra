Serrurier.SerrurierMenu = RageUI.CreateMenu(Config["keys"].MenuTitle.SerrurierMenu, Config["keys"].MenuSubTitle.SerrurierMenu, 8, 200)

Serrurier.SelectedMenu = RageUI.CreateSubMenu(Serrurier.SerrurierMenu, Config["keys"].MenuTitle.SelectedMenu, Config["keys"].MenuSubTitle.SelectedMenu, 8, 200)

local open = false

Serrurier.SerrurierMenu.Closed = function()
    open = false
end

function Serrurier:OpenMenu()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(Serrurier.SerrurierMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(Serrurier.SerrurierMenu, true)
        open = true

        Serrurier.owneds = {}

        Framework.TriggerServerCallback('keys:getOwneds', function(myOwneds)
            Serrurier.owneds = myOwneds
        end)

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(Serrurier.SerrurierMenu, true, true, true, function()

                    for k,v in pairs(Serrurier.owneds) do
                        RageUI.ButtonWithStyle("[~b~"..v.plate.."~s~] - "..v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                Serrurier.selectedVehicle = {
                                    characterId = v.characterId,
                                    label = v.label or "Ma Voiture",
                                    plate = v.plate, 
                                }
                            end
                        end, Serrurier.SelectedMenu)
                    end

                end)

                RageUI.IsVisible(Serrurier.SelectedMenu, true, true, true, function()

                    RageUI.Separator("↓ Informations ↓")

                    RageUI.ButtonWithStyle("Nom: ~g~"..Serrurier.selectedVehicle.label, nil, {}, true, function(Hovered, Active, Selected) end)

                    RageUI.ButtonWithStyle("Plaque: ~b~"..Serrurier.selectedVehicle.plate, nil, {}, true, function(Hovered, Active, Selected) end)

                    RageUI.Separator("↓ Actions ↓")

                    RageUI.ButtonWithStyle("Faire les clés", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            exports["ac"]:ExecuteServerEvent('keys:buy_key', Serrurier.selectedVehicle)
                        end
                    end)
                end)
            end
        end)
    end
end