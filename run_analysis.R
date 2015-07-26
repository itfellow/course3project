
# merge all files
dtMerged <- c(scan("UCI HAR Dataset/test/X_test.txt"), scan("UCI HAR Dataset/train/X_train.txt"))
dtLabels <- c(scan("UCI HAR Dataset/test/y_test.txt"), scan("UCI HAR Dataset/train/y_train.txt"))
dtSubject <- c(scan("UCI HAR Dataset/test/subject_test.txt"), scan("UCI HAR Dataset/train/subject_train.txt"))
dtactivities <- read.table("UCI HAR Dataset/activity_labels.txt")
Activity <- sapply(dtLabels, (function(id) dtactivities$V2[id]))


features <- read.table("UCI HAR Dataset/features.txt")
features_index <- grep("mean\\(\\)|std\\(\\)", features$V2)

indexes <- 1:length(features$V2)
indexes_filter <- sapply(indexes, (function(index) index %in% features_index))
selected_features <- features[features_index,]

mean_std <- split(dtMerged[rep(indexes_filter, length(dtMerged) / length(indexes))], 1:length(features_index))

tidy_data <- data.frame(dtSubject, Activity, mean_std)
colnames(tidy_data) <- c("Subject", "Activity", sapply(selected_features$V2, (function(id) toString(id))))

write.table(tidy_data, file="myTidyDataSet.txt", row.name=FALSE)
