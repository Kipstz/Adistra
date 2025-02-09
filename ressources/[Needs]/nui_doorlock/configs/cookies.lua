

-- Enter 1
table.insert(Config.DoorList, {
	lockpick = false,
	slides = false,
	maxDistance = 2.5,
	authorizedJobs = { ['cookies']=0 },
	audioRemote = false,
	locked = true,
	doors = {
		{objHash = 1884827145, objHeading = 169.99998474121, objCoords = vector3(-534.4903, 34.65528, 44.9669)},
		{objHash = 1884827145, objHeading = 265.0, objCoords = vector3(-532.9839, 32.78611, 44.9612)}
 },            
        -- oldMethod = true,
        -- audioLock = {['file'] = 'metal-locker.ogg', ['volume'] = 0.6},
        -- audioUnlock = {['file'] = 'metallic-creak.ogg', ['volume'] = 0.7},
        -- autoLock = 1000
})