--PANTALLA DONDE LOS ESTUDIANTES TIENEN UNA FIGURA Y ENCAJAN
encajando = {}

local cfg = {
  puntos = {
    distancia = 50
  }
}

local triangulos = {
  {
    400,200,
    200,600,
    740,600
  }
}

local triangulo_actual
local puntos

function encajando.load ()

  -- CREANDO LOS PUNTOS
  puntos = {}

  -- TRIANGULO QUE SE MUESTRA
  triangulo_actual = 1
end

function encajando.draw()
  --DIBUJANDO TRIANGULO
  love.graphics.setColor(0,0,0)
  love.graphics.setLineWidth(5)
  love.graphics.polygon("line", triangulos[triangulo_actual])
end

function encajando.mousepressed(x,y)
  --AÑADIENDO PUNTOS
  local nuevo_punto = {
    x = x,
    y = y
  }
  print ("nuevo punto", nuevo_punto.x, nuevo_punto.y)
  puntos = nuevo_punto
end

function calcular_altura(triangulo, base) do
  local base
  if base == 1 then
    base = {
      x1 = triangulo[1],
      y1 = triangulo[2],
      x2 = triangulo[3],
      y2 = triangulo[4],
    }
  elseif base == 2 then
    base = {
      x1 = triangulo[3],
      y1 = triangulo[4],
      x2 = triangulo[5],
      y2 = triangulo[6],
    }
  elseif base == 3 then
    base = {
      x1 = triangulo[5],
      y1 = triangulo[6],
      x2 = triangulo[1],
      y2 = triangulo[1],
    }  
  end

  local m1, m2
  if base.x1 ~= base.x2 then
    m1 = (base.y2 - base.y1) / (base.x2 - base.x1)
  else
    m1 = 
  end
  local m2 = 1 / (-m1)
end