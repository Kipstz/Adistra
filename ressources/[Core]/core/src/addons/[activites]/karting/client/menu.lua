
kartingManagement = {
    isInActivity = false,
    myKart = nil,
    myVehicles = {}
}

local MainMenuKarting = RageUI.CreateMenu("", "Karting", 8, 200)

local open = false

MainMenuKarting.Closed = function()
    open = false
end

function OpenMainMenuKarting()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(MainMenuKarting, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(MainMenuKarting, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(MainMenuKarting, true, true, true, function()

                    if not kartingManagement.isInActivity then 

                        RageUI.ButtonWithStyle("Commencer l'activité (15 minutes)", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                kartingManagement.isInActivity = true
                                Framework.Game.SpawnVehicle("veto2", vector3(-163.36437988281, -2141.1254882812, 16.704879760742), 200.3645935058, function(vehicle)
                                    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                    SetVehicleNumberPlateText(vehicle, "KART") 
                                    kartingManagement.myKart = vehicle
                                    table.insert(kartingManagement.myVehicles, {
                                        deleteTime = GetGameTimer() + 15 * 60 * 1000,
                                        entity = vehicle,
                                        spawnedCoords = GetEntityCoords(vehicle),
                                    })
                                end)
                                RageUI.CloseAll()
                            end
                        end)
                    else
                        RageUI.ButtonWithStyle("Terminer l'activité", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                kartingManagement.isInActivity = false
                                ForceDeleteEntity(kartingManagement.myKart)
                            end
                        end)
                    end

                end)
            end
        end)
    end
end