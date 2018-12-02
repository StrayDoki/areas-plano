formando = {}

-- ESTATICOS --
local figuras = {
  casa = {
    {x = 1, y = 7},
    {x = 6, y = 2},
    {x = 11, y = 7},
    {x = 9, y = 7},
    {x = 9, y = 12},
    {x = 3, y = 12},
    {x = 3, y = 7},
  }
}
local respuestas = {
  casa = {
    {
      {x = 9, y = 7},
      {x = 3, y = 7},
    },
  }
}
local partes = {
  casa = {
    {
      {x = 1, y = 7},
      {x = 6, y = 2},
      {x = 11, y = 7},
    },
  }
}
local condiciones = {
  casa = {
    {1}
  }
}
local distancia = 50
local radio_punto = 5

-- DINAMICOS --
local figura_actual
local respuesta_actual
local condicion_actual
local puntos
local segmentos
local segmento_adicional
local respuestas_encontradas
local partes_encontradas

function formando.load()
  puntos = {}
  segmento_adicional = {}
  respuestas_encontradas = {}
  partes_encontradas = {}

  figura_actual = "casa"
    
  if (figura_actual == "casa") then
    puntos = figuras.casa
    respuesta_actual = respuestas.casa
    condicion_actual = condiciones.casa
  end
end

function formando.draw()
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
    local sgte = i % #puntos + 1
    love.graphics.line(puntos[i].x * distancia,puntos[i].y * distancia,puntos[sgte].x * distancia,puntos[sgte].y*distancia)
  end

  -- DIBUJANDO SEGMENTO ADICIONAL
  if #segmento_adicional == 2 then
    love.graphics.setLineWidth(3)
    love.graphics.setColor(0,0,0)
    love.graphics.line(segmento_adicional[1].x,segmento_adicional[1].y,segmento_adicional[2].x,segmento_adicional[2].y)
  end

  -- DIBUJANDO LAS RESPUESTAS YA ENCONTRADAS
  love.graphics.setLineWidth(3)
  love.graphics.setColor(0,0,0)
  for i=1, #respuestas_encontradas do
    local respuesta_encontrada = respuesta_actual[respuestas_encontradas[i]]
    love.graphics.line(
      respuesta_encontrada[1].x * distancia,
      respuesta_encontrada[1].y * distancia,
      respuesta_encontrada[2].x * distancia,
      respuesta_encontrada[2].y * distancia
    )
  end

  -- DIBUJANDO PUNTOS DEL SEGMENTO ADICIONAL
  love.graphics.setLineWidth(3)
  for i = 1, #segmento_adicional do
    love.graphics.setColor(0.5,0.5,1)
    love.graphics.circle("fill",segmento_adicional[i].x, segmento_adicional[i].y, radio_punto)
    love.graphics.setColor(0,0,0)
    love.graphics.circle("line",segmento_adicional[i].x, segmento_adicional[i].y, radio_punto)
  end

end

function formando.mousepressed(x,y)
  local punto = {
    x = x,
    y = y
  }

  if #segmento_adicional == 2 then
    segmento_adicional = {}
  end

  for i=1, #respuesta_actual do
    for j=1, 2 do
      local respuesta = {
        x = respuesta_actual[i][j].x * distancia,
        y = respuesta_actual[i][j].y * distancia
      }
      local distancia_a_respuesta = math.sqrt( (punto.x - respuesta.x)^2 + (punto.y - respuesta.y)^2 )
      if distancia_a_respuesta <= distancia/4 then
        punto.x = respuesta.x
        punto.y = respuesta.y
      end 
    end
  end

  segmento_adicional[#segmento_adicional+1] = punto

  -- SI EL SEGMENTO ES UNA RESPUESTA, LO ALMACENA
  if #segmento_adicional == 2 then
    for i=1, #respuesta_actual do
      local caso_1 = (
        segmento_adicional[1].x == respuesta_actual[i][1].x * distancia and
        segmento_adicional[1].y == respuesta_actual[i][1].y * distancia and
        segmento_adicional[2].x == respuesta_actual[i][2].x * distancia and
        segmento_adicional[2].y == respuesta_actual[i][2].y * distancia
      )

      local caso_2 = (
        segmento_adicional[2].x == respuesta_actual[i][1].x * distancia and
        segmento_adicional[2].y == respuesta_actual[i][1].y * distancia and
        segmento_adicional[1].x == respuesta_actual[i][2].x * distancia and
        segmento_adicional[1].y == respuesta_actual[i][2].y * distancia
      )
      if caso_1 or caso_2 then
        --aca deberia verificar si es que ya existe
        respuestas_encontradas[#respuestas_encontradas+1] = i
      end
    end
  end

  print(#respuestas_encontradas)

  -- SI UNA FORMA ESTA ENCONTRADA, LO ALMACENA
  for i=1, #respuestas_encontradas do
    for j=1, #condicion_actual do
      local condiciones = 0
      for k=1, #condicion_actual[j] do
        if respuestas_encontradas[i] == condicion_actual[j][j] then
          condiciones = condiciones + 1
        end
      end
      if condiciones == #condicion_actual[j] then
      end
      -- si la condicion es igual al maximo entonces la forma es almacenada
    end
  end
end