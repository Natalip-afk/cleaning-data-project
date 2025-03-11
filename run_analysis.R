# Proyecto

# cargar 
library(dplyr)

# Crear el directorio de trabajo
setwd("C:/Users/USUARIO/Documents/UCI HAR Dataset")

# Comprobar que se ha creado el directorio de trabajo
getwd()

# Pregunta 1.Fusiona los conjuntos de entrenamiento y de prueba para crear un único conjunto de datos. 

# Cargar datos de entrenamiento
train_data <- read.table("C:/Users/USUARIO/Documents/UCI HAR Dataset/train/X_train.txt")

# Cargar datos de prueba
test_data <- read.table("C:/Users/USUARIO/Documents/UCI HAR Dataset/test/X_test.txt")

# para fusionarlos datos
merged_data <- rbind(train_data, test_data)

# Verifica que los datos se hayan combinado correctamente
dim(merged_data)  # Verá el número total de filas y columnas del nuevo conjunto

# Pregunta 2. Extrae sólo las mediciones de la media y la desviación estándar de cada medición.

# Cargar el archivo features.txt
features <- read.table("C:/Users/USUARIO/Documents/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)

# Identificar índices de las columnas con "mean()" o "std()"
mean_std_indices <- grep("mean\\(\\)|std\\(\\)", features$V2)

# Opcional: Verificar los nombres de las columnas seleccionadas
mean_std_columns <- features$V2[mean_std_indices]
print(mean_std_columns)  # Lista de columnas seleccionadas

# Filtrar columnas de "mean" y "std" usando los índices encontrados
filtered_data <- merged_data[, mean_std_indices]

# Asignar nombres de columnas al conjunto de datos fusionado
colnames(merged_data) <- features$V2

# Seleccionar columnas con "mean" o "std" directamente
filtered_data <- merged_data %>%
        select(matches("mean\\(\\)|std\\(\\)"))

# Pregunta 3. Utiliza nombres de actividades descriptivos para nombrar las actividades del conjunto de datos

# Cargar activity_labels.txt
activity_labels <- read.table("C:/Users/USUARIO/Documents/UCI HAR Dataset/activity_labels.txt", col.names = c("ActivityID", "ActivityName"))

# Cargar datos de actividad
train_activity <- read.table("C:/Users/USUARIO/Documents/UCI HAR Dataset/train/y_train.txt", col.names = "ActivityID")
test_activity <- read.table("C:/Users/USUARIO/Documents/UCI HAR Dataset/test/y_test.txt", col.names = "ActivityID")

# Fusionar datos de actividad de entrenamiento y prueba
activity_data <- rbind(train_activity, test_activity)

# Agregar códigos de actividad a merged_data
merged_data <- cbind(activity_data, merged_data)

# Fusionar activity_labels con los datos

merged_data <- merge(merged_data, activity_labels, by = "ActivityID", all.x = TRUE)

# Debido al aviso. se debe Revisar los nombres de las columnas:
colnames(merged_data)
colnames(activity_labels)

# Verificamos los nombres de las columnas de merget_data
colnames(merged_data)

# Renombra las columnas de merged_data para que tengan nombres más seguros:
colnames(merged_data) <- make.names(colnames(merged_data), unique = TRUE)

# Vuelve a realizar la combinación: Después de renombrar las columnas, 
# Intenta nuevamente la operación merge:
merged_data <- merge(merged_data, activity_labels, by = "ActivityID", all.x = TRUE)

# Verifica el resultado: Comprueba si la combinación fue exitosa sin advertencias:
head(merged_data)

# La columna "ActivityID" está presente en merged_data
# Sin embargo,el problema persiste debido a los nombres complejos de las columnas
# Renombrar columnas problemáticas:
colnames(merged_data) <- make.names(colnames(merged_data), unique = TRUE)

# Intentar la combinación nuevamente:
merged_data <- merge(merged_data, activity_labels, by = "ActivityID", all.x = TRUE)

# Verifica los resultados:
head(merged_data)
# Tambien se puede usar la función dplyr() para fusionar las columnas
library(dplyr)
merged_data <- merged_data %>%
        left_join(activity_labels, by = "ActivityID")



# Pregunta 4 Etiqueta adecuadamente el conjunto de datos con nombres descriptivos de las variables. 

# Ver los nombres actuales de las columnas
colnames(merged_data)

# Eliminar paréntesis y guiones
colnames(merged_data) <- gsub("[()\\-]", "", colnames(merged_data))

# Cambiar abreviaciones por nombres completos
colnames(merged_data) <- gsub("^t", "Time", colnames(merged_data))  # t -> Time
colnames(merged_data) <- gsub("^f", "Frequency", colnames(merged_data))  # f -> Frequency
colnames(merged_data) <- gsub("Acc", "Accelerometer", colnames(merged_data))  # Acc -> Accelerometer
colnames(merged_data) <- gsub("Gyro", "Gyroscope", colnames(merged_data))  # Gyro -> Gyroscope
colnames(merged_data) <- gsub("Mag", "Magnitude", colnames(merged_data))  # Mag -> Magnitude
colnames(merged_data) <- gsub("BodyBody", "Body", colnames(merged_data))  # Corregir duplicados de "Body"

# Imprimir los nuevos nombres de las columnas
colnames(merged_data)

# Confirmar el contenido de la combinación 
head(merged_data)

# Validar valores de ActivityID o ActivityName:
unique(merged_data$ActivityName)

# El resultado NULL indica que la columna ActivityName no fue añadida correctamente durante la combinación
# Verifica si ActivityID tiene valores coincidentes en ambos conjuntos de datos:
unique(merged_data$ActivityID)
unique(activity_labels$ActivityID)

# Confirmar los nombres de columnas en activity_labels
colnames(activity_labels)
head(activity_labels)

# Realiza la combinación nuevamente
merged_data <- merge(merged_data, activity_labels, by = "ActivityID", all.x = TRUE)

# verifica el resultado 
head(merged_data$ActivityName)
unique(merged_data$ActivityName)



# Pregunta 5. A partir del conjunto de datos del paso 4, 
# Crea un segundo conjunto de datos independiente y ordenado con la media de cada variable para cada actividad y cada sujeto.


# Cargar datos de sujetos
subject_train <- read.table("C:/Users/USUARIO/Documents/UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
subject_test <- read.table("C:/Users/USUARIO/Documents/UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

# Fusionar datos de sujetos
subject_data <- rbind(subject_train, subject_test)

# Agregar sujetos a merged_data
merged_data <- cbind(subject_data, merged_data)

# Verificar columnas
colnames(merged_data)

# Agrupar datos por "sujeto" y "actividad"
grouped_data <- merged_data %>%
        group_by(subject, ActivityName)

# Calcular la media de todas las columnas

tidy_data <- merged_data %>%
        group_by(subject, ActivityName) %>%
        summarise(across(everything(), mean, na.rm = TRUE))

# Código corregido:
tidy_data <- merged_data %>%
        group_by(subject, ActivityName) %>%
        summarise(across(where(is.numeric), \(x) mean(x, na.rm = TRUE)), .groups = "drop")

# Cómo validar el resultado:

head(tidy_data)


