sub init()

	m.busyspinner = m.top.findNode("Spinner")
	m.busyspinner.poster.observeField("loadStatus", "showspinner")

	ipAddress = m.top.findNode("ipAddress")
	networkInterface = m.top.findNode("networkInterface")
	ipData = GetFirstLocalIPAddress()
	ipAddress.text = ipData.value
	networkInterface.text = ipData.key


	' 1. Find your UI elements if you need to update them later
	' m.statusLabel = m.top.findNode("StatusLabel")

	' 2. Create the Task node
	m.tcpTask = CreateObject("roSGNode", "TcpListenerTask")

	' 3. Set the port (optional, as it has a default in the XML)
	m.tcpTask.port = 46899

	' 4. Observe fields if you want the Task to send data back to the UI
	' m.tcpTask.observeField("receivedMessage", "onMessageReceived")

	' 5. Start the thread
	m.tcpTask.control = "RUN"

	print "TCP Task Thread Started..."

	' Pre-create the player but keep it hidden
	m.player = CreateObject("roSGNode", "VideoPlayerScene")
	m.player.visible = false
	m.top.appendChild(m.player)

	m.top.setFocus(true)
end sub

sub showspinner()
	if(m.busyspinner.poster.loadStatus = "ready")

		m.busyspinner.visible = true
	end if
end sub

sub onVisibleChange()
	if m.top.visible = true
		m.tcpTask.control = "RUN"
	else
		m.tcpTask.control = "STOP"
	end if
end sub