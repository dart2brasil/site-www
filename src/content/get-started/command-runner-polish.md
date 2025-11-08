---
ia-translate: true
title: Polimento do command_runner
shortTitle: Polimento do command_runner
description: >-
  Melhore o HelpCommand para fornecer informações mais detalhadas e adicione um
  argumento onOutput para tratamento flexível de saída.
sitemap: false
noindex: true
layout: learn
prevpage:
  url: /get-started/advanced-oop
  title: Recursos avançados de OOP
nextpage:
  url: /get-started/data-and-json
  title: Dados e JSON
---

{% render 'fwe-wip-warning.md', site: site %}

Neste capítulo, você dará os toques finais no pacote `command_runner`.
Você refinará o `HelpCommand` para fornecer informações de uso mais detalhadas
e adicionará um argumento `onOutput` para tratamento de saída mais flexível.
Isso finaliza o pacote `CommandRunner` e o prepara para uso em
cenários mais complexos.

:::secondary O que você aprenderá

* Usar `StringBuffer` para concatenação eficiente de strings.
* Melhorar o `HelpCommand` para fornecer informações de uso mais detalhadas.
* Adicionar um argumento `onOutput` ao `CommandRunner` para saída personalizável
* tratamento.

:::

## Pré-requisitos

Antes de começar este capítulo, certifique-se de:

* Ter completado o Capítulo 7 e ter um ambiente de desenvolvimento Dart funcionando
  com o projeto `dartpedia`.
* Estar familiarizado com conceitos básicos de programação como variáveis, funções e
  controle de fluxo.
* Entender os conceitos de pacotes e bibliotecas no Dart.
* Estar familiarizado com princípios de programação orientada a objetos como herança e
  classes abstract.

## Tarefas

Você polirá o pacote `command_runner` para torná-lo mais robusto e
amigável ao usuário.

### Tarefa 1 Melhorar a saída do `HelpCommand`

Melhore o `HelpCommand` para fornecer informações de uso mais detalhadas,
incluindo opções e suas descrições. Isso facilitará para os usuários
entenderem como usar seu aplicativo CLI.

1.  Abra o arquivo `command_runner/lib/src/help_command.dart`.

1.  Adicione imports para `console.dart` e `exceptions.dart` no topo do arquivo.
    Você precisa deles para usar as extensões de cor e para lançar uma
    `ArgumentException`.

    ```dart
    import 'dart:async';

    import 'package:command_runner/command_runner.dart';

    import 'console.dart';
    import 'exceptions.dart';
    ```

1.  Substitua o método `run` existente pelo seguinte. Esta nova versão usa
    um `StringBuffer` para construir eficientemente a string de ajuda e inclui lógica para
    lidar com saída detalhada.

    ```dart
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
              'Input ${args.commandArg} is not a known command.',
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

    `StringBuffer` é uma classe Dart que permite construir strings eficientemente.
    É mais performática do que usar o operador `+`, especialmente ao realizar
    muitas concatenações dentro de um loop.

1.  Adicione o método auxiliar privado `_renderCommandVerbose` à classe `HelpCommand`.
    Este método formata a saída detalhada para um único comando.

    ```dart
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

### Tarefa 2 Adicionar um callback `onOutput`

Em seguida, adicione um argumento `onOutput` ao `CommandRunner` para permitir
tratamento flexível de saída.

1.  Abra o arquivo `command_runner/lib/src/command_runner_base.dart`.

1.  Adicione o argumento `onOutput` ao construtor `CommandRunner`, e adicione o
    membro `onOutput` correspondente à classe.

    ```dart
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

    ```dart
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
        } on Exception catch (e) {
          print(e);
        }
      }
    ```

    Isso atualiza o método `run` para usar a função `onOutput` se ela for
    fornecida, caso contrário, ela usa o padrão de imprimir no console.

### Tarefa 3 Usar o callback `onOutput`

Finalmente, atualize seu aplicativo principal para usar o novo recurso `onOutput`.

1.  Abra o arquivo `cli/bin/cli.dart`.

1.  Atualize a função `main` para passar a função `onOutput` ao
    `CommandRunner`. Você também precisará adicionar um import para `console.dart` para
    tornar a função `write` disponível.

    ```dart
    import 'package:command_runner/command_runner.dart';
    import 'package:command_runner/src/console.dart';

    const version = '0.0.1';

    void main(List<String> arguments) {
      var commandRunner = CommandRunner<String>(
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

### Tarefa 4 Testar as mudanças

Teste o `HelpCommand` melhorado e o callback `onOutput`.

1.  Abra seu terminal e navegue até o diretório `cli`.

1.  Execute o comando `dart run bin/cli.dart help --verbose`.

    Você deve ver informações de uso detalhadas para o comando `help`, impressas
    usando a função `write` personalizada.

## Revisão

Nesta lição, você aprendeu:

* Como usar `StringBuffer` para manipulação eficiente de strings.
* Como melhorar o `HelpCommand` para exibir informações de uso detalhadas.
* Como adicionar um argumento `onOutput` ao `CommandRunner` para tratamento
  de saída personalizável.

## Quiz

**Questão 1:** Qual é o propósito da classe `StringBuffer` no Dart?

* A) Armazenar uma string de tamanho fixo.
* B) Construir strings eficientemente anexando múltiplas partes.
* C) Criptografar strings.
* D) Comparar duas strings para igualdade.

**Questão 2:** O que o argumento `onOutput` na classe `CommandRunner`
permite que você faça?

* A) Especificar a entrada para um comando.
* B) Personalizar o tratamento de saída de um comando.
* C) Definir a mensagem de erro para um comando.
* D) Definir o nome de um comando.

## Próxima lição

Na próxima lição, você se preparará para a porção da Wikipedia do aplicativo.
