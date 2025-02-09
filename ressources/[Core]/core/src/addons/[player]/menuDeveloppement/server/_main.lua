MenuDev = {}

Framework.RegisterServerCallback('menudev:isWlAccess', function(src, cb) cb(MenuDev:canAccess(src)) end)

RegisterNetEvent('menudev:addItem')
AddEventHandler('menudev:addItem', function(item)
    local src = source;
    if MenuDev:canAccess(src) then
        MySQL.Async.execute('INSERT INTO items (name, label, weight, can_remove) VALUES (@name, @label, @weight, @can_remove)', {
            ['@name'] = item.name,
            ['@label'] = item.label,
            ['@weight'] = item.weight,
            ['@can_remove'] = item.canRemove
        }, function(rowsChanged)
        end)
        Wait(2500)
        exports['framework']:ReloadItems()
    else
        print("^1 [MENUDEV] Utilisation d'un trigger par un joueur non-autorisé !^0 ID: "..src)
    end
end)

RegisterNetEvent('menudev:addJob')
AddEventHandler('menudev:addJob', function(job)
    local src = source;
    if MenuDev:canAccess(src) then
        if not Framework.JOBS:DoesJobExist(job.name, 0) then
            MySQL.Async.execute('INSERT INTO jobs (name, label) VALUES (@name, @label)', {
                ['@name'] = job.name,
                ['@label'] = job.label
            }, function(rowsChanged)
            end)
        else
            print("[DEVMENU] CANCELED, existe déjà")
        end
    
        for k,v in pairs(job.grades) do
            if not Framework.JOBS:DoesJobExist(job.name, v.id) then
                MySQL.Async.execute('INSERT INTO job_grades (job_name, grade, name, label) VALUES (@job_name, @grade, @name, @label)', {
                    ['@job_name'] = job.name,
                    ['@grade'] = v.grade,
                    ['@name'] = v.name,
                    ['@label'] = v.label
                })
            else
                print("[DEVMENU] CANCELED, existe déjà")
            end
        end
        Wait(2500)
        exports['framework']:ReloadJobs()
    else
        print("^1 [MENUDEV] Utilisation d'un trigger par un joueur non-autorisé !^0 ID: "..src)
    end
end)