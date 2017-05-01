
library(shiny)
library(data.table)
library(wordcloud2)
library(tm)
library(dplyr)
library(stringr)


movies = fread("output.csv", header = F, select = 3, colClasses = c( rep("character",5)))[-1] # select col 2 to 5,  remove 1st row
setnames(movies, "Movie_Name")
movies[,"Movie_Name"] = str_replace_all(movies$Movie_Name," - IMDb","")

fluidPage(
  titlePanel("Word Cloud"),
  checkboxInput(inputId = "showSummary", 
                label = "click to show table summary", 
                value = FALSE),
  dataTableOutput("UserInput"),
  sidebarLayout(
    sidebarPanel(
      selectInput("selection", "Choose a movie:",
                  choices = sort(unique(movies[[1]]))),
      actionButton(inputId =  "update", label = "go" )
    ),
    mainPanel()
  ),
  wordcloud2Output(outputId = "draw_cloud" , width = "85%", height = "1200px")
)