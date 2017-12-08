library(caTools)
library(ggplot2)
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)
dataset = read.csv("Salary_Data.csv")

set.seed(123)

# Splitting to test and train
split = sample.split(dataset$Salary, SplitRatio = 2 / 3)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

#fitting line
regressor = lm(formula = Salary ~ YearsExperience, data = training_set)

# Predicting line
y_pred = predict(regressor, newdata = training_set)

pl = ggplot() +
  geom_point(aes(x = test_set$YearsExperience, y = test_set$Salary)) + 
  geom_line(aes(x = training_set$YearsExperience, y = y_pred)) +
  ggtitle("Salary and experience") +
  xlab("Salary") +
  ylab("Years of experience") +
  theme_bw()

print(pl)
