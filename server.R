# rm(list = ls())
# dev.off()
# setwd("~/Documents/SVOD webscrapping")

library(shiny)
library(data.table)
library(wordcloud2)
library(tm)
library(dplyr)
library(stringr)

data = fread("output.csv", header = F, select = c(2:5), colClasses = c( rep("character",5)))[-1] # select col 2 to 5,  remove 1st row
setnames(data, c("FullscreenID", "Movie_Name", "Keyword", "IMDB_rating"))
data[,"Movie_Name"] = str_replace_all(data$Movie_Name," - IMDb","")

function(input, output){
    groupSelectionChoice = eventReactive( input$update, {
      filtered_data = data[Movie_Name == input$selection]
      return(filtered_data)
    })
    
    output$draw_cloud = renderWordcloud2({
      wordcloud2( data = data.frame(x = groupSelectionChoice()$Keyword %>% str_replace_all(" ","-"),
                                    y = rep(1,length(groupSelectionChoice()$Keyword))),
                  size = .15,
                  color = "random-dark",
                  rotateRatio = 0,
                  backgroundColor = "white",
                  shape = "circle")
    })
    
    output$UserInput = renderDataTable({ #showing the raw input
      if(input$showSummary == FALSE){return()}
      temp = data[,.N, by = c ("Movie_Name","IMDB_rating")]
      setnames(temp, "N", "number_of_keywords")
      return(temp)
    })
}
