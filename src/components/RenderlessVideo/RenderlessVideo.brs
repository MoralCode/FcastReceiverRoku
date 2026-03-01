
sub init()
    ' disable default video ui
    m.top.enableUI = false
    ' timers
    m.holdTimer = m.top.FindNode("holdTimer")
    m.holdRewind = m.top.FindNode("holdRewind")
    m.holdRewind.ObserveFieldScoped("fire", "OnHoldRewind")
    m.holdTimer.ObserveFieldScoped("fire", "OnHoldDetection")

    m.forwardCount = invalid
    m.rewindCount = invalid
    m.top.ObserveFieldScoped("position", "OnPositionChanged")
end sub

function GetVideoNode()
    return m.top
end function

sub OnPositionChanged(event as Object)
    if m.direction = invalid
        m.top.progressPosition = fix(event.GetData())
    end if
end sub

function IsDoingSeek() as Boolean
    return (GetVideoNode().seek = m.top.progressPosition)
end function

sub StopRewFF(doSeek = false as Boolean)
    m.forwardCount = invalid
    m.rewindCount = invalid
    m.top.FFRewCount = 0
    m.top.activeButton = ""
    m.holdRewind.control = "stop"
    if doSeek
        GetVideoNode().seek = m.top.progressPosition
        GetVideoNode().control = "resume"
        m.direction = invalid
    end if
end sub

sub OnHoldRewind()
    GetVideoNode().control = "pause"
    if m.direction = "fastforward"
        newPosition = m.top.progressPosition + m.forwardCount * 4
        if newPosition < m.top.duration
            m.top.progressPosition = newPosition
        else
            m.top.progressPosition = m.top.duration
        end if
    end if
    if m.direction = "rewind"
        newPosition = m.top.progressPosition - m.rewindCount * 4
        if newPosition > 0
            m.top.progressPosition = newPosition
        else
            m.top.progressPosition = 0
        end if
    end if
end sub

sub OnHoldDetection()
    GetVideoNode().control = "pause"
    if m.direction = "left"
        newPosition = m.top.progressPosition - m.top.seekdelta
        if newPosition > 0
            m.top.progressPosition = newPosition
        else
            m.top.progressPosition = 0
        end if
    else if m.direction = "right"
        newPosition = m.top.progressPosition + m.top.seekdelta
        if newPosition < m.top.duration
            m.top.progressPosition = newPosition
        else
            m.top.progressPosition = m.top.duration
        end if
    end if
end sub

sub CheckRewindingCount(rewindingType as String)
    if m[rewindingType] = invalid or m[rewindingType] = 8
        m[rewindingType] = 2
    else
        m[rewindingType] *= 2
    end if
    m.top.FFRewCount = m[rewindingType]
end sub

function HandleRightKey(key as String) as Boolean
    StopRewFF()
    m.top.activeButton = key
    m.direction = key
    OnHoldDetection()
    m.holdTimer.control = "start"
    return true
end function

function HandleLeftKey(key as String) as Boolean
    StopRewFF()
    m.top.activeButton = key
    m.direction = key
    OnHoldDetection()
    m.holdTimer.control = "start"
    return true
end function

function HandleFastforwardKey(key as String) as Boolean
    m.rewindCount = invalid
    CheckRewindingCount("forwardCount")
    m.top.activeButton = key
    m.direction = key
    OnHoldRewind()
    m.holdRewind.control = "start"
    return true
end function

function HandleRewindKey(key as String) as Boolean
    m.forwardCount = invalid
    CheckRewindingCount("rewindCount")
    m.top.activeButton = key
    m.direction = key
    OnHoldRewind()
    m.holdRewind.control = "start"
    return true
end function

function HandleReplayKey(key as String) as Boolean
    m.top.activeButton = key
    m.top.progressPosition -= 20
    if m.top.progressPosition < 0 then m.top.progressPosition = 0
    StopRewFF(true)
    return true
end function

function HandleOkAndPlayKey(key as String) as Boolean
    m.direction = invalid
    m.top.activeButton = ""
    if m.top.progressPosition <> fix(GetVideoNode().position)
        StopRewFF(true)
        return true
    end if
    return false
end function

function HandleBackKey(key as String) as Boolean
    m.direction = invalid
    if m.top.progressPosition <> fix(GetVideoNode().position)
        StopRewFF(true)
        return true
    else
        return false
    end if
end function

function OnKeyEvent(key as String, press as Boolean) as Boolean
    handled = false

    if press = true
        ' block user interactions during loading of video
        handled = IsDoingSeek()
        if key = "right" and not handled
            handled = HandleRightKey(key)
        else if key = "left" and not handled
            handled = HandleLeftKey(key)
        else if key = "fastforward" and not handled
            handled = HandleFastforwardKey(key)
        else if key = "rewind" and not handled
            handled = HandleRewindKey(key)
        else if key = "replay"
            handled = HandleReplayKey(key)
        else if key = "play" or key = "OK"
            handled = HandleOkAndPlayKey(key)
        else if key = "back"
            handled = HandleBackKey(key)
        end if
    else if press = false
        if key = "right" or key = "left"
            m.holdTimer.control = "stop"
            if not IsDoingSeek()
                if m.direction = invalid
                    ' user release button to fast and needed logic is not invoked
                    m.direction = key
                    OnHoldDetection()
                end if
                StopRewFF(true)
            end if
            handled = true
        end if
    end if

    return handled
end function
