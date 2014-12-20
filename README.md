==================================================================
analysis_run.R
Version 1.0
==================================================================
Maria Lee-Salisbury
Johns Hopkins University
Coursera
Getting and Cleaning Data
==================================================================



Purpose of the course project:
==============================
The purpose of this project, as part of the "Getting and Cleaning Data" course, was to learn how to gather, clean, and then work with the clean-up version of the data.  The ultimate goal of the project was to provide a tidy data set that adheres to the following principles, according to Hadley Wickham:

1.  Each variable forms a column
2.  Each observation forms a row
3.  Each table (or file) stores data about one class of experimental unit.

The goal of the "analysis_run.R" script was to collect the data pertaining to an experiment conducted on wearable computing, clean the data, and then provide a tidy data set such that it follows the rules set forth in the Tidy Data Set article written by Hadley Wickham.



The dataset includes the following files:
=========================================

- 'README.txt'

- 'analysis_run.R': Script that performs the following:  1)  Download files 2) Load files 3) Clean up files  4) Create a tidy data set

-  MSalisburyTidyData :  The final tidy data set that is a cleaned-up version of the raw data files.  In it is contained variables with descriptive readable column names, and
			 the average of the mean and of the standard deviation for each feature of each subject and activity.  The final tidy data set is presented in the 
			 long format to adhere to the following rule of Tidy Data  --  "Each observation forms a row".  Each feature of the experiment is considered a different
			 observation, which therefore warrants making each one a distinct row, hence having a long format for the final tidy data set.

- 'CODE BOOK.txt': Data dictionary describing all the attributes of the tidy data set




Description of analysis_run.R
=============================
The following description below describes all the steps taken to clean up the raw data files and convert into a tidy data set.


Step 1 - Create Directory:  The first step is to create a directory called Project if it doesn't already exist.  This will be the directory that will
store all the data files related to the experiment on which this project is performing its analysis.


Step 2 - Download and Exract Files:  This step downloads the zipped project file from the web.  It then unzips the file  and extracts all project files 
into the directory created in the step above.


Step 3 - Read Data into Table:  This step reads the features text file and the activity_labels text file into their own respective tables.  Then each 
project data file for the Training set is read into its own respective table.


Step 4 - Assign column names to tables:  This step will assign definitive column names to each table relative to the data each table holds.  For example, 
the activityLables table will have columns renamed to "ActivityID" and "ActivityName" respectively to identify what kind of data is in each column of that
table.  There are steps to rename the columns for each separate table.


Step 5 - Merge activity_labels data file with the y_train and y_test data files


Step 6 -  Combine files:  Using the cbind function, this step combines the  subject_train file with the merged file of 
merged_activityLabels_ytrain (which is the merge between the activity_labels file and the y_train file)
and with merged_activityLabels_ytest (which is the merge between the activity_labels file and the y_test data file)


Step 7 -  Prep features data file:  This next step is to take the individual feature names of the features files and make them the
column names of x_train and x_test files.  One of the first steps is to sort the features files to truly ensure
the individual rows are in order before corresponding them to their respective columns in x_train and x_test.


Step 8 -  Cleanup Variable Names:  This step of the script will edit the variable names to become more readable. 
Some of the cleanup will include removing "()", "-", and correcting some of the labels so that an additional "Body"
literal is removed from the label, thus making it more readable.


Step 9 - Combine files for Test data set and Training data set:  Using the cbind function, this step will merge the x_test data file with the previously
merged file comprised of the activity_labels and subject_test data files.


Step 10 - Combine the Test data set and the Training data set into one data frame using rbind.  Further
clean up the data set by removing the ActivityID variable since the ActivityName is sufficient.


Step 11:  Calculate the average of each variable for each activity of each subject.  The first step is to use the gather() function to convert from a 
wide layout to a long layout.  Then, in the second step, the mean of each variable for each activity of each subject is calculated via the ddply function


Final step:  Write the final tidy data to an output file using write.table function
