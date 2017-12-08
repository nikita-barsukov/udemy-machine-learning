library(ggplot2)
library(reshape2)
library(scales)
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)

salary = function(experience) {
  10000 * experience + 15500
}

set.seed(2017)

observations = 2000
experiences = round(runif(observations, 0, 20), digits = 1)

R.squared = function(actual, predicted) {
  1 - (sum((actual - predicted) ^ 2) / sum((actual - mean(actual)) ^ 2))
}

dataset = data.frame(
  years_of_exp = experiences,
  salaries_true = salary(experiences),
  salaries_observed = abs(
    salary(experiences) + rnorm(observations, sd = 7000) * rnorm(observations, sd = 5)
  )
)

split = sample.split(dataset$salaries_observed, SplitRatio = .8)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

regressor = lm(salaries_observed ~ years_of_exp, data = training_set)

test_set$salaries_fitted = predict(regressor, newdata = test_set)

pl = ggplot() +
  geom_point(
    aes(test_set$years_of_exp,
                 test_set$salaries_observed,
                 color = "Observed salaries")
    ) +
  geom_point(
    aes(
      training_set$years_of_exp,
      training_set$salaries_observed,
      color = "Observed salaries"
    ),
    alpha = 0.2
  ) +
  geom_line(aes(
    test_set$years_of_exp,
    predict(regressor, newdata = test_set),
    color = "Regression line"
  ),
  size = 1) +
  geom_line(aes(test_set$years_of_exp,
                test_set$salaries_true,
                color = "Base line"),
            size = 1) +
  xlab("Years of experience") +
  ylab("Observed salary") +
  scale_colour_manual(
    name = NULL,
    values = c("#855C75", "#855C75", "#D9AF6B"),
    guide = guide_legend(override.aes = list(
      linetype = c("solid", "blank", "solid"),
      shape = c(NA, 16, NA)
    ))
  ) +
  theme_minimal() +
  ggtitle("Linear regression on noisy data from a base line", subtitle = "Points in test set are darker")

print(pl)