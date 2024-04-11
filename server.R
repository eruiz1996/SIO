# server
server <- function(input, output, session) {
  ##############################################################################
  # sheet1
  # variables reactivas
  #-----------------------------------------------------------------------------
  s1.trim <- reactive({ymd(input$trim1)})
  s1.cuenta <- reactive({input$cuenta1})
  s1.ramo <- reactive({input$ramo1})
  #-----------------------------------------------------------------------------
  # tabla
  #-----------------------------------------------------------------------------
  output$s1_table <- DT::renderDT({
    filter_df <- df %>% 
      # filtramos
      filter(trimestre == s1.trim(),
             cuenta == s1.cuenta(),
             operacion %in% s1.ramo()) %>% 
      # agrupamos por institución
      group_by(institucion) %>% 
      summarise(importe = sum(importe)) %>% 
      # ponemos columna de porcentaje
      mutate(porcentaje = percent(importe/sum(importe), accuracy=0.01)) %>%
      # seleccionamos columnas
      select(institucion, importe, porcentaje) %>% 
      # ordenamos de manera descendente
      arrange(desc(importe))
    
    return(filter_df)
  })
  #-----------------------------------------------------------------------------
  # gráfica
  #-----------------------------------------------------------------------------
  output$s1_graphic <- renderPlot({
    filter_df <- df %>% 
      # filtramos
      filter(trimestre == s1.trim(),
             cuenta == s1.cuenta(),
             operacion %in% s1.ramo()) %>% 
      # agrupamos por institución
      group_by(institucion) %>% 
      summarise(importe = sum(importe)) %>% 
      # seleccionamos columnas
      select(institucion, importe) %>% 
      # ordenamos de menor a mayor
      arrange(desc(importe)) %>%
      head(10)  # Obtener las 10 primeras compañías
    
    # Gráfico de barras
    ggplot(filter_df, aes(x = reorder(institucion, -importe), y = importe)) +
      geom_bar(stat='identity', fill = "#4B0082") +
      labs(title = "Top 10 de Compañías", x = "Instituciones", y = "Importe") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
  #-----------------------------------------------------------------------------
  ##############################################################################
  
  
  ##############################################################################
  # sheet2
  # variables reactivas
  #-----------------------------------------------------------------------------
  s2.cuenta <- reactive({input$cuenta2})
  s2.ramo <- reactive({input$ramo2})
  s2.inst <- reactive({input$inst2})
  #-----------------------------------------------------------------------------
  # gráfica de tendencia
  #-----------------------------------------------------------------------------
  output$s2_graphic1 <- renderPlot({
    filter_df <- df %>% 
      # filtramos
      filter(institucion == s2.inst(),
             cuenta == s2.cuenta(),
             operacion %in% s2.ramo()) %>%
      select(trimestre, importe) %>% 
      # agrupamos por trimestre
      group_by(trimestre) %>% 
      summarise(importe = sum(importe))
    # Gráfico de tendencia
    ggplot(filter_df, aes(x = trimestre, y = importe)) +
      geom_line(color = '#E32636') +
      labs(x = "Trimestre", y = "Importe")
  })
  # gráfica de embudo
  #-----------------------------------------------------------------------------
  output$s2_graphic2 <- renderPlotly({
    filter_df <- df %>% 
      # filtramos
      filter(institucion == s2.inst(),
             cuenta == s2.cuenta(),
             operacion %in% s2.ramo()) %>%
      select(trimestre, importe) %>% 
      # agrupamos por trimestre
      group_by(trimestre) %>% 
      summarise(importe = sum(importe))
    # color
    color <- "#8A2BE2"
    # gráfico de embudo
    fig <- plot_ly()
    fig <- fig %>%
      add_trace(
        type = "funnel",
        y = filter_df$trimestre,
        x = filter_df$importe,
        marker = list(color = color))
    fig <- fig %>%
      layout(yaxis = list(categoryarray = filter_df$trimestre))
    fig
  })
  ##############################################################################
  
  ##############################################################################
  # subitem1
  # variables reactivas
  sb1.inst <- reactive({input$inst_cs})
  sb1.cuenta <- reactive({input$cuenta_cs})
  sb1.ramo <- reactive({input$ramo_cs})
  sb1.trim <- reactive({ymd(input$per_cs)})
  #-----------------------------------------------------------------------------
  # tabla
  #-----------------------------------------------------------------------------
  output$sb1_table <- DT::renderDT({
    filter_df_inst <- df %>% 
      # filtramos
      filter(trimestre >= sb1.trim()[1],
             trimestre <= sb1.trim()[2],
             cuenta == sb1.cuenta(),
             operacion %in% sb1.ramo(),
             institucion == sb1.inst()) %>% 
      # seleccionamos columnas
      select(trimestre, importe) %>%
      # agrupamos por institución
      group_by(trimestre) %>% 
      summarise(importe_institucion = sum(importe)) %>% 
      select(trimestre,importe_institucion)
    # sector asegurador
    filter_df_sec <- df %>% 
      # filtramos
      filter(trimestre >= sb1.trim()[1],
             trimestre <= sb1.trim()[2],
             cuenta == sb1.cuenta(),
             operacion %in% sb1.ramo()) %>% 
      # seleccionamos columnas
      select(trimestre, importe) %>%
      # agrupamos por institución
      group_by(trimestre) %>% 
      summarise(importe_sector = sum(importe)) %>% 
      select(trimestre, importe_sector)
    # unimos los dataframes
    filter_df <- merge(filter_df_sec, filter_df_inst, all.x = T)  %>% 
      select(trimestre, importe_sector, importe_institucion)
    
    return(filter_df)
  })
  #-----------------------------------------------------------------------------
  # gráfica de barras
  #-----------------------------------------------------------------------------
  output$sb1_graphic <- renderPlot({
    # institución---
    filter_df_inst <- df %>% 
      # filtramos
      filter(trimestre >= sb1.trim()[1],
             trimestre <= sb1.trim()[2],
             cuenta == sb1.cuenta(),
             operacion %in% sb1.ramo(),
             institucion == sb1.inst()) %>% 
      # seleccionamos columnas
      select(trimestre, importe) %>%
      # agrupamos por institución
      group_by(trimestre) %>% 
      summarise(importe_institucion = sum(importe)) %>% 
      select(trimestre,importe_institucion)
    # sector asegurador---
    filter_df_sec <- df %>% 
      # filtramos
      filter(trimestre >= sb1.trim()[1],
             trimestre <= sb1.trim()[2],
             cuenta == sb1.cuenta(),
             operacion %in% sb1.ramo()) %>% 
      # seleccionamos columnas
      select(trimestre, importe) %>%
      # agrupamos por institución
      group_by(trimestre) %>% 
      summarise(importe_sector = sum(importe)) %>% 
      select(trimestre, importe_sector)
    # unimos los dataframes---
    filter_df <- merge(filter_df_sec, filter_df_inst, all.x = T)  %>% 
      select(trimestre, importe_sector, importe_institucion)
    
    # pasamos a formato largo
    df_long <- pivot_longer(filter_df, cols = c(importe_sector, importe_institucion), 
                            names_to = "variable", values_to = "importe")
    
    # Graficamos ambas variables en un mismo gráfico con barras agrupadas
    ggplot(df_long, aes(x = trimestre, y = importe, fill = variable)) +
      geom_bar(stat = "identity", position = position_dodge()) +
      labs(title = "Comparativo trimestral",  # Título del gráfico
           x = "Trimestre",  # Etiqueta del eje x
           y = "Importe",  # Etiqueta del eje y
           fill = "Variable") +  # Leyenda de las variables
      theme_minimal() +  # Tema del gráfico
      scale_fill_manual(values = c("#ADD8E6", "#808080")) 
    
  })
  ##############################################################################
  
  ##############################################################################
  # subitem2
  # variables reactivas
  sb2.inst1 <- reactive({input$inst1_ci})
  sb2.inst2 <- reactive({input$inst2_ci})
  sb2.cuenta <- reactive({input$cuenta_ci})
  sb2.ramo <- reactive({input$ramo_ci})
  sb2.trim <- reactive({ymd(input$per_ci)})
  #-----------------------------------------------------------------------------
  # tabla
  #-----------------------------------------------------------------------------
  output$sb2_table <- DT::renderDT({
    filter_df_inst1 <- df %>% 
      # filtramos
      filter(trimestre >= sb2.trim()[1],
             trimestre <= sb2.trim()[2],
             cuenta == sb2.cuenta(),
             operacion %in% sb2.ramo(),
             institucion == sb2.inst1()) %>% 
      # seleccionamos columnas
      select(trimestre, importe) %>%
      # agrupamos por institución
      group_by(trimestre) %>% 
      summarise(institucion1 = sum(importe)) %>% 
      select(trimestre,institucion1)
    # sector asegurador
    filter_df_inst2 <- df %>% 
      # filtramos
      filter(trimestre >= sb2.trim()[1],
             trimestre <= sb2.trim()[2],
             cuenta == sb2.cuenta(),
             operacion %in% sb1.ramo(),
             institucion == sb2.inst2()) %>% 
      # seleccionamos columnas
      select(trimestre, importe) %>%
      # agrupamos por institución
      group_by(trimestre) %>% 
      summarise(institucion2 = sum(importe)) %>% 
      select(trimestre, institucion2)
    # unimos los dataframes
    filter_df <- merge(filter_df_inst1, filter_df_inst2, all.x = T)  %>% 
      select(trimestre, institucion1, institucion2)
    
    return(filter_df)
  })
  #-----------------------------------------------------------------------------
  # gráfica de barras
  #-----------------------------------------------------------------------------
  output$sb2_graphic <- renderPlot({
    # institución---
    filter_df_inst1 <- df %>% 
      # filtramos
      filter(trimestre >= sb2.trim()[1],
             trimestre <= sb2.trim()[2],
             cuenta == sb2.cuenta(),
             operacion %in% sb2.ramo(),
             institucion == sb2.inst1()) %>% 
      # seleccionamos columnas
      select(trimestre, importe) %>%
      # agrupamos por institución
      group_by(trimestre) %>% 
      summarise(institucion1 = sum(importe)) %>% 
      select(trimestre,institucion1)
    # sector asegurador
    filter_df_inst2 <- df %>% 
      # filtramos
      filter(trimestre >= sb2.trim()[1],
             trimestre <= sb2.trim()[2],
             cuenta == sb2.cuenta(),
             operacion %in% sb1.ramo(),
             institucion == sb2.inst2()) %>% 
      # seleccionamos columnas
      select(trimestre, importe) %>%
      # agrupamos por institución
      group_by(trimestre) %>% 
      summarise(institucion2 = sum(importe)) %>% 
      select(trimestre, institucion2)
    # unimos los dataframes
    filter_df <- merge(filter_df_inst1, filter_df_inst2, all.x = T)  %>% 
      select(trimestre, institucion1, institucion2)
    
    # pasamos a formato largo
    df_long <- pivot_longer(filter_df, cols = c(institucion1, institucion2), 
                            names_to = "variable", values_to = "importe")
    
    # Graficamos ambas variables en un mismo gráfico con barras agrupadas
    ggplot(df_long, aes(x = trimestre, y = importe, fill = variable)) +
      geom_bar(stat = "identity", position = position_dodge()) +
      labs(title = "Comparativo trimestral",  # Título del gráfico
           x = "Trimestre",  # Etiqueta del eje x
           y = "Importe",  # Etiqueta del eje y
           fill = "Variable") +  # Leyenda de las variables
      theme_minimal() +  # Tema del gráfico
      scale_fill_manual(values = c("#9370DB", "#ADFF2F")) 
    
  })
  ##############################################################################
  
  ##############################################################################
  # sheet3
  # variables reactivas
  #-----------------------------------------------------------------------------
  s3.inst <- reactive({input$inst3})
  s3.trim <- reactive({ymd(input$trim3)})
  s3.trim.c <- reactive({ymd(input$trim3_com)})
  s3.ramo <- reactive({input$ramo3})
  #-----------------------------------------------------------------------------
  # gráfico cirular
  output$s3_graphic1 <- renderPlot({
    filter_df <- df %>% 
      # filtramos
      filter(institucion == s3.inst(),
             operacion == s3.ramo(),
             trimestre %in% c(s3.trim(), s3.trim.c())) %>%
      select(trimestre, importe) %>% 
      # agrupamos por trimestre
      group_by(trimestre) %>% 
      summarise(importe = sum(importe))
    # gráfico circular
    pie(filter_df$importe, labels = filter_df$trimestre, col = c("#8B0000", "#40E0D0"))
  })
  #-----------------------------------------------------------------------------
  # gráfico barras
  output$s3_graphic2 <- renderPlot({
    filter_df <- df %>% 
      # filtramos
      filter(institucion == s3.inst(),
             trimestre %in% c(s3.trim(), s3.trim.c()),
             operacion == s3.ramo()) %>%
      select(trimestre, importe) %>% 
      # agrupamos por trimestre
      group_by(trimestre) %>% 
      summarise(importe = sum(importe))
    # gráfico de barras
    ggplot(filter_df, aes(x = trimestre, y = importe)) +
      geom_bar(stat='identity', fill = "#FFC0CB") +
      labs(x = "Trimestre", y = "Importe")
  })
  #-----------------------------------------------------------------------------
  ##############################################################################

}