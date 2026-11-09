---
ia-translate: true
title: Estruture apps com herança e classes abstratas
shortTitle: Herança e abstração
description: >-
  Aprenda sobre herança, classes abstratas, sobrescrita de métodos e
  encapsulamento em Dart. Construa um framework extensível para apps CLI.
layout: learn
---

Este capítulo se baseia nas classes criadas na lição anterior, explorando
herança e classes abstratas em Dart.
Aprenda como compartilhar comportamento entre classes usando
[herança][inheritance], definir contratos usando
[classes abstratas][abstract classes] e
proteger o estado interno com [encapsulamento][encapsulation].

<SummaryCard>
title: O que você vai realizar
items:
  - title: Projetar e entender classes abstratas
    icon: schema
  - title: Estender classes pai e sobrescrever métodos
    icon: account_tree
  - title: Proteger o estado interno com encapsulamento
    icon: lock
  - title: Construir um framework extensível de executor de comandos
    icon: terminal
</SummaryCard>

## Pré-requisitos {:#prerequisites}

Antes de começar este capítulo:

- Conclua o Capítulo 5 e tenha um
  ambiente de desenvolvimento Dart funcionando com o projeto `dartpedia`.
- Entenda conceitos básicos de orientação a objetos em Dart,
  como definir classes, construtores, campos e getters.
- Entenda pacotes e bibliotecas em Dart.

## Classes abstratas e herança {:#abstract-classes-and-inheritance}

No Dart, uma **classe abstrata** é uma classe que não pode ser instanciada
diretamente (chamar `CliElement()` causa um erro de compilação).
Em vez disso, ela serve como um molde ou contrato que outras classes estendem.

Em uma CLI, opções (`--verbose`) e comandos (`help`) compartilham
características comuns, como um nome e uma descrição de ajuda,
mas um "elemento de CLI" genérico não faz sentido por si só.
Declarar `CliElement` e `Command` como **abstratas** garante que o código
só instancie classes específicas, como `Option` e `HelpCommand`.

```
       ┌──────────────┐
       │  CliElement  │ (abstract: blueprint for all CLI elements)
       └──────┬───────┘
              │
      ┌───────┴───────┐
      ▼               ▼
┌───────────┐   ┌───────────┐
│  Option   │   │  Command  │ (abstract: blueprint for commands)
└───────────┘   └─────┬─────┘
                      │
                      ▼
               ┌─────────────┐
               │ HelpCommand │ (can be instantiated and run)
               └─────────────┘
```

### Compartilhe comportamento com herança {:#share-behavior-with-inheritance}

**Herança** permite que uma classe adote
propriedades e comportamentos de uma classe pai.
Como tanto as opções (`Option`) quanto os comandos (`Command`) compartilham um `name`,
um texto de `help` e uma mensagem formatada de `usage`,
herdar de um pai `CliElement` comum elimina código duplicado
em várias classes.

A herança também possibilita o **polimorfismo**: a capacidade de o executor de comandos
tratar qualquer comando ou opção de forma uniforme
pela interface compartilhada `CliElement`.

## Tarefas {:#tasks}

No Capítulo 5, as classes `Option` e `ArgResults` estabeleceram
estruturas de dados básicas para opções de CLI e a saída analisada.
Este capítulo estabelece uma hierarquia compartilhada entre comandos e opções,
e expande o `CommandRunner` provisório do Capítulo 4 para
um analisador de comandos completo.

As classes e a lógica das tarefas a seguir
criam a base para analisar e executar os comandos da CLI.

### Tarefa 1: Defina a classe abstrata CliElement e atualize Option {:#task-1-define-the-clielement-abstract-class-and-update-option}

Tanto as opções quanto os comandos compartilham atributos centrais, como `name`,
o texto de `help` e uma string formatada de `usage`.
Definir uma classe base abstrata estabelece um único contrato para ambos.

1.  Abra `command_runner/lib/src/arguments.dart`.

1.  Defina uma `abstract class` chamada `CliElement` logo abaixo do enum `OptionType`:

    ```dart title="command_runner/lib/src/arguments.dart"
    abstract class CliElement {
      String get name;
      String? get help;

      // In the case of flags, the default value is a bool.
      // In other options and commands, the default value is a String.
      // NB: flags are just Option objects that don't take arguments
      Object? get defaultValue;
      String? get valueHelp;

      String get usage;
    }
    ```

    A palavra-chave `abstract` marca `CliElement` como uma classe base que não pode
    ser instanciada diretamente (`CliElement()`).
    Getters sem corpo (`String get name;`) definem propriedades obrigatórias
    que toda subclasse precisa implementar.
    O getter `defaultValue` usa o tipo `Object?` para poder retornar tanto um
    `bool` (para flags) quanto uma `String` (para opções que aceitam valores).

1.  Atualize a classe `Option` para estender `CliElement`:

    ```dart title="command_runner/lib/src/arguments.dart"
    class Option extends CliElement {
      Option(
        this.name, {
        required this.type,
        this.help,
        this.abbr,
        this.defaultValue,
        this.valueHelp,
      });

      @override
      final String name;

      final OptionType type;

      @override
      final String? help;

      final String? abbr;

      @override
      final Object? defaultValue;

      @override
      final String? valueHelp;

      @override
      String get usage {
        if (abbr != null) {
          return '-$abbr,--$name: $help';
        }

        return '--$name: $help';
      }
    }
    ```

    A palavra-chave `extends` estabelece uma relação de herança em que `Option`
    passa a ser um subtipo de `CliElement`.
    No Dart, todo campo tem um getter implícito.
    Declarar `@override final String name;` satisfaz o getter abstrato
    `String get name;` declarado em `CliElement`.
    Os campos `abbr` e `type` continuam específicos de `Option`.

### Tarefa 2: Defina a classe abstrata Command {:#task-2-define-the-command-abstract-class}

Comandos representam ações que os usuários podem executar, como `help` ou `search`.
Como os comandos compartilham propriedades com `Option` (como `name` e `usage`),
eles também estendem `CliElement`.

1.  Adicione os imports necessários no topo de `command_runner/lib/src/arguments.dart`:

    ```dart title="command_runner/lib/src/arguments.dart"
    import 'dart:async';
    import 'dart:collection';
    import 'command_runner_base.dart';
    ```

1.  Comece definindo a classe abstrata central `Command`
    com suas propriedades e a referência ao executor:

    ```dart title="command_runner/lib/src/arguments.dart"
    abstract class Command extends CliElement {
      @override
      String get name;

      String get description;

      bool get requiresArgument => false;

      late CommandRunner runner;

      @override
      String? help;

      @override
      String? defaultValue;

      @override
      String? valueHelp;
    }
    ```

    - **`abstract class Command extends CliElement`**:
      Estabelece `Command` como um subtipo abstrato de `CliElement`,
      servindo de modelo para que todos os comandos específicos sigam.
    - **`late CommandRunner runner;`**:
      Um comando precisa de uma referência ao `CommandRunner` que o executa,
      para acessar o estado global do executor.
      A palavra-chave `late` promete ao Dart que essa variável não nula
      será atribuída antes de ser lida
      (ao registrar o comando com `command.runner = this;`).

1.  Em seguida, adicione o armazenamento encapsulado de opções e os métodos auxiliares em `Command`:

    ```dart title="command_runner/lib/src/arguments.dart"
    abstract class Command extends CliElement {
      // ... existing properties ...

      final List<Option> _options = [];

      UnmodifiableSetView<Option> get options =>
          UnmodifiableSetView(_options.toSet());

      void addFlag(
        String name, {
        String? help,
        String? abbr,
        String? valueHelp,
      }) {
        _options.add(
          Option(
            name,
            help: help,
            abbr: abbr,
            defaultValue: false,
            valueHelp: valueHelp,
            type: OptionType.flag,
          ),
        );
      }

      void addOption(
        String name, {
        String? help,
        String? abbr,
        String? defaultValue,
        String? valueHelp,
      }) {
        _options.add(
          Option(
            name,
            help: help,
            abbr: abbr,
            defaultValue: defaultValue,
            valueHelp: valueHelp,
            type: OptionType.option,
          ),
        );
      }
    }
    ```

    - **Encapsulamento com `_options`**:
      Prefixar `_options` com um sublinhado (`_`) o torna privado da biblioteca,
      impedindo que código fora de `arguments.dart` modifique a lista diretamente.
    - **`UnmodifiableSetView`**:
      Expõe uma visualização somente leitura das opções do comando,
      garantindo que quem chama não consiga alterar o estado interno diretamente.
    - **`addFlag` e `addOption`**:
      Fornecem métodos controlados para criar e registrar instâncias válidas de `Option`
      no comando.

1.  Por fim, adicione o método abstrato `run` e
    o getter `usage` para completar `Command`:

    ```dart title="command_runner/lib/src/arguments.dart"
    abstract class Command extends CliElement {
      // ... existing properties and helper methods ...

      FutureOr<Object?> run(ArgResults args);

      @override
      String get usage {
        return '$name:  $description';
      }
    }
    ```

    - **`FutureOr<Object?> run(...)`**:
      Define o método abstrato onde fica a lógica de execução de um comando.
      `FutureOr` permite que o método retorne tanto um valor síncrono direto
      quanto um `Future`, para operações assíncronas (retomando o Capítulo 3).
    - **Getter `usage`**:
      Formata o nome e a descrição do comando para a saída de ajuda da CLI.

1.  Atualize a classe `ArgResults`, no final de
    `command_runner/lib/src/arguments.dart`, para referenciar `Command`:

    ```dart title="command_runner/lib/src/arguments.dart"
    class ArgResults {
      Command? command;
      String? commandArg;
      Map<Option, Object?> options = {};

      // ... existing flag, hasOption, and getOption methods ...
    }
    ```

    No Capítulo 5, `ArgResults.command` era um `String?`, pois `Command` ainda não existia.
    Agora que `Command` existe, mudar o tipo para `Command?` permite que o
    executor de comandos armazene e execute diretamente o objeto `Command` resolvido.

### Tarefa 3: Atualize a classe CommandRunner {:#task-3-update-the-commandrunner-class}

O Capítulo 4 criou um `CommandRunner` provisório em
`command_runner/lib/src/command_runner_base.dart`
que apenas imprimia os argumentos.
Agora, substitua esse provisório pelo coordenador de comandos de verdade.

1.  Abra `command_runner/lib/src/command_runner_base.dart`.

1.  Substitua o conteúdo do arquivo pelo seguinte código:

    ```dart title="command_runner/lib/src/command_runner_base.dart"
    import 'dart:collection';
    import 'dart:io';
    import 'arguments.dart';

    class CommandRunner {
      final Map<String, Command> _commands = <String, Command>{};

      UnmodifiableSetView<Command> get commands =>
          UnmodifiableSetView<Command>(<Command>{..._commands.values});

      Future<void> run(List<String> input) async {
        final ArgResults results = parse(input);
        if (results.command != null) {
          Object? output = await results.command!.run(results);
          print(output.toString());
        }
      }

      void addCommand(Command command) {
        _commands[command.name] = command;
        command.runner = this;
      }

      ArgResults parse(List<String> input) {
        var results = ArgResults();
        results.command = _commands[input.first];
        return results;
      }

      String get usage {
        final exeFile = Platform.script.path.split('/').last;
        return 'Usage: dart bin/$exeFile <command> [commandArg?] [...options?]';
      }
    }
    ```

    Destaques do código anterior:

    - **Operador spread (`..._commands.values`)**:
      Desempacota os valores do mapa privado `_commands` em um novo conjunto,
      impedindo que quem chama modifique o mapa original.
    - **`command.runner = this;`**:
      Atribui a instância do executor ao comando no momento do registro,
      cumprindo a promessa feita pela palavra-chave `late` em `Command`.
    - **Operador de asserção nula (`!`)**:
      Em `results.command!.run(results)`, o `!` afirma que `command`
      não é nulo, por causa da verificação `if (results.command != null)` anterior.

1.  Abra `command_runner/lib/command_runner.dart` e atualize as exportações:

    ```dart title="command_runner/lib/command_runner.dart"
    /// Support for command-line parsing and execution.
    library;

    export 'src/arguments.dart';
    export 'src/command_runner_base.dart';
    export 'src/help_command.dart';
    ```

    Essas declarações `export` tornam `arguments.dart`,
    `command_runner_base.dart` e `help_command.dart`
    parte da API pública do pacote `command_runner`.

### Tarefa 4: Crie um HelpCommand {:#task-4-create-a-helpcommand}

Crie um `HelpCommand` que estende `Command` e imprime as informações de uso.

1.  Crie `command_runner/lib/src/help_command.dart`.

1.  Adicione o seguinte código:

    ```dart title="command_runner/lib/src/help_command.dart"
    import 'dart:async';
    import 'arguments.dart';

    class HelpCommand extends Command {
      HelpCommand() {
        addFlag(
          'verbose',
          abbr: 'v',
          help: 'When true, prints each command and its options.',
        );
        addOption(
          'command',
          abbr: 'c',
          help: 'Prints verbose usage for the specified command.',
        );
      }

      @override
      String get name => 'help';

      @override
      String get description => 'Prints usage information to the command line.';

      @override
      String? get help => 'Prints this usage information';

      @override
      FutureOr<Object?> run(ArgResults args) async {
        var usage = runner.usage;
        for (var command in runner.commands) {
          usage += '\n ${command.usage}';
        }

        return usage;
      }
    }
    ```

    O construtor de `HelpCommand` chama os métodos auxiliares herdados `addFlag` e
    `addOption` para configurar as opções suportadas.
    O método `run` lê `runner.usage` e percorre `runner.commands`
    para montar e retornar dinamicamente a mensagem completa de uso da CLI.

### Tarefa 5: Atualize o cli.dart para usar o CommandRunner {:#task-5-update-cli-dart-to-use-commandrunner}

Conecte o `CommandRunner` e o `HelpCommand` no ponto de entrada executável.

1.  Abra `cli/bin/cli.dart`.

1.  Substitua o conteúdo do arquivo pelo seguinte código:

    ```dart title="cli/bin/cli.dart"
    import 'package:command_runner/command_runner.dart';

    const version = '0.0.1';

    void main(List<String> arguments) {
      var commandRunner = CommandRunner()..addCommand(HelpCommand());
      commandRunner.run(arguments);
    }
    ```

    A notação em cascata `..addCommand(...)` chama `addCommand` no
    `CommandRunner` recém-criado e retorna essa mesma instância,
    permitindo encadear métodos de forma concisa antes de passar `arguments` para `run()`.

### Tarefa 6: Execute o aplicativo {:#task-6-run-the-application}

Teste o `CommandRunner` e o `HelpCommand`.

1.  No diretório `cli`, execute:

    ```bash
    dart run bin/cli.dart help
    ```

    O console mostra:

    ```bash
    Usage: dart bin/cli.dart <command> [commandArg?] [...options?]
     help:  Prints usage information to the command line.
    ```

    Isso confirma que o `CommandRunner` direciona a execução para o `HelpCommand`
    e imprime a saída de uso esperada.

    :::note
    Sempre forneça um argumento de comando (como `help`) ao executar esta etapa.
    O Capítulo 7 apresenta o tratamento de erros para lidar com entradas vazias ou
    inválidas de forma adequada.
    :::

## Revisão {:#review}

<SummaryCard>
title: O que você realizou
subtitle: Um resumo dos conceitos e do código introduzidos nesta lição.
completed: true
items:
  - title: Projetou e entendeu classes abstratas
    icon: schema
    details: >-
      Criou as classes abstratas `CliElement` e `Command` como contratos base
      que não podem ser instanciados diretamente.
  - title: Estendeu classes pai e sobrescreveu métodos
    icon: account_tree
    details: >-
      Usou `extends` para criar os subtipos `Option`, `Command` e `HelpCommand`,
      usando `@override` para fornecer as implementações obrigatórias.
  - title: Protegeu o estado interno com encapsulamento
    icon: lock
    details: >-
      Armazenou as opções em listas privadas (`_options`, `_commands`) e as expôs
      por meio de `UnmodifiableSetView`, para evitar modificações indesejadas.
  - title: Construiu um framework extensível de executor de comandos
    icon: terminal
    details: >-
      Aplicou princípios de orientação a objetos para implementar um framework
      de CLI polimórfico, capaz de despachar comandos dinamicamente.
</SummaryCard>

## Quiz {:#quiz}

<Quiz title="Confira seu entendimento" id="inheritance" />

## Próxima lição {:#next-lesson}

O próximo capítulo aborda o tratamento de erros e exceções em Dart.
Você vai criar uma classe de exceção personalizada e
adicionar tratamento de erros ao `CommandRunner` para tornar a aplicação mais robusta.

[inheritance]: /language/extend
[abstract classes]: /language/class-modifiers#abstract
[encapsulation]: /resources/glossary#library-private
