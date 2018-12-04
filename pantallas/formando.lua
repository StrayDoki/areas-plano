formando = {}

-- ESTATICOS --
local posiciones_respuesta = {
  {x = 0, y = 0},
  {x = 315, y = 0},
}
local error = 30

-- DINAMICOS --
local imagenes
local offset 
local rotacion
local encontrados
local boton_atras
-----------------------
-- F U N C T I O N S --
----------------------- 
function crear_imagen(src, x, y)
  nueva_imagen = {
    src = src,
    x = x or 0,
    y = y or 0,
    rotacion = 0,
    width = src:getWidth(),
    height = src:getHeight(),
    estado = "reposo"
  }
  return nueva_imagen
end

function dibujar_imagen(imagen)
  love.graphics.draw(
    imagen.src,
    imagen.x,
    imagen.y,
    imagen.rotacion,
    1,1,
    imagen.width/2,
    imagen.height/2
  )
end

function esta_seleccionado(imagen,x,y)
  local x = x or love.mouse.getX()
  local y = y or love.mouse.getY()
  local esta_dentro = false

  if (
    x > imagen.x - imagen.width/2 and
    x < imagen.x + imagen.width/2 and
    y > imagen.y - imagen.height/2 and
    y < imagen.y + imagen.height/2
  ) then
    esta_dentro = true
  end
  return esta_dentro
end

function esta_en_centro(imagen,x,y)
  local x = x or love.mouse.getX()
  local y = y or love.mouse.getY()
  local esta_dentro = false

  if (
    x > imagen.x - error and
    x < imagen.x + error and
    y > imagen.y - error and
    y < imagen.y + error
  ) then
    esta_dentro = true
  end
  return esta_dentro
end

-------------
-- L O A D --
-------------
function formando.load()
  imagenes = {}
  offset = {
    x = 0,
    y = 0
  }
  encontrados = {}

  local src
  src = love.graphics.newImage( 'imagenes/figura.png' )
  imagenes[1] = crear_imagen(src, 100, 100)

  src = love.graphics.newImage( 'imagenes/figura.png' )
  imagenes[2] = crear_imagen(src, 500, 100)

  -- CREAR BOTON ATRAS
  local distancia = 50
  local boton_ancho = 150
  local boton_largo = 80
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

-------------
-- D R A W --
-------------
function formando.draw()
  love.graphics.setColor(1,1,1,1)
  for i=1, #imagenes do
    dibujar_imagen(imagenes[i])
  end

  boton_atras.draw()
end

-----------------
-- U P D A T E --
-----------------
function formando.update()
  for i=1, #imagenes do
    if imagenes[i].estado == "moviendo" then
      imagenes[i].x = love.mouse.getX() - offset.x
      imagenes[i].y = love.mouse.getY() - offset.y
    elseif imagenes[i].estado == "rotando" then
      local inicio = math.atan2(offset.y, offset.x)
      local final = math.atan2(love.mouse.getY()-imagenes[i].y, love.mouse.getX()-imagenes[i].x)
      imagenes[i].rotacion = rotacion + final - inicio
    end
  end

  boton_atras.update(
    love.mouse.getX(),
    love.mouse.getY()
  )
end

--------------------------------
-- M O U S E -- P R E S S E D --
--------------------------------
function formando.mousepressed(x,y)
  local seleccionado

  for i=1, #imagenes do
    if esta_seleccionado(imagenes[i]) then
      seleccionado = i
    end
  end

  if seleccionado ~= nil then
    if esta_en_centro(imagenes[seleccionado]) then
      imagenes[seleccionado].estado = "moviendo"
      offset = {
        x = x - imagenes[seleccionado].x,
        y = y - imagenes[seleccionado].y
      }
    -- else
    --   imagenes[seleccionado].estado = "rotando"
    --   offset = {
    --     x = x - imagenes[seleccionado].x,
    --     y = y - imagenes[seleccionado].y
    --   }
    --   rotacion = imagenes[seleccionado].rotacion
    end
  elseif boton_atras.estaSeleccionado(x,y) then
    cambiarPantalla(menu)
  end
end

----------------------------------
-- M O U S E -- R E L E A S E D --
----------------------------------
function formando.mousereleased(x,y)
  for i=1, #imagenes do
    imagenes[i].estado = "reposo"
  end

  encontrados = {}

  for i=1, #imagenes do
    for j=i+1, #imagenes do
      if (
        math.abs((imagenes[i].x - imagenes[j].x) - (posiciones_respuesta[i].x - posiciones_respuesta[j].x)) < error and
        math.abs((imagenes[i].y - imagenes[j].y) - (posiciones_respuesta[i].y - posiciones_respuesta[j].y)) < error
      ) then
        print ("true")
      end
    end
  end
end