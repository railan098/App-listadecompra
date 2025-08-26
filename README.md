# 🛒 Lista de Compra - App Flutter

Uma aplicação simples e funcional para gerenciar sua lista de compras, desenvolvida em Flutter.

## ✨ Funcionalidades

✅ **Adicionar itens** - Nome, quantidade e observações
✅ **Marcar como comprado** - Checkbox para acompanhar progresso
✅ **Editar itens** - Modificar detalhes dos itens
✅ **Deletar itens** - Remover itens da lista
✅ **Limpar lista** - Apagar toda a lista de uma vez
✅ **Armazenamento local** - Dados salvos no dispositivo
✅ **Interface intuitiva** - Design Material 3 moderno
✅ **Multiplataforma** - Funciona em Android, iOS, Web e Desktop

## 🚀 Como Usar

### 1. **Adicionar Itens**
- Toque no botão **+** (flutuante)
- Digite o nome do item
- Defina a quantidade
- Adicione observações (opcional)
- Toque em **Adicionar**

### 2. **Gerenciar Itens**
- **Marcar como comprado**: Toque no checkbox
- **Deletar**: Toque no ícone de lixeira
- **Limpar lista**: Toque no ícone de limpar na barra superior

### 3. **Navegação**
- Interface simples e direta
- Sem necessidade de login ou conta

## 🏗️ Estrutura do Projeto

```
lib/
├── main.dart                           # Ponto de entrada
├── models/
│   └── item_compra.dart              # Modelo de dados
├── services/
│   └── local_storage_service.dart    # Serviço de armazenamento local
└── screens/
    └── lista_compra_simple_screen.dart # Tela principal
```

## 🎨 Design

- **Tema**: Verde (shopping cart)
- **Design System**: Material 3
- **Cores**: Adaptativas para tema claro/escuro
- **Ícones**: Material Design Icons

## 📱 Plataformas Suportadas

- ✅ Android
- ✅ iOS  
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🧪 Como Executar

### Pré-requisitos
- Flutter SDK 3.9.0 ou superior
- Dart 3.0.0 ou superior

### Passos
1. Clone o repositório
2. Execute `flutter pub get`
3. Execute `flutter run`

### Comandos Úteis
```bash
# Instalar dependências
flutter pub get

# Executar em modo debug
flutter run

# Executar em modo release
flutter run --release

# Build para web
flutter build web

# Build para Android
flutter build apk
```

## 🔧 Dependências

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  shared_preferences: ^2.2.2  # Armazenamento local
```

## 📊 Modelo de Dados

```dart
class ItemCompra {
  final String id;
  final String nome;
  final int quantidade;
  final bool comprado;
  final DateTime dataCriacao;
  final String? observacao;
}
```

## 💾 Armazenamento

- **Local**: Dados salvos no dispositivo usando SharedPreferences
- **Persistente**: Dados mantidos entre sessões
- **Offline**: Funciona sem conexão com internet

## 🚀 Funcionalidades Futuras

- [ ] Categorias de produtos
- [ ] Listas compartilhadas
- [ ] Histórico de compras
- [ ] Notificações
- [ ] Backup na nuvem
- [ ] Sincronização com Firebase (opcional)

## 🆘 Solução de Problemas

### App não inicia
```bash
flutter clean
flutter pub get
flutter run
```

### Dados não aparecem
- Verifique se o app tem permissão de armazenamento
- Reinicie o app

### Erro de build
- Verifique se o Flutter está atualizado
- Execute `flutter doctor` para diagnóstico

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Push para a branch
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

## 👨‍💻 Desenvolvedor

Desenvolvido com ❤️ usando Flutter

## 🔗 Links Úteis

- [Flutter Documentation](https://flutter.dev/docs)
- [Material Design](https://material.io/design)
- [SharedPreferences](https://pub.dev/packages/shared_preferences)

---

**🎯 Objetivo**: Simplificar o gerenciamento de listas de compra com uma interface intuitiva e funcionalidades essenciais.
