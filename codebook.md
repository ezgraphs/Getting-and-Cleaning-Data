# Codebook
The following is a description of data processed by the run_analysis.R script.

## Raw Data 
The raw data ([available for download](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)) originally published at the ([Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)) was collected from accelerometers on Samsung Galaxy S smartphones.   Thirty volunteers ages 19 to 48 years performed six activities wearing the smartphone on the waist. 

Each record in the dataset includes : 

* Triaxial (indicated by X,Y or Z axis) acceleration from the accelerometer.
* Triaxial Angular velocity from the gyroscope. 
* A 561-feature vector with time and frequency domain variables derived from the raw sensor data. 
* An activity label. 
* A numeric identifier representing the subject who carried out the experiment.

Training and test records separate in the raw data were combined in the current project into a single unified dataset.  The dataset is "raw" in the sense that it is in the original form provided for the project.  Processing and transformation did take place. Data is not simply raw values read from sensors.  See the documentation included with the original dataset for additional information. 

### File Listing

#### activity_labels.txt
An id and label representing the complete list of activities a subject is recorded as performing.

* WALKING
* WALKING_UPSTAIRS
* WALKING_DOWNSTAIRS
* SITTING
* STANDING	 
* LAYING

#### features.txt
An id and label representing the complete list of variables derived from raw accelerometer and gyroscope data.  

#### subject_test.txt, subject_train.txt
Each file consists of a single variable (subject).  Each record represents the subject associated with the measurements for the record on the corresponding line in the X_ and y_ files. Values are between 1 and 30.

#### X_test.txt, X_train.txt
Data for each subject.  Column identifiers found in features.txt
  
#### y_test.txt, y_train.txt
Test/Training lables for the datasets found in X_test.txt and X_train.txt.

## Final Data
A data frame consisting of 11880 rows and 6 columns.

Column Name   | Column Type | Description
--------------|-------------|---------------------------
activity_label| chr         | WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDIN ,LAYING 
subjectid     | int         | 1 through 30
name          | chr         | fBodyAcc, fBodyAccJerk, fBodyAccMag, fBodyBodyAccJerkMag, etc.
statistic     | chr         | mean() or std() for the name / coordinate
coordinate    | chr         | X,Y,Z (or NA)
avg           | num         | A decimal value for the name/coordinate/statistic (normalized to between -1 and 1)

Example of the first few lines of the file 

```
"activity_label" "subjectid" "name" "statistic" "coordinate" "avg"
"LAYING" 1 "fBodyAcc" "mean()" "X" -0.9390990524
"LAYING" 1 "fBodyAcc" "mean()" "Y" -0.86706520518
```

## Transformations
The following transformations of the raw data were performed:

* Training and Test Data was combined. 
* Columns containing measurements other than standard deviation and average were removed.
* Measurement records had the activity id added as a column.
* An activity label was sustituted for the activity id. 
* Added a PK "primary key" column used to join data frames as needed by a unique row number
* Pivoted to convert column name measurements represented in rows.
* Split measurement names into name, statistic and coordinate.  Not all measurements have coordinates (are listed as NA).
* Averaged the standard deviation and average for each measurement record.
