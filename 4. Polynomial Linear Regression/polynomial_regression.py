import numpy as np 
import matplotlib.pyplot as plt 
import pandas as pd 
import os
import pprint
from tabulate import tabulate

from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import PolynomialFeatures


# Setting working directory to the directory of this script
abspath = os.path.abspath(__file__)
dname = os.path.dirname(abspath)
os.chdir(dname)

# Reading data
dataset = pd.read_csv("Position_Salaries.csv")
X = dataset.iloc[:, 1:2].values # Making sure X is a matrix not a vector
y = dataset.iloc[:, 2].values

# Only 10 rows, no need to split into test and train datasets.
# No need for feature scaling.

# Building with simple linear regression first
linear_regressor = LinearRegression()
linear_regressor.fit(X, y)

# Then building polynomial regresson
polynomial_features = PolynomialFeatures(degree = 3)
# Creating a matrix with 3 columns
# with ones, with X-es and with x-squareds.
# since we assume our regression would be ax^2 + bx + c
x_poly = polynomial_features.fit_transform(X) 

polynomial_regressor = LinearRegression()
polynomial_regressor.fit(x_poly, y)

# Visualising results
plt.scatter(X, y, color = 'red')

plt.plot(X, linear_regressor.predict(X), color = 'blue')
plt.plot(X, polynomial_regressor.predict(x_poly), color = 'green')

plt.title('Predicting salaries')
plt.xlabel('Position level')
plt.ylabel('Salary')
plt.show()

