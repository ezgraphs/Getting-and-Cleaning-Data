## https://class.coursera.org/getdata-008/human_grading/view/courses/972586/assessments/3/submissions
## You should create one R script called run_analysis.R that does the following.
## Comments below include numbered tasks in comments that correspond to the assignment tasks

library(lubridate)
library(data.table)
library(tidyr)
library(dplyr)

##
## DOWNLOAD AND STAGE FILES 
##

##
## Utility function to move a group of files from a nested directory to
## the current working directory.
## Parameters: dir   - nested directory
##             files - group of files to move
##
mvFiles <- function(dir, files){
  sapply(files, FUN=function(f) file.rename(from=paste(dir,f,sep=''),to=f))
}

##
## Function to download and stage files
## If the data directory exists, skip this processing and 
## assume it is populated. Otherwise create the directory, 
## download the data, and move the files as needed
##
downloadAndStageFiles <- function(){
  
  dataDirectory<-"data"
  
  if (!file.exists(dataDirectory)) {
      
    ## Create a directory
    dir.create(dataDirectory)
    setwd(dataDirectory)
  
    ## Download and extract a zip file
    zipFile <- 'tmp.zip'
    url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
    download.file(url, zipFile, method='curl', mode = "wb")
    unzip(zipFile)
    setwd('..')
  
    ## Move the files to the script working directory
    mvFiles('data/UCI\ HAR\ Dataset/',       c('activity_labels.txt',            'features.txt'))
    mvFiles('data/UCI\ HAR\ Dataset/test/',  c('subject_test.txt', 'X_test.txt', 'y_test.txt'))
    mvFiles('data/UCI\ HAR\ Dataset/train/', c('subject_train.txt','X_train.txt','y_train.txt'))
  
  }else{
    print('Data directory exists, assume data previously downloaded.')
  }
}

##
## Read in a file and assign column names
##
read_file <- function(file_name, col_names){
  f        <- read.table(file_name, quote="\"", stringsAsFactors=FALSE)
  names(f) <- col_names
  return(f)
}

##
## Read in multiple files and concatenate the data frames
##
read_files <- function(file_name1, file_name2, col_names){
  return(rbind(read_file(file_name1, col_names), read_file(file_name2, col_names)))
}


##
## Main processing 
##
tryCatch(downloadAndStageFiles(), 
         error = function(e) print('Unable to download files')) 

##
## Read in the raw data
##
activity_labels  <- read_file("activity_labels.txt", c('activity', 'activity_label'))
features         <- read_file("features.txt", c('featureid', 'feature'))

## 1. Merge the training and the test sets to create one data set.
all_subjects  <- read_files("subject_test.txt", "subject_train.txt", c('subjectid'))
all_X         <- read_files("X_test.txt", "X_train.txt", features$feature)
all_Y         <- read_files("Y_test.txt", "Y_train.txt", c('activity'))

## 2. Extract only the measurements on the mean and standard deviation for each measurement. 
## Remove columns that are not either standard deviation or mean
all_X<-all_X[,grep("\\-std\\(\\)|\\-mean\\(\\)", names(all_X))]

## Convert to data tables for faster processing
all_X_table <- data.table(all_X)
all_Y_table <- data.table(all_Y)
all_subjects_table <- data.table(all_subjects)

## Add a 'Primary Key' - based on the row numbers
all_X_table$pk <- rownames(all_X_table)
all_Y_table$pk <- rownames(all_Y_table)
all_subjects_table$pk <- rownames(all_subjects)

## Combine the features and the activities
untidy    <- merge(all_X_table, all_Y_table, by=c('pk'))

## Combine the features/activities with the subjects
untidy    <- merge(untidy, all_subjects_table, by=c('pk'))
untidy$pk <- as.numeric(untidy$pk) 

## 3. Use descriptive activity names to name the activities in the data set
untidy    <- merge(untidy, activity_labels, by=c('activity'))

## 4. Appropriately label the data set with descriptive variable names. 
gathered  <- untidy %>% arrange(pk) %>% gather(measurement_name,measurement_val, 3:68)

## Divide into measurement name, statistic, and coordinate
## unique(tidy$measurement_name)
gathered$measurement_name <- as.character(gathered$measurement_name)
gathered$name       <- sapply(strsplit(gathered$measurement_name,'-'), function(x) x[1])
gathered$statistic  <- sapply(strsplit(gathered$measurement_name,'-'), function(x) x[2])
gathered$coordinate <- sapply(strsplit(gathered$measurement_name,'-'), function(x) x[3])

tidy <- gathered %>% select(subjectid, activity_label, name, statistic, coordinate, measurement_val)

## 5.  From the data set in step 4, creates a second, independent tidy data set with the 
## average of each variable for each activity and each subject.
tmp <- group_by(tidy, activity_label, subjectid, name, statistic, coordinate)
tidy2 <- summarize(tmp, mean(measurement_val))

## Write data for upload
write.table(tidy2, file="step5.txt", row.name=FALSE) 


## Alternate way of creating the data for 5 (using sqldf)
library(sqldf)
tidy3 <- sqldf('select activity_label, subjectid, name, statistic, coordinate, avg(measurement_val) avg from tidy group by activity_label, subjectid, name, statistic, coordinate')


