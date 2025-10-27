# Clube Pharma

Sistema completo de gerenciamento farmacêutico com backend Node.js/Express e frontend Flutter.

## Estrutura do Projeto

```
Desenvolvimento/
├── clube_pharma_backend/    # API REST com Node.js, Express e Prisma
└── clube_pharma_frontend/   # Aplicativo Flutter multiplataforma
```

## Tecnologias

### Backend
- Node.js + Express
- TypeScript
- Prisma ORM
- PostgreSQL/MySQL
- JWT Authentication
- Bcrypt
- Multer (upload de arquivos)

### Frontend
- Flutter
- Dart
- Provider (gerenciamento de estado)
- HTTP/Dio
- Shared Preferences

## Pré-requisitos

### Backend
- Node.js 16+ e npm
- PostgreSQL ou MySQL
- Git

### Frontend
- Flutter SDK (3.0+)
- Dart SDK
- Android Studio / Xcode (para desenvolvimento mobile)
- Chrome (para desenvolvimento web)

## Configuração e Instalação

### 1. Backend

```bash
# Entrar no diretório do backend
cd clube_pharma_backend

# Instalar dependências
npm install

# Configurar variáveis de ambiente
cp .env.example .env
# Edite o arquivo .env com suas configurações

# Gerar cliente Prisma
npx prisma generate

# Executar migrações do banco de dados
npx prisma migrate dev

# (Opcional) Popular banco com dados de teste
npx prisma db seed

# Iniciar servidor de desenvolvimento
npm run dev
```

O servidor estará rodando em `http://localhost:3000` (ou porta configurada no .env).

#### Variáveis de Ambiente (.env)

```env
DATABASE_URL="postgresql://user:password@localhost:5432/clubepharma"
JWT_SECRET="seu-secret-super-seguro"
PORT=3000
NODE_ENV=development
```

### 2. Frontend

```bash
# Entrar no diretório do frontend
cd clube_pharma_frontend

# Instalar dependências
flutter pub get

# Verificar configuração do Flutter
flutter doctor

# Executar em modo desenvolvimento
flutter run

# Ou para plataforma específica:
flutter run -d chrome           # Web
flutter run -d windows          # Windows
flutter run -d android          # Android
flutter run -d ios              # iOS (somente macOS)
```

#### Configuração da API

Edite o arquivo de configuração da API no frontend para apontar para seu backend:

```dart
// lib/services/api_service.dart ou similar
static const String baseUrl = 'http://localhost:3000/api';
```

Para desenvolvimento Android, use `http://10.0.2.2:3000/api` (emulador Android) ou o IP da sua máquina na rede local.

## Scripts Disponíveis

### Backend

```bash
npm run dev          # Desenvolvimento com hot-reload
npm run build        # Build para produção
npm start            # Iniciar servidor de produção
npm test             # Executar testes
npm run prisma:studio # Abrir Prisma Studio (GUI do banco)
```

### Frontend

```bash
flutter run          # Executar app
flutter build apk    # Build Android (APK)
flutter build appbundle # Build Android (AAB para Play Store)
flutter build web    # Build para Web
flutter build windows # Build para Windows
flutter test         # Executar testes
flutter clean        # Limpar build cache
```

## Documentação Adicional

### Backend
- [README Backend](./clube_pharma_backend/README.md) - Documentação completa da API
- [QUICKSTART Backend](./clube_pharma_backend/QUICKSTART.md) - Guia rápido
- [ARCHITECTURE](./clube_pharma_backend/ARCHITECTURE.md) - Arquitetura do sistema

### Frontend
- [README Frontend](./clube_pharma_frontend/README.md) - Documentação do app
- [INICIAR_PROJETO](./clube_pharma_frontend/INICIAR_PROJETO.md) - Guia de inicialização
- [INTEGRACAO_BACKEND_RESUMO](./clube_pharma_frontend/INTEGRACAO_BACKEND_RESUMO.md) - Integração com API

## Funcionalidades Principais

- Autenticação e autorização de usuários
- Gerenciamento de farmácias
- Gestão de produtos farmacêuticos
- Controle de estoque
- Sistema de pedidos
- Upload de imagens
- Relatórios e dashboard
- Interface responsiva e multiplataforma

## Desenvolvimento

### Fluxo de Trabalho

1. Certifique-se de que o backend está rodando
2. Configure o endereço da API no frontend
3. Inicie o frontend na plataforma desejada
4. Teste as funcionalidades

### Testes

#### Backend
```bash
cd clube_pharma_backend
npm test
```

#### Frontend
```bash
cd clube_pharma_frontend
flutter test
```

## Deploy

### Backend

Opções recomendadas:
- Heroku
- Railway
- Render
- DigitalOcean
- AWS/Azure/GCP

### Frontend

#### Web
```bash
flutter build web
# Deploy pasta build/web para qualquer hosting estático
```

#### Mobile
```bash
# Android
flutter build appbundle
# Upload para Google Play Console

# iOS (requer macOS)
flutter build ipa
# Upload para App Store Connect
```

## Problemas Comuns

### Backend

**Erro de conexão com banco de dados**
- Verifique se o PostgreSQL/MySQL está rodando
- Confirme as credenciais no arquivo .env
- Execute `npx prisma migrate dev` novamente

**Porta já em uso**
- Altere a variável PORT no .env
- Ou mate o processo: `npx kill-port 3000`

### Frontend

**Erro ao conectar com API**
- Verifique se o backend está rodando
- Confirme o baseUrl no código
- Para Android emulador, use `10.0.2.2` ao invés de `localhost`

**Dependências desatualizadas**
```bash
flutter clean
flutter pub get
```

## Contribuindo

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/MinhaFeature`)
3. Commit suas mudanças (`git commit -m 'Adiciona MinhaFeature'`)
4. Push para a branch (`git push origin feature/MinhaFeature`)
5. Abra um Pull Request

## Licença

[Adicione sua licença aqui]

## Contato

[Adicione informações de contato]

---

Desenvolvido com Node.js, Express, Flutter e muito café!
