
VigneronJob.CraftMenu = RageUI.CreateMenu("Vigneron", "~p~Vigneron~s~: Craft", 8, 200)

local open = false

VigneronJob.CraftMenu.Closed = function()
    open = false
end

VigneronJob.OpenCraftMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(VigneronJob.CraftMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(VigneronJob.CraftMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(VigneronJob.CraftMenu, true, true, true, function()
                    for k,v in pairs(Config['job_vigneron'].itemsCraft) do
                        RageUI.ButtonWithStyle(v.label, "[~r~E~s~] pour arrêter", { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                VigneronJob.startCraft(v.need, v.name, v.msg)
                            end
                        end)
                    end
                end)
            end
        end)
    end
end

VigneronJob.startCraft = function(need, type, msg)
    VigneronJob.canNotif = true

    if not VigneronJob.inCraft then
        for k,v in pairs(Framework.PlayerData.inventory) do
            if v.name == need then
                if v.count > 0 then
                    VigneronJob.canNotif = false
                    VigneronJob.inCraft = true
    
                    exports["ac"]:ExecuteServerEvent('VigneronJob:startCraft', need, type)
                    VigneronJob:progress(msg)
                else
                    VigneronJob.canNotif = false
                    VigneronJob.inCraft = false
                    Framework.ShowNotification("~r~Vous n'avez pas les matières premières requises !")
    
                    return
                end
            end
        end

        if VigneronJob.canNotif then
            Framework.ShowNotification("~r~Vous n'avez pas les matières premières requises !")
        end
    end
end

RegisterNetEvent('VigneronJob:stopCraft')
AddEventHandler('VigneronJob:stopCraft', function()
    VigneronJob.inCraft = false
    FreezeEntityPosition(PlayerPedId(), false)
end)