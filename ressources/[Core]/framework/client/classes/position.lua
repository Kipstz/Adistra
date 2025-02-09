
RegisterNetEvent('framework:teleport')
AddEventHandler('framework:teleport', function(coords)
	Framework.Game.Teleport(PlayerPedId(), coords)
end)