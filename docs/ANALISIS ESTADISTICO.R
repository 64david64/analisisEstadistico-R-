analizar_datos_canavos <- function() {
  # Solicitar archivo CSV
  cat("Selecciona tu archivo CSV:\n")
  archivo <- file.choose()
  datos <- read.csv(archivo, header = TRUE)
  
  # Extraer la primera columna numérica
  columna <- names(datos)[1]
  valores <- na.omit(datos[[1]])
  
  if (!is.numeric(valores)) {
    stop("ERROR: La columna debe contener datos numéricos.")
  }
  
  # --- PASO 1: Calcular parámetros base ---
  n <- length(valores)
  minimo <- min(valores)
  maximo <- max(valores)
  rango <- maximo - minimo
  
  # --- PASO 2: Determinar diferencia mínima teórica (d) ---
  contar_decimales <- function(x) {
    if (all(x == floor(x))) return(0)
    x_split <- strsplit(as.character(x), "\\.")
    max(sapply(x_split, function(y) ifelse(length(y) > 1, nchar(y[2]), 0)))
  }
  
  decimales <- contar_decimales(valores)
  d <- ifelse(decimales == 0, 1, 10^(-decimales))  # d = 1 para enteros, 0.1, 0.01, etc. para decimales
  
  # --- PASO 3: Calcular número de clases (K) con Sturges ---
  k_teorico <- 1 + log2(n)
  k_floor <- floor(k_teorico)
  k_ceil <- ceiling(k_teorico)
  
  # --- PASO 4: Validar si la agrupación es posible ---
  # Calcular C (amplitud) para K posibles
  c_floor <- (rango + d) / k_floor
  c_ceil <- (rango + d) / k_ceil
  
  # Nueva función segura para verificar si un número tiene decimales válidos
  verificar_decimales <- function(c_valor, decimales_datos) {
    parte_decimal <- sub("^[^.]*\\.", "", formatC(c_valor, format = "f", digits = decimales_datos + 2))
    nchar_parte <- nchar(gsub("0+$", "", parte_decimal))  # Quita ceros a la derecha
    return(nchar_parte <= decimales_datos)
  }
  
  valido_floor <- verificar_decimales(c_floor, decimales)
  valido_ceil  <- verificar_decimales(c_ceil, decimales)
  
  if (!valido_floor && !valido_ceil) {
    stop(paste0("\nNO SE PUEDE REALIZAR LA AGRUPACIÓN:\n  - Ningún valor de K (", k_floor, " o ", k_ceil, 
                ") produce una amplitud (C) con ", decimales, " decimal(es).\n  - Revise los datos o los parámetros."))
  }
  
  # --- PASO 5: Si pasa las validaciones, usar K y C válidos ---
  if (valido_floor) {
    k_final <- k_floor
    c_final <- round(c_floor, decimales)
  } else {
    k_final <- k_ceil
    c_final <- round(c_ceil, decimales)
  }
  
  # --- Construcción de intervalos ---
  li1 <- minimo - (d / 2)
  limites_inf <- li1 + (0:(k_final - 1)) * c_final
  limites_sup <- limites_inf + c_final
  
  if (max(limites_sup) < maximo) {
    limites_sup[k_final] <- maximo
  }
  
  cortes <- cut(valores, breaks = c(limites_inf, limites_sup[k_final]), 
                right = FALSE, include.lowest = TRUE)
  niveles <- levels(cortes)
  niveles[length(niveles)] <- gsub("\\)$", "]", niveles[length(niveles)])
  
  frecuencias <- table(cortes)
  
  # --- Mostrar resultados ---
  cat("\n=== AGRUPACIÓN VÁLIDA ===\n")
  cat("Total de datos (n):", n, "\n")
  cat("Dato menor:", minimo, "| Dato mayor:", maximo, "| Rango (R):", rango, "\n")
  cat("Diferencia mínima teórica (d):", d, "\n")
  cat("Número de clases (K):", k_final, "\n")
  cat("Amplitud de clase (C):", c_final, "\n")
  cat("Límite inferior inicial (LI1):", li1, "\n\n")
  
  cat("=== DISTRIBUCIÓN DE FRECUENCIAS ===\n")
  print(data.frame(Intervalo = niveles, Frecuencia = as.numeric(frecuencias)))
  
  # --- Mostrar histograma de frecuencias ---
  hist(valores, breaks = c(limites_inf, limites_sup[k_final]), 
      col = "lightblue", border = "black", main = "Histograma de Frecuencias",
      xlab = "Valor", ylab = "Frecuencia", right = FALSE, include.lowest = TRUE)
}
# Ejecutar la función
analizar_datos_canavos()
