import numpy as np 
import matplotlib.pyplot as plt 
import pandas as pd 
import os
import pprint
from tabulate import tabulate

from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression

# Setting working directory to the directory of this script
abspath = os.path.abspath(__file__)
dname = os.path.dirname(abspath)
os.chdir(dname)

# Reading data
dataset = pd.read_csv("Salary_Data.csv")
X = dataset.iloc[:, :-1].values
y = dataset.iloc[:, 1].values

#splitting test and train dataset
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 1/3, random_state = 0)

# Fitting simple linear regression -- least squares
regressor = LinearRegression() # simple least squares linear regression
regressor.fit(X_train, y_train)
y_hat = regressor.predict(X_test)


pretty_matrix = np.vstack((X_test.T, y_test, y_hat, 100 * (y_hat - y_test)/y_test) ).T
print(tabulate(pretty_matrix, headers=["Experience", "Actual salary", "Predicted salary", "Diff"]))

# Visualising results
plt.scatter(X, y, color='red')
plt.plot(X_test, y_hat, color = "blue")
plt.title("Salary and experience, training set")
plt.xlabel("years of experience")
plt.ylabel("Salary")
plt.show()
