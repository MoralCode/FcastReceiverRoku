sub init()
    m.video = m.top.FindNode("video")
    m.loadingGroup = m.top.FindNode("loadingGroup")
    m.transportControls = m.top.FindNode("transportControls")
    m.progressBar = m.top.FindNode("progressBar")
    m.stateIcon = m.top.FindNode("stateIcon")
    m.timeLabel = m.top.FindNode("timeLabel")
    m.action = m.top.FindNode("action")
    ShowLoadingFacade(true)

    ' animations
    m.showTCAnimation = m.top.findNode("showTCAnimation")
    m.transportControlsInterpolator = m.top.findNode("transportControlsInterpolator")
    m.gradientInterpolator = m.top.findNode("gradientInterpolator")
    ' controls hiding timer
    m.transportControlsTimer = m.top.findNode("transportControlsTimer")
    m.transportControlsTimer.ObserveFieldScoped("fire", "HideTransportControls")
    m.top.ObserveFieldScoped("focusedChild", "OnFocusChange")
    SetupVideoObservers()

    m.fullTimeString = "0"
    m.screenHeight = 720
end sub

sub OnFocusChange()
    if m.top.HasFocus()
        m.video.SetFocus(true)
    end if
end sub

sub ShowLoadingFacade(show as Boolean)
    m.loadingGroup.visible = show
end sub

sub SetupVideoObservers()
    m.video.ObserveFieldScoped("state", "OnVideoStateChanged")
    m.video.ObserveFieldScoped("duration", "OnDurationChanged")
    m.video.ObserveFieldScoped("progressPosition", "OnPositionChanged")
    m.video.ObserveFieldScoped("activeButton", "OnVideoButtonPressed")
end sub

sub OnVideoStateChanged(event as Object)
    state = event.GetData()
    if state = "buffering"
        ShowLoadingFacade(true)
    else
        ShowLoadingFacade(false)
    end if

    if state = "paused"
        m.transportControlsTimer.control = "stop"
        SetStateIcon("pkg:/images/player/play.png")
    else
        SetStateIcon("pkg:/images/player/pause.png")
    end if
end sub

sub OnDurationChanged(event as Object)
    m.progressBar.length = event.GetData()
    m.fullTimeString = ""
    m.fullTimeString = GetDurationStringStandard(int(event.GetData()), false)
    UpdateTimeLabel()
end sub

sub OnPositionChanged(event as Object)
    if m.direction = invalid
        m.progressBar.progressPosition = event.GetData()
        UpdateTimeLabel()
    end if
end sub

sub OnVideoButtonPressed(event as Object)
    button = event.GetData()
    ShowTransportControls()
    m.transportControlsTimer.control = "stop"
    if button = "right"
        m.action.uri = "pkg:/images/player/plus10.png"
    else if button = "left"
        m.action.uri = "pkg:/images/player/minus10.png"
    else if button = "fastforward"
        m.action.uri = "pkg:/images/player/ff" + m.video.FFRewCount.ToStr() + ".png"
    else if button = "rewind"
        m.action.uri = "pkg:/images/player/rewind" + m.video.FFRewCount.ToStr() + ".png"
    else if button = ""
        m.action.uri = ""
        m.transportControlsTimer.control = "start"
    end if
end sub

sub UpdateTimeLabel()
    m.timeLabel.text = GetDurationStringStandard(int(m.progressBar.progressPosition), false) + " / " + m.fullTimeString
end sub

sub SetStateIcon(uri as String)
    m.stateIcon.uri = uri
end sub

sub OnTransportControlsShow(slideUp as Boolean)
    if slideUp
        m.transportControlsInterpolator.keyValue = [m.transportControls.translation, [0, m.screenHeight*0.9]]
        m.gradientInterpolator.keyValue = [m.transportControls.opacity, 1.0]
    else
        m.transportControlsInterpolator.keyValue = [m.transportControls.translation, [0, m.screenHeight]]
        m.gradientInterpolator.keyValue = [m.transportControls.opacity, 0.0]
    end if
    m.showTCAnimation.control = "start"
end sub

sub HideTransportControls()
    OnTransportControlsShow(false)
end sub

sub ShowTransportControls()
    OnTransportControlsShow(true)
end sub

function OnKeyEvent(key as String, press as Boolean) as Boolean
    if press and key = "back" and m.transportControls.opacity > 0
        HideTransportControls()
        return true
    end if
    return false
end function
