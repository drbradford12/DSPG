library(tidyverse)
file = "rawdata/Iowa_Physical_and_Cultural_Geographic_Features.csv"

text_to_geometry <- function(x) {
  # input: vector of characters of the form POINT (-93.5878033 41.5620619)
  # output: data frame of the same length as input with columns Longitude and Latitude

  # split along the white space
  listx <- strsplit(x, split=" ")
  arrayx <- matrix(unlist(listx), ncol = 3, byrow=TRUE)

  data.frame(
    Longitude = parse_number(arrayx[,2]),
    Latitude = parse_number(arrayx[,3])
  )
}

iowa_buildings <- readr::read_csv(file)

# add two variables: Latitude and Longitude
iowa_buildings <- data.frame(iowa_buildings, text_to_geometry(iowa_buildings$`Primary Point (Coordinates)`))

iowa_buildings %>% filter(Feature.Class == "Park") %>%
  ggplot(aes(x = Longitude, y = Latitude)) + geom_point()

iowa_buildings %>%
  ggplot(aes(x = Longitude, y = Latitude)) +
  geom_point(aes(colour = Feature.Class))

zeroes <- which(iowa_buildings$Longitude > -25)


# idx <- which.min(parks$Longitude)
# parks[idx,]
# parks[idx,]$Latitude <- 42.4474083
# parks[idx,]$Longitude <- -94.2868697
#
# idx <-which.max(parks$Longitude)
# parks[idx,]
# parks[idx,]$Latitude <- 41.7280558
# parks[idx,]$Longitude <- -91.7353302
#
# # Lake Bremer
# idx <-which.max(parks$Longitude)
# parks[idx,]
# parks[idx,]$Latitude <- 42.8509957
# parks[idx,]$Longitude <- -92.5423162
#
#
# # Ackerman Tact
# idx <-which.max(parks$Longitude)
# parks[idx,]
# parks[idx,]$Latitude <- 42.5887327
# parks[idx,]$Longitude <- -93.4362442
#
#
# # Maria Hladik Roadside Park
# idx <-which.max(parks$Latitude)
# parks[idx,]
# parks[idx,]$Latitude <- 42.0866961
# parks[idx,]$Longitude <- -92.5842567
#
#
# # Ackerman's River Woods
# idx <-which.min(parks$Latitude)
# parks[idx,]
# parks[idx,]$Latitude <- 43.454899
# parks[idx,]$Longitude <- -95.8771993
#
# # Smith Wildlife Area
# idx <-which.min(parks$Latitude)
# parks[idx,]
# parks[idx,]$Latitude <- 43.0233265
# parks[idx,]$Longitude <- -94.2188712
#
# # Indian Path
# idx <-which.min(parks$Latitude)
# parks[idx,]
# parks[idx,]$Latitude <- 40.722199
# parks[idx,]$Longitude <- -91.244757



# convert Longitude and Latitude into point object
iowa_buildings <- iowa_buildings %>% sf::st_as_sf(coords = c("Longitude", "Latitude"),
                                                          crs = 4326, agr = "identity")

iowa_buildings <- iowa_buildings %>% rename(
  Elevation.M = Elevation..Meters.,
  Elevation.Ft = Elevation..Feet.
)
usethis::use_data(iowa_buildings, overwrite = TRUE)
####
# there's some values with a location of 0,0
iowa_buildings$geometry[zeroes] <- NA