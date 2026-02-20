sub init()
	m.top.functionName = "listenToTcp"
end sub

sub listenToTcp()
	' Create the TCP socket
	tcp = CreateObject("roStreamSocket")
	if tcp = invalid then
		print "ERROR: Failed to create socket."
		return
	end if

	' Create a message port to receive socket events
	port = CreateObject("roMessagePort")
	tcp.setMessagePort(port)

	' Setup the address and bind to the specified port
	addr = CreateObject("roSocketAddress")
	addr.setPort(m.top.port)

	if not tcp.setAddress(addr) then
		print "ERROR: Could not set address."
		return
	end if

	' Start listening (the '5' is the max backlog of connections)
	tcp.notifyReadable(true)
	tcp.listen(5)
	print "TCP Listener started on port: "; m.top.port

	while true
		' Wait for an event (connection request or data)
		msg = wait(0, port)

		if type(msg) = "roSocketEvent"
			socketID = msg.getSocketID()

			' If the event is on our main listener, accept the connection
			if socketID = tcp.getSocketID()
				newConn = tcp.accept()
				if newConn <> invalid
					print "--- New Connection Established ---"
					newConn.setMessagePort(port)
					newConn.notifyReadable(true)
				end if
			else
				' If the event is on an existing connection, receive data
				' Note: In a production app, you'd track individual connection objects
				' For this simple script, we use msg.getSocketID to identify the source.

				' We need to find which socket triggered the message
				' For simplicity, we assume the last accepted connection:
				if newConn <> invalid and socketID = newConn.getSocketID()
					receivedData = newConn.receive(10) ' Buffer size
					if receivedData <> invalid
						' Convert roByteArray to ASCII String and print
						print "Received: " ; receivedData.getText()
					else
						print "--- Connection Closed by Sender ---"
						newConn.close()
					end if
				end if
			end if
		end if
	end while
end sub