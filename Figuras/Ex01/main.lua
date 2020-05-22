--Grupo: Felipe Metson - 1520302
--       Mark Ribeiro - 1612043 
local figuras = {}

local tempoexib = 1

local limite = 10

local function novafigura (x, y, larg, alt)
-- nova figura deve existir no retangulo
-- com canto superior esquerdo em x e y
  local partes
  local st = true
  local tempoCorrido = 0
  local function main (dt)
          local espera 
          partes = {}
          while tempoCorrido < math.random(1, 5) do
            tempoCorrido = tempoCorrido + dt
            dt=coroutine.yield()
          end
          tempoCorrido = 0
                              
          table.insert (partes, {tipo = "rect",
                                 x = x,
                                 y = y,
                                 w = larg,
                                 h = alt
                                })
          while tempoCorrido < math.random(1, 5) do
            tempoCorrido = tempoCorrido + dt
            dt=coroutine.yield()
          end
          tempoCorrido = 0  
                            
          table.insert (partes, {tipo = "circ",
                                 x = x + larg/3,
                                 y = y + 2*(alt/5),
                                 r = math.min(larg/10, alt/10)
                                })
                              
          while tempoCorrido < math.random(1, 5) do
            tempoCorrido = tempoCorrido + dt
            dt=coroutine.yield()
          end
          tempoCorrido = 0
                              
          table.insert (partes, {tipo = "circ",
                                 x = x + 2*(larg/3),
                                 y = y + 2*(alt/5),
                                 r = math.min(larg/10, alt/10)
                                })
                              
          while tempoCorrido < math.random(1, 5) do
            tempoCorrido = tempoCorrido + dt
            dt=coroutine.yield()
          end
                              
          table.insert (partes, {tipo = "rect",
                                 x = x + (larg/2) - larg/10,
                                 y = y + 2*(alt/3) - alt/20,
                                 w = larg/5,
                                 h = alt/10
                                })
        end
  local coFigura = coroutine.create(main)
  return { 
    update = function(dt)
      coroutine.resume(coFigura, dt)
    end,

    draw = function ()
             for _, p in ipairs(partes) do
               if p.tipo == "rect" then
                 love.graphics.rectangle ("line", p.x, p.y, p.w, p.h)
               elseif p.tipo == "circ" then
                 love.graphics.circle ("line", p.x, p.y, p.r)
               end
             end
           end
           
  }
end

function love.load()
  figuras = {}
  local w, h = love.graphics.getDimensions()
  for i=1, limite do
     figuras[i] = novafigura((w/2 - w/20)*i*0.1, (h/2-h/20)*i*0.1, (w/10)*i*0.1, (h/10)*i*0.1)
     
  end
end 

function love.update (dt)
  for i = 1, #figuras do
    figuras[i].update(dt)
  end
end

function love.draw()
  for i = 1, #figuras do
    figuras[i].draw()
  end
end

function love.quit ()
  os.exit()
end
