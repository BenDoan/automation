high = gpio.HIGH
low = gpio.LOW
pins = {false,false,false,false,false}
for i=0,table.getn(pins) do
    gpio.mode(i,gpio.OUTPUT);
end
srv = net.createServer(net.TCP, 30)
thing = gpio.HIGH

srv:listen(80,function(conn)
    conn:on('receive', function(conn,payload)
        print(payload)
        q = string.match(payload,"GET%s+%S+")
        print("AASDF :"..q..":\n")
        si,ei = string.find(q,"GET%s+")
        path = string.sub(q,ei+1,string.len(q))
        print(path)
        num = tonumber(string.match(path,"%d"))
        print(num)
        if num == nil then
            conn:send('HTTP/1.1 500 ERROR\n\n')
            conn:send('invalid query, no number\n')
            conn:on('sent',function(conn) conn:close() end)
            return
        end
        num = num + 1
        if string.find(path,"on") then
            pins[num] = true
        elseif string.find(path,"off") then
            pins[num] = false
        else
            if pins[num] then
                pins[num] = false
            else
                pins[num] = true
            end
        end
        if pins[num] then
            gpio.write(num-1,gpio.HIGH)
        else
            gpio.write(num-1,gpio.LOW)
        end
        conn:send('HTTP/1.1 200 OK\n\n')
        for i=1,table.getn(pins) do
            print(i..'')
            conn:send((i-1)..' : '..tostring(pins[i])..'\n')
        end
        conn:on('sent',function(conn) conn:close() end)
    end)
end)
