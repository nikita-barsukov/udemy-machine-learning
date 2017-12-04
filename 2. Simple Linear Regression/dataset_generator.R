library(ggplot2)
library(reshape2)
library(scales)
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)

salary = function(experience) {
  10000 * experience + 15500
}

set.seed(1983)

observations = 200
experiences = round(runif(observations, 0, 20), digits = 1)

dataset = data.frame(
  years_of_exp = experiences,
  salaries_true = salary(experiences),
  salaries_observed = abs(salary(experiences) + rnorm(observations, sd =
                                                        30000))
)

dataset_molten = melt(dataset, id.vars = "years_of_exp")

pl = ggplot(dataset) +
  geom_point(aes(years_of_exp, salaries_observed, color = "Observed salaries")) +
  geom_smooth(
    aes(years_of_exp, salaries_observed, color = "Least squares regression line"),
    #color = "#855C75",
    method = "lm",
    se = FALSE
  ) +
  geom_line(
    aes(years_of_exp, salaries_true, color = "True line"),
    #color = "#D9AF6B",
    show.legend = TRUE, 
    size=1
  ) +
  scale_x_continuous(name = "Years of experience", limits=c(0,20)) +
  scale_y_continuous(name = "Observed salary", labels = comma) +
  scale_colour_manual(name = NULL, values = c("#855C75","#855C75","#D9AF6B" )) +
  theme_minimal()

print(pl)

write.csv(dataset[, c(1, 3)], file = "regression_ds.csv", row.names = FALSE)
