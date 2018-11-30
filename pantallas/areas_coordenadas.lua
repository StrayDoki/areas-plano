areas_coordenadas = {}

local puntos_iniciales = {
  cuadrilatero = {
    {x = 2, y = 10},
    {x = 4, y = 2},
    {x = 8, y = 3},
    {x = 11, y = 10}
  }
}
local distancia = 50

local figura_inicial
local puntos
local lineas

function areas_coordenadas.load()
  puntos = {}
  figura_inicial = "cuadrilatero"
  
  -- CREANDO PUNTOS INICIALES
  for i = 1, #puntos_iniciales.cuadrilatero do
    puntos[i] = puntos_iniciales.cuadrilatero[i]
  end

  
end

function areas_coordenadas.draw()
  -- DIBUJANDO COORDENADAS
  love.graphics.setLineWidth(1)
  love.graphics.setColor(0.8,0.8,0.8)
  for i = distancia, love.graphics.getWidth() - distancia, distancia do
    love.graphics.line(i,0,i,love.graphics.getHeight())
  end
  for i = distancia, love.graphics.getHeight() - distancia, distancia do
    love.graphics.line(0,i,love.graphics.getWidth(),i)
  end

  -- DIBUJANDO POLÍGONO
  love.graphics.setLineWidth(3)
  love.graphics.setColor(0,0,0)
  for i = 1, #puntos do
    if i ~= #puntos then
      love.graphics.line(puntos[i].x * distancia,puntos[i].y * distancia,puntos[i+1].x * distancia,puntos[i+1].y*distancia)
    else
      love.graphics.line(puntos[i].x * distancia,puntos[i].y * distancia,puntos[1].x * distancia,puntos[1].y*distancia)
    end
  end

  -- DIBUJANDO PUNTOS
  love.graphics.setLineWidth(3)
  local radio_punto = 5
  for i = 1, #puntos do
    love.graphics.setColor(0.5,0.5,1)
    love.graphics.circle("fill",puntos[i].x * distancia, puntos[i].y * distancia, radio_punto)
    love.graphics.setColor(0,0,0)
    love.graphics.circle("line",puntos[i].x * distancia, puntos[i].y * distancia, radio_punto)
  end
end

function calcular_area()

end