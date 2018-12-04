areas_coordenadas = {}

-- ESTATICOS --
local puntos_iniciales = {
  triangulo = {
    {x = 2, y = 10},
    {x = 8, y = 3},
    {x = 12, y = 10},
  },
  cuadrilatero = {
    {x = 2, y = 10},
    {x = 4, y = 2},
    {x = 8, y = 3},
    {x = 12, y = 10},
  }
}
local distancia = 50
local radio_punto = 5

-- DINAMICOS --
local figura_actual
local puntos
local lineas
local area
local boton_triangulo
local boton_cuadrilatero
local boton_atras

function areas_coordenadas.load()

  puntos = {}
  figura_actual = "triangulo"
  
  -- CREANDO PUNTOS INICIALES
  for i = 1, #puntos_iniciales.triangulo do
    puntos[i] = puntos_iniciales.triangulo[i]
    puntos[i].estado = "reposo"
  end

  -- CALCULANDO AREA
  area = calcular_area()  

  -- CREANDO BOTONES
  boton_triangulo = crearBoton(
    16 * distancia,
    4 * distancia,
    3 * distancia,
    2 * distancia,
    {1,0.2,0.2},
    "TRIANGULO",
    18,
    {1,1,1},
    4
  )

  boton_cuadrilatero = crearBoton(
    16 * distancia,
    7 * distancia,
    3 * distancia,
    2 * distancia,
    {0.2,0.2,1},
    "CUADRILATERO",
    18,
    {1,1,1},
    4
  )

  -- CREANDO BOTON
  local boton_ancho = distancia*3
  local boton_largo = distancia*2
  boton_atras = crearBoton(
    love.graphics.getWidth() - distancia - boton_ancho,
    love.graphics.getHeight() - distancia - boton_largo,
    boton_ancho,
    boton_largo,
    {0.2,0.2,0.2}, -- color de fondo
    "ATRAS",
    40, -- tamaño de texto
    {1,1,1}, --color de texto
    8
  )
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

  -- DIBUJANDO BOTON
  boton_triangulo.draw()
  boton_cuadrilatero.draw()
  boton_atras.draw()
  
  -- DIBUJANDO POLÍGONO
  love.graphics.setLineWidth(3)
  love.graphics.setColor(0,0,0)
  for i = 1, #puntos do
    local sgte = i % #puntos + 1
    love.graphics.line(puntos[i].x * distancia,puntos[i].y * distancia,puntos[sgte].x * distancia,puntos[sgte].y*distancia)
  end

  -- DIBUJANDO PUNTOS
  love.graphics.setLineWidth(3)
  for i = 1, #puntos do
    love.graphics.setColor(0.5,0.5,1)
    love.graphics.circle("fill",puntos[i].x * distancia, puntos[i].y * distancia, radio_punto)
    love.graphics.setColor(0,0,0)
    love.graphics.circle("line",puntos[i].x * distancia, puntos[i].y * distancia, radio_punto)
  end

  -- DIBUJANDO AREA
  love.graphics.setLineWidth(3)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle("line",16*distancia,1*distancia,3*distancia,2*distancia)
  local texto_area = "Area = " .. area
  dibujarTexto(texto_area, 17.5*distancia, 2*distancia, 24, {0,0,0})
end

function areas_coordenadas.update(dt)
  -- ACTUALIZA LOS PUNTOS
  for i = 1, #puntos do
    local estado = puntos[i].estado
    if estado == "reposo" then
    elseif estado == "siguiendo" then
      puntos[i].x = math.floor ( (love.mouse.getX()+distancia/2) / distancia)
      puntos[i].y = math.floor ( (love.mouse.getY()+distancia/2) /distancia)
      area = calcular_area()
    end
  end

  -- BOTON CAMBIA DE COLOR SI ESTA SELECCIONADO
  boton_triangulo.update(love.mouse.getX(), love.mouse.getY())
  boton_cuadrilatero.update(love.mouse.getX(), love.mouse.getY())
  boton_atras.update(love.mouse.getX(), love.mouse.getY())
end

function areas_coordenadas.mousepressed(x,y)
  for i = 1, #puntos do
    local punto = {
      x = puntos[i].x * distancia,
      y = puntos[i].y * distancia
    }
    local distancia_mouse = math.sqrt ( (x - punto.x)^2 + (y-punto.y)^2 )
    if distancia_mouse < distancia/2 then
      puntos[i].estado = "siguiendo"
      return
    end 
  end

  if boton_triangulo.estaSeleccionado(x,y) then
    puntos = {}
    figura_actual = "triangulo"
    
    -- CREANDO PUNTOS INICIALES
    for i = 1, #puntos_iniciales.triangulo do
      puntos[i] = puntos_iniciales.triangulo[i]
      puntos[i].estado = "reposo"
    end

    area = calcular_area()  
  end

  if boton_cuadrilatero.estaSeleccionado(x,y) then
    puntos = {}
    figura_actual = "cuadrilatero"
    
    -- CREANDO PUNTOS INICIALES
    for i = 1, #puntos_iniciales.cuadrilatero do
      puntos[i] = puntos_iniciales.cuadrilatero[i]
      puntos[i].estado = "reposo"
    end

    area = calcular_area()  
  end

  if boton_atras.estaSeleccionado(x,y) then
    cambiarPantalla(menu)
  end
end

function areas_coordenadas.mousereleased(x,y)
  for i = 1, #puntos do
    puntos[i].estado = "reposo"
  end
end

function calcular_area()
  local doble_area = 0
  for i=1, #puntos do
    local sgte = i % #puntos + 1
    local prev = (i - 2) % #puntos + 1
    doble_area = doble_area + puntos[i].x * (puntos[sgte].y - puntos[prev].y) 
  end
  return math.abs(doble_area/2)
end