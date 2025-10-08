#!/bin/bash

REPO="$HOME/legado"
MENU="$REPO/menu_lateral.html"
LOG="$REPO/bitacora_menu.txt"
DATE=$(date +"%Y-%m-%d %H:%M")
HASH=$(git rev-parse HEAD)

# 1. Corregir extensiones
find "$REPO" -type f \( -name "*.html" -o -name "*.css" \) -exec sed -i \
-e 's/\.JPG"/\.jpg"/g' \
-e "s/\.PNG'/\.png'/g" {} +

# 2. Validar rutas rotas
echo "🔍 Validando rutas rotas..." > "$LOG"
grep -rhoE 'src="[^"]+|href="[^"]+' "$REPO" | cut -d'"' -f2 | while read -r ruta; do
    [ -f "$REPO/$ruta" ] || echo "❌ Ruta rota: $ruta" >> "$LOG"
done

# 3. Extraer menú limpio
sed -n '/<!-- MENU-LATERAL-START -->/,/<!-- MENU-LATERAL-END -->/p' "$MENU" > "$REPO/menu_temp.txt"

# 4. Reemplazar menú en cada página
find "$REPO" -name "*.html" ! -name "menu_lateral.html" | while read -r pagina; do
    if grep -q '<!-- MENU-LATERAL-START -->' "$pagina"; then
        sed -i "/<!-- MENU-LATERAL-START -->/,/<!-- MENU-LATERAL-END -->/c\\
$(cat "$REPO/menu_temp.txt")" "$pagina"
        echo "✅ Menú sincronizado en: $pagina" >> "$LOG"
    else
        echo "⚠️ Sin delimitador en: $pagina" >> "$LOG"
    fi
done
rm "$REPO/menu_temp.txt"

# 5. Git commit y push
git add .
git commit -m "Validación completa: extensiones, rutas y menú lateral ($DATE)"
git pull --rebase origin main
git push origin main
bash validar_y_sincronizar_sitio.sh
