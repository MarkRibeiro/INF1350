-- MUDAR meu id!!!!
local meuid = "1612043"
local m = mqtt.Client("noemi_melhor_prof" .. meuid, 120)
local led1 = 0
local led2 = 6
local led1On = true
local led2On = true
gpio.mode(led1, gpio.OUTPUT)
gpio.mode(led2, gpio.OUTPUT)
gpio.write(led1, gpio.HIGH);
gpio.write(led2, gpio.HIGH);

function publica(c)
  c:publish("nodelove1612043","alo de " .. meuid,0,0, 
            function(client) print("mandou!") end)  
end

function novaInscricao (c)
  local msgsrec = 0
  function novamsg (c, t, m)
    if m=="1" then
        if led1On == false then
            gpio.write(led1, gpio.HIGH);
        else
            gpio.write(led1, gpio.LOW);
        end 
        led1On = not led1On
    else
        if led2On == false then
            gpio.write(led2, gpio.HIGH);
        else
            gpio.write(led2, gpio.LOW);
        end 
        led2On = not led2On
    end
  end
  c:on("message", novamsg)
end

function conectado (client)
  publica(client)
  client:subscribe("lovenode1612043", 0, novaInscricao)
end 

m:connect("broker.hivemq.com", 1883, false, 
             conectado,
             function(client, reason) print("failed reason: "..reason) end)



        


