function Framework.Scaleform.ShowFreemodeMessage(title, msg, sec)
	local scaleform = Framework.Scaleform.Utils.RequestScaleformMovie('MP_BIG_MESSAGE_FREEMODE')

	BeginScaleformMovieMethod(scaleform, 'SHOW_SHARD_WASTED_MP_MESSAGE')
	ScaleformMovieMethodAddParamTextureNameString(title)
	ScaleformMovieMethodAddParamTextureNameString(msg)
	EndScaleformMovieMethod()

	while sec > 0 do
		Wait(1)
		sec = sec - 0.01

		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
	end

	SetScaleformMovieAsNoLongerNeeded(scaleform)
end

function Framework.Scaleform.ShowBreakingNews(title, msg, bottom, sec)
	local scaleform = Framework.Scaleform.Utils.RequestScaleformMovie('BREAKING_NEWS')

	BeginScaleformMovieMethod(scaleform, 'SET_TEXT')
	ScaleformMovieMethodAddParamTextureNameString(msg)
	ScaleformMovieMethodAddParamTextureNameString(bottom)
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(scaleform, 'SET_SCROLL_TEXT')
	ScaleformMovieMethodAddParamInt(0) -- top ticker
	ScaleformMovieMethodAddParamInt(0) -- Since this is the first string, start at 0
	ScaleformMovieMethodAddParamTextureNameString(title)

	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(scaleform, 'DISPLAY_SCROLL_TEXT')
	ScaleformMovieMethodAddParamInt(0) -- Top ticker
	ScaleformMovieMethodAddParamInt(0) -- Index of string

	EndScaleformMovieMethod()

	while sec > 0 do
		Wait(1)
		sec = sec - 0.01

		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
	end

	SetScaleformMovieAsNoLongerNeeded(scaleform)
end

function Framework.Scaleform.ShowPopupWarning(title, msg, bottom, sec)
	local scaleform = Framework.Scaleform.Utils.RequestScaleformMovie('POPUP_WARNING')

	BeginScaleformMovieMethod(scaleform, 'SHOW_POPUP_WARNING')

	ScaleformMovieMethodAddParamFloat(500.0) -- black background
	ScaleformMovieMethodAddParamTextureNameString(title)
	ScaleformMovieMethodAddParamTextureNameString(msg)
	ScaleformMovieMethodAddParamTextureNameString(bottom)
	ScaleformMovieMethodAddParamBool(true)

	EndScaleformMovieMethod()

	while sec > 0 do
		Wait(1)
		sec = sec - 0.01

		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
	end

	SetScaleformMovieAsNoLongerNeeded(scaleform)
end

function Framework.Scaleform.ShowTrafficMovie(sec)
	local scaleform = Framework.Scaleform.Utils.RequestScaleformMovie('TRAFFIC_CAM')

	BeginScaleformMovieMethod(scaleform, 'PLAY_CAM_MOVIE')

	EndScaleformMovieMethod()

	while sec > 0 do
		Wait(1)
		sec = sec - 0.01

		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
	end

	SetScaleformMovieAsNoLongerNeeded(scaleform)
end

function Framework.Scaleform.Utils.RequestScaleformMovie(movie)
	local scaleform = RequestScaleformMovie(movie)

	while not HasScaleformMovieLoaded(scaleform) do
		Wait(1)
	end

	return scaleform
end
