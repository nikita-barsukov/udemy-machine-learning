library(ggplot2)
library(dplyr)
library(scales)
library(knitr)
library(readr)
library(lubridate)
library(ggmap)

this.dir = dirname(parent.frame(2)$ofile)
options(scipen = 999999, digits=4) # disabling scientific notation
setwd(this.dir)

source("kc_house_data_read.R")
source("ggplot2_formatter.r")

# ========================
# Plotting maps with sales

us = c(left = -122.8, bottom = 47.2, right = -121.5, top = 47.9)
map = get_stamenmap(us, zoom = 10, maptype = "toner-lite")

plt = ggmap(map, extent="device") +
  scale_x_continuous(name=NULL) +
  scale_y_continuous(name=NULL) +
  stat_density_2d(data = kc_house_data, aes(x=long, y=lat, fill = ..level..), geom = "polygon", alpha = .3, color = NA) +
  scale_fill_gradient2("Houses sold", low = "white", high = "red", breaks = c(4, 16),labels=c("Less","More")) +
  theme_minimal() +
  ggtitle("Locations of all houses sold in Seattle area", subtitle = "Kaggle dataset, May 2014 to May 2015") +
  theme(axis.line = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank())
print(plt)


# Density by grade level
plt = ggmap(map, extent="device") +
  stat_density_2d(data = kc_house_data_grade, aes(x=long, y=lat, fill = ..level..), geom = "polygon", alpha = .3, color = NA) +
  scale_fill_gradient2("Houses sold", low = "white", high = "green", breaks = c(5, 30),labels=c("Less","More")) +
  facet_wrap(~grade) +
  theme_minimal() +
  ggtitle("Locations of houses sold in Seattle area", 
          subtitle = "Breakdown by house grade. Kaggle dataset, May 2014 to May 2015") +
  theme(axis.line = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank())
print(plt)

# Density by bedrooms
plt = ggmap(map, extent="device") +
  stat_density_2d(data = kc_house_data_bedrooms, aes(x=long, y=lat, fill = ..level..), geom = "polygon", alpha = .3, color = NA) +
  scale_fill_gradient2("Houses sold", low = "white", high = "blue", breaks = c(5, 30),labels=c("Less","More")) +
  facet_wrap(~bedrooms) +
  theme_minimal() +
  ggtitle("Locations of houses sold in Seattle area", 
          subtitle = "Breakdown by number of bedrooms. Kaggle dataset, May 2014 to May 2015") +
  theme(axis.line = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank())
print(plt)

# 