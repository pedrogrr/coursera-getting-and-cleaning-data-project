#I need to load the plyr library
library(plyr)

# 1. Merge the training and test sets to create one data set
# I must load the X, Y and subject for train and test into Data sets and then must be merged
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Merge of X data
x_data <- rbind(x_train, x_test)

# Merge of Y data
y_data <- rbind(y_train, y_test)

# Merge of SUBJECT data
subject_data <- rbind(subject_train, subject_test)

# 2. Extract only the measurements on the mean and standard deviation for each measurement

features <- read.table("./data/UCI HAR Dataset/features.txt")

# Getting only columns with mean or std
mean_std_features <- grep("-(mean|std)\\(\\)", features[, 2])
x_data <- x_data[, mean_std_features]
names(x_data) <- features[mean_std_features, 2]


# 2. Use descriptive activity names to name the activities in the data set

activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

# correcting activity names
y_data[, 1] <- activities[y_data[, 1], 2]

# correcting column names
names(y_data) <- "activity"

# 4. Appropriately label the data set with descriptive variable names

# correcting column names
names(subject_data) <- "subject"

# all the data must be set in a data set
all_data <- cbind(x_data, y_data, subject_data)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# column 66 to (activity & subject)
avr_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(avr_data, "avr_data.txt", row.name=FALSE)
