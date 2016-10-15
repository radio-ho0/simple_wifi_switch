g = gpio
L = g.LOW
H = g.HIGH
w = g.write
m = g.mode

ON  = H
OFF = L

pin = {}
pin.D0 = 0
pin.D1 = 1
pin.D2 = 2

for k, v in pairs(pin) do
	print(k, v)
	m(v, g.OUTPUT)
	w(v, g.LOW)
end

red_pin = pin.D0
green_pin = pin.D1
blue_pin = pin.D2
 -- my AP 
--[[
ap_name_cfg = {}
ap_name_cfg.ssid = "simple_switch_ap"
ap_name_cfg.pwd="1008610086"
wifi.ap.config(ap_name_cfg)

ap_ip_cfg = {}
ap_ip_cfg.ip="192.168.192.1"
ap_ip_cfg.netmask="255.255.255.0"
ap_ip_cfg.geteway="192.168.192.1"
wifi.ap.setip(ap_ip_cfg)
wifi.setmode(wifi.SOFTAP)

]]


wifi.setmode(wifi.STATION)
wifi.sta.config("johnAP", "hero08hero08")
wifi.sta.autoconnect(1)

-- Create a server
-- and set 30s time out for a incative client 

sv = net.createServer(net.TCP, 30)

-- Server listen on 80
-- Print HTTP headers to console
sv:listen( 80, function(c)
	c:on("receive", function(conn, playload)
		print(playload)
		if(string.find(playload, "/ha") ~= nil) then
			w(red_pin, ON)
		end

		conn:send("HTTP/1.0 200 OK\n\r")
		conn:close()
	end)
end)


