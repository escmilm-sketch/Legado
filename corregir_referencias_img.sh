#!/usr/bin/env bash
set -euo pipefail

echo "🔍 Corrigiendo referencias a imágenes con extensión en mayúscula..."

# Extensiones comunes a corregir
EXTS=("JPG" "JPEG" "PNG" "GIF" "WEBP" "SVG")

# Archivos HTML a procesar
mapfile -t htmls < <(find . -maxdepth 1 -type f -name "*.html")

for html in "${htmls[@]}"; do
  for ext in "${EXTS[@]}"; do
    ext_lower="$(echo "$ext" | tr 'A-Z' 'a-z')"
    # Reemplazar src="imagen.JPG" → src="imagen.jpg"
    sed -i "s/\.\($ext\)\([\"']\)/.$ext_lower\2/g" "$html"
  done
done

echo "✅ Referencias corregidas en ${#htmls[@]} archivos HTML"

# Commit y push si hay cambios
git add *.html
git commit -m "Corregir referencias a imágenes con extensión en minúscula"
git pull --rebase origin main
git push origin main

echo "🚀 Cambios subidos a GitHub"
