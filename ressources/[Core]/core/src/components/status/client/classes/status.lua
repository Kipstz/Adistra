function CreateStatus(name, default, color, tickCallback)

	local self = {}

	self.val          = default
	self.name         = name
	self.default      = default
	self.color        = color
	self.tickCallback = tickCallback

	function self._set(k, v)
		self[k] = v
	end

	function self._get(k)
		return self[k]
	end

	function self.onTick()
		self.tickCallback(self)
	end

	function self.set(val)
		self.val = val
	end

	function self.add(val)
		if self.val + val > Config['status'].StatusMax then
			self.val = Config['status'].StatusMax
		else
			self.val = self.val + val
		end
	end

	function self.remove(val)
		if self.val - val < 0 then
			self.val = 0
		else
			self.val = self.val - val
		end
	end

	function self.reset()
		self.set(self.default)
	end

	function self.getPercent()
		return (self.val / Config['status'].StatusMax) * 100
	end

	return self

end
