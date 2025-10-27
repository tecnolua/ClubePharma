# Script para adicionar Ngrok ao PATH do Windows
# Execute como Administrador

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  Adicionar Ngrok ao PATH" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Verificar se é Admin
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "ERRO: Execute como Administrador!" -ForegroundColor Red
    Write-Host "Clique com botão direito e selecione 'Executar como Administrador'`n" -ForegroundColor Yellow
    Read-Host "Pressione Enter para sair"
    exit
}

# Locais comuns onde ngrok pode estar
$possiblePaths = @(
    "C:\ProgramData\chocolatey\bin",
    "C:\ProgramData\chocolatey\lib\ngrok\tools",
    "$env:LOCALAPPDATA\Programs\ngrok",
    "$env:ProgramFiles\ngrok",
    "$env:USERPROFILE\Downloads",
    "$env:USERPROFILE\Desktop"
)

Write-Host "Procurando ngrok.exe...`n" -ForegroundColor Yellow

$ngrokPath = $null

# Procurar ngrok
foreach ($path in $possiblePaths) {
    if (Test-Path "$path\ngrok.exe") {
        $ngrokPath = $path
        Write-Host "Encontrado em: $ngrokPath" -ForegroundColor Green
        break
    }
}

# Se não encontrou, perguntar ao usuário
if (-not $ngrokPath) {
    Write-Host "Ngrok não encontrado nos locais comuns.`n" -ForegroundColor Yellow
    Write-Host "Digite o caminho completo onde está o ngrok.exe:" -ForegroundColor Yellow
    Write-Host "(Exemplo: C:\Users\Luana\Downloads)`n" -ForegroundColor Cyan

    $userPath = Read-Host "Caminho"

    if (Test-Path "$userPath\ngrok.exe") {
        $ngrokPath = $userPath
        Write-Host "`nEncontrado em: $ngrokPath" -ForegroundColor Green
    } else {
        Write-Host "`nERRO: ngrok.exe não encontrado em: $userPath" -ForegroundColor Red
        Write-Host "`nBaixe o ngrok em: https://ngrok.com/download" -ForegroundColor Yellow
        Read-Host "`nPressione Enter para sair"
        exit
    }
}

# Pegar PATH atual
$currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")

# Verificar se já está no PATH
if ($currentPath -like "*$ngrokPath*") {
    Write-Host "`nNgrok já está no PATH!" -ForegroundColor Green
    Write-Host "PATH atual inclui: $ngrokPath" -ForegroundColor Cyan
} else {
    Write-Host "`nAdicionando ao PATH..." -ForegroundColor Yellow

    # Adicionar ao PATH
    $newPath = "$currentPath;$ngrokPath"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")

    Write-Host "OK - Ngrok adicionado ao PATH!" -ForegroundColor Green
    Write-Host "Local adicionado: $ngrokPath" -ForegroundColor Cyan
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  Configuração Completa!" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "IMPORTANTE: Feche e reabra o PowerShell/CMD" -ForegroundColor Yellow
Write-Host "para que as mudanças no PATH tenham efeito.`n" -ForegroundColor Yellow

Write-Host "Depois, teste:" -ForegroundColor Cyan
Write-Host "  ngrok version`n" -ForegroundColor White

Read-Host "Pressione Enter para sair"
