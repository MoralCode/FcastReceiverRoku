sub init()

	m.busyspinner = m.top.findNode("Spinner")
	m.busyspinner.poster.observeField("loadStatus", "showspinner")

	m.top.setFocus(true)
end sub

sub showspinner()
	if(m.busyspinner.poster.loadStatus = "ready")

		m.busyspinner.visible = true
	end if
end sub