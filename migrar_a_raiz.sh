#!/bin/bash

# Ir al directorio raíz del repositorio
cd "$(git rev-parse --show-toplevel)"

# Validar que existe la carpeta imgequipos
if [ ! -d "imgequipos" ]; then
  echo "❌ La carpeta 'imgequipos' no existe. Abortando."
  exit 1
fi

# Mover todas las subcarpetas de imgequipos a la raíz
echo "📦 Moviendo carpetas desde 'imgequipos/' a la raíz..."
for folder in imgequipos/*; do
  if [ -d "$folder" ]; then
    mv "$folder" .
    echo "✅ Movido: $(basename "$folder")"
  fi
done

# Eliminar carpeta vacía imgequipos
rmdir imgequipos && echo "🧹 Carpeta 'imgequipos' eliminada."

# Confirmar cambios en Git
git add .
git commit -m "Migración de carpetas desde imgequipos a raíz del sitio - módulo enseñable para Leonel"
git push

echo "🚀 Migración completada y sincronizada con GitHub."
