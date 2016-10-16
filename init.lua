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

        kit = require("kit")
        client:send( kit.main_page_header )
        -- buf = buf .. getPinString(pin.D0)
        for k,v in pairs( pin ) do
            local row =  getPinString(v)
            client:send( row );
        end

        local _on,_off = "",""

        if _GET.code then
            parseCode( _GET.code )
        end

        client:send( kit.main_page_footer)
        client:close();
        collectgarbage();
    end)
end)

function parseCode( code )
            local data = code
            print( data )
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

function getPinString( pin )
    local status = g.read(pin)
    local checked_str = "";
    if status == ON then
        checked_str = "checked"
    end

    local switch_str = [[
        <label class="switch">
            <input type="checkbox" disabled %s>
            <div class="slider"></div>
        </label>
    ]]
    switch_str = string.format(switch_str, checked_str)

    local str = "";
    str = str .. switch_str
    str = str ..  "<p>GPIO%d <a href=\"?code=O%d\"><button>ON</button></a>&nbsp;<a href=\"?code=C%d\"><button>OFF</button></a></p>";
    str = string.format(str, pin, pin, pin)
    return str
end
