## This is a project for Getting and Cleaning Data course at Coursera
# We have to get a bunch of data from smartphone sensors, filter and combine
# it.



# First, we read activity labels like WALKING, STANDING, etc. 
# There are only 6 of them
alabels <- read.table("activity_labels.txt", stringsAsFactors = FALSE)
# and add names for readability
colnames(alabels) <- c("label", "activity")

# Read features: 561 different kinds of measurements, means, max, min, deviations, etc.
features <- read.table("features.txt", stringsAsFactors = FALSE)
# From those 561 types of data we have to get only means and stadard deviations
# so we use grep to find out their indexes in the 'features' data frame 
mean.std.idx <- grep("mean\\(|std", features$V2)

# Now we have to read and combine data from 'test' and 'train' datasets.
# We start with 'test' and repeat the same steps with 'train'.
# Read from the file
x.test <- read.table("test/X_test.txt", header = FALSE, col.names = features[ , 2])
# Leave only those that are 'mean' or 'std'
x.test.meanstd <- x.test[, mean.std.idx]
# Now read the table of activities. It's a one-column data frame with the 
# same number of records as in X_test file. It has just numbers from 1 to 6
y.test <- read.table("test/y_test.txt")
# Now we replace the numbers with their actual activity names
y.test[,1] <- alabels[y.test[,1],"activity"]
# and convert it to a vector to be able to cbind it with the data frame
# (actually I'm not sure if it's necessary)
y.test.vector <- as.vector(as.matrix(y.test))
# People who participated in this research are called 'subjects' and they are numbered
# from 1 to 24
# Again, we read a one-column data frame with the same number of records as
# in X_test - 2947 observations
subj.test <- read.table("test/subject_test.txt")
subj.test.vector <- as.vector(as.matrix(subj.test))
# And now we can create a combined data frame which includes subjects, activities
# with their names and observations only for mean and std data.
test.merged <- cbind(subj.test.vector, y.test.vector, x.test.meanstd)

## Now we repeat the same steps for 'train' data
x.train <- read.table("train/X_train.txt", header = FALSE, col.names = features[ , 2])
# Leave only those that are 'mean' or 'std'
x.train.meanstd <- x.train[, mean.std.idx]
# Now read the table of activities. It's a one-column data frame with the 
# same number of records as in X_train file. It has just numbers from 1 to 6
y.train <- read.table("train/y_train.txt")
# Now we replace the numbers with their actual activity names
y.train[,1] <- alabels[y.train[,1],"activity"]
# and convert it to a vector to be able to cbind it with the data frame
# (actually I'm not sure if it's necessary)
y.train.vector <- as.vector(as.matrix(y.train))
# People who participated in this research are called 'subjects' and they are numbered
# from 1 to 30.
# Again, we read a one-column data frame with the same number of records as
# in X_train - 7352 observations
subj.train <- read.table("train/subject_train.txt")
subj.train.vector <- as.vector(as.matrix(subj.train))
# And now we can create a combined data frame which includes subjects, activities
# with their names and observations only for mean and std data.
train.merged <- cbind(subj.train.vector, y.train.vector, x.train.meanstd)

# Before merging these two data frames, let's make sure they have similar column names
colnames(test.merged)[1] <- "subject"
colnames(train.merged)[1] <- "subject"
colnames(test.merged)[2] <- "activity"
colnames(train.merged)[2] <- "activity"


all.merged <- rbind(test.merged, train.merged)

# Now we have to produce averages by subject and by activity
# we split 'all.merged' into columns: subjects, activities and all features
# then we use apply and tapply to calculate averages
# (example taken from http://www.magesblog.com/2012/01/say-it-in-r-with-by-apply-and-friends.html)

all.s <- subset(all.merged, select = subject)
all.a <- subset(all.merged, select = activity)
all.f <- subset(all.merged, select = c(-subject,-activity))
mean.by.s <- apply(all.f, 2, function(x) tapply(x, all.s, mean))
mean.by.a <- apply(all.f, 2, function(x) tapply(x, all.a, mean))
mean.by.a.labels <- cbind(names(mean.by.a[,1]), mean.by.a)
mean.by.s.subj <- cbind(names(mean.by.s[,1]), mean.by.s)
colnames(mean.by.s.subj)[1] <- "subject"
colnames(mean.by.a.labels)[1] <- "activity"
write.table(mean.by.a.labels, "mean_by_activity.txt", row.names = FALSE)
write.table(mean.by.s.subj, "mean_by_subject.txt", row.names = FALSE)
