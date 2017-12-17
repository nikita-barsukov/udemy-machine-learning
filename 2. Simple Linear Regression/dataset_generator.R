library(ggplot2)
library(reshape2)
library(scales)
library(caTools)
options(scipen=999)
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
    salary(experiences) + round(rnorm(observations, sd = 10000) * rnorm(observations, sd = 5), -2)
  )
)

pl = ggplot(data = dataset, aes(x=years_of_exp, y=salaries_observed)) +
  geom_point(color="#855C75") + 
  scale_x_continuous(name = "Years after graduation") +
  scale_y_continuous(name = "Observed salary", labels = comma) +
  ggtitle("Linear regression on noisy data from a base line", subtitle = "Random dataset generated from base line") +
  theme_minimal()

print(pl)
  

split = sample.split(dataset$salaries_observed, SplitRatio = .8)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

pl = ggplot() +
  geom_point(data = dataset, aes(x=years_of_exp, y=salaries_observed, alpha = split), color="#855C75") + 
  scale_x_continuous(name = "Years after graduation") +
  scale_y_continuous(name = "Observed salary", labels = comma) +
  scale_alpha_manual(labels = c("Test set", "Training set"), values = c(1, .2), name = NULL) +
  ggtitle("Linear regression on noisy data from a base line",subtitle = "Training and test datasets") +
  theme_minimal()

print(pl)

regressor = lm(salaries_observed ~ years_of_exp, data = training_set)

test_set$salaries_fitted = predict(regressor, newdata = test_set)

pl = pl +
  geom_line(aes(
    test_set$years_of_exp,
    predict(regressor, newdata = test_set),
    color = "Fitted line"
  ),
  size = 1) +
  geom_line(aes(test_set$years_of_exp,
                test_set$salaries_true,
                color = "Base line"),
            size = 1) +
  scale_colour_manual(
    name = NULL,
    values = c("#855C75", "#D9AF6B")
  ) +
  ggtitle("Linear regression on noisy data from a base line",subtitle = "Fitted and base lines")

print(pl)

r_sq_base = R.squared(test_set$salaries_observed, test_set$salaries_true)
r_sq_fitted = R.squared(test_set$salaries_observed, test_set$salaries_fitted)

residuals = data.frame(
  base_line = test_set$salaries_true - test_set$salaries_observed,
  fitted_line = test_set$salaries_fitted - test_set$salaries_observed
)

residuals.melt = melt(residuals)
levels(residuals.melt$variable) = c("Base line", "Fitted line")

residuals_means = data.frame(
  variable = levels(residuals.melt$variable),
  col_means = colMeans(residuals),
  mean_lbls = paste("Mean error:\n", round(colMeans(residuals), digits=1))
)

pl_residuals = ggplot(data = residuals.melt) +
  geom_histogram(aes(value, fill = variable)) +
  geom_vline(data = residuals_means, aes(xintercept = col_means)) +
  geom_label(data=residuals_means, aes(x = col_means-28000, y = 75, label = mean_lbls)) +
  facet_grid(variable ~ .) +
  scale_y_continuous(name = "Number of observations") +
  scale_x_continuous(name = "Residual errors", labels = comma) +
  scale_fill_manual(values = c("#855C75", "#D9AF6B"), guide=FALSE) +
  ggtitle("Residual errors", subtitle = "Base line and fitted line vs noisy data") +
  theme_minimal()

print(pl_residuals)
