sub init()

	m.busyspinner = m.top.findNode("Spinner")
	m.busyspinner.poster.observeField("loadStatus", "showspinner")

	ipAddress = m.top.findNode("ipAddress")
	networkInterface = m.top.findNode("networkInterface")
	ipData = GetFirstLocalIPAddress()
	ipAddress.text = ipData.value
	networkInterface.text = ipData.key

	m.top.setFocus(true)
end sub

sub showspinner()
	if(m.busyspinner.poster.loadStatus = "ready")

		m.busyspinner.visible = true
	end if
end sub