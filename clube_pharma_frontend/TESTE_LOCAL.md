# 🧪 Como Testar Localmente ANTES de Enviar para o Netlify

## 🎯 Por que Testar Localmente Primeiro?

Se funcionar no seu computador, sabemos que o código está OK!
O problema seria só na hospedagem.

---

## 💻 Método 1: Python (MAIS FÁCIL)

### Windows:
```bash
cd build/web
python -m http.server 8000
```

### Depois abra no navegador:
```
http://localhost:8000
```

---

## 💻 Método 2: Node.js

Se você tem Node instalado:

```bash
npx http-server build/web -p 8000
```

Depois abra: http://localhost:8000

---

## 💻 Método 3: PHP

Se você tem PHP:

```bash
cd build/web
php -S localhost:8000
```

---

## 💻 Método 4: VS Code (SUPER FÁCIL!)

1. Instale a extensão "Live Server" no VS Code
2. Clique com botão direito no arquivo `build/web/index.html`
3. Selecione "Open with Live Server"
4. Abre automaticamente!

---

## 💻 Método 5: Flutter Run (MELHOR!)

Execute direto pelo Flutter:

```bash
flutter run -d chrome
```

Isso roda a versão de desenvolvimento no Chrome!

---

## ✅ O que Verificar:

### **Se FUNCIONAR localmente:**
✅ Código está OK!
❌ Problema é na hospedagem (Netlify)

**Soluções:**
- Adicionar arquivo `_redirects` no Netlify
- Testar outro serviço (Vercel, Firebase)

---

### **Se NÃO FUNCIONAR localmente:**
❌ Problema no código
✅ Podemos corrigir juntos!

**Próximos passos:**
- Verificar console (F12)
- Ver erros específicos
- Corrigir (provavelmente Google Fonts)

---

## 🔍 Como Ver Erros:

1. Com o site aberto (local ou Netlify)
2. Pressione **F12**
3. Vá na aba **Console**
4. Me mande print dos erros em vermelho!

---

## 📸 Informações Úteis para Me Enviar:

1. **Console do navegador** (F12 > Console)
2. **Network tab** (F12 > Network) - veja se algum arquivo deu 404
3. **Diga se funciona localmente ou não**
4. **URL do Netlify que você usou**

Com isso eu identifico o problema em 1 minuto! 🚀
