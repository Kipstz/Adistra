__Database = {}

function __Database:create(callback, where, data)
    local exist = LoadResourceFile(GetCurrentResourceName(), "Framework/server/database/"..where.."/" .. data .. ".json")
    if exist == nil then
        SaveResourceFile(GetCurrentResourceName(), "Framework/server/database/"..where.."/" .. data .. ".json", '{}')
        callback("Data created")
    else
        callback("Data already exists")
    end
end

function __Database:insert(callback, where, data, value)
    local exist = LoadResourceFile(GetCurrentResourceName(), "Framework/server/database/"..where.."/" .. data .. ".json")
    if exist == nil then
        callback('Data Not Found')
    else
        SaveResourceFile(GetCurrentResourceName(), "Framework/server/database/"..where.."/" .. data .. ".json", json.encode(value))
        callback("Insertion made")
    end
end

function __Database:select(callback, where, data)
    local result = LoadResourceFile(GetCurrentResourceName(), "Framework/server/database/"..where.."/" .. data .. ".json")
    if result == nil then
        callback('Data Not Found')
    else
        callback(json.decode(result))
    end
end
