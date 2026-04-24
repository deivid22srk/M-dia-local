# Guia de Instalação e Configuração

## Pré-requisitos

1. **Flutter SDK** instalado (versão 3.5.0 ou superior)
   - [Guia de instalação do Flutter](https://docs.flutter.dev/get-started/install)

2. **Android Studio** ou VS Code com extensão Flutter
   - [Android Studio](https://developer.android.com/studio)
   - [VS Code + Flutter Extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)

3. **Chave API do TMDB**
   - Acesse https://www.themoviedb.org/
   - Crie uma conta gratuita
   - Vá em Configurações → API → Solicitar chave API
   - Copie sua chave API v3

## Passo a Passo

### 1. Clonar/Navegar até o Projeto

```bash
cd /workspace/media_player_app
```

### 2. Configurar Chave API do TMDB

Edite o arquivo `lib/services/tmdb_service.dart`:

```dart
static const String _apiKey = 'SUA_CHAVE_API_AQUI'; // Substitua pela sua chave
```

### 3. Instalar Dependências

```bash
flutter pub get
```

### 4. Configurar Android (Opcional)

Se quiser personalizar:

- **Nome do App**: Edite `android/app/src/main/res/values/strings.xml`
- **Ícone**: Substitua os arquivos em `android/app/src/main/res/mipmap-*/ic_launcher.png`
- **Permissões**: Já configuradas em `android/app/src/main/AndroidManifest.xml`

### 5. Rodar o App

Conecte um dispositivo Android ou inicie um emulador, depois execute:

```bash
flutter run
```

Ou para build de release:

```bash
flutter build apk --release
```

O APK será gerado em: `build/app/outputs/flutter-apk/app-release.apk`

## Estrutura de Pastas

```
media_player_app/
├── android/                 # Configurações Android
│   ├── app/
│   │   ├── src/main/
│   │   │   ├── AndroidManifest.xml    # Permissões e config do app
│   │   │   ├── kotlin/                # Código nativo Kotlin
│   │   │   └── res/                   # Recursos (ícones, temas)
│   │   └── build.gradle               # Configuração do build Android
│   └── build.gradle                   # Configuração do projeto
├── assets/images/           # Imagens e recursos estáticos
├── lib/                     # Código Dart/Flutter
│   ├── main.dart            # Entry point
│   ├── models/              # Modelos de dados
│   ├── screens/             # Telas do app
│   ├── services/            # Serviços e lógica de negócio
│   └── widgets/             # Componentes reutilizáveis
├── pubspec.yaml             # Dependências e configurações
└── README.md                # Documentação
```

## Troubleshooting

### Erro: "Flutter SDK not found"

Certifique-se de que o Flutter está no PATH:

```bash
export PATH="$PATH:/caminho/para/flutter/bin"
```

### Erro: "Permission Denied" no Android

Verifique se as permissões estão corretas no `AndroidManifest.xml`.

### Erro: "API Key Inválida"

- Verifique se copiou a chave correta do TMDB
- Confirme se há conexão com internet
- Teste a API no navegador: `https://api.themoviedb.org/3/movie/popular?api_key=SUA_CHAVE&language=pt-BR`

### Build Falha no Android

Limpe o build e tente novamente:

```bash
flutter clean
flutter pub get
flutter run
```

## Dicas de Desenvolvimento

### Hot Reload

Durante o desenvolvimento, pressione:
- `r` no terminal para hot reload
- `R` para hot restart
- `q` para sair

### Debug Mode

Para ver logs detalhados:

```bash
flutter run --verbose
```

### Format Code

```bash
flutter format .
```

### Analyze Code

```bash
flutter analyze
```

## Suporte a Versões Android

| Versão Android | API Level | Suporte |
|---------------|-----------|---------|
| 5.0 - 5.1     | 21-22     | ✅      |
| 6.0           | 23        | ✅      |
| 7.0 - 7.1     | 24-25     | ✅      |
| 8.0 - 8.1     | 26-27     | ✅      |
| 9             | 28        | ✅      |
| 10            | 29        | ✅      |
| 11            | 30        | ✅      |
| 12            | 31-32     | ✅      |
| 13            | 33        | ✅      |
| 14            | 34        | ✅      |

## Próximos Passos

Após instalar e testar:

1. Personalize o tema em `lib/main.dart`
2. Adicione mais funcionalidades ao player
3. Implemente cache offline
4. Adicione suporte a legendas
5. Crie builds para diferentes arquiteturas (arm64-v8a, armeabi-v7a, x86_64)

---

**Dúvidas?** Consulte a documentação oficial do Flutter: https://docs.flutter.dev/
