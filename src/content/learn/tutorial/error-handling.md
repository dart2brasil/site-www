---
ia-translate: true
title: Trate erros com elegância
shortTitle: Tratamento de erros
description: >-
  Torne o app mais robusto tratando erros.
  Aprenda sobre exceções, erros, `try/catch`, `throw` e `rethrow`.
layout: learn
---

Neste capítulo, você vai tornar sua aplicação mais robusta
tratando erros com elegância.
Explore exceções, blocos `try/catch` e como
criar exceções personalizadas para gerenciar erros de forma estruturada.

<SummaryCard>
title: O que você vai realizar
items:
  - title: Diferenciar erros de exceções
    icon: error
  - title: Usar try/catch para tratar falhas
    icon: shield
  - title: Criar e lançar exceções personalizadas
    icon: deployed_code_alert
</SummaryCard>

## Pré-requisitos {:#prerequisites}

Antes de começar este capítulo, certifique-se de:

- Ter concluído o Capítulo 6 e ter um
  ambiente de desenvolvimento Dart funcionando com o projeto `dartpedia`.
- Entender conceitos básicos de programação, como funções e classes.

## Erros versus exceções {:#errors-versus-exceptions}

O Dart distingue dois tipos principais de falhas:
**erros** e **exceções**.

| Conceito | `Exception` | `Error` |
| :--- | :--- | :--- |
| **O que indica** | Uma falha esperada em tempo de execução, da qual o código pode se recuperar. | Um bug de programação ou uma falha no código. |
| **Exemplos comuns** | `FormatException`, `HttpException`, `SocketException`. | `RangeError`, `TypeError`, `StateError`. |
| **Causas típicas** | Entrada inválida do usuário, falha de rede, arquivo ausente. | Índice fora por um, chamada de método em `null`. |
| **Como tratar** | Capturar e tratar com elegância (por exemplo, com `try/catch`). | Não capturar; corrija o bug no seu código. |

### Exceções {:#exceptions}

Exceções representam condições que você pode prever e das quais pode se recuperar.
Por exemplo, quando o usuário digita um argumento de linha de comando não reconhecido,
seu aplicativo não deve travar com um stack trace bruto.
Em vez disso, seu código captura a exceção,
exibe uma mensagem de erro amigável e
mostra ao usuário as instruções de uso corretas.

No Dart, exceções personalizadas normalmente implementam a classe `Exception` ou
estendem um tipo de exceção existente, como `FormatException`.

### Erros {:#errors}

Erros representam bugs na sua lógica que
devem ser corrigidos durante o desenvolvimento, e não tratados em tempo de execução.
Por exemplo, acessar um elemento além dos limites de uma lista lança um
`RangeError`.
Tentar capturar e suprimir um `RangeError` esconde o bug e
pode deixar seu aplicativo em um estado imprevisível.
Em vez disso, deixe o erro se propagar para que você possa inspecionar o stack trace e
corrigir o erro original.

No Dart, classes que representam bugs estendem ou implementam `Error`.

## Tarefas {:#tasks}

As tarefas a seguir aplicam esses princípios ao pacote `command_runner`.
Você vai definir uma classe de exceção personalizada para argumentos inválidos do usuário,
usar blocos `try/catch` para interceptar falhas e
configurar o `CommandRunner` para tratar exceções com elegância
enquanto deixa erros inesperados se propagarem.

### Tarefa 1: Crie uma ArgumentException personalizada {:#task-1-create-a-custom-argumentexception}

Primeiro, defina uma classe de exceção personalizada chamada `ArgumentException` para
representar erros relacionados a argumentos de linha de comando.

1.  Crie o arquivo `command_runner/lib/src/exceptions.dart`.
    Esse arquivo contém a definição da sua classe `ArgumentException`.

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

      @override
      String toString() {
        return 'ArgumentException: $message';
      }
    }
    ```

    Essa classe estende `FormatException`, que
    é uma classe integrada do Dart que implementa `Exception`.
    Argumentos de linha de comando inválidos são uma condição esperada
    que quem chama pode prever e tratar com elegância, por isso
    `ArgumentException` é projetada como uma exceção, e não como um `Error`.
    Ela inclui propriedades adicionais para armazenar o
    comando e o nome do argumento associados ao erro.
    Isso fornece mais contexto ao tratar a exceção.

    - `command`:
      O comando que estava sendo processado quando a exceção ocorreu.
    - `argumentName`:
      O nome do argumento que causou a exceção.


### Tarefa 2: Implemente o tratamento de erros no CommandRunner {:#task-2-implement-error-handling-in-commandrunner}

Em seguida, atualize a classe `CommandRunner` para
tratar possíveis erros com elegância.
Isso envolve adicionar um callback de tratamento de erros,
usar `try/catch` para gerenciar exceções e
lançar sua nova `ArgumentException` quando o usuário fornecer uma entrada inválida.

1.  Adicione os imports necessários.

    Em `command_runner/lib/src/command_runner_base.dart`,
    adicione imports para `dart:async` (para usar `FutureOr`) e
    para o seu novo arquivo `exceptions.dart`.

    ```dart title="command_runner/lib/src/command_runner_base.dart"
    import 'dart:async'; // Add this line
    import 'dart:collection';
    import 'dart:io';

    import 'arguments.dart';
    import 'exceptions.dart'; // Add this line
    ```

1.  Adicione um callback `onError` ao `CommandRunner`.

    Modifique o CommandRunner para
    aceitar uma função `onError` opcional em seu construtor.
    Isso permite que quem usa seu pacote
    defina a própria lógica de tratamento de erros.

    ```dart title="command_runner/lib/src/command_runner_base.dart"
    class CommandRunner {
      // Add a constructor that accepts the optional callback.
      CommandRunner({this.onError});

      final Map<String, Command> _commands = <String, Command>{};

      UnmodifiableSetView<Command> get commands =>
          UnmodifiableSetView<Command>(<Command>{..._commands.values});

      // Define the onError property.
      FutureOr<void> Function(Object)? onError;

      // The rest of the class implementation...
    }
    ```

    Essa mudança introduz a propriedade `onError`, que pode ser nula.
    O tipo `FutureOr<void> Function(Object)?` significa que é uma função que
    recebe um `Object` e retorna um `Future` ou nada, e pode ser nula.

1.  Atualize o método run para usar `try`/`catch`.

    Envolva a lógica dentro do método run em um bloco `try`/`catch`.
    Se ocorrer uma exceção, esse bloco a captura e a envia para o
    callback `onError` ou a relança caso nenhum callback seja fornecido.
    O `rethrow` preserva o erro original e o stack trace.

    ```dart title="command_runner/lib/src/command_runner_base.dart"
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

    Observe o uso de `on Exception catch (exception)`.
    No Dart, um `catch (e)` sem tipo intercepta todos os objetos lançados,
    incluindo instâncias de `Error`.
    Especificar `on Exception` garante que seu código capture apenas
    exceções recuperáveis,
    deixando os bugs se propagarem sem serem capturados para que você possa corrigi-los.

1.  Adicione validação ao método `parse`.

    Por fim, substitua o método `parse` existente em `command_runner_base.dart`
    pela versão atualizada a seguir.
    Ela inclui verificações que lançam sua `ArgumentException` personalizada
    sempre que detectam uma entrada inválida do usuário.

    ```dart title="command_runner/lib/src/command_runner_base.dart"
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

      // Section: Handle options, including flags.
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

    Este método `parse` atualizado agora se protege ativamente contra entradas inválidas.
    Especificamente, os novos statements `throw` tratam vários casos comuns de erro:

    -   **Comandos desconhecidos:**
        O primeiro bloco `if`/`else` garante que o
        primeiro argumento seja um comando válido.
    -   **Vários comandos:**
        Ele verifica se o usuário não tentou
        executar mais de um comando por vez.
    -   **Opções desconhecidas:**
        O parâmetro `orElse` dentro de `firstWhere` agora lança uma
        exceção se o usuário fornecer uma flag ou opção (como `--foo`) que
        não foi definida para aquele comando.
    -   **Valores de opção ausentes:**
        Ele garante que uma opção (como `--output`) seja seguida de um valor, e
        não de outra opção ou do fim da entrada.
    -   **Argumentos demais:**
        Ele aplica a regra de que comandos
        podem ter apenas um argumento posicional.

### Tarefa 3: Atualize o cli.dart para usar o novo tratamento de erros {:#task-3-update-clidart-to-use-the-new-error-handling}

Modifique `cli/bin/cli.dart` para usar o novo tratamento de erros no `CommandRunner`.

1.  Abra o arquivo `cli/bin/cli.dart`.

1.  Atualize a função `main` para passar uma
    função `onError` ao `CommandRunner`:

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

    Este código passa um callback `onError` para o `CommandRunner`.
    O callback relança qualquer `Error`, fazendo o aplicativo travar,
    enquanto imprime qualquer `Exception` no console para que o usuário veja
    a mensagem de erro.

### Tarefa 4: Atualize as exportações da biblioteca command_runner {:#task-4-update-command_runner-library-exports}

Torne `ArgumentException` disponível para a biblioteca `command_runner`.

1.  Abra `command_runner/lib/command_runner.dart` e
    adicione as seguintes exportações:

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

    Em pacotes Dart, os arquivos dentro de `lib/src/` são detalhes de implementação privados.
    Exportar `src/exceptions.dart` a partir de `lib/command_runner.dart` expõe
    `ArgumentException` como parte da API pública do pacote, para que quem o usa
    (como o `cli.dart`) possa importá-la e usá-la.

### Tarefa 5: Teste o novo tratamento de erros {:#task-5-test-the-new-error-handling}

Teste o novo tratamento de erros executando o aplicativo com argumentos inválidos.

1.  Abra o terminal e navegue até o diretório `cli`.

1.  Execute o comando `dart run bin/cli.dart invalid_command`.

    Você deve ver a seguinte saída:

    ```bash
    ArgumentException: The first word of input must be a command.
    ```

    Isso confirma que a `ArgumentException` está
    sendo lançada e capturada corretamente.

## Revisão {:#review}

<SummaryCard>
title: O que você realizou
subtitle: Veja um resumo do que você construiu e aprendeu nesta lição.
completed: true
items:
  - title: Diferenciou erros de exceções
    icon: error
    details: >-
      Você aprendeu que subtipos de `Error` indicam
      bugs de programação e não devem ser capturados,
      enquanto subtipos de `Exception` representam
      falhas recuperáveis que o seu código pode tratar com elegância.
  - title: Usou blocos try-catch para tratar falhas
    icon: shield
    details: >-
      Você envolveu código arriscado em blocos `try`-`catch` para interceptar exceções.
      Você usou `on ExceptionType catch (e)` para tratar tipos específicos e
      `rethrow` para relançar exceções preservando o stack trace.
  - title: Criou e lançou exceções personalizadas
    icon: deployed_code_alert
    details: >-
      Você criou uma classe `ArgumentException` que estende `FormatException` para
      fornecer informações de erro ricas em contexto.
      Depois, usou `throw` para sinalizar falhas de validação com
      mensagens significativas, para facilitar a depuração e o retorno ao usuário.
</SummaryCard>

## Quiz {:#quiz}

<Quiz title="Confira seu entendimento" id="error-handling" />

## Próxima lição {:#next-lesson}

Na próxima lição, você vai aprender sobre
recursos avançados de orientação a objetos no Dart,
incluindo enums aprimorados e extensões.
Você também vai melhorar a formatação da saída e adicionar cor ao seu aplicativo CLI.
