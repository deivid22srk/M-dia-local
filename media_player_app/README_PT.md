# 🎬 Media Player App - Filmes e Séries

Um aplicativo Android moderno desenvolvido em Flutter para gerenciar e reproduzir filmes e séries locais, com layout inspirado no Stremio/Netflix e integração com a API do TMDB.

## ✨ Funcionalidades Principais

### 📁 Gerenciador de Arquivos Integrado
- **Seleção direta de arquivos**: Navegue e selecione vídeos do seu dispositivo
- **Sem SAF Storage**: Acesso direto aos arquivos sem complicações
- **Múltipla seleção**: Adicione vários arquivos de uma vez
- **Reconhecimento automático**: Extrai título, temporada e episódio do nome do arquivo

### 🎯 Integração com TMDB
- **Busca automática**: Encontra informações de filmes e séries automaticamente
- **Metadados completos**: Sinopse, rating, data de lançamento, elenco
- **Pôsteres e backdrops**: Imagens em alta qualidade
- **Suporte multi-idioma**: Conteúdo em português brasileiro

### 🎨 Layout Moderno Estilo Stremio
- **Tema escuro**: Interface elegante e confortável para os olhos
- **Cards interativos**: Visualização em grid com efeitos de hover
- **Animações suaves**: Transições fluidas entre telas
- **Design responsivo**: Adaptado para diferentes tamanhos de tela

### ▶️ Player de Vídeo Integrado
- **Controles completos**: Play, pause, avançar/retroceder 10s
- **Barra de progresso**: Com scrubbing e tempo real/atual
- **Controles automáticos**: Ocultam-se após 3 segundos
- **Hardware acceleration**: Reprodução otimizada
- **Buffer inteligente**: Carregamento eficiente

### 📚 Biblioteca Pessoal
- **Organização automática**: Filmes e séries separados
- **Indicadores visuais**: Ícones para tipo de mídia e arquivo local
- **Remoção fácil**: Remova itens da biblioteca sem apagar arquivos
- **Estado persistente**: Sua biblioteca é mantida entre sessões

## 📱 Screenshots (Descrição)

- **Tela Inicial**: Grid com biblioteca vazia e botão de adicionar
- **Biblioteca Preenchida**: Cards com pôsteres, ratings e indicadores
- **Detalhes do Filme**: Backdrop grande, sinopse, botão de assistir
- **Player de Vídeo**: Controles sobrepostos com design moderno
- **Busca TMDB**: Campo de pesquisa com resultados em tempo real

## 🛠️ Tecnologias Utilizadas

| Tecnologia | Finalidade |
|------------|-----------|
| **Flutter** | Framework UI cross-platform |
| **Provider** | Gerenciamento de estado |
| **Media Kit** | Player de vídeo poderoso |
| **HTTP** | Requisições à API TMDB |
| **File Picker** | Seleção de arquivos nativa |
| **Cached Network Image** | Cache de imagens online |
| **Permission Handler** | Gerenciamento de permissões |
| **Google Fonts** | Tipografia moderna |

## 🚀 Como Configurar

### 1. Obter Chave API do TMDB (Gratuito)

1. Acesse [https://www.themoviedb.org/settings/api](https://www.themoviedb.org/settings/api)
2. Crie uma conta gratuita
3. Vá em "Settings" → "API" e clique em "Request an API Key"
4. Selecione "Developer"
5. Preencha as informações solicitadas
6. Copie sua chave API (v3)

### 2. Configurar o Projeto

```bash
# Clone ou navegue até o diretório do projeto
cd media_player_app

# Instale as dependências
flutter pub get

# Abra o arquivo lib/services/tmdb_service.dart
# Substitua YOUR_TMDB_API_KEY pela sua chave:
static const String _apiKey = 'SUA_CHAVE_AQUI';
```

### 3. Executar o App

```bash
# Conecte um dispositivo Android ou inicie um emulador
flutter devices

# Execute o app
flutter run
```

## 📋 Permissões Necessárias

O app já inclui todas as permissões no `AndroidManifest.xml`:

```xml
<!-- Armazenamento (Android até 12) -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />

<!-- Mídia (Android 13+) -->
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />

<!-- Gerenciamento de arquivos -->
<uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" />

<!-- Internet para API TMDB -->
<uses-permission android:name="android.permission.INTERNET" />
```

## 🎯 Como Usar

### Adicionar Filmes/Séries

1. **Botão Único**: Toque no botão vermelho "+" no canto superior direito
2. **Múltiplos**: Toque no botão azul de pasta ao lado
3. **Navegue**: Encontre seus arquivos de vídeo
4. **Selecione**: Toque no arquivo desejado
5. **Aguarde**: O app buscará informações automaticamente

### Navegar na Biblioteca

- **Grid View**: Visualize todos os itens em cards
- **Toque**: Clique em qualquer card para ver detalhes
- **Informações**: Veja sinopse, rating, data de lançamento
- **Assistir**: Toque em "ASSISTIR AGORA" para reproduzir

### Buscar no TMDB

1. Vá para a aba "Buscar"
2. Digite o nome do filme/série
3. Resultados aparecem em tempo real
4. Toque para ver detalhes ou adicionar

### Configurações

- **Qualidade**: Ajuste a qualidade do player
- **Legendas**: Configure legendas (funcionalidade futura)
- **Armazenamento**: Veja e limpe o cache
- **API**: Configure sua chave TMDB

## 🎨 Paleta de Cores

```
Primary:      #E50914 (Vermelho Netflix)
Secondary:    #B81D24 (Vermelho escuro)
Background:   #141414 (Preto quase total)
Surface:      #1F1F1F (Cinza muito escuro)
Card:         #1F1F1F (Cinza escuro)
Text Primary: #FFFFFF (Branco)
Text Secondary: #FFFFFF70 (Branco translúcido)
```

## 📁 Estrutura do Projeto

```
lib/
├── main.dart                    # Entry point e tema
├── models/
│   └── media_item.dart         # Modelo de dados
├── services/
│   ├── tmdb_service.dart       # API TMDB
│   ├── file_picker_service.dart # Seleção de arquivos
│   └── media_provider.dart     # Estado global
├── screens/
│   ├── home_screen.dart        # Tela principal (tabs)
│   ├── media_detail_screen.dart # Detalhes da mídia
│   └── player_screen.dart      # Player de vídeo
└── widgets/
    └── media_card.dart         # Card de mídia
```

## ⚠️ Notas Importantes

1. **Chave API**: É obrigatório obter sua própria chave do TMDB
2. **Android 13+**: Permissões de mídia são diferentes
3. **Arquivos Locais**: O app não baixa vídeos, apenas reproduz arquivos locais
4. **Internet**: Necessária apenas para buscar metadados
5. **Formatos**: Suporta formatos comuns (MP4, MKV, AVI, etc.)

## 🔧 Funcionalidades Futuras (Roadmap)

- [ ] Legendas embutidas e externas
- [ ] Histórico de reprodução
- [ ] Continuar assistindo
- [ ] Favoritos e listas personalizadas
- [ ] Modo offline (cache de metadados)
- [ ] Suporte a streaming de rede (SMB, DLNA)
- [ ] Equalizador de áudio
- [ ] Controle de velocidade de reprodução
- [ ] Picture-in-Picture
- [ ] Chromecast support

## 🐛 Solução de Problemas

### App não encontra arquivos
- Verifique se as permissões foram concedidas
- No Android 11+, pode ser necessário permitir acesso a "Todos os arquivos"

### Imagens não carregam
- Verifique sua conexão com internet
- Confirme que a chave API do TMDB está correta

### Player não reproduz
- Verifique se o formato de vídeo é suportado
- Tente reinstalar o app

### Erro na busca do TMDB
- Verifique sua chave API
- Confirme se há conexão com internet

## 📄 Licença

Este projeto é desenvolvido para fins educacionais e de aprendizado.

## 🤝 Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para:
- Reportar bugs
- Sugerir melhorias
- Enviar pull requests

## 📞 Suporte

Para dúvidas ou problemas:
1. Verifique este README
2. Confira os issues no repositório
3. Crie um novo issue descrevendo o problema

---

**Desenvolvido com ❤️ usando Flutter**

*Inspired by Stremio & Netflix*
