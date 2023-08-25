# Mobile Service Cancellation Predictor

## Overview
This repository contains R code to predict the chances of a user canceling their mobile service based on several factors using logistic regression.

## Authors
- [Prajakta Tambe](#)
- [Varun Kapuria](#)

## Course Information
- Course: MIS 545 Section 01
- Lab Assignment: Lab06
- File Name: Lab06TambeKapuria.R

## Installation
Before running the code, you will need to install the following R packages if you haven't already. You can install them using the following commands:

```R
install.packages("tidyverse")
install.packages("corrplot")
install.packages("olsrr")
install.packages("smotefamily")
```

## Usage
- Clone this repository to your local machine.
```
git clone https://github.com/varunkapuria96/MobilePhoneSubscriberAnalysis-logistic-regression-with-r.git
```

- Set the working directory to the folder where you cloned this repository. You can change this line in the code to match your directory:

```
setwd("C:/working-directory")
```
- Open the R script Lab06TambeKapuria.R in your R environment.

- Run the script to execute the logistic regression analysis and predictions.

## Code Description
- The code reads mobile phone subscriber data from a CSV file.
- It performs exploratory data analysis, including creating histograms and a correlation matrix plot.
- Class imbalance is addressed using the SMOTE technique.
- A logistic regression model is generated to predict mobile service cancellations.
- Model accuracy and confusion matrix metrics are calculated.

## Results
- The script provides predictions for mobile service cancellations and evaluates model performance.

## Acknowledgments
- This code is part of a project completed for the MIS 545 course.
