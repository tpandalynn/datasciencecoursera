# This R script does the following:

# 1. Merges the training and the test sets to create one data set.


x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

# create 'x' data set
X <- rbind(x_train, x_test)

# create 'y' data set
Y <- rbind(y_train, y_test)

# create 'subject' data set
S <- rbind(subject_train, subject_test)

# 2. Extract only the measurements on the mean and standard deviation for each measurement.

features <- read.table("features.txt")

# get only columns with mean() or std() in their names
indices_of_mean_std_features <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])

# subset the desired columns
X <- X[, indices_of_mean_std_features]

# correct the column names
names(X) <- features[indices_of_mean_std_features, 2]
names(X) <- gsub("\\(|\\)", "", names(X))
names(X) <- tolower(names(X))

# 3. Use descriptive activity names to name the activities in the data set.

activities <- read.table("activity_labels.txt")
activities[, 2] = gsub("_", "", tolower(as.character(activities[, 2])))

# update values with correct activity names
Y[,1] = activities[Y[,1], 2]

# correct column name
names(Y) <- "activity"

# 4. Appropriately label the data set with descriptive variable names.

# correct column name
names(S) <- "subject"

# bind all the data in a single data set
cleaned <- cbind(S, Y, X)
write.table(cleaned, "merged_clean_data.txt")

# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject.

result <- ddply(cleaned, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(result, "data_set_with_the_averages.txt")
