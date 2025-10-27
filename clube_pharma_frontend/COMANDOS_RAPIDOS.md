# ⚡ COMANDOS RÁPIDOS - Cole e Execute!

## 🎯 TESTE 1: Executar no Chrome

```bash
flutter run -d chrome
```

✅ **Deve abrir o app funcionando no Chrome!**

---

## 🎯 TESTE 2: Servidor Local

```bash
cd build/web
python -m http.server 8000
```

Depois abra: **http://localhost:8000**

---

## 🎯 TESTE 3: Verificar Arquivos

Abra: **http://localhost:8000/test.html**

(Após rodar o servidor local do Teste 2)

---

## 🧹 SE QUISER LIMPAR TUDO:

```bash
flutter clean
flutter pub get
flutter build web --release
```

---

## 🔍 VER ERROS:

```bash
flutter analyze
```

---

## 📦 RECOMPILAR:

```bash
flutter build web --release --no-tree-shake-icons
```

---

## ✅ CHECKLIST RÁPIDO:

- [ ] Executei `flutter run -d chrome`
- [ ] Funcionou? → **SIM** = Código OK! / **NÃO** = Tirar print do console
- [ ] Abri http://localhost:8000/test.html
- [ ] Tirei print do console (F12)
- [ ] Mandei prints para o Claude

---

**Cole esses comandos no terminal e pronto! 🚀**
