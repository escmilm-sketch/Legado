#!/bin/bash

# Carpeta donde están las imágenes
CARPETA="guri"
BITACORA="bitacora_guri_v12.log"

# Archivos originales con tilde
declare -A archivos=(
  ["guría1.jpg"]="guria1.jpg"
  ["guría2.jpg"]="guria2.jpg"
  ["guría3.jpg"]="guria3.jpg"
)

echo "🧬 Inicio de renombrado y validación: $(date)" > "$BITACORA"

for original in "${!archivos[@]}"; do
  nuevo="${archivos[$original]}"
  
  if [ -f "$CARPETA/$original" ]; then
    mv "$CARPETA/$original" "$CARPETA/$nuevo"
    echo "✅ Renombrado: $original → $nuevo" >> "$BITACORA"
  else
    echo "⚠️ Archivo no encontrado: $original" >> "$BITACORA"
  fi

  # Validación de existencia y peso
  if [ -f "$CARPETA/$nuevo" ]; then
    peso=$(stat -c%s "$CARPETA/$nuevo")
    if [ "$peso" -gt 0 ]; then
      echo "✔️ Validado: $nuevo ($peso bytes)" >> "$BITACORA"
    else
      echo "❌ Archivo vacío: $nuevo" >> "$BITACORA"
    fi
  else
    echo "❌ Archivo faltante tras renombrado: $nuevo" >> "$BITACORA"
  fi
done

echo "🧾 Fin del proceso: $(date)" >> "$BITACORA"
