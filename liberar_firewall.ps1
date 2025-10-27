# Script para liberar portas no Firewall do Windows
# Execute como Administrador: PowerShell com "Executar como Administrador"

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  CLUBE PHARMA - Configurar Firewall" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Verificar se está rodando como administrador
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "ERRO: Este script precisa ser executado como Administrador!" -ForegroundColor Red
    Write-Host "`nClique com botão direito no arquivo e selecione:" -ForegroundColor Yellow
    Write-Host "'Executar com PowerShell (Admin)' ou 'Executar como Administrador'`n" -ForegroundColor Yellow
    Read-Host "Pressione Enter para sair"
    exit
}

Write-Host "Liberando portas no Firewall do Windows...`n" -ForegroundColor Green

# Remover regras antigas se existirem
Write-Host "[1/4] Removendo regras antigas (se existirem)..." -ForegroundColor Yellow
Remove-NetFirewallRule -DisplayName "Clube Pharma Backend" -ErrorAction SilentlyContinue
Remove-NetFirewallRule -DisplayName "Clube Pharma Frontend" -ErrorAction SilentlyContinue

# Liberar porta 3000 (Backend)
Write-Host "[2/4] Liberando porta 3000 (Backend API)..." -ForegroundColor Yellow
try {
    New-NetFirewallRule `
        -DisplayName "Clube Pharma Backend" `
        -Direction Inbound `
        -LocalPort 3000 `
        -Protocol TCP `
        -Action Allow `
        -Profile Any `
        -Description "Permite acesso externo ao backend do Clube Pharma"

    Write-Host "    OK - Porta 3000 liberada!" -ForegroundColor Green
} catch {
    Write-Host "    ERRO ao liberar porta 3000: $_" -ForegroundColor Red
}

# Liberar porta 8080 (Frontend Web - opcional)
Write-Host "[3/4] Liberando porta 8080 (Frontend Web - opcional)..." -ForegroundColor Yellow
try {
    New-NetFirewallRule `
        -DisplayName "Clube Pharma Frontend" `
        -Direction Inbound `
        -LocalPort 8080 `
        -Protocol TCP `
        -Action Allow `
        -Profile Any `
        -Description "Permite acesso externo ao frontend web do Clube Pharma"

    Write-Host "    OK - Porta 8080 liberada!" -ForegroundColor Green
} catch {
    Write-Host "    ERRO ao liberar porta 8080: $_" -ForegroundColor Red
}

# Listar regras criadas
Write-Host "`n[4/4] Verificando regras criadas..." -ForegroundColor Yellow
Get-NetFirewallRule -DisplayName "Clube Pharma*" | Format-Table DisplayName, Enabled, Direction, Action

# Descobrir IP local
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  INFORMAÇÕES DE REDE" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "Seu IP Local (para configurar no roteador):" -ForegroundColor Yellow
$ipLocal = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notlike "*Loopback*" -and $_.IPAddress -notlike "169.254.*" }).IPAddress | Select-Object -First 1
Write-Host "  $ipLocal" -ForegroundColor Green

Write-Host "`nSeu IP Público (para compartilhar com outros):" -ForegroundColor Yellow
try {
    $ipPublico = (Invoke-WebRequest -Uri "https://api.ipify.org" -TimeoutSec 5 -UseBasicParsing).Content
    Write-Host "  $ipPublico" -ForegroundColor Green

    Write-Host "`nURL para compartilhar:" -ForegroundColor Yellow
    Write-Host "  http://${ipPublico}:3000" -ForegroundColor Cyan
} catch {
    Write-Host "  Não foi possível obter IP público (verifique sua conexão)" -ForegroundColor Red
}

# Próximos passos
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  PRÓXIMOS PASSOS" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "1. Configure Port Forwarding no seu roteador:" -ForegroundColor Yellow
Write-Host "   - Porta Externa: 3000" -ForegroundColor White
Write-Host "   - Porta Interna: 3000" -ForegroundColor White
Write-Host "   - IP Local: $ipLocal" -ForegroundColor Green
Write-Host "   - Protocolo: TCP`n" -ForegroundColor White

Write-Host "2. Inicie o backend:" -ForegroundColor Yellow
Write-Host "   cd clube_pharma_backend" -ForegroundColor White
Write-Host "   npm run dev`n" -ForegroundColor White

Write-Host "3. Leia o arquivo ACESSO_REMOTO_IP.md" -ForegroundColor Yellow
Write-Host "   para instruções completas!`n" -ForegroundColor White

Write-Host "========================================`n" -ForegroundColor Cyan

Read-Host "Pressione Enter para sair"
