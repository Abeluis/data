# 1 Cargar librerias #### 
if (!require("pacman")) {
  install.packages("pacman")
}

pacman::p_load(dplyr, tidyverse) 

# 2 Cargar archivos #### 
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "Dataset.zip")

# Descomprimir 
unzip(zipfile = "Dataset.zip", exdir = "data")

# Archivos 
features <- read.table(file = "UCI HAR Dataset/features.txt") %>% 
  pull(2) %>% 
  as.character()

## 2.1 Procesar Train ####
# Vector con nombre 
activity_name <- c("Id", "Actividades")
  
# df con actividades 
activity <- read.table(file = "UCI HAR Dataset/activity_labels.txt") %>% 
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
 
# df con train x 
x_train <- read.table(file = "UCI HAR Dataset/train/X_train.txt") %>% 
  setNames(nm = features)

# df con train y, solo id de actividades
y_train <- read.table(file = "UCI HAR Dataset/train/y_train.txt") %>%
  rename("Id" = 1) 

# df con train y con id + nombre de actividades
y_train <- y_train %>% 
  right_join(activity, y_train, by = "Id")
 
# bind entre y_train y x_train 
train <- cbind(y_train, x_train)

## 2.2 Procesar Test #### 
x_test <- read.table(file = "UCI HAR Dataset/test/X_test.txt") %>% 
  setNames(nm = features)

y_test <- read.table(file = "UCI HAR Dataset/test/Y_test.txt") %>%
  rename("Id" = 1) 

# df con train y con id + nombre de actividades
y_test<- y_test %>% 
  right_join(activity, y_test, by = "Id")

# bind entre y_test y x_test
test <- cbind(y_test, x_test)

# Union entre train y test  
union <- rbind(train, test)

# 3 Media y desviacion estandar #### 
extraer <- union %>%
  select(matches("Id|Actividades|Mean|Std", ignore.case = TRUE))

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
  mutate(Id = as.factor(Id)) %>% 
  aggregate(. ~ Id + Actividades, data = ., FUN = mean) %>% 
  arrange(Id)

 
write.table(promedios, file = "Promedios.txt", row.names = FALSE)
