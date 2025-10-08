#!/usr/bin/env bash
set -euo pipefail

# Ruta local (ajustada para Git Bash en Windows)
REPO="/c/Users/pzmaq/Legado"
CARPETA="homologacion"
BRANCH="main"
COMMIT_MSG="Agregar carpeta homologacion con contenido técnico"

cd "$REPO"

# Verificar que estamos en un repo Git
if [ ! -d ".git" ]; then
  echo "❌ No se detecta repositorio Git en $REPO"
  exit 1
fi

# Confirmar que la carpeta existe
if [ ! -d "$CARPETA" ]; then
  echo "❌ Carpeta $CARPETA no encontrada en $REPO"
  exit 1
fi

# Confirmar remoto
REMOTE_URL="$(git remote get-url origin 2>/dev/null || echo "")"
if [[ "$REMOTE_URL" != *"escmilm-sketch/Legado"* ]]; then
  git remote remove origin 2>/dev/null || true
  git remote add origin "https://github.com/escmilm-sketch/Legado.git"
fi

# Traer cambios remotos
git fetch origin
git pull --rebase origin "$BRANCH"

# Añadir carpeta y commitear
git add "$CARPETA"
if git diff --cached --quiet; then
  echo "⚠️ No hay cambios nuevos para commitear."
else
  git commit -m "$COMMIT_MSG"
  echo "✅ Commit creado."
fi

# Push al remoto
git push origin "$BRANCH"
echo "🚀 Push completado a origin/$BRANCH"
