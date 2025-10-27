# ClubePharma - Aplicativo Flutter

## Descrição do Projeto

Este é o aplicativo mobile do ClubePharma, desenvolvido em Flutter/Dart. O app oferece um clube de benefícios para saúde com descontos em consultas médicas e medicamentos manipulados.

## Funcionalidades Implementadas (v1.0)

### ✅ Tela de Boas-vindas (Welcome Screen)
- Design moderno e responsivo
- Apresentação dos benefícios do ClubePharma
- Seção de FAQ (Perguntas Frequentes)
- Estatísticas do serviço
- Botões de ação para acessar plataforma e conhecer planos
- **MENU FIXO EMBAIXO** - Conforme solicitado, removemos a opção de escolher a posição do menu

### ✅ Sistema de Navegação
- Menu de navegação fixo na parte inferior
- 6 abas principais:
  - 🏠 Início
  - 🩺 Consultas
  - 💊 Farmácia
  - ❤️ Tratamentos
  - 👨‍👩‍👧‍👦 Família
  - 👤 Perfil

### ✅ Tema Claro/Escuro
- Alternância entre modo claro e escuro
- Botão de troca de tema nas telas Welcome e Home
- Paleta de cores consistente com a identidade visual

### ✅ Estrutura das Telas
- Todas as 6 telas principais criadas (em modo esqueleto)
- Prontas para receber o conteúdo específico de cada seção

## Estrutura do Projeto

```
lib/
├── main.dart                    # Arquivo principal do app
├── theme/
│   ├── app_colors.dart          # Definição de cores do tema
│   └── app_theme.dart           # Configuração dos temas claro/escuro
├── widgets/
│   └── clube_pharma_logo.dart   # Widget do logo customizado
├── screens/
│   ├── welcome_screen.dart      # Tela de boas-vindas
│   ├── home_screen.dart         # Tela principal com navegação
│   └── tabs/
│       ├── inicio_tab.dart      # Aba Início
│       ├── consultas_tab.dart   # Aba Consultas
│       ├── farmacia_tab.dart    # Aba Farmácia
│       ├── tratamentos_tab.dart # Aba Tratamentos
│       ├── familia_tab.dart     # Aba Família
│       └── perfil_tab.dart      # Aba Perfil
```

## Paleta de Cores

- **Primary**: `#1ABFB0` (Verde-água vibrante)
- **Secondary**: `#059669` (Verde esmeralda)
- **Accent**: `#10B981` (Verde menta)
- **Danger**: `#EF4444` (Vermelho)
- **Warning**: `#F59E0B` (Amarelo/Laranja)
- **Info**: `#3B82F6` (Azul)
- **Purple**: `#A855F7` (Roxo)

## Como Executar o Projeto

### Pré-requisitos
- Flutter SDK instalado (versão 3.8.1 ou superior)
- Android Studio ou VS Code com extensões Flutter
- Emulador Android/iOS ou dispositivo físico conectado

### Passos para Executar

1. **Verificar instalação do Flutter**
   ```bash
   flutter doctor
   ```

2. **Instalar dependências**
   ```bash
   flutter pub get
   ```

3. **Executar o aplicativo**
   ```bash
   flutter run
   ```

   Ou selecione o dispositivo específico:
   ```bash
   flutter devices
   flutter run -d <device-id>
   ```

### Comandos Úteis

- **Executar em modo debug**
  ```bash
  flutter run
  ```

- **Executar em modo release**
  ```bash
  flutter run --release
  ```

- **Limpar build**
  ```bash
  flutter clean
  ```

- **Verificar problemas**
  ```bash
  flutter doctor -v
  ```

## Dependências Utilizadas

- `google_fonts: ^6.2.1` - Fontes customizadas (Inter)
- `flutter_svg: ^2.0.10+1` - Suporte para arquivos SVG
- `cupertino_icons: ^1.0.8` - Ícones do iOS

## Próximos Passos (Backend e Banco de Dados)

Após finalizar todo o front-end navegável, seguiremos para:

1. **Backend (Node.js)**
   - Criação de APIs RESTful
   - Autenticação e autorização
   - Integração com serviços externos

2. **Banco de Dados (PostgreSQL)**
   - Modelagem do banco de dados
   - Criação de tabelas e relacionamentos
   - Migrations e seeds

3. **Integração Front-Backend**
   - Consumo de APIs no Flutter
   - Gerenciamento de estado
   - Cache e persistência local

## Status Atual

🟢 **PRONTO PARA DESENVOLVIMENTO**

A estrutura base está completa e funcionando. Todas as telas navegáveis estão implementadas com o menu fixo embaixo conforme solicitado.

## Observações Importantes

- ✅ Menu sempre fixo na parte inferior (conforme solicitado)
- ✅ Tema claro/escuro funcionando
- ✅ Navegação entre todas as abas funcionando
- ✅ Design responsivo para diferentes tamanhos de tela
- ⏳ Aguardando desenvolvimento de conteúdo específico de cada tela

## Contato

Para dúvidas sobre o desenvolvimento, consulte a documentação do Flutter em [flutter.dev](https://flutter.dev)
