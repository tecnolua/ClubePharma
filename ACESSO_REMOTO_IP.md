# Guia de Acesso Remoto via IP Público - Clube Pharma

## Como permitir que outras pessoas acessem o sistema rodando no seu PC

---

## 1. Configurar o Roteador (Port Forwarding)

### Passo a Passo:

1. **Descobrir seu IP local:**
```bash
# Windows
ipconfig
# Procure por "IPv4 Address" (algo como 192.168.0.X ou 192.168.1.X)
```

2. **Acessar o painel do roteador:**
   - Abra o navegador
   - Digite o IP do gateway (geralmente `192.168.0.1` ou `192.168.1.1`)
   - Faça login (geralmente: admin/admin ou está na etiqueta do roteador)

3. **Configurar Port Forwarding / Redirecionamento de Portas:**

   Procure por uma dessas opções no menu:
   - "Port Forwarding"
   - "Virtual Server"
   - "NAT"
   - "Redirecionamento de Portas"

   **Configure assim:**

   | Nome | Porta Externa | Porta Interna | IP Local | Protocolo |
   |------|---------------|---------------|----------|-----------|
   | Backend API | 3000 | 3000 | 192.168.0.X | TCP |
   | Frontend Web | 8080 | 8080 | 192.168.0.X | TCP |

   *(Substitua `192.168.0.X` pelo seu IP local que você descobriu)*

4. **Salvar e reiniciar o roteador** (se necessário)

---

## 2. Configurar Firewall do Windows

### Liberar portas no Windows Firewall:

1. **Abra o PowerShell como Administrador**

2. **Execute estes comandos:**

```powershell
# Liberar porta 3000 (Backend)
New-NetFirewallRule -DisplayName "Clube Pharma Backend" -Direction Inbound -LocalPort 3000 -Protocol TCP -Action Allow

# Liberar porta 8080 (Frontend - se usar)
New-NetFirewallRule -DisplayName "Clube Pharma Frontend" -Direction Inbound -LocalPort 8080 -Protocol TCP -Action Allow
```

### Alternativa - Via Interface Gráfica:

1. Abra "Firewall do Windows Defender"
2. "Configurações avançadas"
3. "Regras de Entrada" → "Nova Regra"
4. Tipo: "Porta"
5. TCP - Portas locais específicas: `3000`
6. Ação: "Permitir conexão"
7. Nome: "Clube Pharma Backend"
8. Repetir para porta `8080` se necessário

---

## 3. Configurar o Backend para Aceitar Conexões Externas

### Editar `clube_pharma_backend/src/server.js`:

```javascript
// Procure por algo como:
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

// E SUBSTITUA por:
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on http://0.0.0.0:${PORT}`);
  console.log(`Acesso local: http://localhost:${PORT}`);
  console.log(`Acesso externo: http://SEU_IP_PUBLICO:${PORT}`);
});
```

### Configurar CORS:

```javascript
// No início do arquivo server.js, após as importações
const cors = require('cors');

// Configure CORS para aceitar qualquer origem (desenvolvimento)
app.use(cors({
  origin: '*', // Aceita qualquer origem
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));
```

---

## 4. Descobrir seu IP Público

### Opção 1 - Pelo navegador:
Acesse: https://meu-ip.io ou https://whatismyipaddress.com

### Opção 2 - PowerShell:
```powershell
curl ifconfig.me
```

### Opção 3 - CMD:
```cmd
nslookup myip.opendns.com resolver1.opendns.com
```

**Anote seu IP público** (algo como: `177.123.45.67`)

---

## 5. Testar o Acesso

### No seu PC (teste local):

```bash
# Testar backend
curl http://localhost:3000/api/health

# Ou abra no navegador:
http://localhost:3000
```

### Do PC do seu primo (teste remoto):

```bash
# Substituir SEU_IP_PUBLICO pelo IP que você descobriu
http://SEU_IP_PUBLICO:3000/api/health
```

**Exemplo:**
```
http://177.123.45.67:3000/api/health
```

---

## 6. Configurar o Frontend para Usar seu IP

### Editar `clube_pharma_frontend/lib/config/api_config.dart`:

```dart
class ApiConfig {
  // Substitua SEU_IP_PUBLICO pelo seu IP público real
  static const String baseUrl = 'http://SEU_IP_PUBLICO:3000/api';

  // Exemplo:
  // static const String baseUrl = 'http://177.123.45.67:3000/api';
}
```

**Importante:** Sempre use HTTP (não HTTPS) com IP público sem certificado SSL.

---

## 7. Iniciar os Serviços

### Backend:
```bash
cd clube_pharma_backend
npm run dev
# Deve mostrar: Server running on http://0.0.0.0:3000
```

### Frontend (se rodar Flutter Web localmente):
```bash
cd clube_pharma_frontend
flutter run -d chrome --web-port 8080
```

---

## 8. Enviar o Link para seu Primo

### Se ele vai acessar via navegador (Flutter Web):
```
http://SEU_IP_PUBLICO:8080
```

### Se ele vai rodar o app Flutter no Android dele:

1. **Edite o `api_config.dart` com seu IP público**
2. **Build o APK:**
```bash
cd clube_pharma_frontend
flutter build apk --release
```
3. **Envie o APK** (`build/app/outputs/flutter-apk/app-release.apk`) para ele
4. Ele instala no Android e usa normalmente

---

## Problemas Comuns

### 1. "Conexão recusada"
- ✓ Verifique se o backend está rodando
- ✓ Confirme se a porta 3000 está liberada no firewall
- ✓ Teste primeiro localmente: `http://localhost:3000`

### 2. "Timeout" ou "Não conecta"
- ✓ Port forwarding configurado corretamente no roteador
- ✓ IP local correto no port forwarding
- ✓ Roteador reiniciado após configuração

### 3. "CORS Error"
- ✓ Configure CORS no backend como mostrado acima
- ✓ Reinicie o servidor backend

### 4. IP Público mudou
- Se seu IP público mudar (comum com IP dinâmico):
  - Descubra o novo IP
  - Atualize o `api_config.dart`
  - Rebuild e envie novo APK
  - **Ou considere usar DynamicDNS** (No-IP, DuckDNS)

---

## Segurança - IMPORTANTE!

### ⚠️ Avisos:

1. **Seu IP ficará exposto** - qualquer pessoa com o IP pode tentar acessar
2. **Não deixe rodando 24/7** sem necessidade
3. **Use senha forte** no sistema
4. **Considere adicionar autenticação extra** para acesso externo
5. **Firewall do Windows deve estar ativo**
6. **Não exponha porta do banco de dados** (5432 PostgreSQL, 3306 MySQL)

### Melhorias de Segurança:

#### 1. Whitelist de IPs no Backend:
```javascript
const allowedIPs = ['SEU_IP', 'IP_DO_SEU_PRIMO'];

app.use((req, res, next) => {
  const clientIP = req.ip || req.connection.remoteAddress;
  if (!allowedIPs.some(ip => clientIP.includes(ip))) {
    return res.status(403).json({ error: 'Acesso negado' });
  }
  next();
});
```

#### 2. Usar Túnel Seguro (Alternativa mais segura):

**Ngrok** (mais fácil):
```bash
# Instalar ngrok
choco install ngrok

# Ou baixar de: https://ngrok.com

# Iniciar túnel
ngrok http 3000
```

Vai gerar uma URL tipo: `https://abc123.ngrok.io`
- Não precisa mexer no roteador
- Mais seguro (HTTPS automático)
- Fácil de usar

**Localtunnel:**
```bash
npm install -g localtunnel
lt --port 3000
```

---

## Checklist Final

**Antes de compartilhar:**

- [ ] Port forwarding configurado no roteador
- [ ] Firewall do Windows com portas liberadas
- [ ] Backend rodando e acessível localmente
- [ ] CORS configurado no backend
- [ ] IP público descoberto e anotado
- [ ] Frontend configurado com IP público
- [ ] Testado localmente (localhost)
- [ ] Testado externamente (outro dispositivo na mesma rede)
- [ ] Link enviado para seu primo: `http://SEU_IP:3000`

---

## Resumo Rápido

```bash
# 1. Descobrir IP local
ipconfig

# 2. Descobrir IP público
curl ifconfig.me

# 3. Configurar port forwarding no roteador:
# Porta 3000 (TCP) → Seu IP local

# 4. Liberar firewall
New-NetFirewallRule -DisplayName "Backend" -Direction Inbound -LocalPort 3000 -Protocol TCP -Action Allow

# 5. Iniciar backend
cd clube_pharma_backend
npm run dev

# 6. Enviar para seu primo:
# http://SEU_IP_PUBLICO:3000
```

Pronto! Seu sistema estará acessível externamente! 🚀
