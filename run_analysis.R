##workspace preparation
rm(list=ls())
library(dplyr)

##generate row names
features <- read.table("Dataset/features.txt")
names <- as.character(features$V2)

##generate training dataset
traindata <- read.table("Dataset/train/X_train.txt")
traindatalabel <- read.table("Dataset/train/y_train.txt")
trainsubject <- read.table("Dataset/train/subject_train.txt")
colnames(traindata) <- names

train1 <- traindata[ ,-(461:502)]
train2 <- train1[ ,-(383:423)]
train3 <- train2[ ,-(303:344)]

mean_train <- select(train3, contains("mean()"))
std_train <- select(train3, contains("std()"))
train <- cbind(mean_train, std_train)
train$category <- "train"
train$activity_label <- traindatalabel[ ,1]
train$subject <- trainsubject[ ,1]

##read testing datasets
testdata <- read.table("Dataset/test/X_test.txt")
testdatalabel <- read.table("Dataset/test/y_test.txt")
testsubject <- read.table("Dataset/test/subject_test.txt")
colnames(testdata) <- names

##delete duplicated column names
test1 <- testdata[ ,-(461:502)]
test2 <- test1[ ,-(383:423)]
test3 <- test2[ ,-(303:344)]

mean_test <- select(test3, contains("mean()"))
std_test <- select(test3, contains("std()"))
test <- cbind(mean_test, std_test)
test$category <- "test"
test$activity_label <- testdatalabel[ ,1]
test$subject <- testsubject[ ,1]

##combine the datasets
data <- rbind(train, test)
data <- tbl_df(data)
data <- select(data, -(47:53))

##use activity names
labels <- read.table("Dataset/Activity_labels.txt")
data$activity <- labels$V2[match(data$activity_label, labels$V1)]
data <- select(data, -activity_label)

##Descriptive variable names
names(data) <- gsub("^t", "Time", names(data))
names(data) <- gsub("^f", "Frequency", names(data))
names(data) <- gsub("Acc", "Accelerometer", names(data))
names(data) <- gsub("Gyro", "Gyroscope", names(data))
names(data) <- gsub("BodyBody", "Body", names(data))
names(data) <- gsub("mean()", "Mean", names(data))
names(data) <- gsub("std()", "StandardDeviation", names(data))
names(data) <- gsub("\\(|\\)", "", names(data))
names(data) <- gsub("Mag", "Magnitude", names(data))

##generate a tidy data set with the average of each variable 
##for each activity and each subject
data2 <- select(data, contains("Mean"))
data3 <- select(data, activity, subject)
tidyset <- cbind(data2, data3)
write.table(tidyset, file = "tidydataset.txt", row.names = FALSE)