#Load Libraries:
library(tibble)
library(dplyr)
library(tidyr)
#read feature, activity, and subject data from test and training text files
colnames <- read.table('UCI HAR Dataset/features.txt',stringsAsFactors = FALSE)
test <- read.table('UCI HAR Dataset/test/X_test.txt',header = FALSE,stringsAsFactors = FALSE,col.names = colnames[,2])
testsubjects <- read.table('UCI HAR Dataset/test/subject_test.txt',header = FALSE,stringsAsFactors = FALSE,col.names = 'subject')
testpred <- read.table('UCI HAR Dataset/test/Y_test.txt',header = FALSE,stringsAsFactors = FALSE,col.names = 'activity')
train <- read.table('UCI HAR Dataset/train/X_train.txt',header = FALSE,stringsAsFactors = FALSE,col.names = colnames[,2])
trainsubjects <- read.table('UCI HAR Dataset/train/subject_train.txt',header = FALSE,stringsAsFactors = FALSE,col.names = 'subject')
trainpred <- read.table('UCI HAR Dataset/train/Y_train.txt',header = FALSE,stringsAsFactors = FALSE,col.names='activity')

# combine subject and activity data with to test and train tables
test <- add_column(test,subject = testsubjects[,1], activity = testpred[,1])
train <- add_column(train, subject = trainsubjects[,1], activity = trainpred[,1])

#combine test and train into one data frame
data <- bind_rows(test,train)


#use select to choose only the mean and standard deviation of variables
data <- select(data,c(grep('mean|std',names(data),value = TRUE),subject,activity))

#read activity labels from activity labels file
activities <- read.table('UCI HAR Dataset/activity_labels.txt',stringsAsFactors = FALSE)

#set activity data as a factor and give it correct labels
data$activity <- as.factor(data$activity)
levels(data$activity) <- tolower(activities[,2])

#remove unused variables from environment
rm(testpred,testsubjects,trainpred,trainsubjects,colnames,test,train)

#create summary table
summary <- summarise_all(group_by(data,subject,activity),mean)

#write main data table and summary table to disk as text files
write.table(data,file = 'data_set.txt')
write.table(summary,file='summary_data.txt')
