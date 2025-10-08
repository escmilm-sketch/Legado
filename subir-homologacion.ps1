# subir-homologacion.ps1
$repoPath = "C:\Users\pzmaq\Legado"
$folder = "homologacion"
$branch = "main"
$commitMsg = "Agregar carpeta homologacion con contenido técnico"

Set-Location $repoPath

# Verificar si es un repo Git
if (-not (Test-Path ".git")) {
  Write-Error "❌ No se detecta repositorio Git en $repoPath. Inicializá o cloná primero."
  exit 1
}

# Confirmar que el remoto está bien configurado
$remoto = git remote -v
if ($remoto -notmatch "github.com/escmilm-sketch/Legado") {
  git remote remove origin 2>$null
  git remote add origin "https://github.com/escmilm-sketch/Legado.git"
}

# Traer cambios remotos
git fetch origin
git pull origin $branch --rebase

# Añadir carpeta y commitear
git add $folder
git commit -m $commitMsg 2>$null
if ($LASTEXITCODE -ne 0) {
  Write-Host "⚠️ No hay cambios nuevos para commitear."
} else {
  Write-Host "✅ Commit creado."
}

# Push al remoto
git push origin $branch
if ($LASTEXITCODE -eq 0) {
  Write-Host "🚀 Push completado a origin/$branch"
} else {
  Write-Error "❌ Error al pushear. Verificá credenciales o conflictos."
}
