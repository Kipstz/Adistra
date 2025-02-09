function _Vehicule()
    Action_Config = {
        Vehicule = {
            -- {
            --     Type = "buttom",
            --     Label = ("Nom du véhicule : %s"):format(GetDisplayNameFromVehicleModel(GetEntityModel(LastEntityHit))),
            --     IsRestricted = false,
            --     CloseOnClick = true,
            --     Blocked = false,
            --     OnClick = function() 
            --     end,
            -- },
            {
                Type = "buttom",
                Label = ("ID du véhicule : %s"):format(LastEntityHit),
                IsRestricted = false,
                CloseOnClick = true,
                Blocked = false,
                OnClick = function() 
                end,
            },
            {
                Type = "buttom",
                Label = ("Plaque du véhicule : %s"):format(GetVehicleNumberPlateText(LastEntityHit)),
                IsRestricted = false,
                CloseOnClick = true,
                Blocked = false,
                OnClick = function() 
                end,
            },
            {
                Type = "buttom-submenu",
                Label = "Portes",
                IsRestricted = false,
                CloseOnClick = false,
                Blocked = false,
                Action = {
                    {
                        'Avant Gauche',
                        function()
                            dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(LastEntityHit))
                            if dist < 3 then
                                if GetVehicleDoorAngleRatio(LastEntityHit, 0) == 0 then
                                    SetVehicleDoorOpen(LastEntityHit, 0, false, false)
                                else
                                    SetVehicleDoorShut(LastEntityHit, 0, false)
                                end
                            end
                        end
                    },
                    {
                        'Avant Droite',
                        function()
                            dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(LastEntityHit))
                            if dist < 3 then
                                if GetVehicleDoorAngleRatio(LastEntityHit, 1) == 0 then
                                    SetVehicleDoorOpen(LastEntityHit, 1, false, false)
                                else
                                    SetVehicleDoorShut(LastEntityHit, 1, false)
                                end
                            end
                        end
                    },
                    {
                        'Arrière Gauche',
                        function()
                            dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(LastEntityHit))
                            if dist < 3 then
                                if GetVehicleDoorAngleRatio(LastEntityHit, 2) == 0 then
                                    SetVehicleDoorOpen(LastEntityHit, 2, false, false)
                                else
                                    SetVehicleDoorShut(LastEntityHit, 2, false)
                                end
                            end
                        end
                    },
                    {
                        'Arrière Droite',
                        function()
                            dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(LastEntityHit))
                            if dist < 3 then
                                if GetVehicleDoorAngleRatio(LastEntityHit, 3) == 0 then
                                    SetVehicleDoorOpen(LastEntityHit, 3, false, false)
                                else
                                    SetVehicleDoorShut(LastEntityHit, 3, false)
                                end
                            end
                        end
                    },
                    {
                        'Capot',
                        function()
                            dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(LastEntityHit))
                            if dist < 3 then
                                if GetVehicleDoorAngleRatio(LastEntityHit, 4) == 0 then
                                    SetVehicleDoorOpen(LastEntityHit, 4, false, false)
                                else
                                    SetVehicleDoorShut(LastEntityHit, 4, false)
                                end
                            end
                        end
                    },
                    {
                        'Coffre',
                        function()
                            dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(LastEntityHit))
                            if dist < 3 then
                                if GetVehicleDoorAngleRatio(LastEntityHit, 5) == 0 then
                                    SetVehicleDoorOpen(LastEntityHit, 5, false, false)
                                else
                                    SetVehicleDoorShut(LastEntityHit, 5, false)
                                end
                            end
                        end
                    },
                },
            },          
            {
                Type = "buttom-submenu",
                Label = "Action (Admin)",
                IsRestricted = true,
                CloseOnClick = false,
                Blocked = false,
                Action = {
                    {
                        'Supprimer',
                        function()
                            DeleteEntity(LastEntityHit)
                        end
                    },
                    {
                        'Réparer',
                        function()
                            SetVehicleFixed(LastEntityHit)
                        end
                    },
                    {
                        'Déplacé',
                        function()
                            Target:MouveEntity(LastEntityHit)
                        end
                    },
                    {
                        'Rendre immobile',
                        function()
                            FreezeEntityPosition(LastEntityHit, true)
                        end
                    },
                    {
                        'Rendre mobile',
                        function()
                            FreezeEntityPosition(LastEntityHit, false)
                        end
                    },
                    {
                        'Retourner le véhicule 180°',
                        function()
                            SetEntityHeading(LastEntityHit, GetEntityHeading(LastEntityHit) + 180)
                        end
                    },
                },
            },     
            {
                Type = "buttom-submenu",
                Label = "Motifs (Admin)",
                IsRestricted = true,
                CloseOnClick = false,
                Blocked = false,
                Action = {
                    {
                        'Mettre Motif 1',
                        function()
                            ExecuteCommand("setliveryveh 0")
                        end
                    },
                    {
                        'Mettre Motif 2',
                        function()
                            ExecuteCommand("setliveryveh 1")
                        end
                    },
                    {
                        'Mettre Motif 3',
                        function()
                            ExecuteCommand("setliveryveh 2")
                        end
                    },
                    {
                        'Mettre Motif 4',
                        function()
                            ExecuteCommand("setliveryveh 3")
                        end
                    },
                    {
                        'Mettre Motif 5',
                        function()
                            ExecuteCommand("setliveryveh 5")
                        end
                    },
                },
            },     
        }, 
    }
end


