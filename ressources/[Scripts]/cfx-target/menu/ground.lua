function _Ground()
    Action_Config = {
        Ground = {
            {
                Type = "buttom",
                IsRestricted = true,
                Blocked = true,
                CloseOnClick = true,
                Label = "Vous téléporter ici",
                OnClick = function()
                    SetMinimapComponentPosition(LastCoordsHit())
                    ExecuteCommand("tpm")
                end,
            },
            {
                Type = "buttom",
                IsRestricted = true,
                Blocked = true,
                CloseOnClick = true,
                Label = "Posé un véhicule",
                OnClick = function()
                    veh_model = exports["cfx-target"]:ShowSync('model', false, 320, "small_text")
                    if IsModelValid(veh_model) then
                        RequestModel(veh_model)
                        while not HasModelLoaded(veh_model) do
                            Wait(0)
                        end
                        veh = CreateVehicle(veh_model, LastCoordsHit, GetEntityHeading(PlayerPedId()), true, true)
                        SetEntityAsMissionEntity(veh, true, true)
                        SetVehicleOnGroundProperly(veh)
                        SetModelAsNoLongerNeeded(veh_model)
                    end
                end,
            },
        },
    }
end