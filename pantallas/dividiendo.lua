dividiendo = {}

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
  },
  gato = {
    {x = 2, y = 3},
    {x = 3, y = 4},
    {x = 4, y = 3},
    {x = 4, y = 5},
    {x = 3, y = 6},
    {x = 7, y = 6},
    {x = 8, y = 6},
    {x = 8, y = 7},
    {x = 7, y = 7},
    {x = 7, y = 10},
    {x = 6, y = 7},
    {x = 3, y = 10},
    {x = 3, y = 6},
    {x = 2, y = 5},
  },
  barco = {
    {x = 3, y = 3},
    {x = 5, y = 1},
    {x = 6, y = 1},
    {x = 6, y = 3},
    {x = 6, y = 4},
    {x = 7, y = 4},
    {x = 6, y = 5},
    {x = 6, y = 7},
    {x = 10, y = 7},
    {x = 8, y = 9},
    {x = 3, y = 9},
    {x = 1, y = 7},
    {x = 5, y = 7},
    {x = 5, y = 5},
    {x = 4, y = 5}  ,
    {x = 5, y = 4},
    {x = 5, y = 3},
  }
}
local respuestas = {
  casa = {
    {
      {x = 9, y = 7},
      {x = 3, y = 7},
    },
  },
  gato = {
    {
      {x = 3, y = 4},
      {x = 2, y = 5},
    },
    {
      {x = 3, y = 4},
      {x = 4, y = 5},
    },
    {
      {x = 7, y = 6},
      {x = 6, y = 7},
    },
    {
      {x = 7, y = 6},
      {x = 7, y = 7},
    },
  },
  barco = {
    {
      {x = 5, y = 3},
      {x = 6, y = 3},
    },
    {
      {x = 5, y = 4},
      {x = 6, y = 4},
    },
    {
      {x = 5, y = 5},
      {x = 6, y = 5},
    },
    {
      {x = 5, y = 7},
      {x = 6, y = 7},
    },
  },
}
local partes = {
  casa = {
    {
      {x = 1, y = 7},
      {x = 6, y = 2},
      {x = 11, y = 7},
    },
    {
      {x = 9, y = 7},
      {x = 9, y = 12},
      {x = 3, y = 12},
      {x = 3, y = 7},
    }
  },
  gato = {
    {
      {x = 2, y = 3},
      {x = 3, y = 4},
      {x = 2, y = 5},
    },
    {
      {x = 3, y = 4},
      {x = 4, y = 3},
      {x = 4, y = 5},
    },
    {
      {x = 2, y = 5},
      {x = 3, y = 4},
      {x = 4, y = 5},
      {x = 3, y = 6},
    },
    {
      {x = 3, y = 6},
      {x = 7, y = 6},
      {x = 3, y = 10},
    },
    {
      {x = 7, y = 6},
      {x = 7, y = 7},
      {x = 8, y = 7},
      {x = 8, y = 6},
    },
    {
      {x = 7, y = 6},
      {x = 7, y = 10},
      {x = 6, y = 7},
    }
  },
  barco = {
    {
      {x = 3, y = 3},
      {x = 5, y = 1},
      {x = 6, y = 1},
      {x = 6, y = 3},
    },
    {
      {x = 5, y = 3},
      {x = 6, y = 3},
      {x = 6, y = 4},
      {x = 5, y = 4},
    },
    {
      {x = 5, y = 4},
      {x = 7, y = 4},
      {x = 6, y = 5},
      {x = 4, y = 5},
    },
    {
      {x = 5, y = 5},
      {x = 6, y = 5},
      {x = 6, y = 7},
      {x = 5, y = 7},
    },
    {
      {x = 1, y = 7},
      {x = 10, y = 7},
      {x = 8, y = 9},
      {x = 3, y = 9},
    },
  },
}
local condiciones = {
  casa = {
    {1},
    {1}
  },
  gato = {
    {1},
    {2},
    {1,2},
    {3},
    {4},
    {3,4}
  },
  barco = {
    {1},
    {1,2},
    {2,3},
    {3,4},
    {4},
  }
}
local colores_partes = {
  {1,0,0,0.3},
  {0,1,0,0.3},
  {0,0,1,0.3},
  {1,0,1,0.6},
  {1,1,0,0.6},
  {0,1,1,0.8},
  {0.5,0,0,0.8},
}
local distancia = 50
local radio_punto = 5

-- DINAMICOS --
local estado
local figura_actual
local respuesta_actual
local partes_actuales
local condicion_actual
local puntos
local segmentos
local segmento_adicional
local respuestas_encontradas
local partes_encontradas
local boton_siguiente
local boton_atras

function dividiendo.load()
  estado = "esperando"

  puntos = {}
  segmento_adicional = {}
  respuestas_encontradas = {}
  partes_encontradas = {}

  figura_actual = "casa"
    
  if (figura_actual == "casa") then
    puntos = figuras.casa
    respuesta_actual = respuestas.casa
    condicion_actual = condiciones.casa
    partes_actuales = partes.casa
  end

  -- CREANDO BOTON SIGUIENTE
  boton_siguiente = crearBoton(
    13 * distancia,
    7 * distancia,
    6 * distancia,
    3 * distancia,
    {0.7,0.7,1}, -- color de fondo
    "SIGUIENTE FIGURA",
    30, -- tamaño de texto
    {0,0,0}, --color de texto
    4,
    {0,0,0}
  )

  -- CREANDO BOTON ATRAS
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

function dividiendo.draw()
  -- DIBUJANDO COORDENADAS
  love.graphics.setLineWidth(1)
  love.graphics.setColor(0.8,0.8,0.8)
  for i = distancia/2, love.graphics.getWidth() - distancia/2, distancia/2 do
    love.graphics.line(i,0,i,love.graphics.getHeight())
  end
  for i = distancia/2, love.graphics.getHeight() - distancia/2, distancia/2 do
    love.graphics.line(0,i,love.graphics.getWidth(),i)
  end


  -- DIBUJANDO TITULO
  local color_texto = {0,0,0}

  dibujarTexto("Divide la figura", 16 * distancia, 1.5 * distancia,35, color_texto)
  dibujarTexto("y calcula el area", 16 * distancia, 2.5 * distancia,35, color_texto)
  
  love.graphics.setLineWidth(3)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle("line", 13*distancia, 4*distancia, 6*distancia, 2*distancia)

  dibujarTexto("Partes", 15 * distancia, 4.5 * distancia,30, color_texto)
  dibujarTexto("encontradas", 15 * distancia, 5.5 * distancia,30, color_texto)
  dibujarTexto("= ", 17.5 * distancia, 5 * distancia,30, color_texto)
  dibujarTexto(#partes_encontradas, 18.5 * distancia, 5 * distancia,30, color_texto)

  -- DIBUJANDO PARTES ENCONTRADAS
  for i=1, # partes_encontradas do
    love.graphics.setColor(colores_partes[i])
    local forma_a_dibujar = {}
    local parte_a_dibujar = partes_actuales[partes_encontradas[i]]
    for j=1, #parte_a_dibujar do
      forma_a_dibujar[#forma_a_dibujar+1] = parte_a_dibujar[j].x * distancia
      forma_a_dibujar[#forma_a_dibujar+1] = parte_a_dibujar[j].y * distancia
    end
    love.graphics.polygon("fill", forma_a_dibujar)
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

  -- DIBUJANDO BOTONES
  if #partes_encontradas == #partes_actuales then
    boton_siguiente.draw()
  end
  
  boton_atras.draw()
end

function dividiendo.update(dt)
  if estado == "dibujando" then
    local punto = {
      x = love.mouse.getX(),
      y = love.mouse.getY()
    }
  
    for i=1, #puntos do
      local punto_real = {
        x = puntos[i].x * distancia,
        y = puntos[i].y * distancia
      }
      local distancia_a_punto = math.sqrt( (punto.x - punto_real.x)^2 + (punto.y - punto_real.y)^2 )
      if distancia_a_punto <= distancia/4 then
        punto.x = punto_real.x
        punto.y = punto_real.y
      end
    end

    segmento_adicional[2] = punto
  end

  --ACTUALIZA BOTONES
  boton_siguiente.update(love.mouse.getX(), love.mouse.getY())
  boton_atras.update(love.mouse.getX(), love.mouse.getY())
end

function dividiendo.mousepressed(x,y)
  -- CREAMOS EL PUNTO
  local punto = {
    x = x,
    y = y
  }

  -- LIMPIAMOS EL ANTERIOR SEGMENTO
  segmento_adicional = {}

  -- VERIFICAMOS SI EL SEGMENTO ES UN VERTICE
  for i=1, #puntos do
    local punto_real = {
      x = puntos[i].x * distancia,
      y = puntos[i].y * distancia
    }
    local distancia_a_punto = math.sqrt( (punto.x - punto_real.x)^2 + (punto.y - punto_real.y)^2 )
    if distancia_a_punto <= distancia/4 then
      punto.x = punto_real.x
      punto.y = punto_real.y
    end
  end

  segmento_adicional[1] = punto
  segmento_adicional[2] = punto

  -- CAMBIAMOS EL ESTADO
  estado = "dibujando"

  -- SI EL BOTON SIGUIENTE ESTA SELECCIONADO Y VISIBLE
  if boton_siguiente.estaSeleccionado(x,y) and #partes_encontradas == #partes_actuales then
    respuestas_encontradas = {}
    partes_encontradas = {}

    if figura_actual == "casa" then
      figura_actual = "gato"
      puntos = figuras.gato
      respuesta_actual = respuestas.gato
      condicion_actual = condiciones.gato
      partes_actuales = partes.gato
    elseif figura_actual == "gato" then
      figural_actual = "barco"
      puntos = figuras.barco
      respuesta_actual = respuestas.barco
      condicion_actual = condiciones.barco
      partes_actuales = partes.barco
    end
  end

  -- EL BOTON ATRAS
  if boton_atras.estaSeleccionado(x,y) then
    cambiarPantalla(menu)
  end
end

function dividiendo.mousereleased(x,y)
  if estado == "dibujando" then
    estado = "esperando"

    -- SI EL SEGMENTO ES UNA RESPUESTA, LO ALMACENA
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
        -- buscamos si la respuesta ya existe
        local existe = false
        for j=1 , #respuestas_encontradas do
          if respuestas_encontradas[j] == i then
            existe = true
          end
        end
        -- si no existe, lo almacena
        if not existe then
          respuestas_encontradas[#respuestas_encontradas+1] = i
        end
      end
    end
    

    -- SI UNA FORMA ESTA ENCONTRADA, LO ALMACENA
    for i=1, #condicion_actual do
      local condiciones = 0
      for j=1, #condicion_actual[i] do
        for k=1, #respuestas_encontradas do
          if respuestas_encontradas[k] == condicion_actual[i][j] then
            condiciones = condiciones + 1
          end
        end
      end
      if condiciones == #condicion_actual[i] then
        -- buscamos si la parte ya existe
        local existe = false
        for m=1 , #partes_encontradas do
          if partes_encontradas[m] == i then
            existe = true
          end
        end
        -- si no existe, lo almacena
        if not existe then
          partes_encontradas[#partes_encontradas+1] = i
        end
      end
    end
  end
end