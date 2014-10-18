Getting-and-Cleaning-Data
=========================

## Instructions for Running Script
The script run_analysis.R is relatively self contained.  It does depend on an installation of curl (used to allow use of https protocol).  The required data files are downloaded, staged and unzipped automatically inline.

## Description of Processing
The end result of running the script in an R Session is a file written named step5.txt and the population of a number of variables named tidy and tidy2.

In general the script combines the training and test data into a single monolithic data set.  Associated subject ids are included along with the activity labels that correspond with each measurement record.  Only measurements named average and standard deviation are included in the results set.  The measurements are in individual columns in the raw data.  In the processed results data, the columns are pivoted into an individual measurement per record.  The original measurements include an aggregated name, statistic (average and standard deviation), and optional coordinate (X, Y, Z).  These are split into separate columns in the final data set.

There are a couple of aspects of processing related to the assignment that were open to some interpretation.  

*  There was no definite requirement to include the downloading and staging of files - just that the files be included in the same directory as the script.  This implementation also includes code to download and stage files.  This approach was chosen because it encodes all processing required in a script and involves no manual steps.
*  The final data in this implementation is in a "narrow" format, rather than a wide one.  A narrow format has a record per sensor name, while a wide format has columns for each sensor measurement/coordinate/statistic reading.  Because it is in a narrow format, it needs to be grouped (using group_by or SQLDF with a GROUP BY query).  This is tidier in the sense that that there are no values in columns that might be considered data, and multiple pieces of information in the name of each sensor measurement (sensor measurement/coordinate/statistic) are split into independent columsn with the same type.  It might be considered "not tidy" in that NAs are introduced (for sensor readings that do not have coordinates), and because the wide version would not require grouping for the final analysis.  I opted for narrow because it made the data set easy to understand at a glance and because I could easier visualize the types of analysis I would want to perform. 