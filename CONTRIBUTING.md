# 🤝 Guia de Contribuição

Obrigado por considerar contribuir para o **Contador App**! Este documento fornece diretrizes para contribuir com o projeto.

## 📋 Índice

- [Como Contribuir](#como-contribuir)
- [Reportando Bugs](#reportando-bugs)
- [Sugerindo Melhorias](#sugerindo-melhorias)
- [Processo de Pull Request](#processo-de-pull-request)
- [Padrões de Código](#padrões-de-código)
- [Estrutura de Commits](#estrutura-de-commits)

## 🚀 Como Contribuir

### 1. Fork o Projeto
```bash
# Clique no botão "Fork" no GitHub
# Clone seu fork
git clone https://github.com/SEU_USUARIO/counter-flutter.git
cd contador_app
```

### 2. Crie uma Branch
```bash
# Para nova feature
git checkout -b feature/nome-da-feature

# Para correção de bug
git checkout -b fix/descricao-do-bug

# Para documentação
git checkout -b docs/descricao
```

### 3. Faça suas Alterações
- Escreva código limpo e bem documentado
- Siga os padrões de código do projeto
- Adicione testes se aplicável
- Atualize a documentação se necessário

### 4. Teste suas Alterações
```bash
# Execute os testes
flutter test

# Analise o código
flutter analyze

# Formate o código
flutter format .

# Teste em diferentes plataformas
flutter run -d linux
flutter run -d android
```

### 5. Commit e Push
```bash
git add .
git commit -m "feat: adiciona nova funcionalidade X"
git push origin feature/nome-da-feature
```

### 6. Abra um Pull Request
- Vá para o GitHub
- Clique em "New Pull Request"
- Descreva suas alterações detalhadamente
- Aguarde revisão

## 🐛 Reportando Bugs

### Antes de Reportar
- ✅ Verifique se o bug já foi reportado nas [Issues](https://github.com/Matheussfreitas/counter-flutter/issues)
- ✅ Certifique-se de estar usando a versão mais recente
- ✅ Tente reproduzir o bug

### Como Reportar
Ao criar uma issue, inclua:

**Título claro e descritivo**
```
[BUG] Cronômetro não para ao clicar em pause
```

**Descrição detalhada**
- Passos para reproduzir
- Comportamento esperado
- Comportamento atual
- Screenshots (se aplicável)
- Versão do Flutter
- Plataforma (Linux, Android, etc.)
- Logs de erro

**Exemplo:**
```markdown
## Descrição
O cronômetro continua incrementando mesmo após clicar no botão de pause.

## Passos para Reproduzir
1. Abra um contador
2. Configure velocidade para 1s
3. Clique em Play
4. Clique em Pause
5. Observe que o valor continua aumentando

## Comportamento Esperado
O cronômetro deveria parar imediatamente.

## Ambiente
- Flutter: 3.9.2
- Plataforma: Linux Ubuntu 22.04
- Versão do App: 1.2.0
```

## 💡 Sugerindo Melhorias

### Como Sugerir
Ao sugerir melhorias, inclua:

**Título descritivo**
```
[FEATURE] Adicionar modo escuro/claro manual
```

**Descrição da sugestão**
- Qual problema isso resolve?
- Como funcionaria?
- Benefícios da implementação
- Possíveis alternativas

**Exemplo:**
```markdown
## Descrição
Permitir que o usuário escolha entre tema claro e escuro manualmente.

## Problema
Atualmente o app usa apenas tema escuro, o que pode não agradar todos.

## Solução Proposta
Adicionar um switch nas configurações para alternar entre temas.

## Benefícios
- Maior acessibilidade
- Preferência do usuário
- Uso durante o dia
```

## 🔄 Processo de Pull Request

### Checklist antes de enviar
- [ ] Código funciona corretamente
- [ ] Testes passam (`flutter test`)
- [ ] Análise sem erros (`flutter analyze`)
- [ ] Código formatado (`flutter format .`)
- [ ] Documentação atualizada
- [ ] CHANGELOG.md atualizado (se aplicável)
- [ ] Commits seguem o padrão

### Template de PR
```markdown
## Descrição
Breve descrição das mudanças

## Tipo de Mudança
- [ ] 🐛 Bug fix
- [ ] ✨ Nova feature
- [ ] 📝 Documentação
- [ ] 🎨 Estilo/UI
- [ ] ♻️ Refatoração
- [ ] ⚡ Performance

## Mudanças Realizadas
- Mudança 1
- Mudança 2
- Mudança 3

## Como Testar
1. Passo 1
2. Passo 2
3. Resultado esperado

## Screenshots (se aplicável)
[Adicione imagens aqui]

## Checklist
- [ ] Código testado
- [ ] Documentação atualizada
- [ ] Sem warnings
- [ ] Commits limpos
```

## 📝 Padrões de Código

### Dart/Flutter Guidelines
Siga as [Effective Dart Guidelines](https://dart.dev/guides/language/effective-dart):

```dart
// ✅ BOM - Nome descritivo e clara
class CounterModel {
  final int id;
  final String name;
  
  CounterModel({required this.id, required this.name});
}

// ❌ RUIM - Nomes confusos
class CM {
  var i, n;
}
```

### Nomenclatura
- **Classes:** PascalCase (`CounterModel`, `HomeScreen`)
- **Variáveis/Funções:** camelCase (`_counter`, `incrementValue`)
- **Constantes:** lowerCamelCase com const (`const maxValue`)
- **Arquivos:** snake_case (`counter_model.dart`)

### Estrutura de Arquivos
```dart
import 'dart:async';                    // 1. Imports do Dart
import 'package:flutter/material.dart'; // 2. Imports do Flutter
import 'package:intl/intl.dart';        // 3. Imports de packages
import '../models/counter_model.dart';  // 4. Imports locais

// 5. Classe principal
class MyWidget extends StatefulWidget { }

// 6. State
class _MyWidgetState extends State<MyWidget> { }
```

### Comentários
```dart
// ✅ BOM - Comentário útil
// Cancela o timer ao sair da tela para evitar memory leaks
@override
void dispose() {
  _timer?.cancel();
  super.dispose();
}

// ❌ RUIM - Comentário óbvio
// Incrementa o valor
value++;
```

## 🎯 Estrutura de Commits

Siga o padrão [Conventional Commits](https://www.conventionalcommits.org/):

### Formato
```
tipo(escopo): descrição curta

Descrição longa (opcional)

Rodapé (opcional)
```

### Tipos
- `feat`: Nova funcionalidade
- `fix`: Correção de bug
- `docs`: Documentação
- `style`: Formatação, ponto e vírgula, etc
- `refactor`: Refatoração de código
- `test`: Adição de testes
- `chore`: Manutenção, configs, etc
- `perf`: Melhoria de performance

### Exemplos
```bash
# Feature
git commit -m "feat: adiciona cronômetro automático"

# Bug fix
git commit -m "fix: corrige problema ao pausar cronômetro"

# Documentação
git commit -m "docs: atualiza README com instruções de instalação"

# Refatoração
git commit -m "refactor: simplifica lógica de incremento"

# Com escopo
git commit -m "feat(cronometro): adiciona seletor de velocidade"

# Com descrição longa
git commit -m "feat: adiciona modo persistência

Implementa armazenamento com SharedPreferences
para manter dados após fechar o app.

Closes #123"
```

## 🧪 Testes

### Escrever Testes
```dart
// test/counter_model_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:contador_app/models/counter_model.dart';

void main() {
  group('CounterModel', () {
    test('deve criar contador com valores corretos', () {
      final counter = CounterModel(id: 1, name: 'Test', value: 0);
      
      expect(counter.id, 1);
      expect(counter.name, 'Test');
      expect(counter.value, 0);
    });
  });
}
```

### Executar Testes
```bash
flutter test
flutter test --coverage
```

## 📚 Recursos Úteis

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Material Design 3](https://m3.material.io/)
- [Git Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows)

## ❓ Dúvidas?

Se tiver dúvidas sobre como contribuir:
- 📧 Abra uma [Discussion](https://github.com/Matheussfreitas/counter-flutter/discussions)
- 💬 Comente em uma Issue existente
- 📖 Consulte a documentação do projeto

## 🙏 Agradecimentos

Agradecemos a todos que contribuírem para tornar este projeto melhor! 

Toda contribuição é valiosa, seja:
- 🐛 Reportando bugs
- 💡 Sugerindo features
- 📝 Melhorando documentação
- 💻 Contribuindo com código
- ⭐ Dando uma estrela no projeto

---

**Obrigado por contribuir!** 🎉
