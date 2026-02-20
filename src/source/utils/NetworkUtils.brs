function GetFirstLocalIPAddress() as Object
	deviceInfo = CreateObject("roDeviceInfo")
	return deviceInfo.GetIPAddrs().items()[0]
end function
