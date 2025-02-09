local Croupiers = {
    { type = "blackjack", model = "s_m_y_casino_01", x = 932.0, y = 45.5, z = 80.0, heading = 180.0 },
    { type = "roulette", model = "s_m_y_casino_01", x = 934.0, y = 45.5, z = 80.0, heading = 180.0 }
}

-- Fonction pour créer un croupier
function SpawnCroupiers()
    for _, croupier in pairs(Croupiers) do
        local model = GetHashKey(croupier.model)
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end

        local ped = CreatePed(4, model, croupier.x, croupier.y, croupier.z, croupier.heading, false, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_COP_IDLES", 0, true)
    end
end

-- Appel de la fonction de spawn lors du chargement
AddEventHandler("onResourceStart", function(resourceName)
    if GetCurrentResourceName() == resourceName then
        SpawnCroupiers()
    end
end)
