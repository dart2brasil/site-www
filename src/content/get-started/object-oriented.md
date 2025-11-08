---
ia-translate: true
title: "Programação orientada a objetos em Dart"
shortTitle: Dart orientado a objetos
description: "Aprenda sobre programação orientada a objetos em Dart, incluindo classes abstract, herança, overrides e enums. Construa um framework para aplicativos CLI bem arquitetados."
sitemap: false
noindex: true
layout: learn
prevpage:
  url: /get-started/packages-libs
  title: Packages and libraries
nextpage:
  url: /get-started/error-handling
  title: Error handling
---

{% render 'fwe-wip-warning.md', site: site %}

Neste capítulo, você explorará o poder da programação orientada a objetos (OOP)
em Dart. Você aprenderá como criar classes e definir relacionamentos entre
elas, incluindo **herança** e **classes abstract**. Você também construirá uma
base para criar aplicativos CLI bem estruturados.

:::secondary O que você aprenderá

* Entender classes `abstract` e seus casos de uso.
* Implementar herança usando a keyword `extends` e fazer override de métodos.
* Usar `FutureOr` para funções que podem retornar um valor de forma síncrona ou
  assíncrona.
* Definir e usar tipos `enum` para representar um conjunto fixo de valores.

:::

## Pré-requisitos

Antes de começar este capítulo, certifique-se de:

* Ter completado o Capítulo 4 e ter um ambiente de desenvolvimento Dart funcional com
  o projeto `dartpedia`.
* Estar familiarizado com conceitos básicos de programação como
  variáveis, funções e fluxo de controle.
* Entender os conceitos de packages e libraries em Dart.

## Tarefas

Uma interface de linha de comando (CLI) é definida pelos comandos, opções e
argumentos que um usuário pode digitar em seu terminal.

Ao final desta lição, você terá construído um framework que pode
entender um comando como este:

```bash
$ dartpedia help --verbose --command=search
```

Aqui está um detalhamento de cada parte:

* `dartpedia`: Este é o **executável**, o nome do seu aplicativo.
* `help`: Este é um **comando**, uma ação que você deseja que o aplicativo execute.
* `--verbose`: Este é uma **flag** (um tipo de opção que não recebe um valor),
  que modifica o comportamento do comando.
* `--command=search`: Esta é uma **opção** que recebe um valor. Aqui, a
  `option` é chamada `command`, e seu valor é `search`.

As classes e a lógica que você construir nas tarefas a seguir criam a base para
analisar e executar comandos exatamente como este.

### Tarefa 1: Definir a hierarquia de argumentos

Primeiro, você definirá uma classe `Argument`, uma classe `Option` e uma
classe `Command`, estabelecendo uma relação de herança.

1.  Crie o arquivo `command_runner/lib/src/arguments.dart`. Este arquivo conterá
    as definições para suas classes `Argument`, `Option`, `Command` e
    `ArgResults`.

2.  Defina um `enum` chamado `OptionType`.

    ```dart title="command_runner/lib/src/arguments.dart"
    enum OptionType { flag, option }
    ```

    Este `enum` representa o tipo de opção, que pode ser uma **`flag`**
    (uma opção booleana) ou uma **`option`** regular (uma opção que recebe um valor).
    Enums são úteis para representar um conjunto fixo de valores possíveis.

3.  Defina uma `abstract class` chamada `Argument`.

    Comece definindo a estrutura básica da sua classe `Argument`. Você a
    declarará como `abstract`, o que significa que ela serve como um modelo que outras
    classes podem estender, mas não pode ser instanciada sozinha.

    Abaixo do `enum` que você acabou de adicionar, cole o seguinte código:

    ```dart title="command_runner/lib/src/arguments.dart"
    // Paste this new class below the enum you added
    abstract class Argument {
      String get name;
      String? get help;

      // In the case of flags, the default value is a bool
      // In other options and commands, the default value is String
      // NB: flags are just Option objects that don't take arguments
      Object? get defaultValue;
      String? get valueHelp;

      String get usage;
    }
    ```

    * **`name`** é uma `String` que identifica exclusivamente o argumento.
    * **`help`** é uma `String` opcional que fornece uma descrição.
    * **`defaultValue`** é do tipo `Object?` porque pode ser um `bool` (para
      flags) ou uma `String`.
    * **`valueHelp`** é uma `String` opcional para dar uma dica sobre o valor
      esperado.
    * O getter **`usage`** fornecerá uma string mostrando como usar o
      argumento.

    Com a classe `Argument` totalmente definida, você tem uma interface comum para todos os
    tipos de argumentos de linha de comando. Em seguida, você construirá sobre isso definindo
    `Option`, um tipo específico de argumento que estende `Argument`.

4.  Defina uma classe chamada `Option` que `extends` `Argument`.

    A classe `Option` representará opções de linha de comando como `--verbose` ou
    `--output=file.txt`. Ela herdará da sua classe `Argument`.

    Adicione a seguinte classe `Option` ao final do seu arquivo:

    ```dart title="command_runner/lib/src/arguments.dart"
    class Option extends Argument {
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

    A keyword **`extends`** estabelece a relação de herança. O
    construtor usa `@override` para fornecer implementações concretas para as
    propriedades definidas em `Argument`. Ele também adiciona `type` (usando o
    `enum` `OptionType`) e um `abbr` opcional para uma forma abreviada da opção.
    O getter `usage` é implementado para fornecer instruções claras ao usuário.

    Com `Option` completa, você tem um tipo especializado de argumento. Em seguida,
    você definirá a classe `Command`, outro tipo de argumento que
    representará as ações principais que um usuário pode executar em seu aplicativo CLI.

5.  Defina uma `abstract class` chamada `Command` que também `extends` `Argument`.

    A classe `Command` representará uma ação executável. Como ela fornece um
    modelo para outros comandos seguirem, você a declarará como **`abstract`**.

    ```dart title="command_runner/lib/src/arguments.dart"
    // Add this class below the Option class
    abstract class Command extends Argument {
      // Properties and methods will go here
    }
    ```

    A keyword **`abstract`** significa que `Command` não pode ser instanciada
    diretamente. Ela serve como um modelo para outras classes.

    Agora, adicione as propriedades principais. Um comando precisa de um `name` e
    `description`. Ele também precisa de uma referência de volta ao `CommandRunner` que
    o executa.

    ```dart title="command_runner/lib/src/arguments.dart"
    abstract class Command extends Argument {
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

    A propriedade `runner` é do tipo `CommandRunner`, que você definirá
    posteriormente em `command_runner_base.dart`. Para tornar o Dart ciente desta classe,
    você deve importar seu arquivo de definição. Adicione a seguinte importação ao topo de
    `command_runner/lib/src/arguments.dart`:

    ```dart
    import '../command_runner.dart';
    ```

    Em seguida, para dar aos comandos seu próprio conjunto de opções, você usará uma lista privada
    e exporá uma visualização **não modificável** somente leitura dela. Isso usa a
    classe `UnmodifiableSetView`, que faz parte da biblioteca de coleção principal
    do Dart. Para usá-la, você deve importar essa biblioteca.

    Atualize as importações no topo do seu arquivo para incluir `dart:collection`:

    ```dart
    import 'dart:collection'; // New import
    import '../command_runner.dart';
    ```

    Agora, adicione a lista `options` e o getter à sua classe `Command`:

    ```dart
    abstract class Command extends Argument {
      // ... existing properties ...

      @override
      String? valueHelp;


      // Add the following lines to the bottom of your Command class:

      final List<Option> _options = [];

      UnmodifiableSetView<Option> get options =>
          UnmodifiableSetView(_options.toSet());
    }
    ```

    Para facilitar a adição de opções, forneceremos dois métodos auxiliares, `addFlag`
    e `addOption`.

    ```dart
    abstract class Command extends Argument {
      // ... existing properties and getters ...

      UnmodifiableSetView<Option> get options =>
          UnmodifiableSetView(_options.toSet());


      // Add the following lines to the bottom of your Command class:

      // A flag is an [Option] that's treated as a boolean.
      void addFlag(String name, {String? help, String? abbr, String? valueHelp}) {
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

      // An option is an [Option] that takes a value.
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

    Finalmente, cada comando deve ter lógica para executar. O método `run` deve
    ser flexível, permitindo retornar um valor imediatamente
    (de forma síncrona) ou após um atraso (de forma assíncrona). O tipo `FutureOr<Object?>`
    da biblioteca `async` do Dart atende a esse propósito. Isso significa que o método
    deve retornar um valor (de qualquer tipo ou `null`) de forma síncrona ou
    assíncrona. Esta é sua importação final necessária.

    Atualize as importações no topo do seu arquivo para incluir `dart:async`:

    ```dart
    import 'dart:async'; // New import
    import 'dart:collection';
    import '../command_runner.dart';
    ```

    Agora você pode adicionar o método `run` abstrato e fornecer a implementação de `usage`
    para completar a classe `Command`.

    ```dart
    abstract class Command extends Argument {
      // ... existing properties, getters, and methods ...

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


      // Add the following lines to the bottom of your Command class:
      FutureOr<Object?> run(ArgResults args);

      @override
      String get usage {
        return '$name:  $description';
      }
    }
    ```

    * **`run(ArgResults args)`**: Este método abstrato é onde a
      lógica de um comando reside. Subclasses concretas *devem* implementá-lo.
    * **`usage`**: Este getter fornece uma string de uso simples,
      combinando o `name` e `description` do comando.

    A classe `Command` agora fornece uma base robusta para todos os comandos em
    seu aplicativo CLI. Com a hierarquia de classes estabelecida, você está pronto para definir
    `ArgResults` para conter a entrada analisada.

6.  Defina uma classe chamada `ArgResults`.

    ```dart title="command_runner/lib/src/arguments.dart"
    // Add this class to the end of the file
    class ArgResults {
      Command? command;
      String? commandArg;
      Map<Option, Object?> options = {};

      // Returns true if the flag exists.
      bool flag(String name) {
        // Only check flags, because we're sure that flags are booleans.
        for (var option in options.keys.where(
          (option) => option.type == OptionType.flag,
        )) {
          if (option.name == name) {
            return options[option] as bool;
          }
        }
        return false;
      }

      bool hasOption(String name) {
        return options.keys.any((option) => option.name == name);
      }

      ({Option option, Object? input}) getOption(String name) {
        var mapEntry = options.entries.firstWhere(
          (entry) => entry.key.name == name || entry.key.abbr == name,
        );

        return (option: mapEntry.key, input: mapEntry.value);
      }
    }
    ```

    Esta classe representa os resultados da análise de argumentos de linha de comando. Ela
    contém o comando detectado, qualquer argumento para esse comando e um mapa de
    opções. Ela também fornece métodos auxiliares convenientes como `flag`,
    `hasOption` e `getOption`.

    Agora você definiu a estrutura básica para lidar com comandos, argumentos e
    opções em seu aplicativo de linha de comando.

### Tarefa 2: Atualizar a classe CommandRunner

Em seguida, atualize a classe `CommandRunner` para usar a nova hierarquia `Argument`.

1.  Abra o arquivo `command_runner/lib/src/command_runner_base.dart`.

2.  Substitua a classe `CommandRunner` existente pelo seguinte:

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
        // TODO: handle error (Command's can't have names that conflict)
        _commands[command.name] = command;
        command.runner = this;
      }

      ArgResults parse(List<String> input) {
        var results = ArgResults();
        results.command = _commands[input.first];
        return results;
      }

      // Returns usage for the executable only.
      // Should be overridden if you aren't using [HelpCommand]
      // or another means of printing usage.

      String get usage {
        final exeFile = Platform.script.path.split('/').last;
        return 'Usage: dart bin/$exeFile <command> [commandArg?] [...options?]';
      }
    }
    ```

    Esta classe `CommandRunner` atualizada agora usa a classe `Command` da
    hierarquia `Argument`. Ela inclui métodos para adicionar comandos, analisar
    argumentos e executar o comando apropriado com base na entrada do usuário.

3.  Abra `command_runner/lib/command_runner.dart`, e adicione os seguintes
    exports:

    ```dart title="command_runner/lib/command_runner.dart"
    /// Support for doing something awesome.
    ///
    /// More dartdocs go here.
    library;

    export 'src/arguments.dart';
    export 'src/command_runner_base.dart';
    export 'src/help_command.dart';

    // TODO: Export any libraries intended for clients of this package.
    ```

    Isso torna os arquivos `arguments.dart`, `command_runner_base.dart` e
    `help_command.dart` disponíveis para outros packages que dependem do
    `command_runner`.

### Tarefa 3: Criar um HelpCommand

Crie um `HelpCommand` que estende a classe `Command` e imprime informações de uso.

1.  Crie o arquivo `command_runner/lib/src/help_command.dart`.

2.  Adicione o seguinte código a `command_runner/lib/src/help_command.dart`:

    ```dart title="command_runner/lib/src/help_command.dart"
    import 'dart:async';

    import 'arguments.dart';

    // Prints program and argument usage.
    //
    // When given a command as an argument, it prints the usage of
    // that command only, including its options and other details.
    // When the flag 'verbose' is set, it prints options and details for all commands.
    //
    // This command isn't automatically added to CommandRunner instances.
    // Packages users should add it themselves with [CommandRunner.addCommand],
    // or create their own command that prints usage.

    class HelpCommand extends Command {
      HelpCommand() {
        addFlag(
          'verbose',
          abbr: 'v',
          help: 'When true, this command will print each command and its options.',
        );
        addOption(
          'command',
          abbr: 'c',
          help:
              "When a command is passed as an argument, prints only that command's verbose usage.",
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

    Esta classe `HelpCommand` estende `Command` e implementa o método `run`
    para imprimir informações de uso. Ela também usa os métodos `addFlag` e `addOption`
    para definir suas próprias opções para controlar a saída.

### Tarefa 4: Atualizar cli.dart para usar o novo CommandRunner

Modifique `cli/bin/cli.dart` para usar o novo `CommandRunner` e `HelpCommand`.

1.  Abra o arquivo `cli/bin/cli.dart`.

2.  Substitua o código existente pelo seguinte:

    ```dart title="cli/bin/cli.dart"
    import 'package:command_runner/command_runner.dart';

    const version = '0.0.1';

    void main(List<String> arguments) {
      var commandRunner = CommandRunner()..addCommand(HelpCommand());
      commandRunner.run(arguments);
    }
    ```

    Este código cria uma instância `CommandRunner`, adiciona o `HelpCommand` a ela
    usando cascata de métodos (`..addCommand`), e então executa o command runner
    com os argumentos de linha de comando.

### Tarefa 5: Executar o aplicativo

Teste o novo `CommandRunner` e `HelpCommand`.

1.  Abra seu terminal e navegue até o diretório `cli`.

2.  Execute o comando `dart run bin/cli.dart help`.

    Você deve ver as informações de uso impressas no console:

    ```bash
    Usage: dart bin/cli.dart <command> [commandArg?] [...options?]
     help:  Prints usage information to the command line.
    ```

    Isso confirma que o `CommandRunner` e `HelpCommand` estão funcionando
    corretamente.

## Revisão

Nesta lição, você aprendeu sobre:

* Definir classes **`abstract`** para criar uma hierarquia de tipos.
* Implementar herança usando a keyword **`extends`**.
* Definir e usar tipos **`enum`** para representar um conjunto fixo de valores.
* Construir um framework básico de análise de argumentos de linha de comando usando princípios de OOP.

## Quiz

**Pergunta 1:** Na classe `Option`, qual é o propósito da
  notação `@override`?

* A) Para criar um novo método que não existe na classe pai.
* B) Para indicar que um método é opcional.
* C) Para fornecer uma implementação específica para um método ou propriedade definida em uma
  classe pai.
* D) Para tornar uma propriedade privada.

**Pergunta 2:** Qual é a diferença entre uma classe `abstract` e uma classe
regular em Dart?

* A) Uma classe `abstract` não pode ter nenhum método.
* B) Uma classe `abstract` não pode ser instanciada diretamente.
* C) Uma classe `abstract` só pode ter métodos privados.
* D) Não há diferença entre uma classe `abstract` e uma classe regular.

**Pergunta 3:** No guia, para que foi usado o `enum OptionType`?

* A) Para definir os diferentes tipos de comandos.
* B) Para representar um conjunto fixo de tipos de opção: `flag` e `option`.
* C) Para armazenar os valores padrão para opções.
* D) Para controlar a cor da saída da linha de comando.

## Próxima lição

Na próxima lição, você aprenderá como lidar com erros e exceções em seu
código Dart. Você criará uma classe de exceção personalizada e adicionará tratamento de erros ao seu
`CommandRunner` para tornar seu aplicativo mais robusto.
