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


cfg={}
cfg.ssid="bba"
cfg.pwd="12345678"
wifi.ap.config(cfg)

cfg={}
cfg.ip="192.168.1.1";
cfg.netmask="255.255.255.0";
cfg.gateway="192.168.1.1";
wifi.ap.setip(cfg);
wifi.setmode(wifi.SOFTAP)

-- Create a server
-- and set 30s time out for a incative client 

sv = net.createServer(net.TCP, 30)

-- Server listen on 80
-- Print HTTP headers to console
sv:listen( 80, function(c)
	c:on("receive", function(conn, playload)
		print(playload)
		if(string.find(playload, "/ha") ~= nil) then
			if( g.read(red_pin) == 1) then
				w(red_pin, ON)
			else
				w(red_pin, OFF)
			end
		end

		conn:send("HTTP/1.0 200 OK\n\r")
		conn:close()
	end)
end)



