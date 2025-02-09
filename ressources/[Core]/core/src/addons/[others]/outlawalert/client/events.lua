

RegisterNetEvent('outlawalert:alert')
AddEventHandler('outlawalert:alert', function(alertType, coords, sex, street1, street2)
	OutlawAlert:notify(alertType, sex, street1, street2)
	OutlawAlert:setPlace(coords)
end)