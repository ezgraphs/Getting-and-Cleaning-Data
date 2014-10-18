Getting-and-Cleaning-Data
=========================

## Instructions for Running Script
The script run_analysis.R is relatively self contained.  It does depend on an installation of curl (used to allow use of https protocol).  The required data files are downloaded, staged and unzipped automatically inline.

## Description of Processing
The end result of running the script in an R Session is a file written named step5.txt and the population of a number of variables named tidy and tidy2.

In general the script combines the training and test data into a single monolithic data set.  Associated subject ids are included along with the activity labels that correspond with each measurement record.  Only measurements named average and standard deviation are included in the results set.  The measurements are in individual columns in the raw data.  In the processed results data, the columns are pivoted into an individual measurement per record.  The original measurements include an aggregated name, statistic (average and standard deviation), and optional coordinate (X, Y, Z).  These are split into separate columns in the final data set.
