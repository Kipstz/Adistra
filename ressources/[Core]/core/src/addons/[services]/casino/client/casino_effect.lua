function PlaySoundEffect(effect)
    if effect == "jackpot" then
        PlaySoundFromCoord(-1, "DLC_VW_CASINO_SLOT_WIN_MASTER", 930.5, 45.0, 80.0, "dlc_vw_casino_slot_sounds", 0, 0, 0)
    elseif effect == "win" then
        PlaySoundFromEntity(-1, "DLC_VW_CASINO_BLACKJACK_WIN_MASTER", PlayerPedId(), "dlc_vw_casino_table_games_sounds", 1, 0)
    end
end

function DisplayParticleEffect(effect, x, y, z)
    if effect == "fireworks" then
        RequestNamedPtfxAsset("scr_indep_fireworks")
        while not HasNamedPtfxAssetLoaded("scr_indep_fireworks") do
            Wait(0)
        end

        UseParticleFxAssetNextCall("scr_indep_fireworks")
        StartParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", x, y, z, 0.0, 0.0, 0.0, 1.0, false, false, false)
    end
end
