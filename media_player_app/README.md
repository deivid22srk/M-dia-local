# README - Media Player App

## 🎬 Aplicativo de Filmes e Séries em Flutter

Um aplicativo Android moderno para gerenciar e reproduzir filmes e séries locais, com layout inspirado no Stremio e integração com a API do TMDB.

### ✨ Funcionalidades

- **Gerenciador de Arquivos Integrado**: Selecione arquivos de vídeo diretamente do seu dispositivo sem usar SAF Storage
- **Busca na API TMDB**: Encontre informações detalhadas sobre filmes e séries
- **Layout Moderno**: Interface escura estilo Netflix/Stremio
- **Biblioteca Local**: Organize seus arquivos de mídia em uma biblioteca pessoal
- **Detalhes Completos**: Sinopse, rating, data de lançamento e mais
- **Reconhecimento Automático**: Extrai informações do nome do arquivo

### 📁 Estrutura do Projeto

```
lib/
├── main.dart                 # Ponto de entrada do app
├── models/
│   └── media_item.dart      # Modelo de dados para filmes/séries
├── services/
│   ├── tmdb_service.dart    # Serviço de API do TMDB
│   ├── file_picker_service.dart  # Serviço de seleção de arquivos
│   └── media_provider.dart  # Gerenciamento de estado (Provider)
├── screens/
│   ├── home_screen.dart     # Tela principal com tabs
│   └── media_detail_screen.dart  # Tela de detalhes da mídia
└── widgets/
    └── media_card.dart      # Card de exibição de mídia
```

### 🚀 Configuração

#### 1. Obter Chave API do TMDB

1. Acesse [https://www.themoviedb.org/settings/api](https://www.themoviedb.org/settings/api)
2. Crie uma conta e solicite uma chave API
3. Substitua `YOUR_TMDB_API_KEY` em `lib/services/tmdb_service.dart`

```dart
static const String _apiKey = 'SUA_CHAVE_API_AQUI';
```

#### 2. Configurar Dependências

Execute no terminal:

```bash
cd media_player_app
flutter pub get
```

#### 3. Permissões Android

O app já inclui as permissões necessárias no `AndroidManifest.xml`:

- `READ_EXTERNAL_STORAGE` - Ler arquivos de mídia
- `READ_MEDIA_VIDEO` - Android 13+
- `INTERNET` - Acessar API TMDB
- `MANAGE_EXTERNAL_STORAGE` - Gerenciamento de arquivos

### 🛠️ Tecnologias Utilizadas

- **Flutter** - Framework UI
- **Provider** - Gerenciamento de estado
- **HTTP** - Requisições à API
- **File Picker** - Seleção de arquivos
- **Cached Network Image** - Cache de imagens
- **Permission Handler** - Gerenciamento de permissões

### 📱 Requisitos

- Android 5.0 (API 21) ou superior
- Conexão com internet para buscar metadados
- Armazenamento com arquivos de vídeo

### 🎨 Temas e Cores

O app utiliza um tema escuro com cor primária vermelha (#E50914), similar à Netflix:

- Background: #141414
- Surface: #1F1F1F
- Primary: #E50914
- Secondary: #B81D24

### 📝 Como Usar

1. **Adicionar Mídia**: Toque no botão "+" na tela Biblioteca
2. **Selecionar Arquivo**: Navegue até o arquivo de vídeo desejado
3. **Visualizar Detalhes**: Toque em qualquer item para ver detalhes
4. **Buscar**: Use a aba Buscar para pesquisar na API TMDB
5. **Configurar**: Acesse Configurações para personalizar

### ⚠️ Notas Importantes

- O app não inclui player de vídeo implementado (apenas estrutura)
- É necessário obter sua própria chave API do TMDB
- Para Android 13+, as permissões de mídia são diferentes
- O app não usa SAF Storage, acessando arquivos diretamente

### 🔧 Próximos Passos (Implementações Futuras)

- [ ] Implementar player de vídeo completo
- [ ] Suporte a legendas
- [ ] Histórico de reprodução
- [ ] Favoritos
- [ ] Download de metadados offline
- [ ] Suporte a múltiplas fontes de vídeo

### 📄 Licença

Este projeto é apenas para fins educacionais.

---

**Desenvolvido com ❤️ usando Flutter**
