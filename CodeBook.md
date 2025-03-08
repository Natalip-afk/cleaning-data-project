# Contenido del archivo CodeBook.md
codebook_content <- "
# CodeBook.md

## 1. Introducción
Este archivo describe las variables, los datos y las transformaciones realizadas para el proyecto. El objetivo principal es analizar los datos del conjunto **UCI HAR Dataset** sobre actividades humanas registradas con sensores, y generar un conjunto de datos ordenado.

## 2. Descripción de los Datos
- **Fuente de los datos**: [UCI HAR Dataset](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
- **Estructura de los datos**:
  - Datos originales divididos en conjuntos de entrenamiento (`train`) y prueba (`test`).
  - Incluye mediciones de acelerómetros y giroscopios en unidades **m/s²** y **rad/s**.
- **Número de observaciones**: La unión de los conjuntos de entrenamiento y prueba.
- **Licencia**: Los datos son de uso público con reconocimiento de la fuente original.

## 3. Variables
Las variables representan señales de sensores procesadas para calcular características estadísticas como medias y desviaciones estándar.

Ejemplo de variables seleccionadas:
- **TimeBodyAccelerometerMeanX**: Media de aceleración en el eje X del cuerpo en el dominio del tiempo.
- **TimeBodyAccelerometerStdY**: Desviación estándar de aceleración en el eje Y del cuerpo en el dominio del tiempo.
- **FrequencyBodyGyroscopeMeanZ**: Media de la velocidad angular en el eje Z del cuerpo en el dominio de la frecuencia.

Cada variable seleccionada contiene mediciones relacionadas con:
- **Dominios**: Tiempo (`Time`) o frecuencia (`Frequency`).
- **Sensores**: Acelerómetro (`Accelerometer`) o giroscopio (`Gyroscope`).
- **Características**: Media (`Mean`) o desviación estándar (`Std`).

### Variables adicionales:
- **ActivityName**: Nombre descriptivo de la actividad (por ejemplo, caminar, estar de pie).
- **subject**: Identificador del participante del estudio.

## 4. Transformaciones y Limpieza
### **Paso 1**: Unión de datos
- **Cambio**: Se unieron los conjuntos de datos de entrenamiento y prueba mediante `rbind`.
- **Motivo**: Crear un único conjunto de datos para análisis.

### **Paso 2**: Selección de variables
- **Cambio**: Se filtraron las columnas relacionadas con medias y desviaciones estándar.
- **Motivo**: Simplificar el análisis enfocándose en características relevantes.
- **Método**: Uso de `grep` y selección con `select()`.

### **Paso 3**: Etiquetas descriptivas
- **Cambio**: Nombres de columnas modificados para ser más legibles (por ejemplo, `tBodyAcc-mean()-X` a `TimeBodyAccelerometerMeanX`).
- **Motivo**: Hacer que los nombres sean interpretables.
- **Método**: Uso de expresiones regulares con `gsub`.

### **Paso 4**: Nombres de actividades
- **Cambio**: Se reemplazaron los IDs de las actividades por nombres descriptivos como "WALKING".
- **Motivo**: Facilitar la interpretación de los datos.
- **Método**: Unión del archivo `activity_labels.txt` con los datos.

### **Paso 5**: Conjunto de datos ordenado
- **Cambio**: Cálculo de la media
