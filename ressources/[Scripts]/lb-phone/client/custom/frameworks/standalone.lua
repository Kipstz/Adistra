if Config.Framework ~= "standalone" then
    return
end

while not Framework do
    TriggerEvent("framework:init", function(obj)
        Framework = obj
    end)
    Wait(10)
end

local isFirst = true;
RegisterNetEvent("framework:restoreCharacter", function(playerData)
    Framework.PlayerData = playerData;
    Framework.PlayerLoaded = true;

    if not isFirst then FetchPhone() end

    isFirst = false;
end)

RegisterNetEvent("framework:onPlayerLogout", LogOut)

while not Framework.PlayerLoaded do Wait(10) end

RegisterNetEvent("framework:setJob", function(job)
    Framework.PlayerData.jobs['job'] = job;
end)

loaded = true;

function HasPhoneItem(number)
    if not Config.Item.Require then
        return true
    end

    if Config.Item.Unique then
        return HasPhoneNumber(number)
    end

    if GetResourceState("ox_inventory") == "started" and Config.Item.Inventory == "ox_inventory" then
        return (exports.ox_inventory:Search("count", Config.Item.Name) or 0) > 0
    end

    return true
end

function HasJob(jobs)
    local job = Framework.PlayerData.jobs['job'].name
    for i = 1, #jobs do
        if jobs[i] == job then
            return true
        end
    end
    return false
end

---Apply vehicle mods
---@param vehicle number
---@param vehicleData table
function ApplyVehicleMods(vehicle, vehicleData)
end

---Create a vehicle and apply vehicle mods
---@param vehicleData table
---@param coords vector3
---@return number? vehicle
function CreateFrameworkVehicle(vehicleData, coords)
end

-- Company app
function GetCompanyData(cb)
    cb {}
end

function DepositMoney(amount, cb)
    cb(false)
end

function WithdrawMoney(amount, cb)
    cb(false)
end

function HireEmployee(source, cb)
    cb(false)
end

function FireEmployee(identifier, cb)
    cb(false)
end

function SetGrade(identifier, newGrade, cb)
    cb(false)
end

function ToggleDuty()
    return false
end
