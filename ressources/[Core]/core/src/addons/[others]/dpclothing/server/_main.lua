
DpClothing = {}

function DpClothing:Lang(what)
	local Dict = Locale[Config['dpclothing'].Language]
	if not Dict[what] then return Locale["en"][what] end
	return Dict[what]
end