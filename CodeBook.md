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

1. El archivo features.txt es cargado y se extraen sus valores para ser cargados como un vector con el nombre de las columnas.
2. El archivo activity_labels.txt es es cargaado y sus valores categoricos son traducidos al español.
3. Los archivos X_test.txt y X_train.txt son cargados y unidos con rbind.
4. Los archivos Y_test.txt e Y_test.txt son cargados y unidos con rbind.
5. Los archivos subject_test.txt y subject_train.txt son cargados y unidos con rbind.
6. Se hace un inner_join entre el dataframe que contiene las activity_labels.txt traducidas, con los anteriores archivos de test.
7. Se hace un cbind entre los subjects, activities, and the datarecorded. 
8. Se extraen las columnas de identificacion, ID, Activity Number and Activity name, también la media y desviación estandar. 
9. Se renombrar las variables. 
10. Se agrupa por columnas de identificación y se promedian todas las otras variables.
11. Se guardan los datos. 