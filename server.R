library(shiny)
library(dplyr)
library(lubridate)
library(scales)

# server
server <- function(input, output, session) {
    output$s1_table <- DT::renderDT({
      id.cuenta <- get_id(input$cuenta1, cuentas)
      id.trim <- get_id(ymd(input$trim1), trimestres)
      id.ramo <- get_id(input$ramo1, operaciones)
      # filtramos
      filter_df <- db %>% 
        filter(id_cuenta == id.cuenta,
               id_trim == id.trim,
               id_op %in% id.ramo) %>% 
        mutate(Nombre = get_name(id_nom, instituciones),
               Porcentaje = percent(importe/sum(importe), accuracy=0.01)) %>%
        select(Nombre, importe, Porcentaje) %>% 
        arrange(desc(importe))
      # tomamos el total de lo antes filtrado
      #total_s1 <- reactive({sum(filter_df$importe)})
      return(filter_df)
    })
    
    #output$s1_text <- renderText({
     # total_s1()
    #})
}