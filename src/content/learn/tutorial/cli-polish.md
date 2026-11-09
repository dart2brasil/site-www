---
ia-translate: true
title: Polir seu aplicativo CLI
shortTitle: Polimento do CLI
description: >-
  Melhore o HelpCommand para fornecer informações mais detalhadas e adicione um
  argumento onOutput para tratamento flexível da saída.
layout: learn
---

Neste capítulo, você vai dar os toques finais no pacote `command_runner`.
Você vai refinar o `HelpCommand` para fornecer informações de uso mais detalhadas e
adicionar um argumento `onOutput` para um tratamento de saída mais flexível.
Isso finaliza o pacote `CommandRunner` e o prepara para uso em
cenários mais complexos.

<SummaryCard>
title: O que você vai realizar
items:
  - title: Aprenda a construir strings iterativamente
    icon: text_snippet
  - title: Melhore as informações de uso da ajuda
    icon: help
  - title: Torne seu executor de comandos mais flexível
    icon: terminal
</SummaryCard>

## Pré-requisitos {:#prerequisites}

Antes de começar este capítulo, certifique-se de que você:

- Completou o Capítulo 8 e tem um ambiente de desenvolvimento Dart funcionando
  com o projeto `dartpedia`.
- Está familiarizado com conceitos básicos de programação, como variáveis, funções e
  controle de fluxo.
- Entende os conceitos de pacotes e bibliotecas no Dart.
- Está familiarizado com princípios de programação orientada a objetos, como herança e
  classes abstratas.

## Tarefas {:#tasks}

Você vai polir o pacote `command_runner` para torná-lo mais robusto e
amigável ao usuário.

### Tarefa 1 Melhore a saída do `HelpCommand` {:#task-1-improve-the-helpcommand-output}

Aprimore o `HelpCommand` para fornecer informações de uso mais detalhadas,
incluindo opções e suas descrições.
Isso facilitará para os usuários
entenderem como usar seu aplicativo CLI.

1.  Abra o arquivo `command_runner/lib/src/help_command.dart`.

1.  Adicione imports para `console.dart` e `exceptions.dart` no topo do arquivo.
    Você precisa deles para usar as extensões de cor e para lançar uma
    `ArgumentException`.

    ```dart title="command_runner/lib/src/help_command.dart"
    import 'dart:async';

    import 'package:command_runner/command_runner.dart';

    import 'console.dart';
    import 'exceptions.dart';
    ```

1.  Substitua o método `run` existente pelo seguinte.
    Esta nova versão usa um `StringBuffer` para construir a string de ajuda
    de forma eficiente e inclui lógica para tratar a saída detalhada.

    ```dart title="command_runner/lib/src/help_command.dart"
    @override
    FutureOr<String> run(ArgResults args) async {
      final buffer = StringBuffer();
      buffer.writeln(runner.usage.titleText);

      if (args.flag('verbose')) {
        for (var cmd in runner.commands) {
          buffer.write(_renderCommandVerbose(cmd));
        }

        return buffer.toString();
      }

      if (args.hasOption('command')) {
        var (:option, :input) = args.getOption('command');

        var cmd = runner.commands.firstWhere(
          (command) => command.name == input,
          orElse: () {
            throw ArgumentException(
              'Input $input is not a known command.',
              name,
            );
          },
        );

        return _renderCommandVerbose(cmd);
      }

      // Verbose is false and no arg was passed in, so print basic usage.
      for (var command in runner.commands) {
        buffer.writeln(command.usage);
      }

      return buffer.toString();
    }
    ```

    `StringBuffer` é uma classe Dart que permite construir strings de forma eficiente.
    Ela tem mais desempenho do que usar o operador `+`,
    especialmente ao fazer muitas concatenações dentro de um loop.

1.  Adicione o método auxiliar privado `_renderCommandVerbose` à classe `HelpCommand`.
    Este método formata a saída detalhada de um único comando.

    ```dart title="command_runner/lib/src/help_command.dart"
    String _renderCommandVerbose(Command cmd) {
      final indent = ' ' * 10;
      final buffer = StringBuffer();
      buffer.writeln(cmd.usage.instructionText); //abbr, name: description
      buffer.writeln('$indent ${cmd.help}');
      if (cmd.valueHelp != null) {
        buffer.writeln(
          '$indent [Argument] Required? ${cmd.requiresArgument}, Type: ${cmd.valueHelp}, Default: ${cmd.defaultValue ?? 'none'}',
        );
      }
      buffer.writeln('$indent Options:');
      for (var option in cmd.options) {
        buffer.writeln('$indent ${option.usage}');
      }
      return buffer.toString();
    }
    ```

### Tarefa 2 Adicione um callback `onOutput` {:#task-2-add-an-onoutput-callback}

Em seguida, adicione um argumento `onOutput` ao `CommandRunner` para permitir
um tratamento de saída flexível.

1.  Abra o arquivo `command_runner/lib/src/command_runner_base.dart`.

1.  Adicione o argumento `onOutput` ao construtor `CommandRunner` e adicione o
    membro `onOutput` correspondente à classe.

    ```dart title="command_runner/lib/src/command_runner_base.dart"
    class CommandRunner {
      CommandRunner({this.onOutput, this.onError});

      /// If not null, this method is used to handle output. Useful if you want to
      /// execute code before the output is printed to the console, or if you
      /// want to do something other than print output the console.
      /// If null, the onInput method will [print] the output.
      FutureOr<void> Function(String)? onOutput;

      FutureOr<void> Function(Object)? onError;

      // ... rest of the class
    }
    ```

1.  Atualize o método `run` para usar o argumento `onOutput`.

    ```dart title="command_runner/lib/src/command_runner_base.dart"
      Future<void> run(List<String> input) async {
        try {
          final ArgResults results = parse(input);
          if (results.command != null) {
            Object? output = await results.command!.run(results);
            if (onOutput != null) {
              await onOutput!(output.toString());
            } else {
              print(output.toString());
            }
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

    Isso atualiza o método `run` para usar a função `onOutput`, caso ela seja
    fornecida. Caso contrário, o padrão é imprimir no console.

### Tarefa 3 Use o callback `onOutput` {:#task-3-use-the-onoutput-callback}

Por fim, atualize seu aplicativo principal para usar o novo recurso `onOutput`.

1.  Abra o arquivo `cli/bin/cli.dart`.

1.  Atualize a função `main` para passar a função `onOutput` ao
    `CommandRunner`.
    Você também precisará adicionar um import para `console.dart` para
    deixar a função `write` disponível.

    ```dart title="cli/bin/cli.dart"
    import 'package:command_runner/command_runner.dart';

    const version = '0.0.1';

    void main(List<String> arguments) {
      var commandRunner = CommandRunner(
        onOutput: (String output) async {
          await write(output);
        },
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

### Tarefa 4 Teste as mudanças {:#task-4-test-the-changes}

Teste o `HelpCommand` aprimorado e o callback `onOutput`.

1.  Abra seu terminal e navegue até o diretório `cli`.

1.  Execute o comando `dart run bin/cli.dart help --verbose`.

    Você deve ver informações de uso detalhadas para o comando `help`, impressas
    usando a função `write` personalizada.

## Revisão {:#review}

<SummaryCard>
title: O que você concluiu
subtitle: Aqui está um resumo do que você construiu e aprendeu nesta lição.
completed: true
items:
  - title: Usou StringBuffer para construir strings de forma eficiente
    icon: text_snippet
    details: >-
      Você substituiu a concatenação de strings por um `StringBuffer`,
      que pode ser mais eficiente para construir strings em loops.
      Métodos como `writeln()` e `write()` acrescentam conteúdo,
      enquanto `toString()` produz a string final.
  - title: Aprimorou o HelpCommand com saída detalhada
    icon: help
    details: >-
      Você melhorou o sistema de ajuda para mostrar informações de uso detalhadas,
      incluindo opções, valores padrão e descrições.
      A flag `--verbose` e a opção `--command` dão aos usuários
      controle sobre o nível de detalhe.
  - title: Adicionou um argumento de callback onOutput para tratamento flexível
    icon: terminal
    details: >-
      Você adicionou `onOutput` ao `CommandRunner`,
      permitindo que quem usa a biblioteca personalize como a saída é exibida.
      Esse padrão torna seu pacote mais flexível e adaptável,
      possibilitando impressão atrasada, logging ou redirecionamento da saída.
</SummaryCard>

## Quiz {:#quiz}

<Quiz title="Check your understanding" id="cli-polish" />

## Próxima lição {:#next-lesson}

Na próxima lição, você vai se preparar para
a parte da Wikipedia do aplicativo.
