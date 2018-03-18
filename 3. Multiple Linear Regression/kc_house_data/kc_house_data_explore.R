library(ggplot2)
library(dplyr)
library(scales)
library(caTools)
library(knitr)
library(readr)
library(lubridate)
library(ggmap)

this.dir = dirname(parent.frame(2)$ofile)
options(scipen = 999999, digits=4) # disabling scientific notation
setwd(this.dir)

source("kc_house_data_read.R")
source("ggplot2_formatter.r")

# Exploring: 
hist_threshold = 2000000
human_usd = function(x){human_numbers(x, smbl = "$")}
kc_house_data_hist = kc_house_data
kc_house_data_hist$price[kc_house_data_hist$price > hist_threshold] = hist_threshold +1
plt = ggplot(kc_house_data_hist) +
  geom_histogram(aes(price), breaks = seq(0, 2050000, 50000)) +
  scale_x_continuous(labels = c(human_usd(seq(0, 1800000, 200000)), "$2m+"), breaks = seq(0, 2000000, 200000)) +
  scale_y_continuous(labels = comma) +
  theme_minimal()
print(plt)

# ========================
# Plotting maps with sales

us = c(left = -122.8, bottom = 47.2, right = -121.5, top = 47.9)
map = get_stamenmap(us, zoom = 10, maptype = "toner-lite")

plt = ggmap(map, extent="device") +
  stat_density_2d(data = kc_house_data, aes(x=long, y=lat, fill = ..level..), geom = "polygon", alpha = .3, color = NA) +
  scale_fill_gradient2("Houses sold", low = "white", high = "red") +
  theme_minimal() +
  theme(axis.line = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(), 
        legend.position="none")
print(plt)

# Removing factor levels with <100 sales
kc_house_data_grid = kc_house_data %>% filter(grade %in% c(5,6,7,8,9,10))
plt = ggmap(map, extent="device") +
  stat_density_2d(data = kc_house_data_grid, aes(x=long, y=lat, fill = ..level..), geom = "polygon", alpha = .3, color = NA) +
  scale_fill_gradient2("Houses sold", low = "white", high = "green") +
  facet_wrap(~grade) +
  theme_minimal() +
  theme(axis.line = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(), 
        legend.position="none")
print(plt)

kc_house_data_bedrooms = kc_house_data %>% filter(bedrooms %in% c(1,2,3,4,5,6))
plt = ggmap(map, extent="device") +
  stat_density_2d(data = kc_house_data_bedrooms, aes(x=long, y=lat, fill = ..level..), geom = "polygon", alpha = .3, color = NA) +
  scale_fill_gradient2("Houses sold", low = "white", high = "blue") +
  facet_wrap(~bedrooms) +
  theme_minimal() +
  theme(axis.line = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(), 
        legend.position="none")
print(plt)

# 