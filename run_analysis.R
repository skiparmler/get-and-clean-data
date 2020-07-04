
# Downloading data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip data
unzip(zipfile="./data/Dataset.zip",exdir="./data")


# Merge the training and the test sets to create one data set.

# Load train-data

x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Load test-data
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Load featur
features <- read.table('./data/UCI HAR Dataset/features.txt')

# Load activity labels:
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

# Set column names:

colnames(x_train) <- features[,2]
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

# Merging all data

mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)



#Extracts only the measurements on the mean and standard deviation for each measurement.


#Get column names:

colNames <- colnames(setAllInOne)

#Create vector for defining ID, mean and standard deviation:

mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

# Get subset of dats

setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]


#Uses descriptive activity names to name the activities in the data set


setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)


# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

# Save tidy data

write.table(secTidySet, "secTidySet.txt", row.name=FALSE)