if (!require("pacman")) install.packages("pacman")
# pacman checkt, ob Pakete fehlen, und installiert sie
pacman::p_load("shiny", "shinyFiles", "exifr", "readr")

# Funktion zum Auslesen der Metadaten von PDF-Dateien
read_pdf_metadata <- function(directory_path) {
          # Erstelle eine Liste von PDF-Dateien im angegebenen Verzeichnis
          pdf_files <- list.files(directory_path, pattern = "\\.pdf$", full.names = TRUE)
          
          # Lese die Metadaten der PDF-Dateien mit ExifTool aus
          metadata <- read_exif(pdf_files)
          
          return(metadata)
}

# UI der Shiny App
ui <- fluidPage(
          titlePanel("PDF Metadaten Extraktion"),
          
          sidebarLayout(
                    sidebarPanel(
                              shinyDirButton("dir", "Ordner auswählen", "Bitte wählen Sie einen Ordner mit PDF-Dateien aus"),
                              actionButton("analyzeBtn", "Metadaten generieren")
                    ),
                    
                    mainPanel(
                              textOutput("status")
                    )
          )
)

# Server Logik der Shiny App
server <- function(input, output, session) {
          
          # Initialisiere den Ordnerpfad
          volumes <- c(Home = fs::path_home(), "RStudio" = getwd())
          shinyDirChoose(input, "dir", roots = volumes, session = session)
          
          dirPath <- reactive({
                    return(ifelse(is.null(input$dir), NULL, parseDirPath(volumes, input$dir)))
          })
          
          observeEvent(input$analyzeBtn, {
                    # Überprüfe, ob der Pfad eingegeben wurde
                    if (is.null(dirPath())) {
                              output$status <- renderText("Bitte wählen Sie einen gültigen Ordner aus.")
                              return(NULL)
                    }
                    
                    # Lese die Metadaten der PDF-Dateien im Verzeichnis aus
                    metadata_df <- read_pdf_metadata(dirPath())
                    
                    # Überprüfe, ob PDF-Dateien vorhanden sind und Metadaten extrahiert wurden
                    if (nrow(metadata_df) == 0) {
                              output$status <- renderText("Keine PDF-Dateien im angegebenen Ordner gefunden oder keine Metadaten verfügbar.")
                              return(NULL)
                    }
                    
                    # Speichern der Metadaten in einer CSV-Datei
                    csv_filename <- "pdf_metadata.csv"
                    write_delim(metadata_df, csv_filename, delim = "|")
                    
                    # Statusausgabe
                    output$status <- renderText(paste("Analyse abgeschlossen. Metadaten gespeichert in", csv_filename))
          })
          
          # Session beenden, wenn die Verbindung geschlossen wird
          session$onSessionEnded(function() {
                    stopApp()
          })
}

# Starte die Shiny App
shinyApp(ui = ui, server = server)
