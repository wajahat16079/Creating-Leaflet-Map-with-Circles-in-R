
## loading packages 

library(tidyverse)
library(leaflet)
library(htmltools)
library(htmlwidgets)



## Data preparation
## Changing Leaflet skins
## Adding Circles to the map
## Changing circles' color, size and opacity
## Adding circles' labels 
## setting view of the map
## saving map as an html 

## loading data

df = read.csv("US Cities.csv")

df = df[2:nrow(df),]

## Cleaning data
df$Location = gsub("<b0>",".",df$Location)
df$Location = gsub("N",",",df$Location)
df$Location = gsub("W","",df$Location)
df$Location = gsub("\\?","",df$Location)

df$X2021.estimate = gsub(",","",df$X2021.estimate) %>% as.numeric()

df$Lat = substr(df$Location,1,5) %>% as.numeric()
df$Long = substr(df$Location,8,12) %>% as.numeric()









## Simple Map
leaflet() %>%
  addTiles()

## Add Different Skins

## Skins: https://leaflet-extras.github.io/leaflet-providers/preview/

# Stamen.Watercolor
# CartoDB.DarkMatterNoLabels

leaflet() %>%
  addProviderTiles("CartoDB.DarkMatterNoLabels") 



## Adding Circles
leaflet() %>%
  addProviderTiles("Stamen.Watercolor") %>% 
  addCircleMarkers(
    lng = -df$Long,
    lat = df$Lat
  )

## Changing Radius of Circle 
leaflet() %>%
  addProviderTiles("Stamen.Watercolor") %>% 
  addCircleMarkers(
    lng = -df$Long,
    lat = df$Lat,
    radius = (df$X2021.estimate/max(df$X2021.estimate))*25
  )


## Changing Circle Color

## Colors: https://www.rapidtables.com/web/color/RGB_Color.html

leaflet() %>%
  addProviderTiles("CartoDB.DarkMatterNoLabels") %>% 
  addCircleMarkers(
    lng = -df$Long,
    lat = df$Lat,
    radius = (df$X2021.estimate/max(df$X2021.estimate))*25,
    color = "#FFAB00",
    stroke = F
  )


## Changing Color Opacity

leaflet() %>%
  addProviderTiles("CartoDB.DarkMatterNoLabels") %>% 
  addCircleMarkers(
    lng = -df$Long,
    lat = df$Lat,
    radius = (df$X2021.estimate/max(df$X2021.estimate))*25,
    color = "#FFAB00",
    stroke = F,
    fillOpacity = 1
  )

## Creating variable for Opacity
df$Opacity = 0.35 + (df$X2021.estimate/(2*max(df$X2021.estimate)))


leaflet() %>%
  addProviderTiles("CartoDB.DarkMatterNoLabels") %>% 
  addCircleMarkers(
    lng = -df$Long,
    lat = df$Lat,
    radius = (df$X2021.estimate/max(df$X2021.estimate))*25,
    color = "#FFAB00",
    stroke = F,
    fillOpacity = df$Opacity
  )


## Adding Labels

## Creating hover and click labels
Label <- paste0(
  "<b> City:",df$City,"</b>","<br/>",
  "Population:",df$X2021.estimate
)


leaflet() %>%
  addProviderTiles("CartoDB.DarkMatterNoLabels") %>% 
  addCircleMarkers(
    lng = -df$Long,
    lat = df$Lat,
    radius = (df$X2021.estimate/max(df$X2021.estimate))*25,
    stroke = FALSE, 
    fillOpacity = df$Opacity,
    color = "#FFAB00",
    popup =  Label,
    label =   lapply(Label, htmltools::HTML)
  )


## Set View

leaflet() %>%
  addProviderTiles("Stamen.Watercolor") %>% 
  addCircleMarkers(
    lng = -df$Long,
    lat = df$Lat,
    radius = (df$X2021.estimate/max(df$X2021.estimate))*25,
    stroke = FALSE, 
    fillOpacity = df$Opacity,
    color = "black",
    popup =  Label,
    label =   lapply(Label, htmltools::HTML)
  )%>%
  setView(-98.5795, 39.8282, zoom=3)


## SAving the map as html
Map = leaflet() %>%
  addProviderTiles("Stamen.Watercolor") %>% 
  addCircleMarkers(
    lng = -df$Long,
    lat = df$Lat,
    radius = (df$X2021.estimate/max(df$X2021.estimate))*25,
    stroke = FALSE, 
    fillOpacity = df$Opacity,
    color = "#FFAB00",
    popup =  Label,
    label =   lapply(Label, htmltools::HTML)
  )%>%
  setView(-98.5795, 39.8282, zoom=3)

## Save Map as an html
saveWidget(Map, file="USMap.html")

