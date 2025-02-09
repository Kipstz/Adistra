
MecanoJob.CraftMenu = RageUI.CreateMenu("Mécano", "~p~Mécano~s~: Craft", 8, 200)

local open = false

MecanoJob.CraftMenu.Closed = function()
    open = false
end

MecanoJob.OpenCraftMenu = function()
    if open then
        RageUI.CloseAll()
        RageUI.Visible(MecanoJob.CraftMenu, false)
        open = false
    else
        RageUI.CloseAll()
        RageUI.Visible(MecanoJob.CraftMenu, true)
        open = true

        CreateThread(function()
            while open do
                Wait(1)

                RageUI.IsVisible(MecanoJob.CraftMenu, true, true, true, function()
                    for k,v in pairs(Config['job_mecano'].itemsCraft) do
                        RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                            if Selected then
                                MecanoJob.startCraft(v.need, v.name, v.msg)
                            end
                        end)
                    end
                end)
            end
        end)
    end
end

MecanoJob.startCraft = function(need, type, msg)
    MecanoJob.canNotif = true;

    if not MecanoJob.inCraft then
        for k,v in pairs(Framework.PlayerData.inventory) do
            if v.name == need then
                if v.count > 0 then
                    MecanoJob.canNotif = false;
                    MecanoJob.inCraft = true;
    
                    exports["ac"]:ExecuteServerEvent("MecanoJob:startCraft", need, type)
                
                    MecanoJob:progress(msg, anim)
                else
                    MecanoJob.canNotif = false;
                    MecanoJob.canCraft = false;
                    Framework.ShowNotification("~r~Vous n'avez pas les outils requis !")
    
                    return
                end
            end
        end

        if MecanoJob.canNotif then
            Framework.ShowNotification("~r~Vous n'avez pas les outils requis !")
        end
    end
end

RegisterNetEvent('MecanoJob:stopCraft')
AddEventHandler('MecanoJob:stopCraft', function()
    MecanoJob.inCraft = false
    FreezeEntityPosition(PlayerPedId(), false)
end)