title: "Cleaning Data Project"
author: "Natali Pérez""
date: "`r Sys.Date()`"
output: html_document


## Purpose
Purpose
This project demonstrates the ability to clean, transform, and analyze a messy dataset, producing a tidy dataset ready for analysis.

## Scripts
The script run_analysis.R performs the following tasks:

1. Loads and combines training and test data.

2. Extracts measurements of mean and standard deviation.

3. Assigns descriptive names to activities and variables.

3. Calculates the average of each variable for each activity and subject.

4. Saves a tidy dataset as tidy_data.txt.


#Project questions once the data is loaded

# Project Data acquisition and cleaning

# Load necessary library
library(dplyr)

# Set working directory
setwd("C:/Users/USUARIO/Documents/UCI HAR Dataset")

# Check the current working directory
getwd()

# Question 1: Merge the training and test datasets to create a single dataset.

# Load training data
train_data <- read.table("C:/Users/USUARIO/Documents/UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")

# Load test data
test_data <- read.table("C:/Users/USUARIO/Documents/UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")

# Merge the datasets
merged_data <- rbind(train_data, test_data)

# Verify that the datasets were merged correctly
dim(merged_data)  # Check the total number of rows and columns in the new dataset

# Question 2: Extract only the measurements of mean and standard deviation for each measurement.

# Load the features.txt file
features <- read.table("C:/Users/USUARIO/Documents/UCI HAR Dataset/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)

# Identify the indices of columns with "mean()" or "std()"
mean_std_indices <- grep("mean\\(\\)|std\\(\\)", features$V2)

# Optional: Verify the names of the selected columns
mean_std_columns <- features$V2[mean_std_indices]
print(mean_std_columns)  # List of selected columns

# Filter "mean" and "std" columns using the identified indices
filtered_data <- merged_data[, mean_std_indices]

# Assign column names to the merged dataset
colnames(merged_data) <- features$V2

# Select columns with "mean" or "std" directly
filtered_data <- merged_data %>%
        select(matches("mean\\(\\)|std\\(\\)"))

# Question 3: Use descriptive activity names to name the activities in the dataset.

# Load activity_labels.txt
activity_labels <- read.table("C:/Users/USUARIO/Documents/UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt", col.names = c("ActivityID", "ActivityName"))

# Load activity data
train_activity <- read.table("C:/Users/USUARIO/Documents/UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt", col.names = "ActivityID")
test_activity <- read.table("C:/Users/USUARIO/Documents/UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt", col.names = "ActivityID")

# Merge training and test activity data
activity_data <- rbind(train_activity, test_activity)

# Add activity codes to merged_data
merged_data <- cbind(activity_data, merged_data)

# Merge activity_labels with the data
merged_data <- merge(merged_data, activity_labels, by = "ActivityID", all.x = TRUE)

# Validate column names in merged_data and activity_labels
colnames(merged_data)
colnames(activity_labels)

# Step 4: Appropriately label the dataset with descriptive variable names.

# Simplify column names
colnames(merged_data) <- gsub("[()\\-]", "", colnames(merged_data))
colnames(merged_data) <- gsub("^t", "Time", colnames(merged_data))
colnames(merged_data) <- gsub("^f", "Frequency", colnames(merged_data))
colnames(merged_data) <- gsub("Acc", "Accelerometer", colnames(merged_data))
colnames(merged_data) <- gsub("Gyro", "Gyroscope", colnames(merged_data))
colnames(merged_data) <- gsub("Mag", "Magnitude", colnames(merged_data))
colnames(merged_data) <- gsub("BodyBody", "Body", colnames(merged_data))

# Verify new column names
colnames(merged_data)

# Step 5: Create a second independent tidy dataset with the average of each variable for each activity and each subject.

# Load subject data
subject_train <- read.table("C:/Users/USUARIO/Documents/UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
subject_test <- read.table("C:/Users/USUARIO/Documents/UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

# Merge subject data
subject_data <- rbind(subject_train, subject_test)

# Add subjects to merged_data
merged_data <- cbind(subject_data, merged_data)

# Group data by "subject" and "activity"
tidy_data <- merged_data %>%
        group_by(subject, ActivityName) %>%
        summarise(across(where(is.numeric), \(x) mean(x, na.rm = TRUE)), .groups = "drop")

# Validate the final tidy dataset
head(tidy_data)

# Save the tidy dataset
write.table(tidy_data, "tidy_data.txt", row.names = FALSE)
