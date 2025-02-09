Blips = {
    {name="~o~Farm Pommes~s~ | Récolte",color=24, id=618, Position = vector3(238.1, 6517.4, 31.2)},
    {name="~o~Farm Pommes~s~ | Traitement",color=24, id=618, Position = vector3(408.4, 6495.8, 27.9)},
    {name="~o~Farm Pommes~s~ | Vente",color=24, id=618, Position = vector3(376.5, 6649.5, 28.7)},

    {name="~o~Farm Oranges~s~ | Récolte",color=47, id=618, Position = vector3(2381.4, 4709.0, 34.0)},
    {name="~o~Farm Oranges~s~ | Traitement",color=47, id=618, Position = vector3(2907.9, 4468.8, 48.2)},
    {name="~o~Farm Oranges~s~ | Vente",color=47, id=618, Position = vector3(2680.1, 3508.7, 53.3)},

    {name="~o~Farm Charbon~s~ | Récolte",color=83, id=683, Position = vector3(-472.7, 2090.2, 120.0)},
    {name="~o~Farm Charbon~s~ | Traitement",color=83, id=683, Position = vector3(-481.6, 1895.1, 119.6)},
    {name="~o~Farm Charbon~s~ | Vente",color=83, id=683, Position = vector3(-459.0, -63.6, 44.5)},

    {name="~o~Farm Chantier~s~ | Récolte",color=46, id=365, Position = vector3(-485.2, -985.0,29.1)},
    {name="~o~Farm Chantier~s~ | Traitement",color=46, id=365, Position = vector3(-452.6, -1003.0, 23.9)},
    {name="~o~Farm Chantier~s~ | Vente",color=46, id=365, Position = vector3(-1042.3, -2023.8, 13.1)},

    {name="~o~Farm Poulet~s~ | Récolte",color=1, id=501, Position = vector3(-65.7, 6236.2, 31.0)},
    {name="~o~Farm Poulet~s~ | Traitement",color=1, id=501, Position = vector3(-105.9, 6204.8, 31.0)},
    {name="~o~Farm Poulet~s~ | Vente",color=1, id=501, Position = vector3(-155.1, 6138.7, 32.3)},

    {name="~o~Farm Petrol~s~ | Récolte",color=0, id=51, Position = vector3(1363.3, -2204.3, 60.2)},
    {name="~o~Farm Petrol~s~ | Traitement",color=0, id=51, Position = vector3(1473.1, -1602.9, 71.1)},
    {name="~o~Farm Petrol~s~ | Vente",color=0, id=51, Position = vector3(1458.8, -1930.6, 71.8)},

    {name="~o~Farm Cuivre~s~ | Récolte",color=0, id=354, Position = vector3(2753.6, 1522.0, 40.3)},
    {name="~o~Farm Cuivre~s~ | Traitement",color=0, id=354, Position = vector3(2795.6, 1666.8, 21.0)},
    {name="~o~Farm Cuivre~s~ | Vente",color=0, id=354, Position = vector3(2760.6, 1548.4, 40.3)},

    {name="~o~Farm OmriVine~s~ | Récolte",color=2, id=469, Position = vector3(4751.9, -5756.4, 20.4)},
    {name="~o~Farm OmriVine~s~ | Traitement",color=2, id=469, Position = vector3(4503.9, -4554.2, 4.1)},
    {name="~o~Farm OmriVine~s~ | Vente",color=2, id=469, Position = vector3(5133.1, -4615.5, 2.4)},

    {name="Locations | Véhicules",color=47, id=280, Position = vector3(-1035.5, -2731.2, 13.7)},
    {name="Locations | Véhicules",color=47, id=280, Position = vector3(-413.2, 1168.3, 325.9)},
    {name="Locations | JetSki",color=47, id=471, Position = vector3(-1613.0, -1128.7, 2.3)},
}

Citizen.CreateThread(function()
    for k,v in pairs(Blips) do
        local blip = AddBlipForCoord(v.Position)
        SetBlipSprite (blip, v.id)
        SetBlipScale  (blip, 0.7)
        SetBlipColour (blip, v.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING") 
        AddTextComponentString(v.name)
        EndTextCommandSetBlipName(blip)
    end
end)