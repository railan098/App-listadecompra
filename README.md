# 📱 Lista de Compra - Flutter App

Um aplicativo de lista de compras desenvolvido em Flutter com integração Firebase, oferecendo uma experiência completa para gerenciar suas compras diárias.

## ✨ Funcionalidades

- 🔐 **Autenticação Firebase** - Login com Google e Email/Senha
- 📝 **Gerenciamento de Itens** - Adicionar, editar e remover itens
- 💰 **Controle de Preços** - Preço unitário e cálculo automático de subtotais
- 📊 **Resumo da Compra** - Total geral e estatísticas
- ✅ **Status de Compra** - Marcar itens como comprados
- 📱 **Interface Responsiva** - Otimizado para dispositivos Android
- ☁️ **Sincronização em Nuvem** - Dados salvos no Firestore
- 🔄 **Tempo Real** - Atualizações automáticas

## 🚀 Tecnologias Utilizadas

- **Flutter** - Framework de desenvolvimento
- **Firebase** - Backend e autenticação
  - **Firestore** - Banco de dados
  - **Firebase Auth** - Autenticação de usuários
- **Dart** - Linguagem de programação
- **Material Design** - Interface do usuário

## 📋 Pré-requisitos

- Flutter SDK (versão 3.0 ou superior)
- Dart SDK
- Android Studio / VS Code
- Conta Firebase
- Dispositivo Android ou emulador

## 🛠️ Instalação

1. **Clone o repositório**
   ```bash
   git clone https://github.com/seu-usuario/listadecompra.git
   cd listadecompra
   ```

2. **Instale as dependências**
   ```bash
   flutter pub get
   ```

3. **Configure o Firebase**
   - Crie um projeto no [Firebase Console](https://console.firebase.google.com/)
   - Baixe o arquivo `google-services.json` para Android
   - Coloque na pasta `android/app/`
   - Configure as regras do Firestore

4. **Execute o aplicativo**
   ```bash
   flutter run
   ```

## 🔧 Configuração Firebase

### Android
1. Adicione o arquivo `google-services.json` em `android/app/`
2. Configure o `build.gradle.kts` com o plugin do Firebase

### iOS
1. Adicione o arquivo `GoogleService-Info.plist` em `ios/Runner/`
2. Configure o `AppDelegate.swift`

## 📱 Estrutura do Projeto

```
lib/
├── main.dart                 # Ponto de entrada da aplicação
├── firebase_config.dart      # Configuração do Firebase
├── firebase_options.dart     # Opções do Firebase
├── models/                   # Modelos de dados
│   ├── item_compra.dart     # Modelo do item de compra
│   └── usuario.dart         # Modelo do usuário
├── screens/                  # Telas da aplicação
│   ├── login_screen.dart    # Tela de login
│   ├── lista_compra_firebase_screen.dart  # Tela principal
│   └── perfil_usuario_screen.dart         # Perfil do usuário
└── services/                 # Serviços
    ├── auth_service.dart     # Serviço de autenticação
    ├── firebase_service.dart # Serviço do Firebase
    └── usuario_service.dart  # Serviço do usuário
```

## 🎯 Como Usar

1. **Login**: Faça login com sua conta Google ou crie uma conta
2. **Adicionar Itens**: Toque no botão "+" para adicionar novos itens
3. **Gerenciar**: Edite preços, quantidades e observações
4. **Marcar**: Use o checkbox para marcar itens como comprados
5. **Acompanhar**: Visualize o total e estatísticas no topo da tela

## 🔒 Segurança

- Autenticação obrigatória para acessar dados
- Regras do Firestore configuradas para proteger dados do usuário
- Cada usuário só acessa suas próprias listas

## 📊 Funcionalidades de Preço

- **Preço Unitário**: Defina o valor de cada item
- **Quantidade**: Especifique a quantidade desejada
- **Subtotal**: Calculado automaticamente (preço × quantidade)
- **Total Geral**: Soma de todos os subtotais
- **Formatação**: Suporte para valores decimais (centavos)

## 🎨 Interface

- **Design Material**: Seguindo as diretrizes do Material Design
- **Responsivo**: Adapta-se a diferentes tamanhos de tela
- **Temas**: Suporte a temas claro/escuro
- **Animações**: Transições suaves entre telas

## 🚧 Desenvolvimento

### Estrutura de Commits
- `feat:` Nova funcionalidade
- `fix:` Correção de bug
- `docs:` Documentação
- `style:` Formatação de código
- `refactor:` Refatoração
- `test:` Testes
- `chore:` Tarefas de manutenção

### Branches
- `main` - Código de produção
- `develop` - Desenvolvimento
- `feature/*` - Novas funcionalidades
- `hotfix/*` - Correções urgentes

## 🤝 Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 👨‍💻 Autor

**alvesprotect**
- GitHub: [@railan098](https://github.com/railan098)

## 🙏 Agradecimentos

- Flutter Team pelo framework incrível
- Firebase Team pela infraestrutura robusta
- Comunidade Flutter pela inspiração e suporte

## 📞 Suporte

Se você encontrar algum problema ou tiver sugestões, por favor:
- Abra uma [issue](https://github.com/railan098/listadecompra/issues)
- Entre em contato: contato@alvesprotect.com.br

---

⭐ **Se este projeto te ajudou, considere dar uma estrela!**
