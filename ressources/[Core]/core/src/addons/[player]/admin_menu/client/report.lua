AdminMenu.reportsTable, AdminMenu.reportCount, AdminMenu.take = {},0,0

AdminMenu.reportsDisplay = function()
    return "~s~Reports actifs: ~o~"..AdminMenu.reportCount.."~s~ | Pris en charge: ~y~"..AdminMenu.take
end

RegisterNetEvent("admin_menu:updateReports")
AddEventHandler("admin_menu:updateReports", function(table)
    AdminMenu.reportCount = 0
    AdminMenu.take = 0

    for src,report in pairs(table) do
        AdminMenu.reportCount = AdminMenu.reportCount + 1

        if report.taken then AdminMenu.take = AdminMenu.take + 1 end
    end

    AdminMenu.reportsTable = table
end)