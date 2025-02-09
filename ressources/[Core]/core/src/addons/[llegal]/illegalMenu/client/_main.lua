
IllegalMenu = {}

RegisterCommand("illegalMenu:open", function()
    if Framework.PlayerData.jobs and Framework.PlayerData.jobs['job2'].name ~= 'unemployed2' then
        if not ZoneSafe.isInZone then
            IllegalMenu.Open()
        else
            Framework.ShowNotification("~r~Vous ne pouvez pas faire ceci en Zone-Safe !")
        end
    else
        Framework.ShowNotification("~r~Vous n'avez pas accès à ce Menu !")
    end
end)

RegisterKeyMapping('illegalMenu:open', "Ouvrir le menu Illegal", 'keyboard', "F7")