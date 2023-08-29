# Import necessary libraries
import pandas as pd
import numpy as np
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import confusion_matrix, accuracy_score
from imblearn.over_sampling import SMOTE
import seaborn as sns
import matplotlib.pyplot as plt

# Set the working directory to your Lab06 folder (if needed)
# Example: os.chdir("path/to/your/Lab06")

# Read MobilePhoneSubscribers.csv into a DataFrame called mobilePhone
mobilePhone = pd.read_csv("G:\Other computers\My Laptop\Desktop\Laptop Stuff\Eller Fall 2022\MIS545\Lab06\Lab06\MobilePhoneSubscribers.csv")

# Display mobilePhone in the console
print(mobilePhone)

# Display the structure of mobilePhone in the console
print(mobilePhone.info())

# Display the summary of mobilePhone in the console
print(mobilePhone.describe())

# Define a function to display histograms
def display_all_histograms(df):
     numeric_cols = df.select_dtypes(include=[np.number])
     for col in numeric_cols.columns:
         sns.histplot(df, x=col, kde=True)
         plt.show()

# Call the display_all_histograms() function, passing in mobilePhone as an argument
display_all_histograms(mobilePhone)

# Calculate and display the correlation matrix
correlation_matrix = mobilePhone.corr().round(2)
print(correlation_matrix)

# Plot the correlation matrix
sns.heatmap(correlation_matrix, annot=True, cmap="coolwarm")
plt.show()

# Remove the DataUsage and DataPlan variables
mobilePhone = mobilePhone.drop(columns=["DataUsage", "DataPlan"])

# Randomly split the dataset into training (75%) and testing (25%) sets
mobilePhoneTraining, mobilePhoneTesting = train_test_split(mobilePhone, test_size=0.25, random_state=203)

# Check if we have a class imbalance issue in CancelledService
print(mobilePhoneTraining["CancelledService"].value_counts())

# Calculate class imbalance magnitude
classImbalanceMagnitude = 1253 / 360

# Deal with class imbalance using the SMOTE technique
X_train = mobilePhoneTraining.drop(columns=["CancelledService"])
y_train = mobilePhoneTraining["CancelledService"]
smt = SMOTE(sampling_strategy=1.0)
X_train_smoted, y_train_smoted = smt.fit_resample(X_train, y_train)

# Define a mapping for "CancelledService" and "RecentRenewal"
bool_mapping = {
    "CancelledService": {True: True, False: False},  # Map True to True and False to False
    "RecentRenewal": {1: True, 0: False}  # Map 1 to True and 0 to False (assuming these are the unique values)
}

# Apply the mapping to the columns
X_train_smoted = X_train_smoted.replace(bool_mapping)

# Now, "CancelledService" and "RecentRenewal" should contain boolean values

# Generate the logistic regression model
logistic_model = LogisticRegression()
logistic_model.fit(X_train_smoted, y_train_smoted)

# Display the logistic regression model results
print(logistic_model.coef_)

# Use the model to predict outcomes in the testing dataset
mobilePhonePrediction = logistic_model.predict(mobilePhoneTesting.drop(columns=["CancelledService"]))

# Generate a confusion matrix of predictions
confusion_matrix_result = confusion_matrix(mobilePhoneTesting["CancelledService"], mobilePhonePrediction)
print(confusion_matrix_result)

# Calculate the false positive rate
false_positive_rate = confusion_matrix_result[0, 1] / (confusion_matrix_result[0, 1] + confusion_matrix_result[0, 0])
print("False Positive Rate:", false_positive_rate)

# Calculate the false negative rate
false_negative_rate = confusion_matrix_result[1, 0] / (confusion_matrix_result[1, 0] + confusion_matrix_result[1, 1])
print("False Negative Rate:", false_negative_rate)

# Calculate the model prediction accuracy
accuracy = accuracy_score(mobilePhoneTesting["CancelledService"], mobilePhonePrediction)
print("Model Accuracy:", accuracy)