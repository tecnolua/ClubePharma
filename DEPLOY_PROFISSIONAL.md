# 🚀 Deploy Profissional - Clube Pharma

## Com Domínio Próprio - Setup Definitivo

### Por que fazer assim?
- ✅ URL fixa (não muda nunca!)
- ✅ HTTPS automático (seguro)
- ✅ Não precisa deixar PC ligado
- ✅ Rápido e profissional
- ✅ Grátis (exceto domínio)

---

## 1️⃣ Comprar Domínio

### Opção A: Registro.br (Brasil - Recomendado)
- **Site:** https://registro.br
- **Preço:** ~R$40/ano (.com.br)
- **Vantagens:** Brasileiro, suporte em PT

### Opção B: Namecheap (Internacional)
- **Site:** https://namecheap.com
- **Preço:** ~$10/ano (.com)
- **Vantagens:** Mais barato, .com

### Opção C: Google Domains / Cloudflare
- Preços competitivos
- Fácil gerenciar DNS

**Sugestões de domínio:**
- `clubepharma.com.br`
- `clubepharma.app`
- `clubepharma.online`

---

## 2️⃣ Deploy do Backend

### 🔥 Railway (RECOMENDADO - Mais Fácil!)

#### Vantagens:
- ✅ Deploy automático via GitHub
- ✅ Banco PostgreSQL grátis incluso
- ✅ 500h/mês grátis ($5 de crédito)
- ✅ HTTPS automático
- ✅ Logs em tempo real

#### Passo a Passo:

1. **Acesse:** https://railway.app
2. **Login com GitHub**
3. **New Project** → **Deploy from GitHub repo**
4. Selecione: `ClubePharma`
5. **Configure:**
   - Root Directory: `clube_pharma_backend`
   - Build Command: `npm install && npx prisma generate`
   - Start Command: `npm start`

6. **Adicionar Banco PostgreSQL:**
   - No projeto, clique em **"New"** → **"Database"** → **"PostgreSQL"**
   - Vai criar automaticamente!

7. **Variáveis de Ambiente:**
   Clique em **"Variables"** e adicione:
   ```
   DATABASE_URL=${{Postgres.DATABASE_URL}}  # Railway injeta automaticamente
   JWT_SECRET=seu-secret-super-seguro-aqui-123456
   NODE_ENV=production
   PORT=3000
   ```

8. **Deploy!**
   - Railway vai gerar uma URL tipo: `https://clubepharma-backend-production.up.railway.app`

9. **Conectar Domínio (Depois que comprar):**
   - Settings → Domains → Add Custom Domain
   - Digite: `api.seudominio.com`
   - Configure DNS (Railway vai te mostrar)

**Pronto! Backend no ar!** 🎉

---

### 🔷 Alternativa: Render

1. **Acesse:** https://render.com
2. **New** → **Web Service**
3. Conecte GitHub → Selecione `ClubePharma`
4. **Configure:**
   - Name: `clube-pharma-backend`
   - Root Directory: `clube_pharma_backend`
   - Build Command: `npm install && npx prisma generate && npx prisma migrate deploy`
   - Start Command: `npm start`

5. **Criar Banco:**
   - New → PostgreSQL
   - Copie a `DATABASE_URL`

6. **Environment Variables:**
   ```
   DATABASE_URL=cole-aqui-a-url-do-banco
   JWT_SECRET=seu-secret-aqui
   NODE_ENV=production
   ```

7. **Deploy!**

---

## 3️⃣ Deploy do Frontend

### 🔥 Vercel (RECOMENDADO - Facilimo!)

#### Vantagens:
- ✅ Deploy automático do Flutter Web
- ✅ HTTPS automático
- ✅ CDN global (super rápido)
- ✅ Domínio customizado grátis
- ✅ 100% grátis para hobby

#### Passo a Passo:

1. **Acesse:** https://vercel.com
2. **Login com GitHub**
3. **Import Project** → Selecione `ClubePharma`

4. **Configure:**
   - Framework Preset: **Other**
   - Root Directory: `clube_pharma_frontend`
   - Build Command: `flutter build web`
   - Output Directory: `build/web`
   - Install Command: `flutter pub get`

5. **Environment Variables:**
   Não precisa! Mas se quiser, adicione:
   ```
   FLUTTER_WEB_AUTO_DETECT=true
   ```

6. **IMPORTANTE - Antes de Deploy:**

   Atualize o `api_config.dart` com a URL do seu backend Railway:

   ```dart
   static const String baseUrlProd = 'https://api.seudominio.com';
   // ou a URL do Railway:
   // static const String baseUrlProd = 'https://clubepharma-backend-production.up.railway.app';

   static String get currentBaseUrl => baseUrlProd;
   ```

   **Commit e push** essa mudança!

7. **Deploy!**
   - Vercel vai gerar: `https://clube-pharma.vercel.app`

8. **Conectar Domínio:**
   - Settings → Domains → Add
   - Digite: `seudominio.com` ou `www.seudominio.com`
   - Configure DNS conforme Vercel instruir

**Pronto! Frontend no ar!** 🎉

---

### 🔷 Alternativa: Netlify

1. **Acesse:** https://netlify.com
2. **Import from Git** → GitHub → `ClubePharma`
3. **Configure:**
   - Base directory: `clube_pharma_frontend`
   - Build command: `flutter build web`
   - Publish directory: `clube_pharma_frontend/build/web`

4. **Deploy!**

---

## 4️⃣ Configurar DNS do Domínio

Depois que comprar o domínio:

### Se usar Railway (Backend) + Vercel (Frontend):

**No painel do seu domínio (Registro.br, Namecheap, etc):**

#### Para o Frontend (www ou raiz):
```
Type: CNAME
Name: www
Value: cname.vercel-dns.com
TTL: 3600
```

OU (para domínio raiz):
```
Type: A
Name: @
Value: 76.76.21.21  # IP da Vercel (eles vão te dar)
```

#### Para o Backend (API):
```
Type: CNAME
Name: api
Value: (Railway vai te dar, tipo: xyz.railway.app)
TTL: 3600
```

**Resultado:**
- Frontend: `https://www.seudominio.com`
- Backend: `https://api.seudominio.com`

---

## 5️⃣ Atualizar Frontend com URL do Backend

Depois que tudo estiver no ar:

1. Edite `clube_pharma_frontend/lib/config/api_config.dart`:

```dart
static const String baseUrlProd = 'https://api.seudominio.com';
static String get currentBaseUrl => baseUrlProd;
```

2. Commit e push:
```bash
git add .
git commit -m "Update: URL de produção do backend"
git push
```

3. Vercel vai fazer **redeploy automático**!

---

## 6️⃣ Configurar Banco de Dados

### Se usar Railway:
- Já vem PostgreSQL configurado! ✅
- Acesse via Railway → PostgreSQL → Connect
- Rode migrations:
  ```bash
  # Localmente, configure DATABASE_URL do Railway
  npx prisma migrate deploy
  ```

### Popular Banco de Produção:

Você pode rodar os scripts de seed:

1. Conecte ao banco Railway localmente
2. Execute:
```bash
npx prisma db seed
```

Ou crie produtos via Railway Console.

---

## 💰 Custos Estimados

| Item | Serviço | Custo |
|------|---------|-------|
| **Domínio** | Registro.br | R$40/ano |
| **Backend** | Railway | GRÁTIS (até 500h/mês) |
| **Frontend** | Vercel | GRÁTIS |
| **Banco** | Railway PostgreSQL | GRÁTIS (1GB) |
| **SSL/HTTPS** | Automático | GRÁTIS |
| **TOTAL** | | **~R$40/ano** |

---

## 🎯 Resumo do Setup Final

### URLs:
- **Frontend:** `https://clubepharma.com` (Vercel)
- **Backend:** `https://api.clubepharma.com` (Railway)
- **Banco:** Railway PostgreSQL

### Características:
- ✅ Online 24/7
- ✅ HTTPS seguro
- ✅ Deploy automático (push no GitHub = atualiza)
- ✅ Logs e monitoramento
- ✅ Backup automático do banco
- ✅ Escalável

---

## 📱 App Mobile

### Android (Google Play):
1. Build APK assinado:
```bash
flutter build appbundle --release
```
2. Upload para Google Play Console
3. **Custo:** $25 (taxa única)

### iOS (App Store):
1. Precisa de Mac + Conta Apple Developer
2. **Custo:** $99/ano

---

## 🚀 Fluxo de Trabalho Após Setup

### Para atualizar o site:

1. Faça mudanças no código
2. Commit e push:
```bash
git add .
git commit -m "Update: nova feature"
git push
```
3. **Pronto!** Vercel e Railway fazem deploy automático! 🎉

### Sem ngrok, sem complicação!

---

## ✅ Checklist de Deploy

### Antes de Comprar Domínio:
- [ ] Backend funcionando no Railway
- [ ] Frontend funcionando na Vercel
- [ ] Banco de dados criado e populado
- [ ] Testado com URLs temporárias

### Depois de Comprar Domínio:
- [ ] DNS configurado (CNAME/A records)
- [ ] Domínio conectado na Vercel
- [ ] Subdomínio api.* conectado no Railway
- [ ] Frontend atualizado com URL de produção
- [ ] Testado tudo funcionando

---

## 🆘 Suporte

### Railway:
- Docs: https://docs.railway.app
- Discord: https://discord.gg/railway

### Vercel:
- Docs: https://vercel.com/docs
- Discord: https://vercel.com/discord

### DNS:
- Registro.br: https://registro.br/suporte
- Namecheap: Live chat 24/7

---

## 🎉 Resultado Final

Seu primo (e qualquer pessoa!) vai poder acessar:

```
https://clubepharma.com
```

E tudo funciona! Login, produtos, pedidos, tudo!

**Profissional, rápido, seguro!** 🚀

---

**Quer que eu te ajude a fazer o setup no Railway e Vercel AGORA?**

É super rápido, em 30 minutos está tudo no ar! 💪
