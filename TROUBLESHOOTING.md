# Troubleshooting - Clube Pharma

## Problema: Botões não funcionam / Nada acontece ao clicar

### Causa:
O frontend não está conseguindo se comunicar com o backend.

### Solução:

#### 1. Verificar se o Backend está rodando

Abra o navegador e teste:
```
http://localhost:3000/health
```

Deve retornar:
```json
{
  "status": "OK",
  "message": "ClubePharma API is running"
}
```

Se NÃO funcionar:
- Inicie o backend: `cd clube_pharma_backend && npm run dev`
- Aguarde ver: "🚀 ClubePharma API Server is running!"

#### 2. Verificar se o Servidor Completo está rodando

Teste:
```
http://localhost:8080/health
```

Deve retornar o mesmo JSON acima.

Se NÃO funcionar:
- Inicie o servidor: `npm start` (na pasta raiz Desenvolvimento)
- Aguarde ver: "🚀 CLUBE PHARMA - Servidor Completo"

#### 3. Verificar Console do Navegador

Abra o DevTools (F12) e vá em "Console"

**Se ver erros de CORS:**
```
Access to fetch at 'http://localhost:3000/api/...' from origin 'http://localhost:8080' has been blocked by CORS
```

**Solução**: O backend precisa permitir CORS. Já está configurado, mas verifique se está rodando corretamente.

**Se ver erros 404:**
```
GET http://localhost:8080/api/products 404 (Not Found)
```

**Solução**: O proxy não está funcionando. Reinicie o servidor completo.

**Se ver "Network Error" ou "Failed to fetch":**
```
TypeError: Failed to fetch
```

**Solução**: Backend não está rodando. Inicie-o primeiro.

---

## Problema: Build web não funciona

### Erro: "Null check operator used on a null value"

**Solução**:
```bash
cd clube_pharma_frontend
flutter clean
flutter pub get
flutter build web
```

### Erro: "Target of URI doesn't exist"

**Solução**: Algum arquivo está faltando. Verifique se todos os arquivos foram baixados do Git.

---

## Problema: Servidor Completo não inicia

### Erro: "Cannot find module 'express'"

**Solução**:
```bash
# Na pasta raiz Desenvolvimento
npm install
```

### Erro: "Port 8080 is already in use"

**Solução**: Algum programa está usando a porta 8080.

**Opção A** - Fechar o que está usando:
```bash
# Windows
netstat -ano | findstr :8080
taskkill /PID <numero_do_pid> /F
```

**Opção B** - Mudar a porta:
Edite `servidor_completo.js` linha 6:
```javascript
const PORT = 9090; // Mude para outra porta
```

---

## Problema: Ngrok não cria túnel

### Erro: "command not found: ngrok"

**Solução**: Ngrok não está instalado ou não está no PATH.

```bash
# Instalar
choco install ngrok

# Ou baixar de: https://ngrok.com/download
```

### Erro: "authentication failed"

**Solução**: Token não configurado.

```bash
ngrok config add-authtoken SEU_TOKEN
```

Pegue o token em: https://dashboard.ngrok.com/get-started/your-authtoken

### Erro: "tunnel not found"

**Solução**: O servidor não está rodando na porta especificada.

Verifique:
```bash
# Ver o que está rodando na porta 8080
netstat -ano | findstr :8080
```

---

## Problema: Frontend mostra mas API não funciona

### Sintoma: Tela carrega, mas produtos não aparecem

#### 1. Abra o Console (F12)

Veja se há erros de rede.

#### 2. Teste a API diretamente

No navegador, acesse:
```
http://localhost:8080/api/products
```

**Se retornar JSON**: API está funcionando!
- O problema pode ser no código do frontend
- Verifique se há erros no console

**Se retornar 404**: Proxy não está funcionando
- Reinicie o servidor completo
- Verifique se o backend está rodando primeiro

**Se retornar "Cannot GET"**: Rota não existe
- Verifique se digitou corretamente

#### 3. Verificar Configuração do Frontend

Arquivo: `clube_pharma_frontend/lib/config/api_config.dart`

Deve estar:
```dart
static String get currentBaseUrl => baseUrlServidorCompleto;
```

Se mudou isso, precisa rebuildar:
```bash
cd clube_pharma_frontend
flutter build web
npm start # Reiniciar servidor
```

---

## Problema: Tela branca / Página em branco

### Causa 1: Build não foi feito

**Solução**:
```bash
cd clube_pharma_frontend
flutter build web
```

### Causa 2: Caminho errado no servidor

Verifique em `servidor_completo.js` linha 30:
```javascript
const webDir = path.join(__dirname, 'clube_pharma_frontend', 'build', 'web');
```

Deve apontar para a pasta correta.

### Causa 3: Erro de carregamento

Abra o Console (F12) e veja os erros.

---

## Problema: "Este site não pode ser acessado" via Ngrok

### Causa 1: Ngrok não está rodando

**Solução**: Execute `ngrok http 8080`

### Causa 2: URL do ngrok mudou

Ngrok muda a URL toda vez que reinicia (plano free).

**Solução**: Use a URL nova que aparece no terminal.

### Causa 3: Servidor não está rodando

**Solução**: Certifique-se que tanto backend quanto servidor completo estão rodando.

---

## Checklist Completo

Quando algo não funciona, verifique na ordem:

1. [ ] Backend rodando? `http://localhost:3000/health`
2. [ ] Servidor completo rodando? `http://localhost:8080/health`
3. [ ] Frontend local funcionando? `http://localhost:8080`
4. [ ] Console sem erros? (F12 → Console)
5. [ ] API funcionando? `http://localhost:8080/api/products`
6. [ ] Ngrok rodando? (se for usar acesso externo)
7. [ ] Todas as dependências instaladas?
   - `cd clube_pharma_backend && npm install`
   - `cd .. && npm install` (raiz)
   - `cd clube_pharma_frontend && flutter pub get`

---

## Comandos Úteis para Debug

### Ver o que está rodando nas portas:
```bash
# Windows
netstat -ano | findstr :3000
netstat -ano | findstr :8080

# Ver processos node
tasklist | findstr node
```

### Matar processos:
```bash
# Windows
taskkill /F /IM node.exe
```

### Verificar logs do backend:
Olhe o terminal onde rodou `npm run dev`

### Verificar logs do servidor completo:
Olhe o terminal onde rodou `npm start`

As requisições aparecem assim:
```
[PROXY] GET /api/products -> http://localhost:3000/api/products
```

---

## Ainda com problemas?

### Reiniciar Tudo (Reset Completo):

```bash
# 1. Matar todos os node
taskkill /F /IM node.exe

# 2. Backend
cd clube_pharma_backend
npm install
npm run dev
# Aguarde iniciar

# 3. Servidor Completo (novo terminal)
cd ..
npm install
npm start
# Aguarde iniciar

# 4. Testar
# Abra: http://localhost:8080

# 5. Ngrok (se precisar acesso externo)
ngrok http 8080
```

---

## Logs Importantes

### Backend iniciou corretamente:
```
🚀 ClubePharma API Server is running!
📍 Port: 3000
🌐 Network: http://0.0.0.0:3000/health
```

### Servidor completo iniciou corretamente:
```
🚀 CLUBE PHARMA - Servidor Completo
✅ Frontend Web: http://localhost:8080
✅ Backend API: http://localhost:3000
✅ Proxy: /api/* -> http://localhost:3000/api/*
```

### Ngrok criou túnel:
```
Forwarding     https://abc-123.ngrok-free.app -> http://localhost:8080
```

Se você vê essas 3 mensagens, está tudo funcionando! 🚀
