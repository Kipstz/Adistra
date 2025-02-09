bossManagement = {}

SharedSocietes = {}

RegisterNetEvent('framework:restoreCharacter')
AddEventHandler('framework:restoreCharacter', function(xPlayer)
    Framework.TriggerServerCallback("bossManagement:getSocietes", function(societes)
        for k,v in pairs(societes) do
            SharedSocietes[v.name] = {}
            SharedSocietes[v.name].name = v.name 
            SharedSocietes[v.name].label = v.label 
            SharedSocietes[v.name].data = v.data
        end
    end)
end)

RegisterNetEvent('bossManagement:updateSocietes')
AddEventHandler('bossManagement:updateSocietes', function()
    Framework.TriggerServerCallback("bossManagement:getSocietes", function(societes)
        for k,v in pairs(societes) do
            SharedSocietes[v.name] = {}
            SharedSocietes[v.name].name = v.name 
            SharedSocietes[v.name].label = v.label 
            SharedSocietes[v.name].data = v.data
        end
    end)
end)

AddEventHandler('bossManagement:openMenu', function(societeName, wlGrades)
    bossManagement.OpenBossMenu(societeName, wlGrades)
end)

bossManagement.isOtherWLbyGrade = function(wlGrades, myGrade)
    if wlGrades ~= nil then
        for k,v in pairs(wlGrades) do
            if myGrade == v then
                return true
            end
        end
    end

    return false
end