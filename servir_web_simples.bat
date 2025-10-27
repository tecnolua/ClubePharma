@echo off
echo ========================================
echo   CLUBE PHARMA - Web Simples
echo ========================================
echo.
echo Este script vai:
echo 1. Servir os arquivos web estaticos (porta 8080)
echo 2. Voce precisa manter o backend rodando separadamente
echo.
pause

cd clube_pharma_frontend\build\web

echo.
echo Iniciando servidor web na porta 8080...
echo.
echo Acesse localmente: http://localhost:8080
echo.
echo Para acesso externo, abra outro terminal e execute:
echo   ngrok http 8080
echo.
echo ========================================
echo.

python -m http.server 8080
