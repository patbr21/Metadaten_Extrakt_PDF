# PDF Metadata Extraction App

Diese Shiny App wurde entwickelt, um Metadaten von PDF-Dateien aus einem ausgewählten Verzeichnis auszulesen und in einer CSV-Datei zu speichern. Die Anwendung ist besonders nützlich, wenn du viele PDF-Dateien verwalten musst und die Metadaten dieser Dateien in einem strukturierten Format exportieren möchtest.

## Hauptfunktionen

-   Ordnerauswahl: Der Benutzer kann ein Verzeichnis auswählen, das PDF-Dateien enthält.
-   Metadatenauslesung: Die App verwendet ExifTool (über das exifr Paket), um die Metadaten der PDF-Dateien im gewählten Verzeichnis auszulesen.
-   CSV-Export: Die extrahierten Metadaten werden in einer CSV-Datei gespeichert, die im selben Verzeichnis abgelegt wird, in dem die App ausgeführt wird.
-   Statusanzeige: Der Benutzer erhält eine Rückmeldung über den Fortschritt und das Ergebnis des Metadaten-Extraktionsprozesses.

## Installation

Um die App lokal auszuführen, stelle sicher, dass die folgenden Pakete in R installiert sind:

if (!require("pacman")) install.packages("pacman") pacman::p_load("shiny", "shinyFiles", "exifr", "readr")

## Verwendung

1.  Starte die App mit shinyApp(ui = ui, server = server).
2.  Wähle den Ordner aus, der die PDF-Dateien enthält.
3.  Klicke auf "Analyse starten", um die Metadaten der PDF-Dateien auszulesen und zu speichern.

## Systemvoraussetzungen

-   R: Version 4.0 oder höher
-   Shiny: Version 1.6 oder höher
-   ExifTool: ExifTool muss auf deinem System installiert und über das exifr Paket zugänglich sein.
