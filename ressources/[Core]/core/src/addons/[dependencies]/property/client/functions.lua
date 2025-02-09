

function Property:getPropertybyName(name)
	for k,v in pairs(Property.properties) do
		if v.params.name == name then return v end
	end
end

function Property:getPropertybyId(id)
	for k,v in pairs(Property.properties) do
		if tonumber(v.id) == tonumber(id) then return v end
	end
end

function Property:isOwnedbyName(property)
    for k,v in pairs(Property.properties) do
        if v.params.name == property.params.name then
            if v.owned then return true end
        end
    end
	return false
end

function Property:isOwnedbyId(property)
    for k,v in pairs(Property.properties) do
		if tonumber(v.id) == tonumber(property.id) then
            if v.owned then return true end
        end
    end
	return false
end

function Property:open(name, idProperty)
	for k,v in pairs(Property.typesOpen.types) do
		if name == k then
			v.action(idProperty)
			break
		end
	end
end

Property.blips = {}
Property.blips2 = {}

function Property:DeleteBlips()
	for k,v in pairs(Property.blips) do
		RemoveBlip(v)
	end
	for k,v in pairs(Property.blips2) do
		RemoveBlip(v)
	end
end

function Property:CreateBlips()
	Property:DeleteBlips()
	Wait(750)
	Property.blips = {}
	Property.blips2 = {}

	for k,v in pairs(Property.properties) do
		if not v.owned and v.points ~= nil and v.points.enter ~= nil and v.points.enter.x ~= nil then
			local blip = AddBlipForCoord(v.points.enter.x, v.points.enter.y, v.points.enter.z)
			table.insert(Property.blips, blip)
			SetBlipSprite(blip, 350)
			SetBlipScale(blip, 0.5)
			SetBlipCategory(blip, 10)
			SetBlipAsShortRange(blip, true)
		end
	end

	if next(Property.owneds) then
		for k,v in pairs(Property.owneds) do
			if v.points ~= nil and v.points.enter ~= nil and v.points.enter.x ~= nil then
				local blip = AddBlipForCoord(v.points.enter.x, v.points.enter.y, v.points.enter.z)
				table.insert(Property.blips2, blip)
				SetBlipSprite(blip, 40)
				SetBlipColour(blip, 2)
				SetBlipScale(blip, 0.5)
				SetBlipCategory(blip, 11)
				SetBlipAsShortRange(blip, true)
		
				BeginTextCommandSetBlipName('STRING')
				AddTextComponentSubstringPlayerName(v.params.name)
				EndTextCommandSetBlipName(blip)
			end
		end
	end
end