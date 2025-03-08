# CodeBook.md

## 1. Introduction
This file describes the variables, data, and transformations performed for the project. The main objective is to analyze the data from the **UCI HAR Dataset** on human activities recorded with sensors and generate a tidy dataset.

## 2. Data Description
- **Data source**: [UCI HAR Dataset](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
- **Data structure**:
  - Original data divided into training (`train`) and test (`test`) sets.
  - Includes measurements from accelerometers and gyroscopes in units of **m/s²** and **rad/s**.
- **Number of observations**: The combination of training and test sets.
- **License**: The data is publicly available with acknowledgment of the original source.

## 3. Variables
The variables represent sensor signals processed to calculate statistical features such as means and standard deviations.

Example of selected variables:
- **TimeBodyAccelerometerMeanX**: Mean of body acceleration on the X-axis in the time domain.
- **TimeBodyAccelerometerStdY**: Standard deviation of body acceleration on the Y-axis in the time domain.
- **FrequencyBodyGyroscopeMeanZ**: Mean of angular velocity on the Z-axis of the body in the frequency domain.

Each selected variable contains measurements related to:
- **Domains**: Time (`Time`) or frequency (`Frequency`).
- **Sensors**: Accelerometer (`Accelerometer`) or gyroscope (`Gyroscope`).
- **Features**: Mean (`Mean`) or standard deviation (`Std`).

### Additional variables:
- **ActivityName**: Descriptive name of the activity (e.g., walking, standing).
- **subject**: Identifier of the study participant.

## 4. Transformations and Cleaning
### **Step 1**: Data merging
- **Change**: Training and test datasets were merged using `rbind`.
- **Reason**: To create a single dataset for analysis.

### **Step 2**: Variable selection
- **Change**: Columns related to means and standard deviations were filtered.
- **Reason**: To simplify the analysis by focusing on relevant features.
- **Method**: Use of `grep` and selection with `select()`.

### **Step 3**: Descriptive labels
- **Change**: Column names were modified to be more readable (e.g., `tBodyAcc-mean()-X` to `TimeBodyAccelerometerMeanX`).
- **Reason**: To make the names interpretable.
- **Method**: Use of regular expressions with `gsub`.

### **Step 4**: Activity names
- **Change**: Activity IDs were replaced with descriptive names such as "WALKING".
- **Reason**: To facilitate data interpretation.
- **Method**: Joining the `activity_labels.txt` file with the data.

### **Step 5**: Tidy dataset
- **Change**: Calculation of the mean for each variable, grouped by activity and subject.

