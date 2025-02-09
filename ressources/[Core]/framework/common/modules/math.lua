Framework.Math = {}

function Framework.Math.Round(value, numDecimalPlaces)
	--print(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10^numDecimalPlaces

--		print(math.floor((value * power) + 0.5) / (power))
		return math.floor((value * power) + 0.5) / (power)
	else
	--	print("2"..math.floor(value + 0.5))
		return math.floor(value + 0.5)
	end
end

function Framework.Math.GroupDigits(value)
	local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')

	return left..(num:reverse():gsub('(%d%d%d)','%1' .. (' ')):reverse())..right
end

function Framework.Math.Trim(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end