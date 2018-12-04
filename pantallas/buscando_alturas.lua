--PANTALLA DONDE LOS ESTUDIANTES TIENEN UN TRIANGULO Y UBICAN LA ALTURA
buscando_alturas = {}

--ESTATICOS
local cfg = {
  color = {
    triangulo = {0.7,0.7,0.3,0.5},
    contorno = {0,0,0},
    linea = {1,0,0},
    base = {0.5,0.5,1},
    punto = {1,0,0},
    texto = {0,0,0},
    caja = {
      titulo = {
        fondo = {1,1,1},
        texto = {0,0,0}
      },
      correcto = {
        fondo = {0,0.7,0},
        texto = {1,1,1}
      },
      incorrecto = {
        fondo = {1,0,0},
        texto = {1,1,1}
      },
      felicitaciones = {
        fondo = {0.4,1,0.4},
        texto = {0,0,0}
      }
    }
  },
  texto = {
    tamaño = 40,
    mensaje_principal = [[Dibuja la altura del triángulo]],
    mensaje_mismo = [[El mismo triángulo pero usemos otra base]],
    mensaje_adicional = [[Ahora de este otro triángulo]],
    mensaje_felicitaciones = [[¡Lo lograste!]],
    correcto = [[¡Muy bien!]],
    incorrecto = [[Intenta de nuevo]],
  },
  plantilla = {
    top = 100
  },
  distancia_minima = 50
}

local triangulos = {
  {
    400,150,
    200,550,
    740,550
  },
  {
    400,150,
    200,550,
    740,550
  },
  {
    200,150,
    200,550,
    740,550
  },
  {
    200,150,
    200,550,
    740,550
  },
  {
    200,150,
    300,550,
    740,550
  }
}

--DINAMICOS
local triangulo_actual
local tipo_base
local base
local altura
local vertice
local puntos
local estado
local mensaje
local corregir_texto_base
local color_caja_fondo
local color_caja_texto
local boton_atras

----------
-- LOAD --
----------
function buscando_alturas.load ()
  -- CREANDO LOS PUNTOS
  puntos = {}

  -- ASIGNANDO ESTADO
  estado = "pregunta"

  -- ASIGNANDO TITULO
  mensaje = cfg.texto.mensaje_principal
  color_caja_fondo = cfg.color.caja.titulo.fondo
  color_caja_texto = cfg.color.caja.titulo.texto

  -- TRIANGULO QUE SE MUESTRA
  triangulo_actual = 1
  tipo_base = 2
  corregir_texto_base = 1
  altura = calcular_altura(triangulos[triangulo_actual])

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

----------
-- DRAW --
----------
function buscando_alturas.draw()
  --DIBUJANDO TEXTO
  dibujarCaja(
    0,
    0,
    love.graphics.getWidth(),
    cfg.plantilla.top,
    color_caja_fondo,
    mensaje,
    cfg.texto.tamaño,
    color_caja_texto
  )
  
  --DIBUJANDO TRIANGULO
  love.graphics.setLineWidth(5)
  love.graphics.setColor(cfg.color.triangulo)
  love.graphics.polygon("fill", triangulos[triangulo_actual])
  love.graphics.setColor(cfg.color.contorno)
  love.graphics.polygon("line", triangulos[triangulo_actual])

  -- DIBUJANDO LINEA
  love.graphics.setLineWidth(5)
  love.graphics.setColor(cfg.color.linea)
  if #puntos == 2 then
    love.graphics.line(puntos[1].x,puntos[1].y,puntos[2].x,puntos[2].y)
  end

  -- DIBUJANDO LINEAS ADICIONALES
  if estado == "correcto" then
    love.graphics.line(puntos[2].x,puntos[2].y,base.x1,base.y1)
    love.graphics.line(puntos[2].x,puntos[2].y,base.x2,base.y2)
  end


  --DIBUJANDO BASE
  love.graphics.setLineWidth(10)
  love.graphics.setColor(cfg.color.base)
  love.graphics.line(base.x1, base.y1, base.x2, base.y2)

  --DIBUJANDO PUNTOS
  love.graphics.setColor(cfg.color.punto)
  for i=1, #puntos do
    love.graphics.circle("fill",puntos[i].x, puntos[i].y,5)
  end

  -- DIBUJANDO TEXTO DE BASE
  love.graphics.push()
  love.graphics.translate(base.x1,base.y1)
  love.graphics.rotate(
    math.atan2(base.y2-base.y1,base.x2-base.x1)
  )
  dibujarTexto(
    "base",
    calcular_distancia(base.x1,base.y1,base.x2,base.y2)/2,
    corregir_texto_base * 30,
    cfg.texto.tamaño,
    cfg.color.base
  )
  love.graphics.pop()
  
  --DIBUJANDO TEXTO DE ALTURA
  if estado == "correcto" then
    love.graphics.push()
    love.graphics.translate(vertice.x,vertice.y)
    love.graphics.rotate(
      math.atan2(altura.y-vertice.y,altura.x-vertice.x)
    )
    dibujarTexto(
      "altura",
      calcular_distancia(vertice.x,vertice.y,altura.x,altura.y)/2,
      corregir_texto_base * 30,
      cfg.texto.tamaño,
      cfg.color.linea
    )
    love.graphics.pop()
  end

  --DIBUJANDO BOTON
  boton_atras.draw()
end

------------
-- UPDATE --
------------
function buscando_alturas.update(dt)
  if estado == "dibujando" then
    -- Creando nuevo punto
    local nuevo_punto = {
      x = love.mouse.getX(),
      y = love.mouse.getY()
    }

    if calcular_distancia(nuevo_punto.x,nuevo_punto.y,vertice.x,vertice.y) < cfg.distancia_minima then
      nuevo_punto.x = vertice.x
      nuevo_punto.y = vertice.y
    end

    if calcular_distancia(nuevo_punto.x,nuevo_punto.y,altura.x, altura.y) < cfg.distancia_minima then
      nuevo_punto.x = altura.x
      nuevo_punto.y = altura.y
    end

    puntos[2] = nuevo_punto
  end

  --ACTUALIZA BOTON
  boton_atras.update(love.mouse.getX(), love.mouse.getY())
end


-------------------
-- MOUSE PRESSED --
-------------------
function buscando_alturas.mousepressed(x,y)
  if estado == "pregunta" then
    -- Creando nuevo punto
    local nuevo_punto = {
      x = x,
      y = y
    }

    if calcular_distancia(x,y,vertice.x,vertice.y) < cfg.distancia_minima then
      nuevo_punto.x = vertice.x
      nuevo_punto.y = vertice.y
    end

    if calcular_distancia(x,y,altura.x, altura.y) < cfg.distancia_minima then
      nuevo_punto.x = altura.x
      nuevo_punto.y = altura.y
    end

    puntos = {} -- borra lo anterior

    puntos[1] = nuevo_punto
    puntos[2] = nuevo_punto

    estado = "dibujando"

  elseif estado == "correcto" then
    if triangulo_actual == #triangulos then
      -- FELICITACIONES
      mensaje = cfg.texto.mensaje_felicitaciones
      color_caja_fondo = cfg.color.caja.felicitaciones.fondo
      color_caja_texto = cfg.color.caja.felicitaciones.texto
    else
      puntos = {} -- borra los puntos
      triangulo_actual = triangulo_actual+1 -- cambia el triangulo

      --NUEVO TRIANGULO
      if triangulo_actual == 2 or triangulo_actual == 4 then
        mensaje = cfg.texto.mensaje_mismo --cambia el mensaje
      else
        mensaje = cfg.texto.mensaje_adicional
      end

      color_caja_fondo = cfg.color.caja.titulo.fondo
      color_caja_texto = cfg.color.caja.titulo.texto
      
      if triangulo_actual == 2 then -- correccion por si el texto base sale debajo
        tipo_base = 3
        corregir_texto_base = -1
      elseif triangulo_actual == 4 then
        tipo_base = 2
        corregir_texto_base = 1
      end
      altura = calcular_altura (triangulos[triangulo_actual]) -- calcula altura
      estado = "pregunta" -- cambia el estado
    end
  end

  -- SI SE PRESIONA EL BOTON ATRAS
  if boton_atras.estaSeleccionado(x,y) then
    cambiarPantalla(menu)
  end
end

--------------------
-- MOUSE RELEASED --
--------------------
function buscando_alturas.mousereleased(x,y)
  if estado == "dibujando" then
  -- si los puntos estan al reves, los intercambia
    if puntos[2].x == vertice.x and puntos[2].y == vertice.y and
    puntos[1].x == altura.x and puntos[1].y == altura.y then
      local temporal = puntos[2]
      puntos[2] = puntos [1]
      puntos[1] = temporal
    end

    --verifica si es la altura correcta
    if
    (puntos[1].x == vertice.x and puntos[1].y == vertice.y and
    puntos[2].x == altura.x and puntos[2].y == altura.y)
    then
      -- CORRECTO!
      mensaje = cfg.texto.correcto --y cambia el texto
      color_caja_fondo = cfg.color.caja.correcto.fondo
      color_caja_texto = cfg.color.caja.correcto.texto
      estado = "correcto"
    else
      -- INCORRECTO!
      mensaje = cfg.texto.incorrecto --cambia el texto
      color_caja_fondo = cfg.color.caja.incorrecto.fondo
      color_caja_texto = cfg.color.caja.incorrecto.texto
      estado = "pregunta"
    end
  end
end

---------------------------
-- FUNCIONES ADICIONALES --
---------------------------

--CALCULA DISTANCIA ENTRE DOS PUNTOS
function calcular_distancia(x1,y1,x2,y2)
  return math.sqrt((x1-x2)^2+(y1-y2)^2)
end 

function calcular_altura (triangulo)
  --DECIDE CUAL ES LA BASE Y EL VERTICE RESTANTE

  if tipo_base == 1 then
    base = {
      x1 = triangulo[1],
      y1 = triangulo[2],
      x2 = triangulo[3],
      y2 = triangulo[4],
    }
    vertice = {
      x = triangulo[5],
      y = triangulo[6]
    }
  elseif tipo_base == 2 then
    base = {
      x1 = triangulo[3],
      y1 = triangulo[4],
      x2 = triangulo[5],
      y2 = triangulo[6],
    }
    vertice = {
      x = triangulo[1],
      y = triangulo[2]
    }
  elseif tipo_base == 3 then
    base = {
      x1 = triangulo[1],
      y1 = triangulo[2],
      x2 = triangulo[5],
      y2 = triangulo[6],
    }
    vertice = {
      x = triangulo[3],
      y = triangulo[4]
    }  
  end

  --CALCULA LOS VECTORES
  local vector_base = {
    x = base.x2 - base.x1,
    y = base.y2 - base.y1
  }

  local vector_restante = {
    x = vertice.x - base.x1,
    y = vertice.y - base.y1
  }

  --MULTIPLICACION DE VECTORES
  local producto_base_restante = (
    vector_base.x * vector_restante.x +
    vector_base.y * vector_restante.y
  )

  local producto_base_base = (
    vector_base.x * vector_base.x +
    vector_base.y * vector_base.y 
  )

  -- LA PROYECCION VECTORIAL
  local vector_altura = {
    x = producto_base_restante / producto_base_base * vector_base.x,
    y = producto_base_restante / producto_base_base * vector_base.y
  }

  -- ENCONTRAMOS EL PIE DE LA ALTURA
  local pie_altura = {
    x = base.x1 + vector_altura.x,
    y = base.y1 + vector_altura.y
  }

  return pie_altura
end