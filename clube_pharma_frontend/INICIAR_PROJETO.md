# 🚀 Como Iniciar o Projeto ClubePharma

## ⚡ Início Rápido

### **Opção 1: Executar no Navegador (Web)**
```bash
flutter run -d chrome
```
O app vai abrir automaticamente no Chrome!

---

### **Opção 2: Executar no Emulador Android**
```bash
flutter run
```
(Se você tem um emulador aberto, vai rodar nele automaticamente)

---

### **Opção 3: Ver Build Web Já Compilado**
1. Navegue até a pasta `build/web/`
2. Abra o arquivo `index.html` em um navegador

   **OU execute um servidor local:**
   ```bash
   cd build/web
   python -m http.server 8000
   ```
   Depois abra: http://localhost:8000

---

## 📱 Todos os Comandos Disponíveis:

### **Desenvolvimento:**
```bash
# Ver dispositivos disponíveis
flutter devices

# Executar no Chrome
flutter run -d chrome

# Executar no Edge
flutter run -d edge

# Executar com hot reload
flutter run

# Limpar cache e rebuildar
flutter clean
flutter pub get
flutter run
```

---

### **Testes:**
```bash
# Executar todos os testes
flutter test

# Executar testes com cobertura
flutter test --coverage

# Análise de código
flutter analyze
```

---

### **Build (Compilar):**
```bash
# Build para Web (produção)
flutter build web --release

# Build para Android (APK)
flutter build apk --release

# Build para Windows
flutter build windows --release
```

---

## 🎯 Atalhos do VS Code:

Se estiver usando VS Code:

1. **F5** - Iniciar debug
2. **Ctrl + F5** - Executar sem debug
3. **Shift + F5** - Parar execução
4. **r** (no terminal) - Hot reload
5. **R** (no terminal) - Hot restart

---

## 🔥 Hot Reload (Desenvolvimento Rápido):

Quando o app estiver rodando:
- Faça alterações no código
- Salve o arquivo (Ctrl + S)
- **Automaticamente atualiza na tela!**

Sem precisar reiniciar o app! 🚀

---

## 📦 Estrutura do Projeto:

```
clube_pharma_frontend/
├── lib/
│   ├── main.dart              ← Arquivo principal
│   ├── screens/               ← Telas do app
│   ├── widgets/               ← Componentes reutilizáveis
│   └── theme/                 ← Cores e temas
├── build/web/                 ← Build web compilado
├── test/                      ← Testes automatizados
└── pubspec.yaml               ← Dependências
```

---

## 🐛 Resolução de Problemas:

### **Erro: "No devices found"**
**Solução:**
```bash
# Habilitar web
flutter config --enable-web

# Verificar dispositivos
flutter devices
```

---

### **Erro ao compilar**
**Solução:**
```bash
flutter clean
flutter pub get
flutter run
```

---

### **Erro de dependências**
**Solução:**
```bash
flutter pub upgrade
```

---

## 💡 Dicas Úteis:

1. **Sempre use hot reload** (salve o arquivo) ao invés de reiniciar
2. **Use `flutter analyze`** antes de commitar código
3. **Execute `flutter test`** para garantir que nada quebrou
4. **Use VS Code** ou **Android Studio** para melhor experiência

---

## 🎨 Como Testar Tema Claro/Escuro:

1. Execute o app
2. Na tela de boas-vindas, clique no ícone de sol/lua no canto superior direito
3. O tema alterna instantaneamente!

---

## 📲 Como Testar Responsividade:

### **No Chrome DevTools:**
1. Pressione F12
2. Clique no ícone de dispositivo móvel
3. Selecione diferentes tamanhos de tela
4. Veja o app se adaptar!

---

## ✅ Checklist Antes de Começar:

- [ ] Flutter instalado (`flutter doctor`)
- [ ] Editor configurado (VS Code ou Android Studio)
- [ ] Dependências instaladas (`flutter pub get`)
- [ ] Sem erros no código (`flutter analyze`)
- [ ] Testes passando (`flutter test`)

---

## 🎯 Status Atual:

✅ **PROJETO PRONTO PARA DESENVOLVIMENTO**

- Tela de boas-vindas completa
- Navegação funcionando
- 6 telas criadas (esqueleto)
- Tema claro/escuro
- Menu fixo embaixo
- Sem erros!

---

## 🚀 Vamos Começar?

```bash
# 1. Instalar dependências (se ainda não fez)
flutter pub get

# 2. Executar no Chrome
flutter run -d chrome

# 3. Começar a codar! 🎉
```

**Divirta-se desenvolvendo!** 🚀✨
