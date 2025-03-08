# Data

The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

[**Read More**](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

[**Download**](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

# Data Set

The data files used are the next

| Data                | Description                             |
|---------------------|-----------------------------------------|
| features.txt        | The name of the features in the dataset |
| activity_labels.txt | The names of the activities             |
| subject_test.txt    | The subject ID in the test session              |
| subject_train.txt   | The subject ID in the training sessions |
| X_test.txt          | The data recorded in the test session           |
| Y_test.txt          | The type of activity measured in the test as a number        |
| X_train.txt         | The data recorded in the training sessions |
| Y_train.txt         | The type of activity measured in the training sessions as a number  |

# Data transformations

1. The features.txt file is loaded and its values are extracted to be loaded as a vector with the name of the columns.
2. The activity_labels.txt file is loaded and its categorical values are translated into English.
3. The files X_test.txt and X_train.txt are loaded and joined with rbind.
4. The files Y_test.txt and Y_test.txt are loaded and merged with rbind.
5. The files subject_test.txt and subject_train.txt are loaded and linked with rbind.
6. The dataframe containing the translated activity_labels.txt is inner_joined with the previous test files.
7. A cbind is made between the subjects, activities, and the datarecorded. 
8. Extract the identification columns, ID, Activity Number and Activity name, as well as the mean and standard deviation. 
9. Rename the variables. 
10. Group by ID columns and average all other variables.
11. Save the data. 

 