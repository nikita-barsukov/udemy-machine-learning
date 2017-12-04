library(caTools)
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)
dataset = read.csv("Data.csv")

# Cleaning data: missing numerical values are means
dataset$Age = ifelse(is.na(dataset$Age),
                     ave(
                       dataset$Age,
                       FUN = function(x)
                         mean(x, na.rm = TRUE)
                     ),
                     dataset$Age)

dataset$Salary = ifelse(is.na(dataset$Salary),
                        ave(
                          dataset$Salary,
                          FUN = function(x)
                            mean(x, na.rm = TRUE)
                        ),
                        dataset$Salary)

# Encoding categorical variables
dataset$Country = factor(
  dataset$Country,
  levels = c("France", "Spain", "Germany"),
  labels = c(1, 2, 3)
)
dataset$Purchased = factor(dataset$Purchased,
                           levels = c("Yes", "No"),
                           labels = c(1, 0))

set.seed(123)

# Splitting to test and train
split = sample.split(dataset$Purchased, SplitRatio = 0.8)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

# Feature scaling
training_set[,2:3] = scale(training_set[,2:3])
test_set[,2:3] = scale(test_set[,2:3])
