
function init()
    videoPlayer = m.top.FindNode("videoPlayer")
    videoPlayer.contentIsPlaylist = true
    videoPlayer.content = GetVideoPlaylist()
    videoPlayer.control = "play"
    videoPlayer.setFocus(true)
end function

function GetVideoPlaylist()
    content = CreateObject("roSGNode", "ContentNode")
    contentItem = content.CreateChild("ContentNode")
    contentItem.url = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4"
    contentItem.playStart = 10
    contentItem = content.CreateChild("ContentNode")
    contentItem.url = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"
    contentItem = content.CreateChild("ContentNode")
    contentItem.url = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
    return content
end function
