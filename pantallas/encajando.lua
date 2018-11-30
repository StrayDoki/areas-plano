--------------
-- PANTALLA --
--------------
encajando = {}

---------------
-- ESTATICOS --
---------------
local cfg = {
  color = {

  }
}

local figuras = {
  {
    70,200,
    170,80,
    270,200,
    270,280,
    470,280,
    350,380,
    350,550,
    290,600,
    220,600,
    280,550,
    280,380,
    190,280,
    190,200,
  }
}

---------------
-- DINAMICOS --
---------------
local figura_actual  
local marco
local boton_atras
----------
-- LOAD --
----------
function encajando.load()
  -- ESCOGER FIGURA
  figura_actual = 1

  -- CREANDO MARCO
  local distancia = 30
  marco = {
    x = distancia,
    y = distancia,
    width = love.graphics.getWidth()/2,
    height = love.graphics.getHeight() - 2*distancia,
  }

  -- CREANDO BOTON ATRAS
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

----------
-- DRAW --
----------
function  encajando.draw()
  -- DIBUJAR FIGURA
  love.graphics.setLineWidth(5)
  love.graphics.setColor(0,0,0)
  love.graphics.polygon("line", figuras[figura_actual])  

  --DIBUJAR MARCO
  love.graphics.setLineWidth(10)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle("line", marco.x, marco.y, marco.width, marco.height)

  -- DIBUJANDO BOTON ATRAS  
  boton_atras.draw()
end

------------
-- UPDATE --
------------
function encajando.update(dt)
  -- ACTUALIZA EL BOTON SI EL MOUSE ESTA ENCIMA
  boton_atras.update(love.mouse.getX(), love.mouse.getY())
end

-------------------
-- MOUSE PRESSED --
-------------------
function encajando.mousepressed(x,y)
  -- SE PRESIONA EL BOTON ATRAS
  if boton_atras.estaSeleccionado(x,y) then
    cambiarPantalla(menu)
  end
end