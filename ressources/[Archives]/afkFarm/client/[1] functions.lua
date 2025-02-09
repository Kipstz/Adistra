local afkblips = __Blips:create("Zone AFK", vector3(234.98597717285,-760.35028076172,30.866399765015), 500, 52, "Zone AFK")

__While:addTick(0, "farming", function()
    if vg_AFKFarm.isInAFKMode then
        DrawRect(0.5, 0.5, 1.0, 1.0, 0, 0, 0, 255)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextScale(0.0, 0.5)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString("Vous êtes en mode AFK, \n vous recevez ~p~5 coins~w~ et ~p~10 000 $~w~ chaque heure.")
        DrawText(0.5, 0.5)
        if IsControlJustPressed(0, 38) then
            AFKMode("exit")
        end
    end
end)

__Zone:create("afkFarmEntered", vector3(234.98597717285,-760.35028076172,30.866399765015), 50, {
    onEnter = function()
        RequestModel(GetHashKey("cs_barry"))
        while not HasModelLoaded(GetHashKey("cs_barry")) do
            Wait(1)
        end
        vg_AFKFarm.ped = __Ped:create(GetHashKey("cs_barry"), vector3(234.98597717285,-760.35028076172,30.866399765015 - 1), 160.78890991211)
        PlaceObjectOnGroundProperly(vg_AFKFarm.ped)
        __Ped:setGodmode(vg_AFKFarm.ped, true)
        __Ped:setFreeze(vg_AFKFarm.ped, true)
        __Ped:setTitle(vg_AFKFarm.ped, "Gustavo")
        SetPedAlertness(vg_AFKFarm.ped, 0)
        SetPedSuffersCriticalHits(vg_AFKFarm.ped, false)
        SetPedFleeAttributes(vg_AFKFarm.ped, 0, false)
        SetPedCombatMovement(vg_AFKFarm.ped, 0)
        SetPedCanCowerInCover(vg_AFKFarm.ped, false)
        TaskSetBlockingOfNonTemporaryEvents(vg_AFKFarm.ped, true)

        __Zone:create("afkFarmPed", vector3(234.98597717285,-760.35028076172,30.866399765015), 2.5, {
            onEnter = function()
                print("entered")
            end,
            onPress = function()
                if not vg_AFKFarm.isInAFKMode then
                    AFKMode("enter")
                end
            end,
            onExit = function()

            end
        })
    end,
    onPress = function()

    end,
    onExit = function()
        __Zone:delete("afkFarmPed")
        __Ped:delete(vg_AFKFarm.ped)
    end
})

