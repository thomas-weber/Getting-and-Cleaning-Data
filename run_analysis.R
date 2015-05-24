## project file for Coursera course "Getting and Cleaning Data"

# clean up and load required libraries
rm(list = ls())
library(plyr)
library(dplyr)
library(reshape2)

# if necessary, download data file and unzip it
filename <- "UCI HAR Dataset.zip"
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists(filename)) {
  download.file(url, destfile = filename, method="curl")
  unzip(filename)
}

# read in the tables for matching 
#   - activity numbers with activity names
#   - column numbers with column names (aka features)
activity.Names <- read.table("UCI HAR Dataset/activity_labels.txt", header=FALSE, 
                             col.names = c("number", "name"), stringsAsFactors = FALSE)
feature.Names <- read.table("UCI HAR Dataset/features.txt", header=FALSE, 
                            col.names = c("number", "name"), stringsAsFactors = FALSE)

# load the datasets and add the activites and subjects columns to the
# two dataframes for training and test data
# the output of this paragraph are test.df and train.df dataframes
test.nrows = 2947
train.nrows = 7352

test.data <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE, 
                        colClasses = rep("numeric", 561), comment.char = "", 
                        nrows = test.nrows)
names(test.data) <- feature.Names[,2]
test.subjects <- read.table("UCI HAR Dataset/test/subject_test.txt", header=FALSE, 
                            nrows = test.nrows)
test.activities <- read.table("UCI HAR Dataset/test/y_test.txt", header=FALSE, 
                             nrows = test.nrows)
test.df <- plyr::mutate(test.data, 
                        subject=test.subjects[,1], activity=test.activities[,1])

train.data <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE, 
                         colClasses = rep("numeric", 561), comment.char = "", 
                         nrows=train.nrows)
names(train.data) <- feature.Names[,2]
train.subjects <- read.table("UCI HAR Dataset/train/subject_train.txt", header=FALSE, 
                            nrows = train.nrows)
train.activities <- read.table("UCI HAR Dataset/train/y_train.txt", header=FALSE, 
                             nrows = train.nrows)
train.df <- plyr::mutate(train.data, 
                        subject=train.subjects[,1], activity=train.activities[,1])

# find the indices of features that are mean or standard deviation for a measurement
# this includes the mean frequency values, despite the fact that they are weighted averages
indices.std <- grep("std", feature.Names["name"][,1])
indices.mean <- grep("mean", feature.Names["name"][,1])
indices <- c(indices.mean, indices.std)

# Preparations are finished, let's move to the assigned tasks

## step one - merge the data sets
df <- rbind(test.df, train.df)

## step two - extract mean and standard deviation for each measurement
## we also add the variables "activity" and "subject" back again
df.filtered <- df[, indices]
df.filtered <- cbind(df.filtered, subject = df[ ,"subject"], activity = df[ , "activity"])

## step three - name activites with names instead of numbers
## rename the (now-named "name") column to "activity"; drop the old "activity" column before that
## further, make "activity" a factor variable
df.named <- merge(df.filtered, activity.Names, by.x="activity", by.y = "number", all=FALSE)
df.named["activity"] <- NULL
df.named <- plyr::rename(df.named, c("name"="activity"))
df.named$activity <- factor(df.named$activity)

## step four - this was already done immediately after creating the data frames test.data
## and train.data

## step five
## melt the dataset into a new dataset with "activity" and "subject" being the id variables
## all other variables are measure variables
df.melt <- reshape2::melt(df.named, id.vars = c("activity", "subject"))
# cast the melted data set
df <- reshape2::dcast(df.melt, activity + subject ~ variable, mean)
write.table(x=df, file="output.txt", row.names = FALSE)
