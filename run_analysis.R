## Create one R script called run_analysis.R that does the following: 
## 1. Merges the training and the test sets to create one data set. 
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set 
## 4. Appropriately labels the data set with descriptive activity names. 
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

# Check for libraries needed
if (!require('data.table')){install.packages('data.table')}
if (!require('dplyr')){install.packages('dplyr')}

# Load libraries used in script
library(data.table)
library(dplyr)

# Read the column variables 
features.col <- fread('./UCI HAR Dataset/features.txt',nrows=-1L)
names(features.col) <- c('Id','Feature')
features.ext.colid <- grep('-mean|-std',tolower(features.col$Feature))

# Read the activity labels
activity.lab <- fread('./UCI HAR Dataset/activity_labels.txt',nrows=-1L)
names(activity.lab) <- c('ActId','Activity')

# Read the training data to environment and merge. Use FREAD as it's much faster
X <- rbind(fread('./UCI HAR Dataset/train/X_train.txt',nrows=-1L),fread('./UCI HAR Dataset/test/X_test.txt',nrows=-1L))[,features.ext.colid,with=FALSE]
y <- rbind(fread('./UCI HAR Dataset/train/y_train.txt',nrows=-1L),fread('./UCI HAR Dataset/test/y_test.txt',nrows=-1L))
subject <- rbind(fread('./UCI HAR Dataset/train/subject_train.txt',nrows=-1L),fread('./UCI HAR Dataset/test/subject_test.txt',nrows=-1L))
data <- cbind(X,subject,y)

# Set the column names for train and test data, based on features and join the activity data
names(data) <- c(features.col$Feature[features.ext.colid],'subject','ActId')
setkey(data,ActId)
data <- data[activity.lab]

# Remove all the unneeded variables
rm(list=(ls()[ls()!="data"]))

# Tidy the data
tidy.data <- data[,lapply(.SD,mean),by=.(subject,Activity)]

# Write the file
write.table(tidy.data,file='./tidy.txt',row.names=FALSE,quote=FALSE,sep=';')
