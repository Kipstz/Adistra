Assurances.AssuranceMenu = RageUI.CreateMenu(Config["assurances"].MenuTitle.AssuranceMenu, Config["assurances"].MenuSubTitle.AssuranceMenu, 8, 200)

Assurances.SelectedMenu = RageUI.CreateSubMenu(Assurances.AssuranceMenu, Config["assurances"].MenuTitle.SelectedMenu, Config["assurances"].MenuSubTitle.SelectedMenu, 8, 200)
Assurances.newContratMenu = RageUI.CreateSubMenu(Assurances.SelectedMenu, Config["assurances"].MenuTitle.newContratMenu, Config["assurances"].MenuSubTitle.newContratMenu, 8, 200)

local open = false

Assurances.AssuranceMenu.Closed = function()
    open = false
end

function Assurances:OpenMenu(type, spawn)
    if open then
        RageUI.CloseAll()
        RageUI.Visible(Assurances.AssuranceMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(Assurances.AssuranceMenu, true)
        open = true

        Assurances.selectedCat = {}

        if type == 'car' then
            Assurances.ownedCars = {}

            Framework.TriggerServerCallback('assurances:getOwneds', function(myCars)
                Assurances.ownedCars = myCars
                Assurances.selectedCat = Assurances.ownedCars
            end, 'car')
        elseif type == 'boat' then
            Assurances.ownedBoats = {}

            Framework.TriggerServerCallback('assurances:getOwneds', function(myBoats) 
                Assurances.ownedBoats = myBoats
                Assurances.selectedCat = Assurances.ownedBoats
            end, 'boat')
        elseif type == 'aircraft' then
            Assurances.ownedAircrafts = {}

            Framework.TriggerServerCallback('assurances:getOwneds', function(myAircrafts) 
                Assurances.ownedAircrafts = myAircrafts
                Assurances.selectedCat = Assurances.ownedAircrafts
            end, 'aircraft')
        end

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(Assurances.AssuranceMenu, true, true, true, function()

                    if next(Assurances.selectedCat) then
                        for k,v in pairs(Assurances.selectedCat) do
                            RageUI.ButtonWithStyle("[~b~"..v.plate.."~s~] - "..v.label, nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    Assurances.selectedVehicle = {
                                        characterId = v.characterId,
                                        vehicle = v.vehicle, 
                                        state = v.state, 
                                        label = v.label or "Mon véhicule",
                                        plate = v.plate, 
                                        type = v.type,
                                        assurance = v.assurance
                                    }
                                end
                            end, Assurances.SelectedMenu)
                        end
                    else
                        RageUI.ButtonWithStyle("~r~Vous n'avez pas de véhicules à assurer.", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        end)
                    end

                end)

                RageUI.IsVisible(Assurances.SelectedMenu, true, true, true, function()

                    RageUI.Separator("↓ Informations ↓")

                    RageUI.ButtonWithStyle("Nom: ~g~"..Assurances.selectedVehicle.label, nil, {}, true, function(Hovered, Active, Selected) end)

                    RageUI.ButtonWithStyle("Plaque: ~b~"..Assurances.selectedVehicle.plate, nil, {}, true, function(Hovered, Active, Selected) end)

                    if not Assurances.selectedVehicle.state then
                        RageUI.ButtonWithStyle("Statut: ~r~Sortie~s~", nil, {}, true, function(Hovered, Active, Selected) end)
                    else
                        RageUI.ButtonWithStyle("Statut: ~g~Dans le garage", nil, {}, true, function(Hovered, Active, Selected) end)
                    end
                        
                    if Assurances.selectedVehicle.assurance ~= nil then
                        RageUI.ButtonWithStyle("Type de contrat: "..Assurances:convertName(Assurances.selectedVehicle.assurance), nil, {}, true, function(Hovered, Active, Selected) end)

                        RageUI.Separator("↓ Actions ↓")

                        RageUI.ButtonWithStyle("Souscrire un nouveau contrat", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        end, Assurances.newContratMenu)

                        if not Assurances.selectedVehicle.state then
                            RageUI.ButtonWithStyle("Demander le véhicule", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                                if Selected then
                                    Assurances:claimVehicle(Assurances.selectedVehicle.assurance, Assurances.selectedVehicle, spawn)
                                end
                            end)
                        else
                            RageUI.ButtonWithStyle("Demander le véhicule", "~r~Vous ne pouvez pas demander un véhicule rentré.", { RightLabel = "→" }, false, function(Hovered, Active, Selected)
                            end)
                        end
                    else
                        RageUI.Separator("↓ Actions ↓")

                        RageUI.ButtonWithStyle("Souscrire un contrat", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        end, Assurances.newContratMenu)

                        RageUI.ButtonWithStyle("Demander le véhicule", "~r~Vous devez d'abord souscrire un contrat.", { RightLabel = "→" }, false, function(Hovered, Active, Selected)
                        end)
                    end
                end)

                RageUI.IsVisible(Assurances.newContratMenu, true, true, true, function()

                    RageUI.Line()

                    for k,v in pairs(Config['assurances'].contrats) do
                        RageUI.ButtonWithStyle(v.name, v.desc, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                if k ~= Assurances.selectedVehicle.assurance then
                                    Assurances:setNewContrat(k, Assurances.selectedVehicle.plate)
                                    RageUI.CloseAll()
                                    open = false
                                else
                                    Framework.ShowNotification("~r~Vous avez déjà ce contrat !")
                                end
                            end
                        end)
                    end

                end)
            end
        end)
    end
end