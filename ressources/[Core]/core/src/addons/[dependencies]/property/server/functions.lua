
function InitSharedProperties()
    for k,v in pairs(Property.owneds) do
        if not SharedProperty[v.id] then
            SharedProperty[v.id] = {}
            SharedProperty[v.id].id = v.id;
            SharedProperty[v.id].name = v.params.name;
            SharedProperty[v.id].data = v.data;
        end
    end
    PropertyLoaded = true;
end

function SaveProperty(id_property, data) 
    MySQL.Sync.execute("UPDATE character_properties SET `data` = @data WHERE `id_property` = @id_property", {
        ["@id_property"] = id_property,
        ["@data"] = json.encode(data)
    })  
end

CreateThread(function()
    while true do
        -- if PropertyLoaded then
            for k,v in pairs(SharedProperty) do 
                SaveProperty(v.id, v.data)
            end
    
            print("[^6Property^0] Les proprietes ont été sauvegarder !")
        -- end

        Wait(60000 * 5)
    end
end)

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
	if eventData.secondsRemaining == 60 then
		CreateThread(function()
			Wait(55000)
            for k,v in pairs(SharedProperty) do 
                SaveProperty(v.id, v.data)
            end
		end)
	end
end)

Property.getsOwneds = function(src)
    local xPlayer = Framework.GetPlayerFromId(src)

    Property.owneds = {}
end
