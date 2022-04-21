library(tidyverse)

## Load the two datasets and put them in one dataset
data_test <- read.table("./test/X_test.txt")
data_train <- read.table("./train/X_train.txt")
data <- rbind(data_test, data_train)

## Load the features and set them as columnames of the sets
features <- read.table("./features.txt")[,2]
names(data) <- features

## Load the activity for each observation in test and train set and put them in one vector
activity_test <- unlist(read.table("./test/y_test.txt"), use.names =  FALSE)
activity_train <- unlist(read.table("./train/y_train.txt"), use.names =  FALSE)
activity <- c(activity_test, activity_train)

## Load the mapping of the activity IDs with their clearnames
activity_names <- read.table("./activity_labels.txt")
names(activity_names) <- c("ID", "activity_name")

## Selection of columnes that contain mean and std. 
mean_sd <- c("mean()", "sd()")


data_tidy <- data %>%
  select(contains(mean_sd)) %>%
  mutate(activity = activity) %>%
  merge(activity_names, by.x = "activity", by.y = "ID") %>%
  select(activity_name, everything()) %>%
  select(-activity)

data_tidy_2 <- data_tidy %>%
  group_by(activity_name) %>%
  summarise(across(everything(), list(mean)))