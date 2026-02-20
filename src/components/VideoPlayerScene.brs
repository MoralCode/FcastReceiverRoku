sub init()
	m.video = m.top.findNode("videoPlayer")


	' Give focus to the scene so it can eventually pass it to the video
	m.top.setFocus(true)
end sub

sub onCastContentChanged()
	url = m.castContent.url
	if url <> "" and url <> invalid
		print "MainScene: Launching video -> "; url

		' Create the content node required by the Video player
		videoContent = CreateObject("roSGNode", "ContentNode")
		videoContent.url = url
		videoContent.streamformat = "mp4" ' Grayjay usually sends mp4/mkv/hls

		' Set content and start playback
		m.video.content = videoContent
		m.video.visible = true
		m.video.control = "play"
		m.video.setFocus(true)
	end if
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