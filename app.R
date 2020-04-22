#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(burnr)
library(dplyr)
library(purrr)
library(tidyr)
source("helpers.R")

# Define UI for data upload app ----
ui <- fluidPage(
    
    # App title ----
    titlePanel("Extract Extended Metadata from FHX Files"),
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
        
        # Sidebar panel for inputs ----
        sidebarPanel(
            
            # Input: Select a file ----
            fileInput(inputId = "files", 
                      label = "Choose FHX File(s)",
                      multiple = TRUE,
                      accept = c(".FHX",
                                 ".fhx"))
        ),
        # 
        # Main panel for displaying outputs ----
        mainPanel(
            includeMarkdown("text_intro.Rmd"),
            # Output: Data file ----
            tableOutput("contents")
            
        )
        
    )
)

# Define server logic to read selected file ----
server <- function(input, output) {
    
    # output$contents <- renderTable({
    #     
    #     # input$file1 will be NULL initially. After the user selects
    #     # and uploads a file, head of that data file by default,
    #     # or all rows if selected, will be shown.
    output$contents <- renderTable({
            req(input$files)
            upload = list()
            for(i in 1:length(input$files[, 1])) {
                in_name = data.frame(file_name = input$files[[i, 'name']])
                fhx_in <- read_fhx(input$files[[i, 'datapath']])
                fhx_meta <- extract_rings_meta(fhx_in)
                upload[[i]] <- cbind(in_name, fhx_meta)
            }
           out <- do.call(rbind, upload)
           out
            
        # req(input$file1)
        # fhx_in <- read_fhx(input$file1$datapath)
        # extract_rings_meta(fhx_in)
        
    },
    digits = 0)
    
}

# Create Shiny app ----
shinyApp(ui, server)

