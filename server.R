library(shiny)
library(dplyr)
library(lubridate)
library(scales)
library(ggplot2)

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
  s2.cuenta <- reactive({input$cuenta2})
  s2.ramo <- reactive({input$ramo2})
  s2.inst <- reactive({input$inst2})
  ##############################################################################
  
  
  ##############################################################################
  # sheet3
  s3.trim <- reactive({input$trim3})
  s3.cuenta <- reactive({input$cuenta2})
  s3.ramo <- reactive({input$ramo3})
  s3.inst <- reactive({input$inst3})
  ##############################################################################

}