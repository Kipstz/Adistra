
function RobHouses:start(robId, robInfos)
    Framework.TriggerServerCallback('rob_houses:canRob', function(canRob, hasItem)
        if canRob then
            local result = exports['lockpick']:startLockpick()
            if result then
                RobHouses.inRobbing = true;
                RobHouses.zones = {}
                RobHouses.robbing = {
                    robId = robId,
                    job = robInfos.job,
                    insidePos = Config['rob_houses'].interieurs[robInfos.int].insidePos,
                    outsidePos = robInfos.pos
                }
                TriggerServerEvent('rob_houses:start', robId)
                RobHouses:tp(RobHouses.robbing.insidePos)
                RobHouses:zoneExit(RobHouses.robbing.insidePos)
                RobHouses:zoneLoot(robInfos.int)
            else
                Framework.ShowNotification("~r~Vous avez échouer !~s~")
            end
        end
    end, tonumber(robId))
end