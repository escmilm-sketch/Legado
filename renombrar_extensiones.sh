#!/usr/bin/env bash
set -euo pipefail

# Carpeta objetivo
DIR="3EN1"
BRANCH="main"
COMMIT_MSG="Renombrar extensiones a minúscula en carpeta 3EN1"

# Buscar archivos con extensión en mayúscula
mapfile -t archivos < <(find "$DIR" -type f -regex '.*\.[A-Z0-9]{1,5}$')

if [ ${#archivos[@]} -eq 0 ]; then
  echo "✅ No se encontraron extensiones en mayúscula en $DIR"
  exit 0
fi

echo "🔍 Archivos a renombrar: ${#archivos[@]}"

# Renombrar cada archivo
for archivo in "${archivos[@]}"; do
  base="$(basename "$archivo")"
  carpeta="$(dirname "$archivo")"
  nombre="${base%.*}"
  extension="${base##*.}"
