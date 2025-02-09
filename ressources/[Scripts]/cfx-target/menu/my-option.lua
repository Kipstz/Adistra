function _My()
    Action_Config = {
        My = {
            {
                Type = "buttom",
                IsRestricted = false,
                Blocked = false,
                CloseOnClick = false,
                Label = ("Mon ID : %s"):format(GetPlayerServerId(PlayerId())),
                OnClick = function()
                end,
            },
            {
                Type = "buttom",
                IsRestricted = false,
                Blocked = false,
                CloseOnClick = false,
                Label = ("Mon nom : %s"):format(GetPlayerName(PlayerId())),
                OnClick = function()
                end,
            },
            {
                Type = "buttom",
                IsRestricted = false,
                Blocked = false,
                CloseOnClick = false,
                Label = ("Endurance : %s"):format(GetPlayerStamina(PlayerId())),
                OnClick = function()
                end,
            },
            -- {
            --     Type = "buttom",
            --     IsRestricted = false,
            --     Blocked = false,
            --     CloseOnClick = true,
            --     Label = "Me (...)",
            --     OnClick = function()
            --         local imput = exports["cfx-target"]:ShowSync('Entrez un texte', false, 320., "small_text")
            --         local text = "* La personne ".. imput .." *"
            --         exports["ac"]:ExecuteServerEvent('3dme:shareDisplay', text)
            --     end,
            -- }, 
            {
                Type = "buttom-submenu",
                Label = "Action (Admin)",
                IsRestricted = true,
                CloseOnClick = true,
                Blocked = false,
                Action = {
                    {
                        'Menu Admin',
                        function()
                            ExecuteCommand("adminmenu")
                        end
                    },
                    {
                        'Menu Vetement',
                        function()
                            ExecuteCommand("skin")
                        end
                    },
                    {
                        'Réanimer',
                        function()
                            ExecuteCommand("rea")
                        end
                    },
                    {
                        'Soigner',
                        function()
                            ExecuteCommand("heal")
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
        },
    }   
end




