
## download the dataset and load it into the workspace

if(!file.exists("./data")){
    dir.create("./data")
    }

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/dataset.zip",method="curl")

## unzip the file

unzip(zipfile = "./data/dataset.zip", exdir = "./data")

## unzipped files are in the folder UCI HAR Dataset
## get the list of files in this folder

path <- file.path("./data", "UCI HAR Dataset/")
files <- list.files(path, recursive = TRUE) # list files inside directories
files

## Reading data files

## train dataset

x_train <- read.table(file.path(path,"train","X_train.txt"), header = FALSE)
y_train <- read.table(file.path(path,"train","y_train.txt"), header = FALSE)
subject_train <- read.table(file.path(path,"train","subject_train.txt"),
                            header = FALSE)

## test data

x_test <- read.table(file.path(path,"test","X_test.txt"), header = FALSE)
y_test <- read.table(file.path(path,"test","y_test.txt"), header = FALSE)
subject_test <- read.table(file.path(path,"test","subject_test.txt"),
                           header = FALSE)

##-----------------------------------------------------------------
## 1. Merges the training and the test sets to create one data set.
##-----------------------------------------------------------------

subject <- rbind(subject_train, subject_test)
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)


## naming the variables

names(subject) <- c("subject")
names(y) <- c("activity")
x_names <- read.table(file.path(path,"features.txt"), header = FALSE)
names(x) <- x_names$V2

## combining

data <- cbind(subject, y, x)

##---------------------------------------------------------------------
## 2.Extracts only the measurements on the mean and standard deviation 
## for each measurement.
##---------------------------------------------------------------------

## match the arguments we want to subset
idx <- x_names$V2[grep("mean\\(.*\\)|std\\(.*\\)", x_names$V2)]
idx <- c("subject","activity", idx)

## subset the dataset
subs <- data[,names(data) %in% idx == TRUE]
head(subs)


##--------------------------------------------------------------------------
## 3. Uses descriptive activity names to name the activities in the data set
##--------------------------------------------------------------------------

require(dplyr)

activityLabels <- read.table(file.path(path,"activity_labels.txt"), header = FALSE)
head(activityLabels)

# merge both datasets and bring activity names
subs <- merge(subs, activityLabels, by.x = "activity", by.y="V1")
names(subs)[69] <- "activityLabels"

##----------------------------------------------------------------------
## 4. Appropriately labels the data set with descriptive variable names.
##----------------------------------------------------------------------

names(subs) <- gsub("^t", "time", names(subs))
names(subs) <- gsub("^f", "frequency", names(subs))
names(subs) <- gsub("Acc", "Accelerometer", names(subs))
names(subs) <- gsub("Gyro", "Gyroscope", names(subs))
names(subs) <- gsub("Mag", "Magnitude", names(subs))
names(subs) <- gsub("BodyBody", "Body", names(subs))

##---------------------------------------------------------------------------
## 5.From the data set in step 4, creates a second, independent tidy data set
## with the average of each variable for each activity and each subject.
##---------------------------------------------------------------------------

ind_tidy_data <- subs %>%
    group_by(activity, subject) %>%
    summarise_each(funs(mean), -activityLabels) %>%
    ungroup() %>%
    arrange(activity, subject)













































