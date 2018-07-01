# Getting & Cleaning Data Course Project

# Creating Tidy data

## Set working directory and load libraries

setwd("C:/Users/lmortens/Documents/R/R Learning/getting-data-course-proj")
library(reshape2)

## Manually download zip file, unzip, review contents files - files now in the working directory

# Pull in the datasets and convert to character fields

labels<-read.table("activity_labels.txt")
features<-read.table("features.txt")
y_train<-read.table("y_train.txt")
y_test<-read.table("y_test.txt")
x_train<-read.table("X_train.txt")
x_test<-read.table("X_test.txt")
subject_train<-read.table("subject_train.txt")
subject_test<-read.table("subject_test.txt")

## Convert key fields to character to allow filtering
features[,2]<-as.character(features[,2])
labels[,2]<-as.character(labels[,2])

## Combine train, test, combine together
train<-cbind(subject_train,y_train,x_train)
test<-cbind(subject_test,y_test,x_test)
dt<-rbind(train,test)
colnames(dt)<-c("subject","activity",features[,2])

## Filter columns to those with mean and std in name, reformat

features_mean_std_vector <- grepl(".*mean.*|.*std.*", features[,2])
features_mean_std_names <- features[features_mean_std_vector,2]
features_mean_std_names = gsub("-std", "std", features_mean_std_names)
features_mean_std_names <- gsub(".*()", "", features_mean_std_names)

dt_mean_std<-dt[,c(TRUE,TRUE,features_mean_std_vector)]

## Replace activity with activity name

dt_mean_std$activity <-factor(dt_mean_std$activity , levels=labels[,1],labels = labels[,2])

## Convert subject to factor

dt_mean_std$subject <-as.factor(dt_mean_std$subject)

### Melt

dt_melt <- melt(dt_mean_std, id = c("subject", "activity"))
dt_cast <- dcast(dt_melt, subject + activity ~ variable, mean)

write.table(dt_mean_std, "tidy_total.txt", row.names = FALSE, quote = FALSE)
write.table(dt_cast, "tidy_mean.txt", row.names = FALSE, quote = FALSE)



