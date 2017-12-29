import numpy as np 
import matplotlib.pyplot as plt 
import pandas as pd 
import os
import pprint
from tabulate import tabulate


from sklearn.preprocessing import Imputer, LabelEncoder, OneHotEncoder, StandardScaler
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression

import statsmodels.formula.api as sm

# Setting working directory to the directory of this script
abspath = os.path.abspath(__file__)
dname = os.path.dirname(abspath)
os.chdir(dname)

# Reading data
dataset = pd.read_csv("50_Startups.csv")
X = dataset.iloc[:, :-1].values
y = dataset.iloc[:, 4].values

labelEncoder_X = LabelEncoder()
X[:, 3] = labelEncoder_X.fit_transform(X[:, 3])
onehotencoder = OneHotEncoder(categorical_features=[3])
X = onehotencoder.fit_transform(X).toarray()

# Removing one dummy variable
X = X[:, 1:]

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.2, random_state = 0)

# Linear regression: all variables
regressor = LinearRegression()
regressor.fit(X_train, y_train)

y_pred = regressor.predict(X_test)

pretty_matrix = np.vstack( (y_test, y_pred, 100 * (y_pred - y_test)/y_test) ).T
print(tabulate(pretty_matrix, headers=["Actual profit", "Predicted profit", "Diff, %"]))
pprint.pprint("Mean resudial error, all params, %")
pprint.pprint(100 * np.mean((y_pred - y_test)/y_test))

# Linear regression: backward elimination

X = np.append(arr = np.ones((X.shape[0], 1)).astype(int), values= X, axis = 1)
X_opt = X[:, np.arange(0, X.shape[1], 1)]
vars_to_include = np.arange(0, X_opt.shape[1], 1)


# Significance level is 0.05 to select a feature in our regresison model
sl = 0.05
regressor_OLS = sm.OLS(endog = y, exog = X_opt).fit()
p_values = regressor_OLS.pvalues

coef_names = ["(intercept)", "Florida", "New York", "R&D Spend", "Administration", "Marketing Spend"]
#pretty_matrix = np.vstack((coef_names, 100 * p_values)).T
#print(tabulate(pretty_matrix, headers=["variables", "p-values, %"]))
print(regressor_OLS.summary())
print("")

max_p_value = max(p_values)
while (max_p_value >= sl):
    max_pvalue_idx = np.argmax(p_values)
    print("removing variable ", coef_names[max_pvalue_idx])
    coef_names = np.delete(coef_names, max_pvalue_idx)
    X_opt = np.delete(X_opt, max_pvalue_idx, 1)
    regressor_OLS = sm.OLS(endog = y, exog = X_opt).fit()
    p_values = np.asarray(regressor_OLS.pvalues)
    max_p_value = max(p_values)
    pretty_matrix = np.vstack((coef_names, 100 * p_values)).T
    print(tabulate(pretty_matrix, headers=["variables", "p-values, %"]))
    print("")

print("Optimal params found")
print("Model summary:")
print(regressor_OLS.summary())
print("")
print("Predictions and resudial errors:")
y_pred = regressor_OLS.predict(exog = X_opt)
print("")
print("Mean resudial error, optimal params params, %")
print(100 * np.mean((y_pred - y)/y))
