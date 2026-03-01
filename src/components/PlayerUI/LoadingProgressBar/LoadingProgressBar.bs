sub init()
    m.loadingAnimation = m.top.FindNode("loadingAnimation")
    m.loadingInterpolator = m.top.FindNode("loadingInterpolator")
end sub

sub OnWidthChanged()
    if m.top.width > 0
        m.loadingInterpolator.keyValue = [0, m.top.width]
        m.loadingAnimation.control = "start"
    else
        m.loadingAnimation.control = "stop"
    end if
end sub
