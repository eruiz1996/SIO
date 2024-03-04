library(shiny)
library(shinydashboard)

instituciones <- c('Quálitas', 'AGROASEMEX')
ramos <- c('Incendio', 'MyT')
cuentas <- c('Primas', 'Utilidad')
trimestres <- c('2022-12-31', '2023-01-31')

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
            menuItem("Top 5", tabName = "sheet1", icon = icon("chart-bar")),
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
            # Primer Hoja ----------------------------------------------------
            tabItem(tabName = "sheet1",
                    fluidRow(
                        h1("Principales Instituciones del Sector Asegurador"),
                        # ---------------------------------------
                        # Botón 1: cuenta de estado de resultados (1)
                        selectInput('cuenta1',
                                    "Cuenta de Estado de Resultados: ",
                                    choices = cuentas,
                                    selected = cuentas[1],
                                    multiple = F),
                        # ---------------------------------------
                        # Botón 2: trimestre (1)
                        selectInput('trim1',
                                    "Trimestre: ",
                                    choices = trimestres,
                                    selected = trimestres[1],
                                    multiple = F),
                        # ---------------------------------------
                        # Botón 3: ramo operado (m)
                        checkboxGroupInput('ramo1',
                                    "Ramos Operados: ",
                                    choices = ramos,
                                    selected = ramos)
                        # ---------------------------------------
                    )
            ),
            # Segunda Hoja ---------------------------------------------------
            tabItem(tabName = "sheet2",
                    fluidRow(
                        h1("Análisis por Institución"),
                        # ---------------------------------------
                        # Botón 1: Institución Aseguradora (1)
                        selectInput('inst2',
                                    "Institución Aseguradora: ",
                                    choices = instituciones,
                                    selected = instituciones[1],
                                    multiple = F),
                        # ---------------------------------------
                        # Botón 2: cuenta de estado de resultados (1) 
                        selectInput('cuenta2',
                                           "Cuenta de Estado de Resultados: ",
                                           choices = cuentas,
                                           selected = cuentas[1],
                                           multiple = F),
                        # ---------------------------------------
                        # Botón 3: ramos operados (m)
                        checkboxGroupInput('ramo2',
                                    "Ramos Operados: ",
                                    choices = ramos,
                                    selected = ramos)
                        # ---------------------------------------
                    )
            ),
            # Hoja concentración 1 -------------------------------------------
            tabItem(tabName = "subitem1",
                    fluidRow(
                        h1("Institución vs Institución")
                    )
            ),
            # Hoja concentración 2 -------------------------------------------
            tabItem(tabName = "subitem2",
                    fluidRow(
                        h1("Institución vs Sector Asegurador")
                    )
            ),
            # Tercer Hoja ----------------------------------------------------
            tabItem(tabName = "sheet3",
                    fluidRow(
                        h1("Análisis de Concentración"),
                        # ---------------------------------------
                        # Botón 1: Institución Aseguradora (1)
                        selectInput('inst3',
                                    "Institución Aseguradora: ",
                                    choices = instituciones,
                                    selected = instituciones[1],
                                    multiple = F),
                        # ---------------------------------------
                        # Botón 2: Ramo Operado (1)
                        selectInput('ramo3',
                                    "Ramo Operado: ",
                                    choices = ramos,
                                    selected = ramos[1],
                                    multiple = F),
                        # ---------------------------------------
                        # Botón 3: Trimestre (1)
                        selectInput('trim3',
                                    "Trimestre: ",
                                    choices = trimestres,
                                    selected = trimestres[1],
                                    multiple = F),
                        # ---------------------------------------
                        # Botón 4: Trimestre (1)
                        selectInput('trim3_com',
                                    "Trimestre de comparativa: ",
                                    choices = trimestres,
                                    selected = trimestres[1],
                                    multiple = F),
                        # ---------------------------------------
                    )
            )
        )
    ),
    skin='green'
)