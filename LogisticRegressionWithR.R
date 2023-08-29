# The following code is to determine the chances of a user cancelling 
# their mobile service based on several factors using logistic regression

# Install the tidyverse, corrplot, olsrr, and smotefamily packages
# install.packages("tidyverse")
# install.packages("corrplot")
# install.packages("olsrr")
# install.packages("smotefamily")

# Load the tidyverse, corrplot, olsrr, and smotefamily libraries
library("tidyverse")
library("corrplot")
library("olsrr")
library("smotefamily")

# Set the working directory to your Lab06 folder
setwd("C:/Users/ual-laptop/Desktop/MIS545/Week6/Lab06")
getwd()

# Read MobilePhoneSubscribers.csv into a tibble called mobilePhone
mobilePhone <- read_csv(file = "MobilePhoneSubscribers.csv",
                        col_types = "lillnininn",
                        col_names = TRUE)

# Display mobilePhone in the console
print(mobilePhone)

# Display the structure of mobilePhone in the console
str(mobilePhone)


# Display the summary of mobilePhone in the console
summary(mobilePhone)

# Recreate the displayAllHistograms() function as shown in a prior video 
# demonstration
displayAllHistograms <- function(tibbleDataset) {
  tibbleDataset %>%
    keep(is.numeric) %>%
    gather() %>%
    ggplot() + geom_histogram(mapping = aes(x=value,fill=key),
                              color = "black") +
    facet_wrap (~key, scales = "free") +
    theme_minimal()
}

# Call the displayAllHistograms() function, passing in mobilePhone as an 
# argument
displayAllHistograms(mobilePhone)

# Display a correlation matrix of mobilePhonerounded to two decimal places
mobilePhoneRounded <- round(cor(mobilePhone),2)

# Display a correlation plot using the "number" method and limit output to the 
# bottom left
corrplot(cor(mobilePhone),
         method = "number",
         type = "lower")

# The correlation plot should reveal three pairwise correlations that are above 
# the threshold of 0.7. Remove the data plan and data usage variables from the 
# 3tibble
mobilePhone <- mobilePhone %>%
  select(-c(DataUsage,DataPlan))

# Randomly split the dataset into mobilePhoneTraining (75% of records) 
# and mobilePhoneTesting (25% of records) using 203 as the random seed
set.seed (203)
sampleMobilePhoneSet <- sample(nrow(mobilePhone),
                               round(nrow(mobilePhone)*0.75),
                               replace = FALSE)
mobilePhoneTraining <- mobilePhone[sampleMobilePhoneSet, ]
mobilePhoneTesting <- mobilePhone[-sampleMobilePhoneSet, ]
summary(mobilePhoneTraining)

# Check if we have a class imbalance issue in CancelledService
summary(mobilePhoneTraining$CancelledService)
classImbalanceMagnitude <- 1253 / 360

# Deal with class imbalance using the SMOTE technique 
# using a duplicate size of 3. Save the result into a 
# new tibble called mobilePhoneTrainingSmoted
mobilePhoneSmoted <- 
  tibble(SMOTE(X = data.frame(mobilePhoneTraining),
               target = mobilePhoneTraining$CancelledService,
               dup_size = 3)$data)
summary(mobilePhoneSmoted)

# Convert CancelledService and RecentRenewal back into logical types
mobilePhoneSmoted <- mobilePhoneSmoted %>%
  mutate(CancelledService = as.logical(CancelledService),
         RecentRenewal = as.logical(RecentRenewal))

# Get rid of the "class" column in the tibble
mobilePhoneSmoted <- mobilePhoneSmoted %>%
  select(-class)
summary(mobilePhoneSmoted)

# Generate the logistic regression model using CancelledService as the 
# binary dependent variable and save it in an object called mobilePhoneModel
mobilePhoneModel <- glm(data = mobilePhoneSmoted,
                        family = binomial,
                        formula = CancelledService ~ .)

# Display the logistic regression model results using the summary() function
summary(mobilePhoneModel)

# Calculate the odds ratios for each of the 7 independent variable coefficients
exp(coef(mobilePhoneModel)["AccountWeeks"])
exp(coef(mobilePhoneModel)["RecentRenewalTRUE"])
exp(coef(mobilePhoneModel)["CustServCalls"])
exp(coef(mobilePhoneModel)["AvgCallMinsPerMonth"])
exp(coef(mobilePhoneModel)["AvgCallsPerMonth"])
exp(coef(mobilePhoneModel)["MonthlyBill"])
exp(coef(mobilePhoneModel)["OverageFee"])

# Use the model to predict outcomes in the testing dataset
# Treating anything below or equal to 0.5 as a 0, anything above 0.5 as a 1.
mobilePhonePrediction <- predict(mobilePhoneModel,
                                 mobilePhoneTesting,
                                 type = "response")
print(mobilePhonePrediction)
mobilePhonePrediction <- 
  ifelse(mobilePhonePrediction >= 0.5, 1, 0)

# Generate a confusion matrix of predictions
mobilePhoneConfusionMatrix <- table(mobilePhoneTesting$CancelledService,
                                    mobilePhonePrediction)
print(mobilePhoneConfusionMatrix)

# Calculate the false positive rate
mobilePhoneConfusionMatrix[1,2] /
  (mobilePhoneConfusionMatrix[1,2] +
     mobilePhoneConfusionMatrix[1,1])

# Calculate the false negative rate
mobilePhoneConfusionMatrix[2,1] /
  (mobilePhoneConfusionMatrix[2,1] +
     mobilePhoneConfusionMatrix[2,2])

# Calculate the model prediction accuracy
sum(diag(mobilePhoneConfusionMatrix))/nrow(mobilePhoneTesting)
