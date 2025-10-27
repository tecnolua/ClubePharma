# Script para configurar Ngrok - Clube Pharma
# Execute normalmente (não precisa ser Admin)

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  CLUBE PHARMA - Configurar Ngrok" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Verificar se ngrok está instalado
Write-Host "[1/3] Verificando se ngrok está instalado..." -ForegroundColor Yellow

$ngrokPath = Get-Command ngrok -ErrorAction SilentlyContinue

if (-not $ngrokPath) {
    Write-Host "    Ngrok não encontrado!" -ForegroundColor Red
    Write-Host "`nDeseja instalar agora? (s/n): " -ForegroundColor Yellow -NoNewline
    $resposta = Read-Host

    if ($resposta -eq 's' -or $resposta -eq 'S') {
        Write-Host "`nInstalando ngrok via Chocolatey..." -ForegroundColor Green

        # Verificar se Chocolatey está instalado
        $chocoPath = Get-Command choco -ErrorAction SilentlyContinue

        if (-not $chocoPath) {
            Write-Host "`nChocolatey não está instalado." -ForegroundColor Red
            Write-Host "Instale manualmente:" -ForegroundColor Yellow
            Write-Host "1. Baixe ngrok em: https://ngrok.com/download" -ForegroundColor White
            Write-Host "2. Extraia o arquivo" -ForegroundColor White
            Write-Host "3. Execute: ngrok config add-authtoken SEU_TOKEN`n" -ForegroundColor White
            Read-Host "Pressione Enter para sair"
            exit
        }

        choco install ngrok -y

        Write-Host "`nNgrok instalado! Reinicie este script." -ForegroundColor Green
        Read-Host "Pressione Enter para sair"
        exit
    } else {
        Write-Host "`nBaixe ngrok manualmente em: https://ngrok.com/download" -ForegroundColor Yellow
        Read-Host "Pressione Enter para sair"
        exit
    }
} else {
    Write-Host "    OK - Ngrok encontrado: $($ngrokPath.Source)" -ForegroundColor Green
}

# Pedir o token
Write-Host "`n[2/3] Configurar token de autenticação" -ForegroundColor Yellow
Write-Host "`nPara pegar seu token:" -ForegroundColor Cyan
Write-Host "1. Acesse: https://dashboard.ngrok.com/get-started/your-authtoken" -ForegroundColor White
Write-Host "2. Copie o token`n" -ForegroundColor White

Write-Host "Cole seu token aqui (ou pressione Enter para pular): " -ForegroundColor Yellow -NoNewline
$token = Read-Host

if ($token) {
    Write-Host "`nConfigurando token..." -ForegroundColor Green
    & ngrok config cr_34fJeIf8ybt5HIIONdHhHfPCwx8 $token

    if ($LASTEXITCODE -eq 0) {
        Write-Host "    OK - Token configurado com sucesso!" -ForegroundColor Green
    } else {
        Write-Host "    ERRO - Não foi possível configurar o token" -ForegroundColor Red
    }
} else {
    Write-Host "    Pulado - Token não fornecido" -ForegroundColor Yellow
}

# Verificar configuração
Write-Host "`n[3/3] Verificando configuração..." -ForegroundColor Yellow

$configFile = "$env:USERPROFILE\.ngrok2\ngrok.yml"

if (Test-Path $configFile) {
    Write-Host "    OK - Arquivo de configuração encontrado" -ForegroundColor Green
    Write-Host "    Local: $configFile" -ForegroundColor Cyan

    # Ler o arquivo para verificar se tem authtoken
    $config = Get-Content $configFile -Raw
    if ($config -match "authtoken:") {
        Write-Host "    OK - Token configurado!" -ForegroundColor Green
    } else {
        Write-Host "    AVISO - Token não encontrado no arquivo" -ForegroundColor Yellow
    }
} else {
    Write-Host "    AVISO - Arquivo de configuração não encontrado" -ForegroundColor Yellow
}

# Instruções finais
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  COMO USAR" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "1. Abra um terminal e inicie o backend:" -ForegroundColor Yellow
Write-Host "   cd clube_pharma_backend" -ForegroundColor White
Write-Host "   npm run dev`n" -ForegroundColor White

Write-Host "2. Abra OUTRO terminal e inicie o ngrok:" -ForegroundColor Yellow
Write-Host "   ngrok http 3000`n" -ForegroundColor White

Write-Host "3. Copie a URL que aparece (https://...)" -ForegroundColor Yellow
Write-Host "   Exemplo: https://abc-123-def.ngrok-free.app`n" -ForegroundColor Cyan

Write-Host "4. Compartilhe esta URL com seu primo!" -ForegroundColor Yellow
Write-Host "   Ele pode acessar: https://sua-url.ngrok-free.app/health`n" -ForegroundColor White

Write-Host "5. Dashboard do Ngrok (no seu PC):" -ForegroundColor Yellow
Write-Host "   http://127.0.0.1:4040`n" -ForegroundColor Cyan

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  DICAS" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "• A URL muda toda vez que você reinicia o ngrok" -ForegroundColor White
Write-Host "• Para parar: Pressione Ctrl+C no terminal do ngrok" -ForegroundColor White
Write-Host "• O plano free é ilimitado mas a URL é aleatória" -ForegroundColor White
Write-Host "• Veja NGROK_SETUP.md para mais detalhes`n" -ForegroundColor White

# Perguntar se quer iniciar agora
Write-Host "Deseja iniciar o ngrok agora? (s/n): " -ForegroundColor Yellow -NoNewline
$iniciar = Read-Host

if ($iniciar -eq 's' -or $iniciar -eq 'S') {
    Write-Host "`nVerificando se o backend está rodando na porta 3000..." -ForegroundColor Yellow

    $backend = Get-NetTCPConnection -LocalPort 3000 -ErrorAction SilentlyContinue

    if ($backend) {
        Write-Host "    OK - Backend detectado na porta 3000!" -ForegroundColor Green
        Write-Host "`nIniciando ngrok...`n" -ForegroundColor Green

        # Iniciar ngrok
        & ngrok http 3000
    } else {
        Write-Host "    AVISO - Backend não está rodando!" -ForegroundColor Red
        Write-Host "`nInicie o backend primeiro:" -ForegroundColor Yellow
        Write-Host "    cd clube_pharma_backend" -ForegroundColor White
        Write-Host "    npm run dev`n" -ForegroundColor White

        Write-Host "Depois execute novamente este script ou digite:" -ForegroundColor Yellow
        Write-Host "    ngrok http 3000`n" -ForegroundColor White
    }
} else {
    Write-Host "`nPara iniciar depois, digite:" -ForegroundColor Yellow
    Write-Host "    ngrok http 3000`n" -ForegroundColor White
}

Write-Host "========================================`n" -ForegroundColor Cyan
