

function TunningSystem:AddToMenu(name,smenu,selected)
	local transla = Config['tunningsystem'].Translations[name]
	if transla == nil then
		transla = name
	end
	local addmen = {
		type = json.encode({tipo = name}),
		title = transla,
		src = "img/"..name..".png",
		subMenuTitle = Config['tunningsystem'].Translations["change"].." "..transla,
		subMenuSelected = selected,
		subMenu = smenu
	}
	return addmen
end

function TunningSystem:AddToSubMenu(name,maxn,moto,sel)
	local transla = Config['tunningsystem'].Translations[name]
	if transla == nil then
		transla = name
	end
	local submenu = {}
	local somar = 0
	if sel then
		somar = 1
		submenu[1] = {
			type = json.encode({tipo = name, index = sel, moto = moto}),
			title = Config['tunningsystem'].Translations["def"]..": "..sel,
			src = "img/Default.png",
		}
	end
	local lel = 0
	if moto then
		lel = 1
	end
	for i = 1, maxn do
		submenu[i+somar] = {
			type = json.encode({tipo = name, index = i-lel, moto = moto}),
			title = transla.." "..i,
			src = "img/"..name..".png",
		}
	end
	return submenu
end