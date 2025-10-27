@echo off
echo ========================================
echo   CLUBE PHARMA - Iniciar Tudo
echo ========================================
echo.
echo Este script vai iniciar:
echo 1. Backend (porta 3000)
echo 2. Servidor Completo - Frontend + Proxy (porta 8080)
echo.
echo Depois voce so precisa rodar:
echo   ngrok http 8080
echo.
echo E compartilhar a URL gerada!
echo.
pause

echo.
echo [1/2] Iniciando Backend...
start "Backend - Clube Pharma" cmd /k "cd clube_pharma_backend && npm run dev"

echo.
echo Aguardando backend iniciar (5 segundos)...
timeout /t 5 >nul

echo [2/2] Iniciando Servidor Completo (Frontend + Proxy)...
start "Servidor Completo - Clube Pharma" cmd /k "npm start"

echo.
echo ========================================
echo   TUDO INICIADO!
echo ========================================
echo.
echo Aguarde 10 segundos para tudo carregar...
timeout /t 10 >nul
echo.
echo TESTE LOCAL:
echo   http://localhost:8080
echo.
echo PARA ACESSO EXTERNO:
echo   1. Abra um novo terminal
echo   2. Execute: ngrok http 8080
echo   3. Copie a URL gerada
echo   4. Compartilhe com seu primo!
echo.
echo ========================================
echo.
pause
