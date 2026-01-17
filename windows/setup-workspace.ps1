# ===================================
# Setup de Estrutura de Workspace
# ===================================

$ErrorActionPreference = "Stop"

function Write-Step { Write-Host "🔵 $args" -ForegroundColor Cyan }
function Write-Success { Write-Host "✅ $args" -ForegroundColor Green }
function Write-Info { Write-Host "📁 $args" -ForegroundColor Yellow }

$baseDir = $env:USERPROFILE

Write-Host "`n========================================" -ForegroundColor Magenta
Write-Host "  CONFIGURAÇÃO DE WORKSPACE" -ForegroundColor Magenta
Write-Host "  Local: $baseDir" -ForegroundColor Magenta
Write-Host "========================================`n" -ForegroundColor Magenta

Write-Step "Criando pastas base no diretório do usuário..."

$inbox = Join-Path $baseDir "inbox"
$projects = Join-Path $baseDir "projects"
$resources = Join-Path $baseDir "resources"
$archive = Join-Path $baseDir "archive"

New-Item -ItemType Directory -Path $inbox -Force | Out-Null
New-Item -ItemType Directory -Path $projects -Force | Out-Null
New-Item -ItemType Directory -Path $resources -Force | Out-Null
New-Item -ItemType Directory -Path $archive -Force | Out-Null

Write-Info "✓ inbox"
Write-Info "✓ projects"
Write-Info "✓ resources"
Write-Info "✓ archive"

Write-Step "`nCriando estrutura em resources..."

$resourceSubfolders = @("books", "images", "articles", "repositories")
foreach ($subfolder in $resourceSubfolders) {
    $path = Join-Path $resources $subfolder
    New-Item -ItemType Directory -Path $path -Force | Out-Null
    Write-Info "  ✓ resources\$subfolder"
}

Write-Step "`nCriando projeto exemplo..."

$projectExample = Join-Path $projects "project_folder_example"
New-Item -ItemType Directory -Path $projectExample -Force | Out-Null

$projectSubfolders = @("inbox", "resources", "archives")
foreach ($subfolder in $projectSubfolders) {
    $path = Join-Path $projectExample $subfolder
    New-Item -ItemType Directory -Path $path -Force | Out-Null
    Write-Info "  ✓ project_folder_example\$subfolder"
}

$projectResourceTypes = @("books", "images", "articles", "repositories")
foreach ($type in $projectResourceTypes) {
    $path = Join-Path $projectExample "resources\$type"
    New-Item -ItemType Directory -Path $path -Force | Out-Null
    Write-Info "  ✓ project_folder_example\resources\$type"
}

Write-Step "`nCriando atalhos simbólicos..."

function Create-Shortcut {
    param($targetPath, $shortcutPath, $description)
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($shortcutPath)
    $Shortcut.TargetPath = $targetPath
    $Shortcut.Description = $description
    $Shortcut.Save()
}

Create-Shortcut -targetPath $inbox -shortcutPath (Join-Path $projectExample "inbox\_LINK_TO_MAIN_INBOX.lnk") -description "Atalho para inbox principal"
Create-Shortcut -targetPath $resources -shortcutPath (Join-Path $projectExample "resources\_LINK_TO_MAIN_RESOURCES.lnk") -description "Atalho para resources principal"
Create-Shortcut -targetPath $archive -shortcutPath (Join-Path $projectExample "archives\_LINK_TO_MAIN_ARCHIVE.lnk") -description "Atalho para archive principal"

Write-Info "  ✓ Atalhos criados"

$inboxReadme = @"
# 📥 INBOX

## Propósito
Pasta de entrada para todos os itens não processados.

## Como usar
1. Todos os downloads vêm aqui primeiro
2. Processar semanalmente
3. Mover para pasta apropriada

## Regra de Ouro
Se está aqui há mais de 1 semana, precisa ser processado!
"@

$inboxReadme | Out-File (Join-Path $inbox "README.md") -Encoding UTF8

$resourcesReadme = @"
# 📚 RESOURCES

## Estrutura
- books/ - Livros e documentação
- images/ - Diagramas e mockups
- articles/ - Artigos salvos
- repositories/ - Links para repos Git
"@

$resourcesReadme | Out-File (Join-Path $resources "README.md") -Encoding UTF8

$archiveReadme = @"
# 🗄️ ARCHIVE

## Propósito
Arquivos não 100% necessários mas potencialmente úteis.

## Revisar trimestralmente
"@

$archiveReadme | Out-File (Join-Path $archive "README.md") -Encoding UTF8

$projectTemplate = @"
# PROJETO: Secretaria Digital

## Overview

### Problema
Igreja busca modernização administrativa.

### Ações Tomadas
- Período: Março-Junho 2024
- Plataforma: Eklesia
- Resultado: Descontinuado por custo

### Proposta
Desenvolver aplicação web customizada

### Alternativas
- Eklesia: R$ 800+
- BeChurch: R$ 600+
- InChurch: R$ 500+

## Links
- [Repositório](https://github.com/filoroch/ministerioatos-secretariadigital)
"@

$projectTemplate | Out-File (Join-Path $projectExample "PROJECT_OVERVIEW.md") -Encoding UTF8

Write-Host "`n========================================" -ForegroundColor Magenta
Write-Host "  ✅ WORKSPACE CONFIGURADO!" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Magenta

Write-Success "Estrutura criada em: $baseDir"
Write-Host ""
Write-Info "Pastas criadas:"
Write-Host "   inbox" -ForegroundColor Gray
Write-Host "   projects" -ForegroundColor Gray
Write-Host "   resources" -ForegroundColor Gray
Write-Host "   archive" -ForegroundColor Gray

Start-Process "explorer.exe" -ArgumentList $baseDir

Write-Host "`nPressione qualquer tecla para fechar..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
