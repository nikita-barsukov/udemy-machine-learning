import numpy as np 
import matplotlib.pyplot as plt 
import pandas as pd 
import os
import pprint

from sklearn.preprocessing import Imputer, LabelEncoder, OneHotEncoder, StandardScaler
from sklearn.cross_validation import train_test_split

# Setting working directory to the directory of this script
abspath = os.path.abspath(__file__)
dname = os.path.dirname(abspath)
os.chdir(dname)

# Reading data
dataset = pd.read_csv("Data.csv")
X = dataset.iloc[:, :-1].values
y = dataset.iloc[:, 3].values


imputer = Imputer(missing_values = 'NaN', strategy="mean", axis=0)
imputer.fit(X[:, 1:3])

X[:, 1:3] = imputer.transform(X[:, 1:3])

labelEncoder_X = LabelEncoder()
X[:, 0] = labelEncoder_X.fit_transform(X[:, 0])
onehotencoder = OneHotEncoder(categorical_features=[0])
X = onehotencoder.fit_transform(X).toarray()

labelEncoder_y = LabelEncoder()
y = labelEncoder_y.fit_transform(y)

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.2, random_state = 0)

sc_X = StandardScaler()

X_test = sc_X.fit_transform(X_test)
X_train = sc_X.fit_transform(X_train)

pprint.pprint(X_train)


