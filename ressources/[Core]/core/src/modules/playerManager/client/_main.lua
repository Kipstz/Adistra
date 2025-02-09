
HD_Cls.createClass("PlayerManager", function(cls)
    local class = cls

    function class:player() return  PlayerId() end
    function class:plyPed() return PlayerPedId() end
    function class:inVeh() return IsPedInAnyVehicle(PlayerPedId()) end
    function class:inHeli() return IsPedInAnyHeli(PlayerPedId()) end
    function class:car() return GetVehiclePedIsIn(PlayerPedId()) end
    function class:CarSpeed() return (GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId())) * 3.6) end
    function class:isDriver() return (GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId()) end
    function class:isArmed() return IsPedArmed(PlayerPedId(), 4) end
    function class:isSwim() return IsPedSwimming(PlayerPedId()) end
    function class:isRun() return IsPedRunning(PlayerPedId()) end

    return class
end)