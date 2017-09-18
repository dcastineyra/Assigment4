library(dplyr) ##loads dplyr library to be used
library(plyr)
setwd("~/Data Science/UCI HAR Dataset") ##set working directory
features<-read.table("features.txt") ##reads the features
features<-features[,2] ##converts the second column into a vector to have a vector of features
features<-as.character(features)
activitylabels<-read.table("activity_labels.txt") ##reads the activity labels
activitylabels<-activitylabels[,2] ##converts the data into a vector
activitylabels<-as.character(activitylabels)

##Reading and merging data set
setwd("~/Data Science/UCI HAR Dataset/train") ##change working directory
trainset<-read.table("X_train.txt") ##reads the training data set
trainlabels<-read.table("y_train.txt")
trainlabels<-as.numeric(trainlabels[,1]) ##creates a numeric vector of the activity labels in the training data set
subtrain<-read.table("subject_train.txt")
subtrain<-subtrain[,1]

setwd("~/Data Science/UCI HAR Dataset/test") ##change working directory
testset<-read.table("X_test.txt") ##reads the test data set
testlabels<-read.table("y_test.txt")
testlabels<-as.numeric(testlabels[,1]) ##creates a numeric vector of the activity labels in the test data set
subtest<-read.table("subject_test.txt")
subtest<-subtest[,1]

totalset<-rbind(trainset,testset) ##merges the training and the test data sets. Merges the training and the test sets to create one data set
names(totalset)<-features ##names each column on the total data set. Appropriately labels the data set with descriptive variable names

##keeping columns with mean and std. Extracts only the measurements on the mean and standard deviation for each measurement
var1<-grep("*mean()|*std()",names(totalset)) ##control variable to know which columns contains mean and std
cleandata<-totalset[,var1] ##creates a data set with columns with mean and std
var2<-grep("*Freq",names(cleandata)) ##control variable to know wich columns contains meanFrequency and stdFrequency
cleandata<-cleandata[,-var2] ##creates a data set with columns with mean and std and excluding meanFrequency and stdFrequency

##including subjects and activity labels
totallabels<-c(trainlabels,testlabels) ##vector of the activities
totalsub<-c(subtrain,subtest) ##vector of subjects

## Uses descriptive activity names to name the activities in the data set
var3<-sapply(totallabels,function(i) activitylabels[i]) ##control variable to match activity labels with numeric labels in trainingset
cleandata<-cbind(activity=var3,cleandata) ##creates a column of activities
cleandata<-cbind(subject=totalsub,cleandata) ##creates a column of the subjects

## creates a new data table with the means by subject and activity
meandata<-melt(cleandata,c("subject","activity"))
meandata<-dcast(meandata,subject+activity~variable,mean)
write.table(meandata,"tidy_data5.txt",row.names = FALSE)
