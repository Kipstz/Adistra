
function Coffres:reloadChests()
	for k,v in pairs(Coffres.xCoffre) do
		Framework.Game.DeleteObject(v)
	end
	Wait(500)
	Coffres.xCoffre = {}
	for k,v in pairs(Coffres.coffres) do
		Framework.Game.SpawnLocalObject('prop_ld_int_safe_01', vector3(v.coords.x, v.coords.y, v.coords.z), function(obj)
			SetEntityHeading(obj, v.coords.h)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)
			table.insert(Coffres.xCoffre, obj)
		end)
	end
end

function Coffres:addNewChest()
	local plyPed = PlayerPedId()
    local myCoords = GetEntityCoords(plyPed)
    local myHeading = GetEntityHeading(plyPed)

    local x = myCoords.x + 1
    local y = myCoords.y
    local z = myCoords.z - 1
    local coords = vector3(x, y, z)

    Framework.Game.SpawnObject('prop_ld_int_safe_01', coords, function(obj)
		SetEntityHeading(obj, h)
        PlaceObjectOnGroundProperly(obj)
        FreezeEntityPosition(obj, true)
        table.insert(Coffres.xCoffre, obj)
	end)
	Wait(500)
	Coffres:initCode(coords, myHeading)
end

function Coffres:initCode(coords, heading)
	local code = VisualManager:KeyboardOutput("Code du Coffre", "", 4)

	if code ~= nil and code ~= '' then
		TriggerServerEvent('coffres:addNewChest', coords, heading, tostring(code)) 
	else
		Framework.ShowNotification("~r~Veuillez saisir un Code valide !~s~")
		Coffres:initCode(coords, h)
	end
end

function Coffres:setCode(id)
	local code = VisualManager:KeyboardOutput("Code du Coffre", "", 4)

	if code ~= nil and code ~= '' then
		TriggerServerEvent('coffres:checkCode', id, tostring(code)) 
	else
		Framework.ShowNotification("~r~Veuillez saisir un Code valide !")
		Coffres:setCode(id)
	end
end