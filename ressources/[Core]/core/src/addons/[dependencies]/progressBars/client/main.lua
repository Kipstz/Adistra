
ProgressBars = {}

function ProgressBars:startUI(time, text) 
	SendNUIMessage({
		action = "showProgress",
		display = true,
		time = time,
		text = text
	})
end