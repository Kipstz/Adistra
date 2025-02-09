function PlayCasinoAnimation(playerId, animation)
    RequestAnimDict(animation.dict)
    while not HasAnimDictLoaded(animation.dict) do
        Wait(0)
    end

    TaskPlayAnim(playerId, animation.dict, animation.name, 8.0, -8.0, -1, 1, 0, false, false, false)
end

-- Exemple d'animations spécifiques pour le blackjack et les machines à sous
local Animations = {
    ["blackjack"] = { dict = "anim_casino_b@amb@casino@games@blackjack@player", name = "place_bet" },
    ["slot_machine"] = { dict = "anim_casino_a@amb@casino@games@slots@male", name = "idle_a" }
}

-- Fonction pour jouer une animation en fonction du type de jeu
function StartGameAnimation(playerId, gameType)
    if Animations[gameType] then
        PlayCasinoAnimation(playerId, Animations[gameType])
    end
end
