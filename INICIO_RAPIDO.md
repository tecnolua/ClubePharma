# Início Rápido - Acesso Remoto

## Passos Simples para Seu Primo Acessar

### 1. Liberar Firewall (EXECUTE PRIMEIRO)

**Clique com botão direito** em `liberar_firewall.ps1` → **Executar com PowerShell (Admin)**

O script vai:
- Liberar portas 3000 e 8080
- Mostrar seu IP local e público
- Dar instruções dos próximos passos

### 2. Configurar Roteador (Port Forwarding)

1. Acesse seu roteador no navegador: `http://192.168.0.1` ou `http://192.168.1.1`
2. Login: admin/admin (ou veja etiqueta do roteador)
3. Procure: "Port Forwarding" ou "Virtual Server"
4. Adicione:
   - **Porta Externa**: 3000
   - **Porta Interna**: 3000
   - **IP Local**: (o IP que o script mostrou)
   - **Protocolo**: TCP

### 3. Descobrir seu IP Público

Abra: https://meu-ip.io

Anote o número (exemplo: 177.123.45.67)

### 4. Iniciar o Backend

```bash
cd clube_pharma_backend
npm run dev
```

Deve mostrar: "🌐 Network: http://0.0.0.0:3000/health"

### 5. Testar

No SEU PC, abra o navegador:
```
http://localhost:3000/health
```

Deve retornar: `{"status": "OK", ...}`

### 6. Compartilhar com seu Primo

Envie esta URL para ele:
```
http://SEU_IP_PUBLICO:3000
```

Exemplo: `http://177.123.45.67:3000`

---

## Se Ele Vai Usar o App Android

### Opção A: Mandar APK com seu IP

1. Edite `clube_pharma_frontend/lib/config/api_config.dart`:
```dart
static const String baseUrlRemote = 'http://SEU_IP_PUBLICO:3000';
static String get currentBaseUrl => baseUrlRemote; // mude esta linha
```

2. Build o APK:
```bash
cd clube_pharma_frontend
flutter build apk --release
```

3. Envie o APK: `build/app/outputs/flutter-apk/app-release.apk`

### Opção B: Ele Roda Flutter no PC dele

Ele precisa:
1. Clonar o repositório
2. Editar o `api_config.dart` com seu IP público
3. Rodar: `flutter run -d chrome`

---

## Checklist Rápido

- [ ] Executou `liberar_firewall.ps1` como Admin
- [ ] Configurou port forwarding no roteador (porta 3000)
- [ ] Backend rodando (`npm run dev`)
- [ ] Testou `http://localhost:3000/health` (funcionou!)
- [ ] Descobriu IP público (anotou!)
- [ ] Enviou link para seu primo: `http://SEU_IP:3000`

---

## Problemas?

Veja o arquivo completo: [ACESSO_REMOTO_IP.md](ACESSO_REMOTO_IP.md)

---

## Dica: Usar Ngrok (Mais Fácil!)

Se quiser evitar mexer no roteador:

```bash
# Instalar ngrok
choco install ngrok

# Rodar backend
cd clube_pharma_backend
npm run dev

# Em outro terminal, rodar ngrok
ngrok http 3000
```

Ele vai gerar uma URL tipo: `https://abc123.ngrok.io`

Compartilhe essa URL! Muito mais fácil! 🚀
