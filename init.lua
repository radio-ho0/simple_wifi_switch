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
pin.D3 = 3
pin.D4 = 4
pin.D5 = 5
pin.D6 = 6
pin.D7 = 7

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
cfg.ip="192.168.192.1";
cfg.netmask="255.255.255.0";
cfg.gateway="192.168.192.1";
wifi.ap.setip(cfg);
wifi.setmode(wifi.SOFTAP)

-- Create a server
-- and set 30s time out for a incative client 
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
        local buf = "";
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        local _GET = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                _GET[k] = v
            end
        end
        buf = buf.."<h1>Simple WiFi Switch</h1>";
        buf = buf.."<p>GPIO0 <a href=\"?code=O0\"><button>ON</button></a>&nbsp;<a href=\"?code=C0\"><button>OFF</button></a></p>";
        buf = buf.."<p>GPIO1 <a href=\"?code=O1\"><button>ON</button></a>&nbsp;<a href=\"?code=C1\"><button>OFF</button></a></p>";
        buf = buf.."<p>GPIO2 <a href=\"?code=O2\"><button>ON</button></a>&nbsp;<a href=\"?code=C2\"><button>OFF</button></a></p>";
        buf = buf.."<p>GPIO3 <a href=\"?code=O3\"><button>ON</button></a>&nbsp;<a href=\"?code=C3\"><button>OFF</button></a></p>";
        buf = buf.."<p>GPIO4 <a href=\"?code=O4\"><button>ON</button></a>&nbsp;<a href=\"?code=C4\"><button>OFF</button></a></p>";
        buf = buf.."<p>GPIO5 <a href=\"?code=O5\"><button>ON</button></a>&nbsp;<a href=\"?code=C5\"><button>OFF</button></a></p>";
        buf = buf.."<p>GPIO6 <a href=\"?code=O6\"><button>ON</button></a>&nbsp;<a href=\"?code=C6\"><button>OFF</button></a></p>";
        buf = buf.."<p>GPIO7 <a href=\"?code=O7\"><button>ON</button></a>&nbsp;<a href=\"?code=C7\"><button>OFF</button></a></p>";
        local _on,_off = "",""

	if _GET.code then
		local data = _GET.code
		print(_GET.code)
		print( type(data) .." got data " .. data)
		local cmd = string.sub(data, 1,1)
		local pin_str  = string.sub(data, 2,-1)
		local pin  = tonumber(pin_str)
		if type(pin) == "number" then
			if cmd == "C" then
				w(pin, OFF)
			elseif cmd == "O" then
				w(pin, ON)
			end
		end
	end

        client:send(buf);
        client:close();
        collectgarbage();
    end)
end)

function parseCode( code )

end
