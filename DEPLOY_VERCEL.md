# Guia de Deploy no Vercel - Clube Pharma

## Problema: Erro 404 NOT_FOUND

O erro acontece porque o repositório contém dois projetos (backend e frontend) e a Vercel não sabe qual servir.

## Solução: Deploy Separado

Você precisa fazer deploy de cada projeto separadamente na Vercel.

---

## 1. Deploy do Backend (API)

### Passo a Passo:

1. **Acesse a Vercel**: https://vercel.com
2. **New Project** → Selecione o repositório `ClubePharma`
3. **Configure o projeto:**
   - **Project Name**: `clube-pharma-backend` (ou outro nome)
   - **Framework Preset**: Other
   - **Root Directory**: `clube_pharma_backend` ⬅️ IMPORTANTE!
   - **Build Command**: Deixe vazio ou `npm install`
   - **Output Directory**: Deixe vazio
   - **Install Command**: `npm install`

4. **Adicione as variáveis de ambiente:**
   - `DATABASE_URL`: Sua URL do banco (PostgreSQL/MySQL)
   - `JWT_SECRET`: Seu secret JWT
   - `NODE_ENV`: `production`
   - `MERCADOPAGO_ACCESS_TOKEN`: Token do Mercado Pago (se usar)

5. **Deploy!**

### URL de Exemplo:
```
https://clube-pharma-backend.vercel.app
```

---

## 2. Deploy do Frontend (Web)

### Opção A: Build Local e Deploy

**Não recomendado** - A Vercel não suporta nativamente Flutter. Melhor usar:
- **Firebase Hosting** (recomendado para Flutter Web)
- **Netlify**
- **GitHub Pages**

### Para Firebase Hosting:

```bash
cd clube_pharma_frontend

# Build do Flutter Web
flutter build web

# Instalar Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Inicializar
firebase init hosting

# Deploy
firebase deploy --only hosting
```

### Opção B: Usar Vercel com Build Manual

Se realmente quiser usar Vercel para o frontend:

1. Faça build local primeiro:
```bash
cd clube_pharma_frontend
flutter build web
```

2. Na Vercel:
   - **Root Directory**: `clube_pharma_frontend/build/web`
   - **Framework Preset**: Other
   - Sem build command (já está buildado)

---

## 3. Alternativa: Backend no Vercel, Frontend no Firebase

### Backend (Vercel):
- Siga os passos acima para backend
- URL: `https://clube-pharma-backend.vercel.app`

### Frontend (Firebase):
```bash
cd clube_pharma_frontend

# Atualizar URL da API
# Edite lib/config/api_config.dart
# baseUrl = 'https://clube-pharma-backend.vercel.app/api'

flutter build web
firebase init hosting
firebase deploy
```

---

## 4. Alternativa: Tudo no Railway/Render

Se quiser evitar essas complexidades, considere:

### Railway (Melhor para Full Stack):
1. Conecte seu GitHub
2. Crie dois serviços:
   - Backend Node.js (detecta automaticamente)
   - Frontend como Static Site (após build)

### Render:
1. Backend: Web Service
2. Frontend: Static Site

---

## Configuração Atual do Projeto

O projeto já tem os arquivos `vercel.json` configurados:

### Backend (`clube_pharma_backend/vercel.json`):
```json
{
  "version": 2,
  "builds": [
    {
      "src": "src/server.js",
      "use": "@vercel/node"
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "src/server.js"
    }
  ]
}
```

### Frontend (`clube_pharma_frontend/vercel.json`):
```json
{
  "buildCommand": "flutter build web",
  "outputDirectory": "build/web",
  "installCommand": "flutter pub get"
}
```

---

## Recomendação Final

**Melhor Stack de Deploy:**

1. **Backend**: Vercel ou Railway
   - URL: `https://clube-pharma-api.vercel.app`

2. **Frontend Web**: Firebase Hosting ou Netlify
   - URL: `https://clube-pharma.web.app`

3. **App Mobile**: Google Play Store / Apple App Store
   - Build com `flutter build apk` / `flutter build ipa`

---

## Checklist de Deploy

### Backend:
- [ ] Criar projeto Vercel separado
- [ ] Configurar Root Directory: `clube_pharma_backend`
- [ ] Adicionar variáveis de ambiente
- [ ] Testar endpoints da API
- [ ] Configurar CORS para permitir frontend

### Frontend:
- [ ] Atualizar `api_config.dart` com URL do backend
- [ ] Build: `flutter build web`
- [ ] Deploy no Firebase/Netlify
- [ ] Testar integração com backend

---

## Problemas Comuns

### 1. CORS Error
Adicione no backend (`src/server.js`):
```javascript
app.use(cors({
  origin: ['https://seu-frontend.web.app', 'https://seu-frontend.vercel.app'],
  credentials: true
}));
```

### 2. Database Connection
Use um banco hospedado:
- **Supabase** (PostgreSQL - Grátis)
- **PlanetScale** (MySQL - Grátis)
- **Railway** (PostgreSQL)

### 3. Variáveis de Ambiente
Sempre configure no painel da Vercel, nunca commite `.env`!

---

## Dúvidas?

Verifique os logs de deploy na Vercel para mais detalhes sobre erros.
