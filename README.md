# 📱 Contador App - Aplicativo de Contadores Inteligentes

Um aplicativo Flutter moderno e elegante para criar e gerenciar múltiplos contadores com funcionalidades avançadas, incluindo cronômetro automático e histórico de logs.

## 🎯 Sobre o Projeto

O **Contador App** é uma aplicação desenvolvida em Flutter que permite aos usuários criar, gerenciar e monitorar múltiplos contadores de forma intuitiva. Ideal para rastreamento de hábitos, contagem de repetições em exercícios, produtividade, ou qualquer situação que necessite contabilizar eventos.

## ✨ Funcionalidades

### 🔢 Gerenciamento de Contadores
- ✅ **Criar múltiplos contadores** com nomes personalizados
- ✅ **Incrementar/Decrementar** valores manualmente
- ✅ **Resetar** contadores para zero
- ✅ **Deletar** contadores com confirmação
- ✅ **Arrastar para deletar** (swipe gesture)

### ⏱️ Cronômetro Automático
- ✅ **Incremento automático** em intervalos regulares
- ✅ **Três velocidades**: 1s, 2s ou 5s
- ✅ **Controles Play/Pause** intuitivos
- ✅ **Mudança de velocidade** em tempo real
- ✅ **Bloqueio de botões** durante execução automática

### 📊 Histórico e Logs
- ✅ **Registro automático** de todas as ações
- ✅ **Visualização cronológica** com data e hora
- ✅ **Logs otimizados** para cronômetro (a cada 10 incrementos)
- ✅ **Interface dedicada** para consultar histórico

### 🎨 Interface e UX
- ✅ **Tema escuro** (Dark Mode)
- ✅ **Animações suaves** em transições
- ✅ **Material Design 3** (Material You)
- ✅ **Feedback visual** para todas as ações
- ✅ **Navegação intuitiva** entre telas

## 🏗️ Arquitetura

### Estrutura de Pastas
```
lib/
├── main.dart                          # Entrada do aplicativo
├── models/
│   └── counter_model.dart            # Modelo de dados do contador
├── storage/
│   └── memory_storage.dart           # Sistema de armazenamento em memória
└── screens/
    ├── home_screen.dart              # Tela principal (lista de contadores)
    ├── counter_detail_screen.dart    # Tela de detalhes e cronômetro
    └── log_screen.dart               # Tela de histórico de logs
```

### Padrões Utilizados
- **Singleton Pattern**: Para gerenciamento de armazenamento
- **StatefulWidget**: Para componentes com estado
- **Future/Async**: Para operações assíncronas
- **Material Design 3**: Para componentes visuais

## 💾 Armazenamento

O aplicativo utiliza **armazenamento em memória** (RAM) através da classe `MemoryStorage`:

```dart
MemoryStorage.instance
  ├── List<CounterModel> _counters  // Lista de contadores
  ├── List<LogEntry> _logs          // Histórico de logs
  ├── Auto-incremento de IDs
  └── Interface assíncrona
```

### ⚠️ Importante
> Os dados são armazenados **apenas em memória** e serão **perdidos ao fechar o app**. Esta abordagem foi escolhida para:
> - Simplicidade de implementação
> - Performance máxima
> - Compatibilidade universal (todas as plataformas)
> - Foco educacional

## 🚀 Como Executar

### Pré-requisitos
- Flutter SDK (versão 3.9.2 ou superior)
- Dart SDK
- Ambiente configurado para desenvolvimento Flutter

### Instalação

1. **Clone o repositório**
```bash
git clone https://github.com/Matheussfreitas/counter-flutter.git
cd contador_app
```

2. **Instale as dependências**
```bash
flutter pub get
```

3. **Execute o aplicativo**

Para Linux:
```bash
flutter run -d linux
```

Para Android:
```bash
flutter run -d android
```

Para iOS:
```bash
flutter run -d ios
```

Para Web:
```bash
flutter run -d chrome
```

### Build para Produção

```bash
# Linux
flutter build linux --release

# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## 📦 Dependências

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8    # Ícones iOS
  intl: ^0.20.2              # Formatação de datas

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0      # Análise de código
```

## 🎮 Como Usar

### 1️⃣ Criar um Contador
1. Na tela inicial, toque no botão **+** (flutuante)
2. Digite um nome para o contador
3. Clique em **Salvar**

### 2️⃣ Usar o Contador
1. **Toque** em um contador para abrir os detalhes
2. Use os botões **+** e **-** para ajustar manualmente
3. Ou use o **cronômetro** para incremento automático

### 3️⃣ Cronômetro Automático
1. Na tela de detalhes do contador
2. Selecione a velocidade (**1s**, **2s** ou **5s**)
3. Clique em **▶️ Play** para iniciar
4. Clique em **⏸️ Pause** para parar

### 4️⃣ Deletar um Contador
- **Opção 1**: Arraste da direita para a esquerda na lista
- **Opção 2**: Abra o contador e clique no ícone de lixeira

### 5️⃣ Ver Histórico
- Toque no ícone **🕐 Histórico** no canto superior direito da tela inicial

## 🎨 Screenshots

### Tela Principal
- Lista de contadores com valores
- Botão flutuante para adicionar
- Ícone de histórico

### Tela de Detalhes
- Valor grande e animado
- Controles do cronômetro
- Botões de incremento/decremento
- Opções de reset e delete

### Tela de Logs
- Histórico cronológico
- Data e hora formatadas
- Ações registradas automaticamente

## 🔧 Desenvolvimento

### Executar Testes
```bash
flutter test
```

### Análise de Código
```bash
flutter analyze
```

### Formatar Código
```bash
flutter format .
```

### Limpar Build
```bash
flutter clean
```

## 🛠️ Tecnologias Utilizadas

- **Flutter** - Framework de desenvolvimento multiplataforma
- **Dart** - Linguagem de programação
- **Material Design 3** - Sistema de design
- **Timer** - Para cronômetro (dart:async)
- **Intl** - Formatação de datas e internacionalização

## 💡 Possíveis Melhorias Futuras

- [ ] Persistência de dados (SharedPreferences, Hive ou SQLite)
- [ ] Categorias de contadores
- [ ] Gráficos e estatísticas
- [ ] Temas personalizáveis
- [ ] Exportação de dados (CSV, JSON)
- [ ] Sincronização na nuvem (Firebase)
- [ ] Notificações para metas
- [ ] Widgets de tela inicial
- [ ] Modo tablet/desktop otimizado
- [ ] Suporte a múltiplos idiomas

## 🤝 Contribuindo

Contribuições são bem-vindas! Sinta-se à vontade para:

1. Fazer fork do projeto
2. Criar uma branch para sua feature (`git checkout -b feature/MinhaFeature`)
3. Commit suas mudanças (`git commit -m 'Adiciona MinhaFeature'`)
4. Push para a branch (`git push origin feature/MinhaFeature`)
5. Abrir um Pull Request

## 📄 Licença

Este projeto é de código aberto e está disponível para fins educacionais.

## 👨‍💻 Autor

**Interas**
- GitHub: [@Matheussfreitas](https://github.com/Matheussfreitas)
- Github: [@GabrielGui13](https://github.com/GabrielGui13)
- Projeto: [counter-flutter](https://github.com/Matheussfreitas/counter-flutter)

## 📞 Suporte

Se você encontrar algum problema ou tiver sugestões, por favor:
- Abra uma [Issue](https://github.com/Matheussfreitas/counter-flutter/issues)
- Entre em contato através do GitHub

---

**Desenvolvido com ❤️ usando Flutter**

*Última atualização: 17 de novembro de 2025*
