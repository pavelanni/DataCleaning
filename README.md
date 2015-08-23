# DataCleaning
This is a repository for the course project in Getting and Cleaning Data course
It has a script run_analysis.R that performs data importing and cleaning and
also the codebook that describes the variables.

## run_analysis.R script
The script takes data from several files in the working directory. 
1. It takes activity labels from 'activity_labels.txt' and creates a vector
2. It takes test and training data from test/X_test.txt and train/X_train.txt respectively. Each data set consists of 2947 and 7352 observations respectively. Each observation consists of 561 values: measurements data from the sensors and also mean, deviation, max, min, and other summary data from the measurements.
3. The script combines list of subjects (numbers from 1 to 30), activity labels ("STANDING", "WALKING", etc.) and sensor data in one data frame. 
4. The script selects only average and standard deviation data for each observation, producing 66 values per each observation.
5. Finally the script calculates avarages for each value per subject and per activity.
6. The script produces two tidy data files: 'mean_by_subject.txt' and 'mean_by_activity.txt' and stores them in the working directory. 
