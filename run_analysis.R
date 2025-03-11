# Data Cleaning Project
# Load necessary library
library(dplyr)

# Set the working directory
setwd("C:/Users/USUARIO/Documents/UCI HAR Dataset")

# Check that the working directory has been set correctly
getwd()

# Question 1: Merge the datasets to create a single dataset.

merged_data <- bind_rows(
        read.table("C:/Users/USUARIO/Documents/UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt"),
        read.table("C:/Users/USUARIO/Documents/UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
)

# Verify that the datasets have been merged correctly
dim(merged_data)  # This will display the total number of rows and columns in the new dataset

# Question 2: Extract only the measurements on the mean and standard deviation for each measurement.

# Load the features.txt file
features <- read.table("C:/Users/USUARIO/Documents/UCI HAR Dataset/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)

# Identify the indices of columns with "mean()" or "std()"
mean_std_indices <- grep("mean\\(\\)|std\\(\\)", features$V2)

# Optional: Verify the names of the selected columns
mean_std_columns <- features$V2[mean_std_indices]
print(mean_std_columns)  # List of selected columns

# Select columns
filtered_data <- merged_data %>%
        select(matches("mean\\(\\)|std\\(\\)"))

# Question 3: Use descriptive activity names to name the activities in the dataset
# Load activity data
activity_data <- bind_rows(
        read.table("C:/Users/USUARIO/Documents/UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt", col.names = "ActivityID"),
        read.table("C:/Users/USUARIO/Documents/UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt", col.names = "ActivityID")
)

# Merge with activity labels
merged_data <- cbind(activity_data, merged_data) %>%
        left_join(read.table("C:/Users/USUARIO/Documents/UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt",
                             col.names = c("ActivityID", "ActivityName")),
                  by = "ActivityID")


# Question 4: Appropriately label the dataset with descriptive variable names.

# Rename columns
# Save the original column names
original_colnames <- colnames(merged_data)

# Create descriptive names for the variables

descriptive_colnames <- original_colnames %>%
        gsub("[()\\-]", "", .) %>%
        gsub("^t", "Time", .) %>%
        gsub("^f", "Frequency", .) %>%
        gsub("Acc", "Accelerometer", .) %>%
        gsub("Gyro", "Gyroscope", .) %>%
        gsub("Mag", "Magnitude", .) %>%
        gsub("BodyBody", "Body", .)

# Assign the descriptive names to the dataset
colnames(merged_data) <- descriptive_colnames

# Optional: Print to confirm
print(descriptive_colnames)


# Question 5: From the dataset in step 4, create a tidy dataset with the averages for each subject and each activity.

subject_train <- read.table("C:/Users/USUARIO/Documents/UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
subject_test <- read.table("C:/Users/USUARIO/Documents/UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

# Combine subject data
subject_data <- rbind(subject_train, subject_test)

# Add subjects to merged_data
merged_data <- cbind(subject_data, merged_data)

# Verify columns
colnames(merged_data)

# Group data by "subject" and "activity"
grouped_data <- merged_data %>%
        group_by(subject, ActivityName)

tidy_data <- merged_data %>%
        group_by(subject, ActivityName) %>%
        summarise(across(where(is.numeric), mean, .names = "mean_{col}"), .groups = "drop")

# Print the entire table of averages
print(tidy_data)


