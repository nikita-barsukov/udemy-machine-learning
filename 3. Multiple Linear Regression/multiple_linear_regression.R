library(caTools)
library(ggplot2)
this.dir <- dirname(parent.frame(2)$ofile)
options(scipen = 999999, digits=4) # disabling scientific notation
setwd(this.dir)

dataset = read.csv("50_Startups.csv")
set.seed(123)

# Encoding categorical variables
dataset$State = factor(
  dataset$State,
  levels = c("New York", "California", "Florida"),
  labels = c(1, 2, 3)
)

# Splitting to test and train datasets
split = sample.split(dataset$Profit, SplitRatio = 0.8)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

# No feature scaling necessary here
# Fitting multiple linear regression into training set
regressor = lm(Profit ~ ., training_set)

# Predicting
y_pred = predict(regressor, newdata=test_set)