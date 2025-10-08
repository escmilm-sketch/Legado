#!/usr/bin/env bash
set -euo pipefail

echo "🔍 Corrigiendo referencias a imágenes con extensión en mayúscula en HTML y CSS..."

# Extensiones comunes
EXTS=("JPG" "JPEG" "PNG" "GIF" "WEBP" "SVG")

# Archivos HTML y CSS
mapfile -t archivos < <(find . -maxdepth 2 -type f \( -name "*.html" -o -name "*.css" \))

for archivo in "${archivos[@]}"; do
  for ext in "${EXTS[@]}"; do
    ext_lower="$(echo "$ext" | tr 'A-Z' 'a-z')"
    # Reemplazar .JPG → .jpg, etc.
    sed -i "s/\.\($ext\)\([\"')]\)/.$ext_lower\2/g" "$archivo"
  done
done

echo "✅ Referencias corregidas en ${#archivos[@]} archivos"

# Commit y push si hay cambios
git add *.html css/*.css
git commit -m "Corregir referencias a imágenes en HTML y CSS (extensiones en minúscula)"
git pull --rebase origin main
git push origin main

echo "🚀 Cambios subidos a GitHub"
