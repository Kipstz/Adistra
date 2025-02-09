
VigneronJob.SellMenu = RageUI.CreateMenu("Vigneron", "~p~Vigneron~s~: Vente", 8, 200)

local open = false

VigneronJob.SellMenu.Closed = function()
    open = false
end

VigneronJob.OpenSellMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(VigneronJob.SellMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(VigneronJob.SellMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(VigneronJob.SellMenu, true, true, true, function()
                    for k,v in pairs(Config['job_vigneron'].itemsSell) do
                        RageUI.ButtonWithStyle(v.label, "[~r~E~s~] pour arrêter", { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                VigneronJob.startSell(v.need, v.msg)
                            end
                        end)
                    end
                end)
            end
        end)
    end
end

VigneronJob.startSell = function(need, msg)
    if not VigneronJob.inSell then
        VigneronJob.inSell = true

        exports["ac"]:ExecuteServerEvent('VigneronJob:startSell', need)
        VigneronJob:progress(msg)
    end
end

RegisterNetEvent('VigneronJob:stopSell')
AddEventHandler('VigneronJob:stopSell', function()
    VigneronJob.inSell = false
    FreezeEntityPosition(PlayerPedId(), false)
end)