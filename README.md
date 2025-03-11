# **title: "Cleaning Data Project"**
#### author: "Natali Pérez""
#### date: "`r Sys.Date()`"
#### output: html_document

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

# Data Cleaning Project
library(dplyr)  # Load necessary library

# Set working directory
setwd("C:/Users/USUARIO/Documents/UCI HAR Dataset")

# Merge training and testing datasets
merged_data <- bind_rows(
  read.table("C:/Users/USUARIO/Documents/UCI HAR Dataset/train/X_train.txt"),
  read.table("C:/Users/USUARIO/Documents/UCI HAR Dataset/test/X_test.txt")
)

# Load features and select mean and standard deviation measurements
features <- read.table("C:/Users/USUARIO/Documents/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
mean_std_indices <- grep("mean\\(\\)|std\\(\\)", features$V2)
filtered_data <- merged_data %>%
  select(matches("mean\\(\\)|std\\(\\)"))

# Load and combine activity data
activity_data <- bind_rows(
  read.table("C:/Users/USUARIO/Documents/UCI HAR Dataset/train/y_train.txt", col.names = "ActivityID"),
  read.table("C:/Users/USUARIO/Documents/UCI HAR Dataset/test/y_test.txt", col.names = "ActivityID")
)

# Merge activity labels
activity_labels <- read.table("C:/Users/USUARIO/Documents/UCI HAR Dataset/activity_labels.txt",
                              col.names = c("ActivityID", "ActivityName"))
merged_data <- cbind(activity_data, merged_data) %>%
  left_join(activity_labels, by = "ActivityID")

# Rename columns with descriptive variable names
original_colnames <- colnames(merged_data)
descriptive_colnames <- original_colnames %>%
  gsub("[()\\-]", "", .) %>%
  gsub("^t", "Time", .) %>%
  gsub("^f", "Frequency", .) %>%
  gsub("Acc", "Accelerometer", .) %>%
  gsub("Gyro", "Gyroscope", .) %>%
  gsub("Mag", "Magnitude", .) %>%
  gsub("BodyBody", "Body", .)
colnames(merged_data) <- descriptive_colnames

# Load and combine subject data
subject_train <- read.table("C:/Users/USUARIO/Documents/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
subject_test <- read.table("C:/Users/USUARIO/Documents/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
subject_data <- rbind(subject_train, subject_test)

# Add subject data to merged_data
merged_data <- cbind(subject_data, merged_data)

# Create tidy dataset with averages for each activity and subject
tidy_data <- merged_data %>%
  group_by(subject, ActivityName) %>%
  summarise(across(where(is.numeric), mean, .names = "mean_{col}"), .groups = "drop")

# Export the tidy dataset to a text file
write.table(tidy_data, file = "C:/Users/USUARIO/Desktop/tidy_data.txt",
            sep = "\t", row.names = FALSE, col.names = TRUE, quote = FALSE)

