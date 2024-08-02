url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "UCI_HAR_Dataset.zip")
unzip("UCI_HAR_Dataset.zip")


# Load required libraries
library(dplyr)

# Read training data
train_data <- read.table("UCI HAR Dataset/train/X_train.txt")
train_labels <- read.table("UCI HAR Dataset/train/y_train.txt")
train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")

# Read test data
test_data <- read.table("UCI HAR Dataset/test/X_test.txt")
test_labels <- read.table("UCI HAR Dataset/test/y_test.txt")
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Read features and activity labels
features <- read.table("UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")



# Merge the data
all_data <- rbind(train_data, test_data)
all_labels <- rbind(train_labels, test_labels)
all_subjects <- rbind(train_subjects, test_subjects)

# Name the columns
colnames(all_data) <- features$V2
colnames(all_labels) <- "activity"
colnames(all_subjects) <- "subject"



# Extract columns with mean and std
mean_std_cols <- grep("-(mean|std)\\(\\)", features$V2)
mean_std_data <- all_data[, mean_std_cols]


all_labels$activity <- factor(all_labels$activity, levels = activity_labels$V1, labels = activity_labels$V2)


# Combine data, labels, and subjects
final_data <- cbind(all_subjects, all_labels, mean_std_data)

# Clean the variable names
names(final_data) <- gsub("^t", "Time", names(final_data))
names(final_data) <- gsub("^f", "Frequency", names(final_data))
names(final_data) <- gsub("Acc", "Accelerometer", names(final_data))
names(final_data) <- gsub("Gyro", "Gyroscope", names(final_data))
names(final_data) <- gsub("Mag", "Magnitude", names(final_data))
names(final_data) <- gsub("BodyBody", "Body", names(final_data))



# Create tidy data set
tidy_data <- final_data %>%
  group_by(subject, activity) %>%
  summarise_all(list(mean = mean))

# Write the tidy data to a file
write.table(tidy_data, "tidy_data.txt", row.names = FALSE)
