library(ggplot2)
library(dplyr)
library(scales)
library(caTools)
library(knitr)
library(readr)
library(lubridate)
library(ggmap)

kc_house_data = read_csv("kc_house_data.csv")
kc_house_data$yr_renovated[kc_house_data$yr_renovated == 0] = NA

kc_house_data$age = year(kc_house_data$date) - kc_house_data$yr_built
kc_house_data$years_since_renovation = year(kc_house_data$date) - kc_house_data$yr_renovated