library(shiny)
library(dplyr)
library(lubridate)
library(scales)
library(ggplot2)
library(plotly)

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
      geom_bar(stat='identity', fill = "skyblue") +
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
      geom_line(color = 'green') +
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
    # gráfico de embudo
    fig <- plot_ly()
    fig <- fig %>%
      add_trace(
        type = "funnel",
        y = filter_df$trimestre,
        x = filter_df$importe)
    fig <- fig %>%
      layout(yaxis = list(categoryarray = filter_df$trimestre))
    fig
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
    ggplot(filter_df, aes(x = "", y = importe, fill = trimestre)) +
      geom_bar(stat = "identity", width = 1) +
      coord_polar(theta = "y")
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
      geom_bar(stat='identity', fill = "skyblue") +
      labs(x = "Trimestre", y = "Importe")
  })
  #-----------------------------------------------------------------------------
  ##############################################################################

}