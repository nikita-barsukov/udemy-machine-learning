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

# Removing factor levels with <100 sales
kc_house_data_grade = kc_house_data %>% filter(grade %in% c(5,6,7,8,9,10))
kc_house_data_grade$grade = factor(paste("Grade", kc_house_data_grade$grade), 
                                   levels = c("Grade 5", "Grade 6", "Grade 7", "Grade 8", "Grade 9", "Grade 10"))


kc_house_data_bedrooms = kc_house_data %>% filter(bedrooms %in% c(1,2,3,4,5,6))
kc_house_data_bedrooms$bedrooms = paste("Bedrooms: ", kc_house_data_bedrooms$bedrooms)