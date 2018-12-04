formando = {}

-- ESTATICOS --
local posiciones_respuesta = {
  {x = 484, y = 172},
  {x = 553, y = 202},
  {x = 416, y = 202},
  {x = 554, y = 281},
  {x = 415, y = 281},
  {x = 484, y = 241},
  {x = 484, y = 325},
}
local error = 10

-- DINAMICOS --
local imagenes
local offset 
local rotacion
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
    x > imagen.x - 3*error and
    x < imagen.x + 3*error and
    y > imagen.y - 3*error and
    y < imagen.y + 3*error
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

  local src
  src = love.graphics.newImage( 'imagenes/robot1.png' )
  imagenes[1] = crear_imagen(src, 310, 151)

  src = love.graphics.newImage( 'imagenes/robot2.png' )
  imagenes[2] = crear_imagen(src, 414, 224)

  src = love.graphics.newImage( 'imagenes/robot3.png' )
  imagenes[3] = crear_imagen(src, 200, 225)

  src = love.graphics.newImage( 'imagenes/robot4.png' )
  imagenes[4] = crear_imagen(src, 353, 262)

  src = love.graphics.newImage( 'imagenes/robot5.png' )
  imagenes[5] = crear_imagen(src, 267, 262)

  src = love.graphics.newImage( 'imagenes/robot6.png' )
  imagenes[6] = crear_imagen(src, 379, 368)

  src = love.graphics.newImage( 'imagenes/robot7.png' )
  imagenes[7] = crear_imagen(src, 243, 368)


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
  
  -- DIBUJANDO COORDENADAS
  local distancia = 50
  love.graphics.setLineWidth(1)
  love.graphics.setColor(0.8,0.8,0.8)
  for i = distancia/2, love.graphics.getWidth() - distancia/2, distancia/2 do
    love.graphics.line(i,0,i,love.graphics.getHeight())
  end
  for i = distancia/2, love.graphics.getHeight() - distancia/2, distancia/2 do
    love.graphics.line(0,i,love.graphics.getWidth(),i)
  end

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
      local _imagen = {
        x = imagenes[i].x,
        y = imagenes[i].y
      }
      for j=1, #imagenes do
        if math.abs(_imagen.x - imagenes[j].x) == math.abs(posiciones_respuesta[i].x - posiciones_respuesta[j].x) and
          math.abs(_imagen.y - imagenes[j].y) == math.abs(posiciones_respuesta[i].y - posiciones_respuesta[j].y)
        then
          imagenes[j].x = love.mouse.getX() - offset.x - posiciones_respuesta[i].x + posiciones_respuesta[j].x
          imagenes[j].y = love.mouse.getY() - offset.y - posiciones_respuesta[i].y + posiciones_respuesta[j].y
        end
      end
    -- elseif imagenes[i].estado == "rotando" then
    --   local inicio = math.atan2(offset.y, offset.x)
    --   local final = math.atan2(love.mouse.getY()-imagenes[i].y, love.mouse.getX()-imagenes[i].x)
    --   imagenes[i].rotacion = rotacion + final - inicio
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

  for i=1, #imagenes do
    for j=i+1, #imagenes do
      if (
        math.abs((imagenes[i].x - imagenes[j].x) - (posiciones_respuesta[i].x - posiciones_respuesta[j].x)) < error and
        math.abs((imagenes[i].y - imagenes[j].y) - (posiciones_respuesta[i].y - posiciones_respuesta[j].y)) < error
      ) then
        imagenes[i].x = (posiciones_respuesta[i].x - posiciones_respuesta[j].x) + imagenes[j].x
        imagenes[i].y = (posiciones_respuesta[i].y - posiciones_respuesta[j].y) + imagenes[j].y
      end
    end
  end
end