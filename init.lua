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
sv = require("http")
sv.createServer(80, function(req, res)
	req.ondata = function(self, chunk)
		-- end of this request ?
		if not chunk then
			res:send(nil, 200)
			res:send_header("Connection", "close")
			res:send_header("Content-Type", "text/html")
			res:send("<!DOCTYPE html>")
			res:send("<html><head><title>")
			res:send("Simple WiFi Switch")
			res:send("</title></head>")
			res:send("<body>")
			res:send("<h1>Hello ele1000</h1>")
			res:send("</body></html>")
			res:finish()
		end
	end
	req.onreceive = function(self, chunk)
		if chunk then
			print("onreceive " .. chunk )
		end
	end
end)
