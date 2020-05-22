local xinit = 50
local yinit = 50

function love.load()
  ret1 = retangulo (50, 200, 200, 150)
end

function love.update (dt)
  local mx, my = love.mouse.getPosition()
end

function love.keypressed(key)
  ret1.keypressed(key)
end

function naimagem (mx, my, x, y, w, h) 
  return (mx>x) and (mx<x+w) and (my>y) and (my<y+h)
end

function retangulo (x,y,w,h)
  local oriX, oriY, rx, ry, rw, rh = x, y, x, y, w, h
  return {
    draw = 
      function()
        love.graphics.rectangle("line", rx, ry, rw, rh)
      end,
    keypressed = 
      function(key)
        local mx, my = love.mouse.getPosition() 
        if key == 'b' and naimagem (mx,my, rx, ry, rw, rh) then
          ry = oriY
          rx = oriX
        end
        if key == "down" and naimagem (mx, my, rx, ry, rw, rh)  then
          ry = ry + 10
        end
        if key == "right" and naimagem (mx, my, rx, ry, rw, rh)  then
          rx = rx + 10
        end
      end
  }
end

function love.draw ()
  ret1.draw()
end
    