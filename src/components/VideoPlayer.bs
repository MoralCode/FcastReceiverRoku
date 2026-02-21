sub init()
	m.video = m.top.findNode("videoElement")
	m.video.observeField("state", "onStateChange")


	' Give focus to the scene so it can eventually pass it to the video
	m.top.setFocus(true)
end sub

sub onStateChange()
	if m.video.state = "finished" or m.video.state = "error"
		' Close the player view when done
		m.top.visible = false
		m.video.control = "stop"
	end if
end sub

sub mapMimeType(mime as string) as string
	mimeMap = {
		"video/mp4":"mp4"
		"application/x-mpegURL":"hls"
		"video/x-matroska": "mkv"
	}
	convertedType = mimeMap[mime]
	if convertedType <> invalid then
		return convertedType
	else
		return invalid
	end if
end sub

sub buildContentNodeForVideo(castContent as object)
	' Create the content node required by the Video player
	videoContent = CreateObject("roSGNode", "ContentNode")
	mimetype = mapMimeType(castContent.mime)
	if mapMimeType = invalid then
		print "Invalid Mime type provided: " + castContent.mime + " Could not map to a roku streamformat"
	end if

	if mimetype = "mp4" then
		videoContent.url = castContent.url
	end if

	videoContent.StreamFormat = mimetype
end sub

sub onCastContentChanged()
	print "MainScene: Launching video"

	videoContent = buildContentNodeForVideo(m.top.castContent)
	' Set content and start playback
	m.video.content = videoContent
	m.video.visible = true
	m.video.control = "play"
	m.video.setFocus(true)
end sub

function onKeyEvent(key as string, press as boolean) as boolean
	if press
		if key = "back"
			if m.video.visible = true
				m.video.control = "stop"
				m.video.visible = false
				m.top.setFocus(true)
				return true ' We handled the event
			end if
		end if
	end if
	return false
end function