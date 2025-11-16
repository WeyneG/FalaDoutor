# Flutter App - Fala Doutor

Aplicativo mobile para gerenciamento de médicos do sistema Fala Doutor.

## 📱 Funcionalidades

- Tela inicial com botão de navegação
- Listagem de todos os médicos cadastrados
- Cadastro de novos médicos
- Visualização de detalhes do médico
- Edição de médicos
- Exclusão de médicos
- Filtros por plano
- Interface moderna e intuitiva

## 🚀 Como Executar

### 1. Instalar dependências
```bash
cd flutter_app
flutter pub get
```

### 2. Configurar o IP da API

**IMPORTANTE:** Edite o arquivo `lib/services/medico_service.dart` e altere o `baseUrl`:

#### Para Emulador Android:
```dart
static const String baseUrl = 'http://10.0.2.2:3000/api';
```

#### Para Dispositivo Físico:
```dart
static const String baseUrl = 'http://SEU_IP_LOCAL:3000/api';
```

Para descobrir seu IP local:
- Windows: `ipconfig` no CMD
- Procure por "IPv4" (ex: 192.168.1.100)

### 3. Certificar que o backend está rodando
```bash
# Na pasta raiz do projeto
npm run dev
```

### 4. Executar o app
```bash
flutter run
```

## 📦 Estrutura do Projeto

```
flutter_app/
├── lib/
│   ├── main.dart                      # Entrada do app
│   ├── models/
│   │   └── medico.dart               # Model do médico
│   ├── services/
│   │   └── medico_service.dart       # Serviço de API
│   └── screens/
│       ├── home_screen.dart          # Tela inicial
│       ├── lista_medicos_screen.dart # Lista de médicos
│       ├── cadastro_medico_screen.dart # Cadastro/Edição
│       └── detalhes_medico_screen.dart # Detalhes
└── pubspec.yaml                       # Dependências
```

## 🎨 Telas

1. **Home Screen** - Tela inicial com botão "Gerenciar Médicos"
2. **Lista de Médicos** - Lista todos os médicos com opções de visualizar, editar e excluir
3. **Cadastro de Médico** - Formulário para cadastrar/editar médico
4. **Detalhes do Médico** - Visualização completa dos dados do médico

## 🔧 Dependências

- `http: ^1.1.0` - Requisições HTTP
- `intl: ^0.18.1` - Formatação de datas

## ⚠️ Problemas Comuns

### Erro de conexão
- Verifique se o backend está rodando
- Certifique-se que o IP está correto no `medico_service.dart`
- Para emulador Android, use `10.0.2.2` ao invés de `localhost`

### CPF não formata
- O formatador só funciona durante a digitação
- CPF é enviado apenas com números para a API

## 📱 Testado em:
- Android Emulator
- Dispositivos físicos Android
