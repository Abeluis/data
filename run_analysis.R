# 1 Cargar librerias #### 
if (!require("pacman")) {
  install.packages("pacman")
}

pacman::p_load(dplyr, tidyverse) 

# 2 Cargar archivos #### 
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "data/Dataset.zip")

# Descomprimir 
unzip(zipfile = "data/Dataset.zip", exdir = "data")

# Archivos 
features <- read.table(file = "data/UCI HAR Dataset/features.txt") %>% 
  pull(2) %>% 
  as.character()

## 2.1 Procesar Train ####
# Vector con nombre 
activity_name <- c("N", "Actividades")
  
# df con actividades 
activity <- read.table(file = "data/UCI HAR Dataset/activity_labels.txt") %>% 
  set_names(activity_name)

# Renombrar actividades 

activity <- activity %>% 
  mutate(Actividades = case_when(
    Actividades == "WALKING" ~ "Caminar",
    Actividades == "WALKING_UPSTAIRS" ~ "Subir escaleras",
    Actividades == "WALKING_DOWNSTAIRS" ~ "Bajar escalares",
    Actividades == "SITTING" ~ "Estar sentado",
    Actividades == "STANDING" ~ "Estar parado",
    Actividades == "LAYING" ~ "Estar acostado"
  ))
 
# df con features
train_features <- read.table(file = "data/UCI HAR Dataset/train/X_train.txt") %>% 
  setNames(nm = features)

test_features <- read.table(file = "data/UCI HAR Dataset/test/X_test.txt") %>% 
  setNames(nm = features)

data_features <- rbind(train_features, test_features)

# df con activity 
train_activity <- read.table(file = "data/UCI HAR Dataset/train/y_train.txt") %>%
  rename("N" = 1) 

test_activity <- read.table(file = "data/UCI HAR Dataset/test/Y_test.txt") %>%
  rename("N" = 1) 

data_activity <- rbind(train_activity, test_activity)

data_activity <- inner_join(data_activity, activity, by = "N")

# df con subject 

train_subject <- read.table(file = "data/UCI HAR Dataset/train/subject_train.txt") %>% 
  rename("ID" = 1)

test_subject <- read.table(file = "data/UCI HAR Dataset/test/subject_test.txt") %>% 
  rename("ID" = 1)

data_subject <- rbind(train_subject, test_subject)

data <- cbind(data_subject, data_activity, data_features)

# 3 Media y desviacion estandar #### 
extraer <- data %>%
  select(ID, N, Actividades, matches("Mean|Std", ignore.case = TRUE))

# 4 Renombrar variables
extraer <- extraer %>%
  rename_with(~ {
    . <- gsub("Acc", "Acelerometro_", .)  
    . <- gsub("Gyro", "Giroscopio_",  .)
    . <- gsub("BodyBody", "Cuerpo_", .)
    . <- gsub("Body", "Cuerpo_", .)
    . <- gsub("Jerk", "Sobreaceleracion_", .)
    . <- gsub("Mag", "Magnitud_", .)
    . <- gsub("Gravity", "Gravedad_", .)
    . <- gsub("gravity", "Gravedad_", .)
    . <- gsub("angle", "Angulo_", .)
    . <- gsub("Mean", "Promedio_", .)
    . <- gsub("-std()", "ESTD", .)
    . <- gsub("-meanFreq()", "Frecuencia promedio_", .)
    . <- gsub("^t", "Tiempo_", .)
    . <- gsub("^f", "Frecuencia_", .)
    . <- gsub("-mean()", "Promedio_", .)
    gsub("BodyBody", "Cuerpo_",  .)
  })

# 5 Promedios y guardar datos #### 
promedios <- extraer %>%
  mutate(
    ID = as.factor(ID),
    N = as.factor(N)) %>% 
  group_by(ID, N, Actividades) %>% 
  summarize(across(everything(), mean, na.rm = TRUE), .groups = "keep") %>% 
  ungroup()

# Guardar
write.table(promedios, file = "data/Tidy.txt", row.names = FALSE)

 
