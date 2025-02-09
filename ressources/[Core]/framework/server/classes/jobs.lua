Framework.JOBS = {}
Framework.JOBS2 = {}

-- CLASS --
function CreateExtendedJobs(playerId, characterId, jobs)
	local self = {}

    self.source = playerId;
    self.characterId = characterId;
    self.jobs = jobs;
	self.job = self.jobs['job'];
	self.job2 = self.jobs['job2'];

	function self.triggerEvent(eventName, ...)
		TriggerClientEvent(eventName, self.source, ...)
	end

	function self.getJobs()
		return self.jobs
	end

	function self.getJob()
		return self.jobs['job']
	end

	function self.getJob2()
		return self.jobs['job2']
	end

	function self.setJob(job, grade)
		grade = tostring(grade)
		local lastJob = json.decode(json.encode(self.jobs['job']))

		if Framework.JOBS:DoesJobExist(job, grade) then
			local jobObject, gradeObject = Framework.JobsList[job], Framework.JobsList[job].grades[grade]

			self.jobs['job'].id    = jobObject.id
			self.jobs['job'].name  = jobObject.name
			self.jobs['job'].label = jobObject.label

			self.jobs['job'].grade        = tonumber(grade)
			self.jobs['job'].grade_name   = gradeObject.name
			self.jobs['job'].grade_label  = gradeObject.label

			TriggerEvent('framework:setJob', self.source, self.jobs['job'], lastJob)
			self.triggerEvent('framework:setJob', self.jobs['job'])
		else
			print(('[framework] [^3WARNING^7] Ignoring invalid .setJob() usage for "%s"'):format(self.identifier))
		end
	end

	function self.setJob2(job2, grade2)
		grade2 = tostring(grade2)
		local lastJob2 = json.decode(json.encode(self.jobs['job2']))

		if Framework.JOBS2:DoesJob2Exist(job2, grade2) then
			local job2Object, grade2Object = Framework.Jobs2List[job2], Framework.Jobs2List[job2].grades[grade2]

			self.jobs['job2'].id    = job2Object.id
			self.jobs['job2'].name  = job2Object.name
			self.jobs['job2'].label = job2Object.label

			self.jobs['job2'].grade        = tonumber(grade2)
			self.jobs['job2'].grade_name   = grade2Object.name
			self.jobs['job2'].grade_label  = grade2Object.label

			TriggerEvent('framework:setJob2', self.source, self.jobs['job2'], lastJob2)
			self.triggerEvent('framework:setJob2', self.jobs['job2'])
		else
			print(('[framework] [^3WARNING^7] Ignoring invalid .setJob2() usage for "%s"'):format(self.identifier))
		end
	end

	return self
end

-- FUNCTIONS --

function Framework.JOBS:GetJobs()
	return Framework.JobsList
end

function Framework.JOBS2:GetJobs2()
	return Framework.Jobs2List
end

function Framework.JOBS:DoesJobExist(job, grade)
	grade = tostring(grade)

	if job and grade then
		if Framework.JobsList[job] and Framework.JobsList[job].grades[grade] then
			return true
		end
	end

	return false
end

function Framework.JOBS2:DoesJob2Exist(job2, grade2)
	grade2 = tostring(grade2)

	if job2 and grade2 then
		if Framework.Jobs2List[job2] and Framework.Jobs2List[job2].grades[grade2] then
			return true
		end
	end

	return false
end