function _Player()
    Action_Config = {
        Player = {
            {
                Type = "buttom",
                IsRestricted = false,
                Blocked = false,
                CloseOnClick = true,
                Label = "ID : "..GetPlayerIdFromPed(LastEntityHit) or "Inconnu",
                OnClick = function()
                end,
            },
            {
                Type = "buttom-submenu",
                Label = "Action (Admin)",
                IsRestricted = true,
                CloseOnClick = true,
                Blocked = false,
                Action = {
                    {
                        'Menu Vetement',
                        function()
                            ExecuteCommand("skin " ..GetPlayerIdFromPed(LastEntityHit))
                        end
                    },
                    {
                        'Réanimer',
                        function()
                            ExecuteCommand("rea " ..GetPlayerIdFromPed(LastEntityHit))
                        end
                    },
                    {
                        'Soigner',
                        function()
                            ExecuteCommand("heal " ..GetPlayerIdFromPed(LastEntityHit))
                        end
                    },
                    {
                        'TP A Moi',
                        function()
                            ExecuteCommand("bring " ..GetPlayerIdFromPed(LastEntityHit))
                        end
                    },
                    {
                        'TP A Lui',
                        function()
                            ExecuteCommand("goto " ..GetPlayerIdFromPed(LastEntityHit))
                        end
                    },
                    {
                        'GoBack',
                        function()
                            ExecuteCommand("goback " ..GetPlayerIdFromPed(LastEntityHit))
                        end
                    },
                    {
                        'UnJail',
                        function()
                            ExecuteCommand("unjail " ..GetPlayerIdFromPed(LastEntityHit))
                        end
                    },
                },
            }, 
        }
    }
end