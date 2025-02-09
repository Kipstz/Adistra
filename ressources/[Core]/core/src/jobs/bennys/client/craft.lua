
BennysJob.CraftMenu = RageUI.CreateMenu("Mécano", "~p~Mécano~s~: Craft", 8, 200)

local open = false

BennysJob.CraftMenu.Closed = function()
    open = false
end

BennysJob.OpenCraftMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(BennysJob.CraftMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(BennysJob.CraftMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(BennysJob.CraftMenu, true, true, true, function()
                    for k,v in pairs(Config['job_bennys'].itemsCraft) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                BennysJob.startCraft(v.need, v.name, v.msg)
                            end
                        end)
                    end
                end)
            end
        end)
    end
end

BennysJob.startCraft = function(need, type, msg)
    BennysJob.canNotif = true

    if not BennysJob.inCraft then
        for k,v in pairs(Framework.PlayerData.inventory) do
            if v.name == need then
                if v.count > 0 then
                    BennysJob.canNotif = false
                    BennysJob.inCraft = true
    
                    exports["ac"]:ExecuteServerEvent("BennysJob:startCraft", need, type)
                
                    BennysJob:progress(msg, anim)
                else
                    BennysJob.canNotif = false
                    BennysJob.canCraft = false
                    Framework.ShowNotification("~r~Vous n'avez pas les outils requis !")
    
                    return
                end
            end
        end

        if BennysJob.canNotif then
            Framework.ShowNotification("~r~Vous n'avez pas les outils requis !")
        end
    end
end

RegisterNetEvent('BennysJob:stopCraft')
AddEventHandler('BennysJob:stopCraft', function()
    BennysJob.inCraft = false
    FreezeEntityPosition(PlayerPedId(), false)
end)