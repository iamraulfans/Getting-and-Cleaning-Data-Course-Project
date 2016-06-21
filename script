##generate row names
features <- read.table("Dataset/features.txt")
names <- as.character(features$V2)
col <- c(grep("mean\\(\\)", names), grep("std\\(\\)", names))

##read in and generate training dataset
traindata <- read.table("Dataset/train/X_train.txt")
traindatalabel <- read.table("Dataset/train/y_train.txt")
trainsubject <- read.table("Dataset/train/subject_train.txt")
colnames(traindata) <- names
train <- traindata[ ,col]

train$activity_label <- traindatalabel[ ,1]
train$subject <- trainsubject[ ,1]

##read in and generate testing datasets
testdata <- read.table("Dataset/test/X_test.txt")
testdatalabel <- read.table("Dataset/test/y_test.txt")
testsubject <- read.table("Dataset/test/subject_test.txt")
colnames(testdata) <- names
test <- testdata[ ,col]

test$activity_label <- testdatalabel[ ,1]
test$subject <- testsubject[ ,1]

##combine the datasets
data <- rbind(train, test)

##Uses descriptive activity names to name the activities in the data set
labels <- read.table("Dataset/Activity_labels.txt")
data$activity <- labels$V2[data$activity_label]
library(plyr)
library(dplyr)
data <- select(data, -activity_label)

##Appropriately labels the data set with descriptive variable names.
names(data) <- gsub("^t", "Time domain signal of ", names(data))
names(data) <- gsub("^f", "Frequency domain signal of ", names(data))
names(data) <- gsub("Acc", " acceleration", names(data))
names(data) <- gsub("Gyro", " angular velocity", names(data))
names(data) <- gsub("Mag", " magnitude", names(data))
names(data) <- gsub("Jerk", " Jerk", names(data))
write.table(data, file = "data.txt")
print("Writing data.txt")

##From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
rm(list=ls())
data <- read.table("data.txt")
tidyset <- ddply(data, .(subject, activity), .fun=function(x){ colMeans(x[,-c(67:68)]) })
write.table(tidyset, file = "tidydataset.txt", row.names = FALSE)
print("writing tidydataset.txt")
