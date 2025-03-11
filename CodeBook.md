# Data Cleaning Project

## 1. Introduction
This document describes the variables, data, and transformation steps used in the analysis of the dataset for the project. The main objective is to process and clean the **UCI HAR Dataset** on human activities recorded by sensors, creating a tidy dataset.

## 2. Data Description
- **Data source**: [UCI HAR Dataset](https://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
- **Data structure**:
  - Split into training and test datasets.
  - Measurements were obtained from accelerometers and gyroscopes in units of **m/s²** and **rad/s**.
- **Total number of observations**: A result of combining the training and test datasets.
- **License**: Data is publicly available with acknowledgment of the original source.

## 3. Variables in the Final Dataset

### Identifiers
- **subject**: Identifier for the subject who performed the activity (range: 1 to 30).
- **ActivityName**: Descriptive name of the activity performed.

### Measurements
The variables represent the mean values of specific features for each subject and activity combination. Examples of the final variables include:
- **mean_TimeBodyAccelerometerMeanX**: Mean of body acceleration in the X direction in the time domain.
- **mean_TimeBodyAccelerometerStdY**: Standard deviation of body acceleration in the Y direction in the time domain.
- **mean_FrequencyBodyGyroscopeMagnitudeMean**: Mean of gyroscope magnitude in the frequency domain.

### Activity Labels
The activities include:
1. **WALKING**
2. **WALKING_UPSTAIRS**
3. **WALKING_DOWNSTAIRS**
4. **SITTING**
5. **STANDING**
6. **LAYING**

## 4. Data Transformation and Cleaning Steps
The following steps were implemented to clean and prepare the dataset:
1. **Merging Datasets**:
   - The training (`X_train.txt`) and test (`X_test.txt`) datasets were combined into a single dataset.
2. **Selecting Specific Measurements**:
   - Columns corresponding to means (`mean()`) and standard deviations (`std()`) were selected.
3. **Adding Descriptive Activity Labels**:
   - Activity IDs were matched with descriptive names using the `activity_labels.txt` file.
4. **Renaming Columns**:
   - Parentheses and dashes were removed for clarity, and descriptive terms were used:
     - `t` → `Time`, `f` → `Frequency`
     - `Acc` → `Accelerometer`, `Gyro` → `Gyroscope`, `Mag` → `Magnitude`
5. **Creating a Tidy Dataset**:
   - A tidy dataset was created with the mean of each variable grouped by subject and activity.

## 5. Final Result
The final dataset contains:
- **Number of rows**: 180 (30 subjects × 6 activities).
- **Number of columns**: Descriptive variables and calculated averages.
- **Exported format**: `tidy_data.txt`, using the following code:
```R
write.table(tidy_data, file = "tidy_data.txt", sep = "\t", row.names = FALSE, col.names = TRUE, quote = FALSE)

