@echo off
echo ========================================
echo   CLUBE PHARMA - Iniciar Web Completo
echo ========================================
echo.
echo Este script vai iniciar:
echo 1. Backend (porta 3000)
echo 2. Frontend Web (porta 8080)
echo.
echo Depois voce precisa abrir 2 terminais separados para ngrok:
echo   Terminal 1: ngrok http 3000
echo   Terminal 2: ngrok http 8080
echo.
echo Pressione qualquer tecla para continuar...
pause >nul

echo.
echo [1/2] Iniciando Backend...
start "Clube Pharma - Backend" cmd /k "cd clube_pharma_backend && npm run dev"

timeout /t 3 >nul

echo [2/2] Iniciando Frontend Web...
start "Clube Pharma - Frontend Web" cmd /k "cd clube_pharma_frontend && flutter run -d web-server --web-port 8080"

echo.
echo ========================================
echo   Servidores Iniciados!
echo ========================================
echo.
echo Backend: http://localhost:3000
echo Frontend: http://localhost:8080
echo.
echo PROXIMOS PASSOS:
echo.
echo 1. Aguarde os servidores iniciarem (30 segundos)
echo.
echo 2. Abra um NOVO terminal e execute:
echo    ngrok http 3000
echo.
echo 3. Abra OUTRO terminal e execute:
echo    ngrok http 8080
echo.
echo 4. Copie a URL do ngrok do frontend (porta 8080)
echo.
echo 5. Compartilhe com seu primo!
echo.
echo ========================================
pause
