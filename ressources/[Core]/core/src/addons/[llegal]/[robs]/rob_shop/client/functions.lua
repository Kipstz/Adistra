
function Rob_Shop:createPed(hash, coords, heading)
    RequestModel(hash)

    while not HasModelLoaded(hash) do Wait(5) end

    local ped = CreatePed(4, hash, coords, false, false)

    SetEntityHeading(ped, heading)
    SetEntityAsMissionEntity(ped, true, true)
    SetPedHearingRange(ped, 0.0)
    SetPedSeeingRange(ped, 0.0)
    SetPedAlertness(ped, 0.0)
    SetPedFleeAttributes(ped, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCombatAttributes(ped, 46, true)
    SetPedFleeAttributes(ped, 0, 0)
    SetEntityInvincible(ped, true)
    
    return ped
end