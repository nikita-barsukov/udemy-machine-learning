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

# Histogram: 
hist_threshold = 2000000
human_usd = function(x){human_numbers(x, smbl = "$")}
kc_house_data_hist = kc_house_data
kc_house_data_hist$price[kc_house_data_hist$price > hist_threshold] = hist_threshold +1
plt = ggplot(kc_house_data_hist) +
  geom_histogram(aes(price), color="white", breaks = seq(0, 2050000, 50000)) +
  geom_vline(xintercept = median(kc_house_data$price), color = "red") +
  annotate("text", x = 475000, y = 2000, label = "Median price:\n$450K", hjust = 0) +
  scale_x_continuous(labels = c(human_usd(seq(0, 1800000, 200000)), "$2m+"), 
                     breaks = seq(0, 2000000, 200000), 
                     name = "House price", 
                     expand = c(0, 0)) +
  scale_y_continuous(labels = comma, 
                     name = "Houses sold", 
                     expand = c(0, 50)) +
  ggtitle("Distribution of house prices in Seattle area", 
          subtitle = "Homes sold between May 2014 and May 2015, Kaggle dataset") +
  theme_minimal()
print(plt)

# Price vs bedrooms
plt = ggplot(kc_house_data_bedrooms) +
  geom_boxplot(aes(x=bedrooms, y=price), outlier.shape = NA) +
  scale_y_continuous(labels = human_usd, 
                     name = "House price") +
  scale_x_discrete(labels=c("one","two","three","four","five","six"), 
                   name = "Number of bedrooms") +
  coord_flip(ylim = c(0, 1750000)) +
  ggtitle("Spread of house prices in Seattle area by number of bedrooms", 
          subtitle = "Homes sold between May 2014 and May 2015, Kaggle dataset") +
  theme_minimal()

print(plt)
# price vs grade
plt = ggplot(kc_house_data_grade) +
  geom_boxplot(aes(x=grade, y=price), outlier.shape = NA) +
  scale_y_continuous(labels = human_usd, 
                     name = "House price") +
  scale_x_discrete(name = NULL) +
  coord_flip(ylim = c(0, 2000000)) +
  ggtitle("Spread of house prices in Seattle area by house grade", 
          subtitle = "Homes sold between May 2014 and May 2015, Kaggle dataset") +
  theme_minimal()

print(plt)
# Price vs sq feet
plt = ggplot(kc_house_data) +
  geom_point(aes(x=price, y=sqft_living), alpha = .3) +
  scale_x_continuous(labels = human_usd, name="House price") +
  scale_y_continuous(labels = comma, name = "Living area, sq. feet") +
  ggtitle("House price and living area", 
          subtitle = "Homes sold between May 2014 and May 2015 in and around Seattle, Kaggle dataset") +
  theme_minimal()
print(plt)

