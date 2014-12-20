## run_analysis.R
## author:  Maria Lee-Salisbury
## course:  Getting and Cleaning Data

## Step 1 - Create Directory:  The first step is to create a directory called Project if it doesn't already exist
## The Project directory will be used as the temporary directory in which to download
## the zipped project data, and then it will serve as the storage directory in which to 
## hold the unzipped project files.
if (!file.exists("./Getting and Cleaning Data")) {
        dir.create("./Getting and Cleaning Data")
}

if (!file.exists("./Getting and Cleaning Data/Project")) {
        dir.create("./Getting and Cleaning Data/Project")
}

## Step 2 - Download and Exract Files:  This step downloads the zipped project file from the web.  It then unzips the file 
## and extracts all project files into the directory created in the step above.
projectFile <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(projectFile, destfile = "./Getting and Cleaning Data/Project/Project_DataSet.zip")
unzip("./Getting and Cleaning Data/Project/Project_DataSet.zip", files = NULL, exdir = "./Getting and Cleaning Data/Project", overwrite = TRUE)

## Step 3 - Read Data into Table:  This step reads the features text file and the activity_labels text file into their own
## respective tables
features <- read.table("./Getting and Cleaning Data/Project/UCI HAR Dataset/features.txt", header=F, sep="")
activityLabels <- read.table("./Getting and Cleaning Data/Project/UCI HAR Dataset/activity_labels.txt", header=F, sep="")

## Step 3 - Read Data into Table:  This step reads each project data file for the Training set into their own respective tables
x_train <- read.table("./Getting and Cleaning Data/Project/UCI HAR Dataset/train/x_train.txt", header=F, sep="")
y_train <- read.table("./Getting and Cleaning Data/Project/UCI HAR Dataset/train/y_train.txt", header=F, sep="")
subject_train <- read.table("./Getting and Cleaning Data/Project/UCI HAR Dataset/train/subject_train.txt", header=F, sep="")

x_test <- read.table("./Getting and Cleaning Data/Project/UCI HAR Dataset/test/X_test.txt", header=F, sep="")
y_test <- read.table("./Getting and Cleaning Data/Project/UCI HAR Dataset/test/y_test.txt", header=F, sep="")
subject_test <- read.table("./Getting and Cleaning Data/Project/UCI HAR Dataset/test/subject_test.txt", header=F, sep="")
                           

## Step 4 - Assign column names to tables:  This step will assign definitive column names to each table
## relative to the data each table holds.  For example, the activityLables table will have columns renamed
## to "ActivityID" and "ActivityName" respectively to identify what kind of data is in each column of that
## table.  There are steps to rename the columns for each separate table.
colnames(features) <- c("FeatureID", "FeatureName")
colnames(activityLabels) <- c("ActivityID", "ActivityName")
colnames(y_train) <- c("ActivityID")
colnames(y_test) <- c("ActivityID")
colnames(subject_train) <- c("SubjectID")
colnames(subject_test) <- c("SubjectID")


## Step 5 - Merge activity_labels data file with the y_train and y_test data files
merged_activityLabels_ytrain <- join(activityLabels, y_train, type="right")
merged_activityLabels_ytest <- join(activityLabels, y_test, type="right")

## Step 6 -  Combine files:  Using the cbind function, this step combines the  subject_train file with the merged file of 
## merged_activityLabels_ytrain (which is the merge between the activity_labels file and the y_train file)
## and with merged_activityLabels_ytest (which is the merge between the activity_labels file and 
## the y_test data file)
initTidyData_ytrain <- cbind(subject_train, merged_activityLabels_ytrain)
initTidyData_ytest <- cbind(subject_test, merged_activityLabels_ytest)

## Step 7 -  Prep features data file:  This next step is to take the individual feature names of the features files and make them the
## column names of x_train and x_test files.  One of the first steps is to sort the features files to truly ensure
## the individual rows are in order before corresponding them to their respective columns in x_train and x_test.
st <- sort(features$FeatureID, index.return=TRUE)
features_sorted <- features[st$ix,]

names(x_test) = features_sorted$FeatureName
names(x_train) = features_sorted$FeatureName

## Step 8 -  Cleanup Variable Names:  This step of the script will edit the variable names to become more readable. 
## Some of the cleanup will include removing "()", "-", and correcting some of the labels so that an additional "Body"
## literal is removed from the label, thus making it more readable.
xtest.subset <- x_test[,grepl("mean\\()", names(x_test)) | grepl("std\\()", names(x_test))]
xtrain.subset <- x_train[,grepl("mean\\()", names(x_train)) | grepl("std\\()", names(x_train))]

xtest.edit <- sub("[(]","",names(xtest.subset),)
names(xtest.subset) = xtest.edit
xtest.edit <- sub("[)]","",names(xtest.subset),)
names(xtest.subset) = xtest.edit
xtest.edit <- gsub("[-]","",names(xtest.subset),)
names(xtest.subset) = xtest.edit
xtest.edit <- sub("BodyBody","Body",names(xtest.subset),)
names(xtest.subset) = xtest.edit

xtrain.edit <- sub("[(]","",names(xtrain.subset),)
names(xtrain.subset) = xtrain.edit
xtrain.edit <- sub("[)]","",names(xtrain.subset),)
names(xtrain.subset) = xtrain.edit
xtrain.edit <- gsub("[-]","",names(xtrain.subset),)
names(xtrain.subset) = xtrain.edit
xtrain.edit <- sub("BodyBody","Body",names(xtrain.subset),)
names(xtrain.subset) = xtrain.edit

## Step 9 - Combine files for Test data set and Training data set:  Using the cbind function, this step will merge the x_test data file with the previously
## merged file comprised of the activity_labels and subject_test data files.
TidyData.test <- cbind(initTidyData_ytest, xtest.subset)
TidyData.train <- cbind(initTidyData_ytrain, xtrain.subset)

## Step 10 - Combine the Test data set and the Training data set into one data frame using rbind.  Further
## clean up the data set by removing the ActivityID variable since the ActivityName is sufficient.
tidydata.combined <- rbind(TidyData.test, TidyData.train)
tidydata.combined$ActivityID = NULL

##  Step 11:  Calculate the average of each variable for each activity of each subject.  The first step is to
## use the gather() function to convert from a wide layout to a long layout.  Then, in the second step,
## the mean of each variable for each activity of each subject is calculated via the ddply function
# tidydata.gather <- gather(tidydata.combined, featurename, value, -SubjectID, -ActivityName)
tidydata.gather <- gather(tidydata.combined, variable, value, -SubjectID, -ActivityName)
names(tidydata.gather) = c("subject", "activity", "feature", "value")
tidydata.mean <- ddply(tidydata.gather, c("subject", "activity", "feature"), summarize, mean = mean(value))

## Final step:  Write the final tidy data to an output file using write.table function
write.table(tidydata.mean, file = "MSalisburyTidyData.txt", row.names=FALSE, col.names=TRUE)
