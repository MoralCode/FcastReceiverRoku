sub init()
	m.top.functionName = "listenToTcp"
end sub

function ByteArrayToHex(bytes as object) as string
	hexString = ""
	for each byte in bytes
		' Convert byte to hex (0-255)
		hex = Right("0" + StrI(byte, 16), 2)
		hexString += hex + " "
	end for
	return hexString
end function

function DecodeFCastPacket(bytes as object) as object
	if bytes = invalid or bytes.count() < 5 then return invalid

	' 1. Extract Length (First 4 bytes, Little Endian)
	' Index 0 is the lowest value, Index 3 is the highest value
	' Formula: byte0 + (byte1 << 8) + (byte2 << 16) + (byte3 << 24)
	headerLength = 5

	packetLength = bytes[0] + (bytes[1] * 256) + (bytes[2] * 65536) + (bytes[3] * 16777216)
	' opcode is the 5th byte
	opcode = bytes[4]

	print "Detected Packet Length: "; packetLength
	' 2. Validation
	actualDataSize = bytes.count() - headerLength

	data = invalid

	if actualDataSize < packetLength then
		print "ERROR: Incomplete packet. Need "; packetLength ; " but got "; actualDataSize
		return invalid
	else if actualDataSize > 0 then
		slice = bytes.Slice(headerLength, headerLength + packetLength)
		asciislice = slice.ToAsciiString()
		data = ParseJson(asciislice)
	end if

	return { opcode: opcode, payload: data }
end function

sub listenToTcp()
	' Create the TCP socket
	tcp = CreateObject("roStreamSocket")
	if tcp = invalid then
		print "ERROR: Failed to create socket."
		return
	end if

	bufferSize = 2048
	buffer = CreateObject("roByteArray")
	buffer[bufferSize] = 0

	' Create a message port to receive socket events
	port = CreateObject("roMessagePort")
	tcp.setMessagePort(port)

	' Setup the receiving address and bind to the specified port
	addr = CreateObject("roSocketAddress")
	addr.setAddress("0.0.0.0")
	addr.setPort(m.top.port)

	if not tcp.setAddress(addr) then
		print "ERROR: Could not set address."
		return
	end if

	if not tcp.eOK()
		print "Error creating listen socket"
		stop
	end if

	' Start listening (the '5' is the max backlog of connections)
	tcp.notifyReadable(true)
	tcp.listen(5)
	print "TCP Listener started on port: "; m.top.port

	while true
		' Wait for an event (connection request or data)
		msg = wait(0, port)

		if type(msg) = "roSocketEvent"
			socketID = msg.GetSocketID()

			' If the event is on our main listener, accept the connection
			if socketID = tcp.getID() and tcp.isReadable()
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
				closed = False
				if newConn <> invalid and socketID = newConn.getID()
					receivedByteCount = newConn.receive(buffer, 0, bufferSize)
					if receivedByteCount > 0
						' print ByteArrayToHex(buffer)
						fcastPacket = DecodeFCastPacket(buffer)
						if fcastPacket <> invalid then
							m.top.payload = fcastPacket

						end if
						buffer.clear()
					else if receivedByteCount = 0 ' client closed
						closed = True
					end if
					if closed or not newConn.eOK()
						' print "closing connection " changedID
						newConn.close()
						' newConn.delete(Stri(changedID))
					end if
				end if
			end if
		else 
			print "other event received"
		end if
	end while
end sub