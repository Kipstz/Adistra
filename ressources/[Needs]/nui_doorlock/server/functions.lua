

function DoorLock:isAuthorized(xPlayer, door, usedLockpick)
    local myJobName = xPlayer['jobs'].job.name;
    local myJob2Name = xPlayer['jobs'].job2.name;
    local myJobGrade = xPlayer['jobs'].job.grade;
    local myJob2Grade = xPlayer['jobs'].job2.grade;
	
	if door.lockpick and usedLockpick then
		local count = xPlayer['inventory'].getInventoryItem('lockpick').count
		if count and count >= 1 then return true end
	end

	if door.authorizedJobs then
		for job,grade in pairs(door.authorizedJobs) do
			if (job == myJobName and grade <= myJobGrade) or (job == myJob2Name and grade <= myJob2Grade) then
				return true
			end
		end
	end

	if door.items then
		for k,v in pairs(door.items) do
			local item = xPlayer['inventory'].getInventoryItem(v)
			if item and item.count > 0 then
				local consumables = {'ticket'}
				if locked and consumables[v] then
					xPlayer['inventory'].removeInventoryItem(v, 1)
				end
				return true
			end
		end
	end
	return false
end

function DoorLock:isWL(identifier)
    for k,v in pairs(Config.WL) do
        if identifier == v then
            return true
        end
    end
    return false
end