'cashe chidren nodes for future operations
Sub Init()
    m.background = m.top.findNode("background")
    m.progress = m.top.findNode("progress")
    m.scrubber = m.top.findNode("scrubber")
    m.scrubberPoster = m.top.findNode("scrubberPoster")
    m.adBlocks = m.top.findNode("ad")

    m.top.ObserveFieldScoped("focusedChild", "OnFocusChanged")
    m.scrubberPadding = -8
end Sub

sub OnFocusChanged()
    if m.top.IsInFocusChain()
        m.scrubberPoster.blendColor = m.top.progressColor
    else
        m.scrubberPoster.blendColor = m.top.backgroundColor
    end if
end sub

'triggers when duration bar width changes
Sub OnWidthChanged()
    m.background.width = m.top.width
end Sub

'triggers when duration bar height changes
Sub OnHeightChanged()
    m.background.height = m.top.height
    m.progress.height = m.top.height
end Sub

'triggers when duration bar color changes
Sub OnProgressColorChanged()
    m.progress.color = m.top.progressColor
end Sub

'triggers when duration bar background changes
Sub OnBackgroundColorChanged()
    m.background.color = m.top.backgroundColor
end Sub

sub LengthChanged()
    UpdateProgress()
    UpdateAdRange()
end sub

'update progress on duration bar
Sub UpdateProgress()
    if m.top.length > 0 AND m.top.progressPosition > 0 AND m.top.progressPosition <= m.top.length 
        progress = m.top.progressPosition / m.top.length
        m.progress.width = progress * m.background.width
    else
        m.progress.width = 0
    end if
    m.scrubber.translation = [m.progress.width+m.scrubberPadding, m.progress.height/2]
end Sub

sub UpdateAdRange()
    if m.top.length > 0
        adPods = m.top.adPods
        for each adPod in adPods
            adRectangle = CreateObject("roSGNode", "Rectangle")
            timeoffSet = GetTimeOffset(adPod)
            if timeoffSet = 0
                tmp = 0
            else
                tmp = timeoffSet / m.top.length
            end if
            translationX = tmp * m.background.width 
            adRectangle.translation = [translationX, 0]
            adRectangle.color="#f7f7f7"

            tmp1 = (timeoffSet+adPod.duration) / m.top.length
            duration = (tmp1 * m.background.width) -  translationX
            adRectangle.width = duration
            adRectangle.height = m.top.height
            m.adBlocks.appendChild(adRectangle)
        end for
    end if
end sub

function GetTimeOffset(adPod as Object)
    if adPod.renderSequence = "preroll"
        return 0
    else if adPod.renderSequence = "postroll"
        return m.top.length - adPod.duration
    else
        return adPod.renderTime
    end if
end function
