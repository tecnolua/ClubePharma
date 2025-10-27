# Guia Completo - Ngrok Setup

## Passo a Passo para Configurar Ngrok

### 1. Instalar Ngrok

#### Opção A - Via Chocolatey (Recomendado):
```bash
choco install ngrok
```

#### Opção B - Download Manual:
1. Baixe em: https://ngrok.com/download
2. Extraia o arquivo `ngrok.exe`
3. Coloque em uma pasta (ex: `C:\ngrok\`)
4. Adicione ao PATH do Windows

### 2. Pegar seu Token de Autenticação

1. Acesse: https://dashboard.ngrok.com/get-started/your-authtoken
2. Ou vá em: https://dashboard.ngrok.com → **Your Authtoken**
3. Copie o token (algo como: `2abc123def456ghi789jkl012mno345_6PqRsTuVwXyZ`)

### 3. Configurar o Token no Ngrok

Abra o **CMD** ou **PowerShell** e execute:

```bash
ngrok config add-authtoken SEU_TOKEN_AQUI
```

Exemplo:
```bash
ngrok config add-authtoken 2abc123def456ghi789jkl012mno345_6PqRsTuVwXyZ
```

Deve aparecer:
```
Authtoken saved to configuration file: C:\Users\SEU_USUARIO\.ngrok2\ngrok.yml
```

### 4. Iniciar o Backend

Em um terminal:
```bash
cd clube_pharma_backend
npm run dev
```

Aguarde até ver:
```
🚀 ClubePharma API Server is running!
📍 Port: 3000
```

### 5. Iniciar o Ngrok

Em **OUTRO TERMINAL** (deixe o backend rodando):

```bash
ngrok http 3000
```

Ou com domínio customizado (se tiver conta paga):
```bash
ngrok http 3000 --domain=seu-dominio.ngrok.app
```

### 6. Resultado

Você vai ver algo assim:

```
ngrok

Session Status                online
Account                       Luana (Plan: Free)
Version                       3.x.x
Region                        South America (sa)
Latency                       -
Web Interface                 http://127.0.0.1:4040
Forwarding                    https://abc-123-def.ngrok-free.app -> http://localhost:3000

Connections                   ttl     opn     rt1     rt5     p50     p90
                              0       0       0.00    0.00    0.00    0.00
```

### 7. URLs Importantes

**URL Pública** (compartilhe esta):
```
https://abc-123-def.ngrok-free.app
```

**Dashboard Local** (só no seu PC):
```
http://127.0.0.1:4040
```
↑ Abra no navegador para ver requisições em tempo real!

### 8. Testar

No seu navegador:
```
https://abc-123-def.ngrok-free.app/health
```

Deve retornar:
```json
{
  "status": "OK",
  "message": "ClubePharma API is running"
}
```

### 9. Compartilhar com seu Primo

Envie a URL para ele:
```
https://abc-123-def.ngrok-free.app
```

**IMPORTANTE**: Sempre use HTTPS (com S) com ngrok!

---

## Configurar Frontend para Usar Ngrok

### Editar `clube_pharma_frontend/lib/config/api_config.dart`:

```dart
class ApiConfig {
  // Substitua pela URL do ngrok (COM https://)
  static const String baseUrlRemote = 'https://abc-123-def.ngrok-free.app';

  // Mude para usar baseUrlRemote
  static String get currentBaseUrl => baseUrlRemote; // ← mude aqui

  // ... resto do código
}
```

### Build APK (se for enviar para Android):

```bash
cd clube_pharma_frontend
flutter build apk --release
```

Envie: `build/app/outputs/flutter-apk/app-release.apk`

---

## Comandos Úteis

### Ver configuração atual:
```bash
ngrok config check
```

### Ver onde está o arquivo de config:
```bash
# Windows
type %USERPROFILE%\.ngrok2\ngrok.yml

# PowerShell
cat ~\.ngrok2\ngrok.yml
```

### Parar ngrok:
Pressione `Ctrl + C` no terminal do ngrok

### Ver túneis ativos:
```bash
ngrok tunnels list
```

---

## Recursos do Ngrok

### Plano Free (Grátis):
- ✅ HTTPS automático
- ✅ 1 túnel simultâneo
- ✅ URL aleatória (muda a cada vez)
- ✅ Sem limite de tempo
- ✅ Dashboard local (http://127.0.0.1:4040)

### Plano Pago:
- Domínio fixo personalizado
- Múltiplos túneis
- IP whitelist
- Mais regiões

---

## Vantagens do Ngrok

✅ **Não precisa mexer no roteador** (sem port forwarding)
✅ **HTTPS automático** (mais seguro)
✅ **URL pública imediata**
✅ **Dashboard com logs de requisições**
✅ **Fácil de usar**
✅ **Funciona atrás de firewall corporativo**

---

## Problemas Comuns

### 1. "command not found: ngrok"

**Solução**: Adicione ngrok ao PATH ou use caminho completo:
```bash
C:\caminho\para\ngrok.exe http 3000
```

### 2. "authentication failed"

**Solução**: Configure o token novamente:
```bash
ngrok config add-authtoken SEU_TOKEN
```

### 3. "tunnel not found"

**Solução**: Certifique-se que o backend está rodando na porta 3000 antes de iniciar o ngrok.

### 4. "Tunnel session failed"

**Solução**: Verifique sua conexão com internet ou reinicie o ngrok.

### 5. URL muda toda vez

**Normal no plano free**. Para URL fixa, precisa do plano pago ($8/mês).

**Alternativa**: Use um serviço de dynamic DNS ou atualize a URL no app sempre que mudar.

---

## Script Automatizado (Opcional)

Crie um arquivo `iniciar_com_ngrok.bat`:

```batch
@echo off
echo Iniciando Clube Pharma com Ngrok...

:: Inicia backend em background
start cmd /k "cd clube_pharma_backend && npm run dev"

:: Aguarda 5 segundos para backend iniciar
timeout /t 5

:: Inicia ngrok
ngrok http 3000

pause
```

**Uso**: Clique duplo no arquivo `.bat`

---

## Dashboard Local do Ngrok

Enquanto o ngrok está rodando, acesse:

```
http://127.0.0.1:4040
```

**Você pode ver:**
- Todas as requisições HTTP em tempo real
- Request/Response completos
- Tempo de resposta
- Status codes
- Headers
- Body das requisições

**Super útil para debug!** 🐛

---

## Alternativas ao Ngrok

Se precisar de alternativas gratuitas:

### 1. LocalTunnel
```bash
npm install -g localtunnel
lt --port 3000
```

### 2. Cloudflare Tunnel
```bash
cloudflared tunnel --url http://localhost:3000
```

### 3. Serveo
```bash
ssh -R 80:localhost:3000 serveo.net
```

---

## Resumo Rápido

```bash
# 1. Instalar
choco install ngrok

# 2. Configurar token (uma vez só)
ngrok config add-authtoken SEU_TOKEN

# 3. Iniciar backend
cd clube_pharma_backend
npm run dev

# 4. Em outro terminal, iniciar ngrok
ngrok http 3000

# 5. Copiar URL mostrada (https://...)
# 6. Compartilhar com seu primo!
```

Pronto! Muito mais fácil que port forwarding! 🚀
