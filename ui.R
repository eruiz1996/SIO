library(shiny)
library(shinydashboard)
library(DT)

# user interface
ui <- dashboardPage(
    # header
    dashboardHeader(
        title = "Sistema de Información Oportuna",
        titleWidth = 350
        ),
    
    # sidebar
    dashboardSidebar(
        sidebarMenu(
            menuItem("Top 10", tabName = "sheet1", icon = icon("chart-bar")),
            menuItem("Por institución", tabName = "sheet2", icon = icon("line-chart")),
            menuItem("Comparativa",
                     menuSubItem("Institución", tabName = "subitem1"),
                     menuSubItem("Sector Asegurador", tabName = "subitem2"),
                     icon = icon("list")),
            menuItem("Concentración", tabName = "sheet3", icon = icon("pie-chart"))
        )
    ),
    
    # body
    dashboardBody(
        tabItems(
            #################################################################### 
            # Primer Hoja ------------------------------------------------------
            tabItem(tabName = "sheet1",
                    titlePanel("Principales Instituciones del Sector Asegurador"),
                    # Panel lateral
                    # ----------------------------------------------------------
                    sidebarLayout(
                      sidebarPanel(
                        # ---------------------------------------
                        # Botón 1: cuentas de estado de resultados (1)
                        selectInput('cuenta1',
                                    "Cuenta de Estado de Resultados: ",
                                    choices = cuentas$nombre,
                                    selected = cuentas$nombre[1],
                                    multiple = F),
                        # ---------------------------------------
                        # Botón 2: trimestre (1)
                        selectInput('trim1',
                                    "Trimestre: ",
                                    choices = trimestres$nombre,
                                    selected = trimestres$nombre[length(trimestres$id)],
                                    multiple = F),
                        # ---------------------------------------
                        # Botón 3: ramo operado (m)
                        selectInput('ramo1',
                                    "Ramos Operados: ",
                                    choices = operaciones$nombre,
                                    selected = operaciones$nombre[1],
                                    multiple = T)
                        # ---------------------------------------
                      ),
                      # --------------------------------------------------------
                      
                      # Panel principal
                      # --------------------------------------------------------
                      mainPanel(
                        tabsetPanel(
                          tabPanel('Tabla', DT::DTOutput('s1_table')),
                          tabPanel('Gráfico', plotOutput("s1_graphic"))
                        )
                      )
                      # --------------------------------------------------------
                    )
            ),
            ####################################################################
            
            #################################################################### 
            # Segunda Hoja ------------------------------------------------------
            tabItem(tabName = "sheet2",
                    titlePanel("Análisis por Institución"),
                    sidebarLayout(
                      sidebarPanel(
                        # ---------------------------------------
                        # Botón 1: Institución Aseguradora (1)
                        selectInput('inst2',
                                    "Institución Aseguradora: ",
                                    choices = instituciones$nombre,
                                    selected = instituciones$nombre[1],
                                    multiple = F),
                        # ---------------------------------------
                        # Botón 2: cuenta de estado de resultados (1) 
                        selectInput('cuenta2',
                                           "Cuenta de Estado de Resultados: ",
                                           choices = cuentas$nombre,
                                           selected = cuentas$nombre[1],
                                           multiple = F),
                        # ---------------------------------------
                        # Botón 3: ramos operados (m)
                        selectInput('ramo2',
                                    "Ramos Operados: ",
                                    choices = operaciones$nombre,
                                    selected = operaciones$nombre[1],
                                    multiple = T)
                        # ---------------------------------------
                        ),
                      mainPanel(
                        h1("Gráfico de tendencia"),
                        plotOutput('s2_graphic1'),
                        h1("Gráfico de Embudo"),
                        plotlyOutput('s2_graphic2')
                        )
                      )
            ),
            ####################################################################
            
            #################################################################### 
            # Hoja concentración 1 ---------------------------------------------
            tabItem(tabName = "subitem1",
                    fluidRow(
                        h1("Institución vs Institución")
                    )
            ),
            ####################################################################
            
            ####################################################################
            # Hoja concentración 2 ---------------------------------------------
            tabItem(tabName = "subitem2",
                    fluidRow(
                        h1("Institución vs Sector Asegurador")
                    )
            ),
            ####################################################################
            
            #################################################################### 
            # Tercer Hoja ------------------------------------------------------
            tabItem(tabName = "sheet3",
                    fluidRow(
                        h1("Análisis de Concentración"),
                        # ---------------------------------------
                        # Botón 1: Institución Aseguradora (1)
                        selectInput('inst3',
                                    "Institución Aseguradora: ",
                                    choices = instituciones$nombre,
                                    selected = instituciones$nombre[1],
                                    multiple = F),
                        # ---------------------------------------
                        # Botón 2: Ramo Operado (1)
                        selectInput('ramo3',
                                    "Ramo Operado: ",
                                    choices = operaciones$nombre,
                                    selected = operaciones$nombre[1],
                                    multiple = F),
                        # ---------------------------------------
                        # Botón 3: Trimestre (1)
                        selectInput('trim3',
                                    "Trimestre: ",
                                    choices = trimestres$nombre,
                                    selected = trimestres$nombre[length(trimestres$id)],
                                    multiple = F),
                        # ---------------------------------------
                        # Botón 4: Trimestre (1)
                        selectInput('trim3_com',
                                    "Trimestre de comparativa: ",
                                    choices = trimestres$nombre,
                                    selected = trimestres$nombre[length(trimestres$id)],
                                    multiple = F),
                        # ---------------------------------------
                    )
            )
            ####################################################################
        )
    ),
    skin='green'
)