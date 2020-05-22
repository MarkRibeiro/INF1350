--Grupo: Felipe Metson - 1520302
--       Mark Ribeiro - 1612043     
arrayBlip = {}
local player
local maxLoops = 3
local iniBlips = 5
local maxImortals = 3
local w, h = love.graphics.getDimensions()
local centerX, centerY = w/2, h/2
local gameState = "Game"
local font = love.graphics.newFont(56)
local textW = love.graphics.newText(font, "Ganhou")
local textL = love.graphics.newText(font, "Perdeu")
local timePassed = 0
local timeToSpawn = love.math.random(50)/10 +2
math.randomseed(os.time())
local function newblip (vel)
  local x, y = 0, 0
  local tam = 40
  local loops = 0
  return {
    update = function (dt)
      local width, _ = love.graphics.getDimensions( )
      x = x+(vel+1)*dt*40
      if x > width then
        -- volta para a esquerda da janela
        loops = loops + 1
        x = 0
      end
    end,
    dead = false,
    affected = function (pos)
      if loops >= maxLoops then
        return false
      end
      if pos>x and pos<x+tam then
      -- "pegou" o blip
        dead = true
        return true
      else
        return false
      end
    end,
    draw = function ()
      if loops >= maxLoops then
        love.graphics.setColor(1, 0, 0)
      else
        love.graphics.setColor(1, 1, 1)
      end
      love.graphics.rectangle("line", x, y, tam, 10)
    end,
    isImortal = function ()
      return loops >= maxLoops
    end
  }
end

local function newplayer ()
  local x, y = 0, 200
  local tam = 30
  local width, height = love.graphics.getDimensions( )
  return {
  try = function ()
    return x + tam/2
  end,
  update = function (dt)
    x = x + 0.5*30*dt
    if x > width then
      x = 0
    end
  end,
  draw = function ()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", x, y, tam, 10)
  end
  }
end

function love.keypressed (key)
  if key == 'space' then
    pos = player.try()
    local allDead = true
    for i=1, #arrayBlip do
      if arrayBlip[i].affected(pos) then
        arrayBlip[i].dead = true
        
      end
      if arrayBlip[i].dead == false then
        allDead = false
      end
    end 
    if allDead == true then
      gameState = "Ganhou"
    end
  end
end


function love.load()
  player =  newplayer()
    for i=1, iniBlips do
      arrayBlip[i] = newblip(love.math.random(100)/10)
    end
end

function love.draw()
  if gameState == "Game" then
    player.draw()
    for i=1, #arrayBlip do
      if arrayBlip[i].dead == false then
        arrayBlip[i].draw()
      end
    end
  elseif gameState == "Ganhou" then
    love.graphics.setBackgroundColor(0, 1, 0)
    love.graphics.draw(textW, centerX-textW:getWidth()/2, centerY-textW:getHeight()/2)
  elseif gameState == "Perdeu" then
    love.graphics.setBackgroundColor(1, 0, 0)
    love.graphics.draw(textL, centerX-textL:getWidth()/2, centerY-textL:getHeight()/2)
  end
end

function love.update(dt)
  if gameState == "Game" then
    timeToSpawn = timeToSpawn - dt
    if timeToSpawn <= 0 then
      arrayBlip[#arrayBlip+1] = newblip(love.math.random(100)/10)
      timeToSpawn = love.math.random(50)/10 + 2
    end    
    player.update(dt)
    local numImortals = 0
    local numAlive = #arrayBlip
    for i=1, #arrayBlip do
      arrayBlip[i].update(dt)
      if arrayBlip[i].isImortal() == true and arrayBlip[i].dead == false then
        numImortals = numImortals + 1
      end
      if arrayBlip[i].dead == true then
        numAlive = numAlive - 1
      end
    end
    
    if(numImortals >= maxImortals) then
      gameState = "Perdeu"
    end
    if numAlive == numImortals then 
      gameState = "Ganhou"
    end
    
  end
end
function love.quit ()
  love.window.close()
  os.exit()
end
