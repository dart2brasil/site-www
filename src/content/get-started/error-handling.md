---
ia-translate: true
title: Tratamento de erros
shortTitle: Tratamento de erros
description: >-
  Melhore a robustez da aplicação lidando com erros. Aprenda sobre exceptions, errors,
  `try/catch`, `throw` e `rethrow`.
sitemap: false
noindex: true
layout: learn
prevpage:
  url: /get-started/object-oriented
  title: Object-oriented Dart programming
nextpage:
  url: /get-started/advanced-oop
  title: Advanced OOP-adjacent features
---

{% render 'fwe-wip-warning.md', site: site %}

Neste capítulo, você aprenderá como tornar sua aplicação mais robusta
lidando com erros de forma elegante. Você explorará exceptions, blocos `try/catch` e
como criar exceptions personalizadas para gerenciar erros de maneira estruturada.

:::secondary O que você aprenderá

* Entender a diferença entre errors e exceptions em Dart.
* Usar blocos `try/catch` para lidar com exceptions.
* Usar `throw` para sinalizar erros.
* Criar uma classe de exception personalizada.
* Usar `rethrow` para propagar exceptions pela pilha de chamadas.

:::

## Pré-requisitos

Antes de começar este capítulo, certifique-se de:

* Ter completado o Capítulo 5 e ter um ambiente de desenvolvimento Dart funcionando com
  o projeto `dartpedia`.
* Entender conceitos básicos de programação como funções e classes.

## Tarefas

Neste capítulo, você melhorará a robustez do seu pacote `command_runner`
implementando tratamento de erros. Você criará uma classe de exception personalizada
e adicionará tratamento de erros ao `CommandRunner` para gerenciar elegantemente erros que
possam ocorrer durante a execução de comandos.

### Tarefa 1: Criar uma ArgumentException personalizada

Primeiro, defina uma classe de exception personalizada chamada `ArgumentException` para
representar erros relacionados a argumentos de linha de comando.

1.  Crie o arquivo `command_runner/lib/src/exceptions.dart`. Este arquivo conterá
    a definição para sua classe `ArgumentException`.

1.  Defina uma classe chamada `ArgumentException` que `extends` `FormatException`.

    ```dart title="command_runner/lib/src/exceptions.dart"
    class ArgumentException extends FormatException {
      /// The command that was parsed before discovering the error.
      ///
      /// This will be empty if the error was on the root parser.
      final String? command;
    
      /// The name of the argument that was being parsed when the error was
      /// discovered.
      final String? argumentName;
    
      ArgumentException(
        super.message, [
        this.command,
        this.argumentName,
        super.source,
        super.offset,
      ]);
    }
    ```

    Esta classe estende `FormatException`, que é uma classe de exception nativa do Dart.
    Ela inclui propriedades adicionais para armazenar o comando e o nome do argumento
    associados ao erro. Isso fornece mais contexto ao lidar com a
    exception.

    * `command`: O comando que estava sendo processado quando a exception
    ocorreu.
    * `argumentName`: O nome do argumento que causou a exception.


## Tarefa 2: Implementar tratamento de erros no CommandRunner

Em seguida, atualize a classe `CommandRunner` para lidar com potenciais erros
de forma elegante. Isso envolve adicionar um callback de tratamento de erros, usar `try/catch`
para gerenciar exceptions e lançar sua nova `ArgumentException` quando o usuário
fornecer entrada inválida.

1.  Adicione os imports necessários.

    Em `command_runner/lib/src/command_runner_base.dart`, adicione imports para
    `dart:async` (para usar `FutureOr`) e seu novo arquivo `exceptions.dart`.

    ```dart
    import 'dart:async'; // Add this line
    import 'dart:collection';
    import 'dart:io';

    import 'arguments.dart';
    import 'exceptions.dart'; // Add this line
    ```

1.  Adicione um callback `onError` ao `CommandRunner`.

    Modifique o CommandRunner para aceitar uma função `onError` opcional em seu
    construtor. Isso permitirá que o usuário do seu pacote defina sua própria
    lógica de tratamento de erros.

    ```dart
    class CommandRunner {
    // Add a constructor that accepts the optional callback.
    CommandRunner({this.onError});

    final Map<String, Command> _commands = <String, Command>{};

    UnmodifiableSetView<Command> get commands =>
        UnmodifiableSetView<Command>(<Command>{..._commands.values});

    // Define the onError property.
    FutureOr<void> Function(Object)? onError;

    // ... rest of the class
    }
    ```
    
    Esta mudança introduz uma propriedade `onError` nullable. O
    tipo `FutureOr<void> Function(Object)?` significa que é uma função que recebe um
    `Object` e retorna um `Future` ou nada, e pode ser null.

1.  Atualize o método run para usar `try`/`catch`.

    Envolva a lógica dentro do método run em um bloco `try`/`catch`. Se uma exception
    ocorrer, este bloco irá "capturá-la" e ou passá-la para o callback `onError`
    ou relançá-la se nenhum callback foi fornecido. `rethrow` preserva o
    erro original e o stack trace.

    ```dart
    Future<void> run(List<String> input) async {
    // [Step 6 update] try/catch added
        try {
            final ArgResults results = parse(input);
            if (results.command != null) {
                Object? output = await results.command!.run(results);
                print(output.toString());
            }
        } on Exception catch (exception) {
            if (onError != null) {
                onError!(exception);
            } else {
                rethrow;
            }
        }
    }
    ```

1.  Adicione validação ao método `parse`.

    Por fim, substitua o método `parse` existente em `command_runner_base.dart`
    pela seguinte versão atualizada. Esta nova versão é muito mais robusta.
    Ela está cheia de verificações que lançarão sua `ArgumentException` personalizada
    sempre que detectar entrada inválida do usuário.

    ```dart
    // [Step 6 update] This method is replaced entirely.
    ArgResults parse(List<String> input) {
        ArgResults results = ArgResults();
        if (input.isEmpty) return results;

        // Throw an exception if the command is not recognized.
        if (_commands.containsKey(input.first)) {
            results.command = _commands[input.first];
            input = input.sublist(1);
        } else {
            throw ArgumentException(
                'The first word of input must be a command.',
                null,
                input.first,
            );
        }

        // Throw an exception if multiple commands are provided.
        if (results.command != null &&
            input.isNotEmpty &&
            _commands.containsKey(input.first)) {
                throw ArgumentException(
                    'Input can only contain one command. Got ${input.first} and ${results.command!.name}',
                    null,
                    input.first,
                );
        }

        // Section: handle Options (including flags)
        Map<Option, Object?> inputOptions = {};
        int i = 0;
        while (i < input.length) {
            if (input[i].startsWith('-')) {
                var base = _removeDash(input[i]);
                // Throw an exception if an option is not recognized for the given command.
                var option = results.command!.options.firstWhere(
                    (option) => option.name == base || option.abbr == base,
                    orElse: () {
                        throw ArgumentException(
                        'Unknown option ${input[i]}',
                        results.command!.name,
                        input[i],
                        );
                    },
                );

                if (option.type == OptionType.flag) {
                    inputOptions[option] = true;
                    i++;
                    continue;
                }

                if (option.type == OptionType.option) {
                // Throw an exception if an option requires an argument but none is given.
                    if (i + 1 >= input.length) {
                        throw ArgumentException(
                            'Option ${option.name} requires an argument',
                            results.command!.name,
                            option.name,
                        );
                    }
                    if (input[i + 1].startsWith('-')) {
                        throw ArgumentException(
                            'Option ${option.name} requires an argument, but got another option ${input[i + 1]}',
                            results.command!.name,
                            option.name,
                        );
                    }
                    var arg = input[i + 1];
                    inputOptions[option] = arg;
                    i++;
                }
            } else {
                // Throw an exception if more than one positional argument is provided.
                if (results.commandArg != null && results.commandArg!.isNotEmpty) {
                throw ArgumentException(
                    'Commands can only have up to one argument.',
                    results.command!.name,
                    input[i],
                );
                }
                results.commandArg = input[i];
            }
            i++;
        }
        results.options = inputOptions;

        return results;
    }

    String _removeDash(String input) {
        if (input.startsWith('--')) {
            return input.substring(2);
        }
        if (input.startsWith('-')) {
            return input.substring(1);
        }
        return input;
    }
    ```
    
    Este método parse atualizado agora defende ativamente contra entrada inválida.
    Especificamente, as novas declarações throw lidam com vários casos de erro comuns:

    *   Comandos desconhecidos: O primeiro bloco `if`/`else` garante que o primeiro argumento seja
        um comando válido.
    *   Múltiplos comandos: Verifica que o usuário não tentou executar mais de
        um comando por vez.
    *   Opções desconhecidas: O parâmetro `orElse` dentro de `firstWhere` agora lança uma
        exception se um usuário fornece uma flag ou opção (como `--foo`) que
        não foi definida para aquele comando.
    *   Valores de opção ausentes: Garante que uma opção (como `--output`) seja
        seguida por um valor e não por outra opção ou pelo fim da entrada.
    *   Muitos argumentos: Impõe uma regra de que comandos só podem ter um
        argumento posicional.

### Tarefa 3: Atualizar cli.dart para usar o novo tratamento de erros

Modifique `cli/bin/cli.dart` para usar o novo tratamento de erros no `CommandRunner`.

1.  Abra o arquivo `cli/bin/cli.dart`.

1.  Atualize a função `main` para passar um método `onError` ao
    `CommandRunner`:

    ```dart title="cli/bin/cli.dart"
    import 'package:command_runner/command_runner.dart';

    const version = '0.0.1';

    void main(List<String> arguments) {
      // [Step 6 update] Add onError method
      var commandRunner = CommandRunner(
        onError: (Object error) {
          if (error is Error) {
            throw error;
          }
          if (error is Exception) {
            print(error);
          }
        },
      )..addCommand(HelpCommand());
      commandRunner.run(arguments);
    }
    ```

    Este código passa uma função de callback `onError` para o construtor do `CommandRunner`.
    Se um erro ocorre durante a execução de um comando, a
    função de callback `onError` é chamada com o objeto de erro. O callback
    verifica se o erro é um `Error` ou uma `Exception`. Se for um
    `Error`, ele é relançado. Se for uma `Exception`, é impresso no console.

### Tarefa 4: Atualizar as exportações da biblioteca command_runner

Torne `ArgumentException` disponível para a biblioteca `command_runner`.

1.  Abra `command_runner/lib/command_runner.dart` e adicione as seguintes
    exportações:

    ```dart title="command_runner/lib/command_runner.dart"
    /// Support for doing something awesome.
    ///
    /// More dartdocs go here.
    library;
    
    export 'src/arguments.dart';
    export 'src/command_runner_base.dart';
    export 'src/help_command.dart';
    export 'src/exceptions.dart'; // Add this line
    
    // TODO: Export any libraries intended for clients of this package.
    ```

    Isso garante que `ArgumentException` esteja disponível para consumidores do
    pacote `command_runner`.

### Tarefa 5: Testar o novo tratamento de erros

Teste o novo tratamento de erros executando a aplicação com argumentos inválidos.

1.  Abra seu terminal e navegue até o diretório `cli`.

1.  Execute o comando `dart run bin/cli.dart invalid_command`.

    Você deverá ver a seguinte saída:

    ```bash
    ArgumentException: The first word of input must be a command.
    ```

    Isso confirma que a `ArgumentException` está sendo lançada e capturada
    corretamente.

## Revisão

Nesta lição, você aprendeu sobre:

*   A diferença entre `Error` e `Exception` em Dart.
*   Usar blocos `try/catch` para lidar com exceptions.
*   Usar `throw` para sinalizar erros.
*   Criar uma classe de exception personalizada para representar tipos específicos de erros.
*   Usar `rethrow` para propagar exceptions pela pilha de chamadas.

## Quiz

**Questão 1:** Qual é o propósito do bloco `try/catch` em Dart?

* A) Definir uma nova classe.
* B) Lidar com exceptions que podem ocorrer durante a execução do código.
* C) Declarar uma variável.
* D) Definir uma função.

**Questão 2:** Qual é o propósito da keyword `throw` em Dart?

* A) Declarar uma nova classe.
* B) Lidar com exceptions que podem ocorrer durante a execução do código.
* C) Sinalizar um erro ou exception.
* D) Definir uma função.

**Questão 3:** Qual é o propósito da keyword `rethrow` em Dart?

* A) Criar uma nova exception.
* B) Capturar uma exception.
* C) Propagar uma exception pela pilha de chamadas.
* D) Ignorar uma exception.

## Próxima lição

Na próxima lição, você aprenderá sobre recursos avançados de orientação a objetos em
Dart, incluindo enums aprimorados e extensions. Você melhorará a formatação
da saída e adicionará cor à sua aplicação CLI.
