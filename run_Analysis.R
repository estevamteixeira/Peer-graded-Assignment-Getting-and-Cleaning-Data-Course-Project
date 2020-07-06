
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











































