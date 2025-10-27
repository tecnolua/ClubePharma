# Acesso Web Simples - Clube Pharma

## Como seu primo pode acessar via navegador

---

## Opção 1: Servir Localmente com Ngrok (MAIS FÁCIL!)

### Passo 1: Iniciar o Backend
```bash
cd clube_pharma_backend
npm run dev
```

### Passo 2: Iniciar o Frontend Web
Em outro terminal:
```bash
cd clube_pharma_frontend
flutter run -d web-server --web-port 8080
```

### Passo 3: Criar Túnel Ngrok para o Frontend
Em outro terminal:
```bash
ngrok http 8080
```

Vai gerar uma URL tipo:
```
https://abc-def-ghi.ngrok-free.app
```

### Passo 4: Compartilhar
Envie a URL do passo 3 para seu primo!

Ele abre no navegador (Chrome, Firefox, Safari) e usa o sistema!

---

## Opção 2: Usar Apenas Backend com Ngrok (ATUAL)

Seu backend já está acessível via:
```
https://bicompact-jodee-appetizingly.ngrok-free.dev
```

Você pode:

### A) Hospedar o Frontend Web em Serviço Gratuito:

#### Firebase Hosting (Recomendado):
```bash
# Instalar Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Inicializar no diretório do frontend
cd clube_pharma_frontend
firebase init hosting

# Quando perguntar "What do you want to use as your public directory?"
# Responda: build/web

# Deploy
firebase deploy --only hosting
```

Vai gerar uma URL tipo:
```
https://clube-pharma.web.app
```

#### Netlify (Alternativa):
1. Acesse: https://app.netlify.com
2. Faça login com GitHub
3. Clique em "Add new site" → "Deploy manually"
4. Arraste a pasta `clube_pharma_frontend/build/web`
5. Pronto! Vai gerar uma URL tipo: `https://seu-site.netlify.app`

#### Vercel (Alternativa):
```bash
# Instalar Vercel CLI
npm install -g vercel

# Deploy
cd clube_pharma_frontend/build/web
vercel
```

---

## Opção 3: Dois Túneis Ngrok (Temporário)

### Terminal 1 - Backend:
```bash
cd clube_pharma_backend
npm run dev
```

### Terminal 2 - Ngrok Backend:
```bash
ngrok http 3000
# URL: https://backend-url.ngrok-free.app
```

### Terminal 3 - Frontend:
```bash
cd clube_pharma_frontend
flutter run -d web-server --web-port 8080
```

### Terminal 4 - Ngrok Frontend:
```bash
ngrok http 8080
# URL: https://frontend-url.ngrok-free.app
```

**Problema**: Você precisaria de 2 contas ngrok (ou conta paga) para 2 túneis simultâneos.

---

## Opção 4: Servir os Arquivos Estáticos da Pasta build/web

Você pode usar qualquer servidor web para servir a pasta `build/web`:

### Usando Python:
```bash
cd clube_pharma_frontend/build/web
python -m http.server 8080
```

### Usando Node.js (serve):
```bash
npm install -g serve
cd clube_pharma_frontend/build/web
serve -s . -p 8080
```

### Depois usar Ngrok:
```bash
ngrok http 8080
```

---

## Recomendação Final: Firebase Hosting

**Por quê?**
- ✅ Grátis
- ✅ URL permanente (não muda)
- ✅ HTTPS automático
- ✅ CDN global (rápido)
- ✅ Não precisa manter seu PC ligado
- ✅ Fácil de atualizar

### Setup Firebase (Passo a Passo):

```bash
# 1. Instalar Firebase CLI
npm install -g firebase-tools

# 2. Login
firebase login

# 3. Ir para pasta do frontend
cd clube_pharma_frontend

# 4. Inicializar Firebase
firebase init hosting

# Responda:
# ? What do you want to use as your public directory? → build/web
# ? Configure as a single-page app? → Yes
# ? Set up automatic builds? → No
# ? File build/web/index.html already exists. Overwrite? → No

# 5. Deploy!
firebase deploy --only hosting
```

Pronto! Vai mostrar:
```
✔ Deploy complete!

Project Console: https://console.firebase.google.com/project/seu-projeto
Hosting URL: https://seu-projeto.web.app
```

Seu primo acessa: **https://seu-projeto.web.app**

---

## Qual Escolher?

| Opção | Prós | Contras | Recomendado? |
|-------|------|---------|--------------|
| Firebase | Grátis, URL fixa, rápido | Requer conta Google | ⭐⭐⭐⭐⭐ |
| Netlify | Fácil, drag-and-drop | - | ⭐⭐⭐⭐ |
| Ngrok (2 túneis) | Rápido para testar | Precisa 2 contas/paga | ⭐⭐ |
| Local + Ngrok | Simples | PC precisa ficar ligado | ⭐⭐⭐ |

---

## Resumo Rápido (Firebase):

```bash
npm install -g firebase-tools
firebase login
cd clube_pharma_frontend
firebase init hosting
# public directory: build/web
# single-page app: Yes
firebase deploy --only hosting
```

**Compartilhe a URL gerada!** 🚀

Seu primo acessa pelo navegador (PC, celular, tablet) sem instalar nada!
