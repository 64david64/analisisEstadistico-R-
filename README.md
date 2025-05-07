# Análisis Estadístico en R

##Descripción del proyecto:

Programa en R que nos permite analizar un conjunto de datos numéricos a partir de un archivo .csv (valores separados por comas). Esto, con el fin de determinar si es posible
agrupar los datos en intervalos de acuerdo con criterios estadísticos. A demás, implementa una versión automatizada de fórmulas y métodos usados por el autor George C. Canavos, incluyendo parámetros como la validación de la amplitud (c) de clase y la acantidad de decimales.

## Funcionalidades Principales 

**1.** Lectura automática de datos desde un archivo CSV.
**2.** Cálculo del rango, número de clases (K) usando la fórmula de Sturges, y amplitud de clase (C).
**3.** Validación para verificar si se puede realizar una agrupación válida con la cantidad de decimales detectada.
**4.** Construcción de la tabla de distribución de frecuencias por intervalos.
**5.** Visualización del histograma de frecuencias.

## Consideraciones y estructura esperada del archivo .csv

**1.** Solo se utiliza la primera columna numérica del archivo.
**2.** No debe contener texto en la columna usada, ni valores faltantes (NA).

## ¿Cuando NO se puede agrupar?

El programa lanza un error cuando ningún valor de K (entero más próximo hacia abajo o arriba) produce una amplitud C compatible con la cantidad de decimales presentes en los datos. Esto garantiza que los intervalos sean precisos, no se pierda información decimal y se evite redondear a amplitud de forma arbitraria.

## Visualización 

El programa genera automáticamente un histograma con los datos agrupados, lo que permite visualizar la distribución de manera clara y ordenada.

## Autores

David Acosta - Juana Fonseca
Universidad Distrital Francisco José de Caldas