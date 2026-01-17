# ===================================
# Script de Instalação - Winget
# ===================================

# Cores para output
function Write-Step { Write-Host "🔵 $args" -ForegroundColor Cyan }
function Write-Success { Write-Host "✅ $args" -ForegroundColor Green }
function Write-Error-Custom { Write-Host "❌ $args" -ForegroundColor Red }

$ErrorActionPreference = "Continue"
$apps = @(
    # Utils  
    "7zip.7zip",
    "Microsoft.Edge",
    "Microsoft.PowerToys",
    "Microsoft.WindowsTerminal"
    
    # Development
    # Gerenciadores de pacotes e compiladores
    "Rustlang.Rustup",
    "pnpm.pnpm",
    "ojdkbuild.openjdk.21.jdk",
    "OpenJS.NodeJS",
    "Python.Launcher",
    "Gitleaks.Gitleaks",
    "PHP.PHP.8.5",
    
    "Git.Git",

    # IDEs e ferramentas
    "JetBrains.IntelliJIDEA.Ultimate",
    "DBeaver.DBeaver.Community",
    "Postman.Postman",
    "Docker.DockerDesktop",
    "Google.Antigravity",
    
    # Games
    # Ative por sua conta e risco
    # "HydraLauncher.Hydra", 
    
    
)

Write-Host "`n========================================" -ForegroundColor Yellow
Write-Host "  INSTALAÇÃO AUTOMÁTICA - WINGET" -ForegroundColor Yellow
Write-Host "  Total de Apps: $($apps.Count)" -ForegroundColor Yellow
Write-Host "========================================`n" -ForegroundColor Yellow

$installed = 0
$failed = 0
$skipped = 0

foreach ($app in $apps) {
    $index = $apps.IndexOf($app) + 1
    Write-Step "[$index/$($apps.Count)] Instalando: $app"
    
    try {
        # Verificar se já está instalado
        $check = winget list --id $app --exact 2>&1
        if ($check -match $app) {
            Write-Host "  ⏭️  Já instalado, pulando..." -ForegroundColor DarkGray
            $skipped++
            continue
        }
        
        # Instalar com log em tempo real
        winget install --id $app --exact --silent --accept-source-agreements --accept-package-agreements --disable-interactivity
        
        if ($LASTEXITCODE -eq 0) {
            Write-Success "  Instalado com sucesso!"
            $installed++
        } else {
            Write-Error-Custom "  Falha na instalação (Exit Code: $LASTEXITCODE)"
            $failed++
        }
    }
    catch {
        Write-Error-Custom "  Erro: $_"
        $failed++
    }
    
    Write-Host ""
}

Write-Host "`n========================================" -ForegroundColor Yellow
Write-Host "  RESUMO DA INSTALAÇÃO" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "✅ Instalados:  $installed" -ForegroundColor Green
Write-Host "⏭️  Pulados:     $skipped" -ForegroundColor DarkGray
Write-Host "❌ Falharam:    $failed" -ForegroundColor Red
Write-Host "========================================`n" -ForegroundColor Yellow

# Log final
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$logFile = "winget-install-log_$timestamp.txt"
"Instalação concluída em $(Get-Date)" | Out-File $logFile
Write-Host "📝 Log salvo em: $logFile`n" -ForegroundColor Cyan

pause
