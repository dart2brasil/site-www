---
ia-translate: true
title: "Recursos avançados adjacentes a OOP"
shortTitle: "Recursos OOP Avançados"
description: >-
  Aprimore suas habilidades em Dart explorando recursos avançados como enhanced enums
  e extensions. Melhore a formatação e cor da saída da sua aplicação,
  tornando-a mais amigável ao usuário.
sitemap: false
noindex: true
layout: learn
prevpage:
  url: /get-started/error-handling
  title: Error handling
nextpage:
  url: /get-started/command-runner-polish
  title: command_runner polish
---

{% render 'fwe-wip-warning.md', site: site %}

Neste capítulo, você explorará recursos avançados do Dart que melhoram a
experiência do usuário da sua aplicação de linha de comando. Você aprenderá como usar enhanced
enums para gerenciar cores do console e extensions para adicionar novas funcionalidades a
tipos existentes, tornando sua aplicação mais interativa e visualmente atraente.

:::secondary O que você aprenderá

*   Usar enhanced enums para definir e gerenciar cores do console.
*   Aplicar extensions para adicionar novos métodos à classe `String`.
*   Melhorar a formatação e cor da saída para uma melhor experiência do usuário.

:::

## Pré-requisitos

Antes de começar este capítulo, certifique-se de que você:

*   Completou o Capítulo 6 e tem um ambiente de desenvolvimento Dart funcionando
    com o projeto `dartpedia`.
*   Está familiarizado com conceitos básicos de programação como variáveis, funções e
    controle de fluxo.
*   Entende os conceitos de pacotes e bibliotecas em Dart.
*   Tem um entendimento básico de conceitos de programação orientada a objetos como
    classes e enums.

## Tarefas

Você melhorará a experiência do usuário da sua aplicação CLI Dartpedia adicionando
cor à saída e melhorando a formatação de texto.

### Tarefa 1: Melhorar o enum de cor do console

Primeiro, adicione cor à saída do console. O
enum `ConsoleColor` incluirá valores RGB e métodos para aplicar
cores ao texto.

1.  Crie o arquivo `command_runner/lib/src/console.dart`.

2.  Adicione o seguinte código para definir o enum `ConsoleColor`:

    ```dart title="command_runner/lib/src/console.dart"
    import 'dart:io';

    const String ansiEscapeLiteral = '\x1B';

    /// Splits strings on `\n` characters, then writes each line to the
    /// console. [duration] defines how many milliseconds there will be
    /// between each line print.
    Future<void> write(String text, {int duration = 50}) async {
      final List<String> lines = text.split('\n');
      for (final String l in lines) {
        await _delayedPrint('$l \n', duration: duration);
      }
    }

    /// Prints line-by-line
    Future<void> _delayedPrint(String text, {int duration = 0}) async {
      return Future<void>.delayed(
        Duration(milliseconds: duration),
        () => stdout.write(text),
      );
    }

    /// RGB formatted colors that are used to style input
    ///
    /// All colors from Dart's brand styleguide
    ///
    /// As a demo, only includes colors this program cares about.
    /// If you want to use more colors, add them here.
    enum ConsoleColor {
      /// Sky blue - #b8eafe
      lightBlue(184, 234, 254),

      /// Accent colors from Dart's brand guidelines
      /// Warm red - #F25D50
      red(242, 93, 80),

      /// Light yellow - #F9F8C4
      yellow(249, 248, 196),

      /// Light grey, good for text, #F8F9FA
      grey(240, 240, 240),

      ///
      white(255, 255, 255);

      const ConsoleColor(this.r, this.g, this.b);

      final int r;
      final int g;
      final int b;
    }
    ```

    Este enum define um conjunto de cores de console com seus valores RGB
    correspondentes. Cada cor é uma instância constante do enum `ConsoleColor`.

3.  Adicione métodos ao enum `ConsoleColor` para aplicar cores ao texto:

    ```dart title="command_runner/lib/src/console.dart"
    enum ConsoleColor {
      // ... (existing enum values)

      const ConsoleColor(this.r, this.g, this.b);

      final int r;
      final int g;
      final int b;

      /// Change text color for all future output (until reset)
      /// ```dart
      /// print('hello'); // prints in terminal default color
      /// print('AnsiColor.red.enableForeground');
      /// print('hello'); // prints in red color
      /// ```
      String get enableForeground => '$ansiEscapeLiteral[38;2;$r;$g;${b}m';

      /// Change text color for all future output (until reset)
      /// ```dart
      /// print('hello'); // prints in terminal default color
      /// print('AnsiColor.red.enableForeground');
      /// print('hello'); // prints in red color
      /// ```
      String get enableBackground => '$ansiEscapeLiteral[48;2;$r;$g;${b}m';

      /// Reset text and background color to terminal defaults
      static String get reset => '$ansiEscapeLiteral[0m';

      /// Sets text color for the input
      String applyForeground(String text) {
        return '$ansiEscapeLiteral[38;2;$r;$g;${b}m$text$reset';
      }

      /// Sets background color and then resets the color change
      String applyBackground(String text) {
        return '$ansiEscapeLiteral[48;2;$r;$g;${b}m$text$ansiEscapeLiteral[0m';
      }
    }
    ```

    Esses métodos usam [ANSI escape codes][] para aplicar cores de primeiro plano e plano de fundo
    ao texto. Os métodos `applyForeground` e `applyBackground` retornam
    uma string com os códigos de escape ANSI aplicados.

### Tarefa 2: Criar uma extension de String

Em seguida, crie uma extension na classe `String` para adicionar métodos utilitários
para aplicar cores de console e formatar texto.

1.  Adicione o seguinte código ao arquivo `command_runner/lib/src/console.dart`:

    ```dart title="command_runner/lib/src/console.dart"
    // Add this code to the bottom of the file
    extension TextRenderUtils on String {
      String get errorText => ConsoleColor.red.applyForeground(this);
      String get instructionText => ConsoleColor.yellow.applyForeground(this);
      String get titleText => ConsoleColor.lightBlue.applyForeground(this);

      List<String> splitLinesByLength(int length) {
        final List<String> words = split(' ');
        final List<String> output = <String>[];
        final StringBuffer strBuffer = StringBuffer();
        for (int i = 0; i < words.length; i++) {
          final String word = words[i];
          if (strBuffer.length + word.length <= length) {
            strBuffer.write(word.trim());
            if (strBuffer.length + 1 <= length) {
              strBuffer.write(' ');
            }
          }
          // If the next word surpasses length, start the next line
          if (i + 1 < words.length &&
              words[i + 1].length + strBuffer.length + 1 > length) {
            output.add(strBuffer.toString().trim());
            strBuffer.clear();
          }
        }

        // Add left overs
        output.add(strBuffer.toString().trim());
        return output;
      }
    }
    ```

    Este código define uma extension chamada `TextRenderUtils` na classe `String`.
    Ela adiciona três métodos getter para aplicar cores de console:
    `errorText`, `instructionText` e `titleText`. Ela também adiciona um método para
    dividir uma string em linhas de um comprimento especificado chamado `splitLinesByLength`.

### Tarefa 3: Atualizar o pacote command_runner

Atualize o pacote `command_runner` para exportar `console.dart`.

1.  Abra `command_runner/lib/command_runner.dart` e adicione a seguinte linha:

    ```dart title="command_runner/lib/command_runner.dart"
    library;

    export 'src/arguments.dart';
    export 'src/command_runner_base.dart';
    export 'src/exceptions.dart';
    export 'src/help_command.dart';
    export 'src/console.dart'; // Add this line

    // TODO: Export any libraries intended for clients of this package.
    ```

### Tarefa 4: Implementar comando echo colorido

Finalmente, implemente um comando de exemplo para testar a impressão. É
uma boa prática implementar um exemplo de uso de um pacote em Dart para
desenvolvedores que usarão seu pacote. Este exemplo cria um comando
que torna a saída do console colorida.

1.  Abra o arquivo `example/command_runner_example.dart`.
2.  Substitua o conteúdo do arquivo pelo seguinte código:

    ```dart title="command_runner/example/command_runner_example.dart"
    import 'dart:async';

    import 'package:command_runner/command_runner.dart';

    class PrettyEcho extends Command<String> {
      PrettyEcho() {
        addFlag(
          'blue-only',
          abbr: 'b',
          help: 'When true, the echoed text will all be blue.',
        );
      }

      @override
      String get name => 'echo';

      @override
      bool get requiresArgument => true;

      @override
      String get description => 'Print input, but colorful.';

      @override
      String? get help =>
          'echos a String provided as an argument with ANSI coloring,';

      @override
      String? get valueHelp => 'STRING';

      @override
      FutureOr<String> run(ArgResults arg) {
        if (arg.commandArg == null) {
          throw ArgumentException(
            'This argument requires one positional argument',
            name,
          );
        }

        List<String> prettyWords = [];
        var words = arg.commandArg!.split(' ');
        for (var i = 0; i < words.length; i++) {
          var word = words[i];
          switch (i % 3) {
            case 0:
              prettyWords.add(word.titleText);
            case 1:
              prettyWords.add(word.instructionText);
            case 2:
              prettyWords.add(word.errorText);
          }
        }

        return prettyWords.join(' ');
      }
    }

    void main(List<String> arguments) {
      final runner = CommandRunner<String>()..addCommand(PrettyEcho());

      runner.run(arguments);
    }
    ```

    Este código define um comando `PrettyEcho` que estende a classe `Command`.
    Ele recebe uma string como argumento e aplica cores diferentes a cada palavra
    com base em sua posição na string. O método `run` usa os métodos getter `titleText`,
    `instructionText` e `errorText` da extension `TextRenderUtils`
    para aplicar as cores.

3.  Navegue até `/dartpedia/command_runner` e execute o seguinte comando:

    ```bash
    dart run example/command_runner_example.dart echo "hello world goodbye"
    ```

    Você deve ver o seguinte texto impresso no console, com a primeira
    palavra aparecendo em azul claro, a segunda em amarelo e a terceira em vermelho.

    ```bash
    hello world goodbye
    ```

## Revisão

Nesta lição, você aprendeu sobre:

*   Usar enhanced enums para definir e gerenciar cores de console.
*   Aplicar extensions para adicionar novos métodos à classe `String`.
*   Melhorar a formatação e cor da saída para uma melhor experiência do usuário.

## Quiz

**Questão 1:** O que é um enhanced enum em Dart?

*   A) Um enum que pode ter apenas valores string.
*   B) Um enum que pode ter métodos e propriedades.
*   C) Um enum que é gerado automaticamente pelo compilador Dart.
*   D) Um enum que só pode ser usado em aplicações Flutter.

**Questão 2:** O que é uma extension Dart?

*   A) Uma maneira de adicionar novos métodos a classes existentes.
*   B) Uma maneira de criar novas classes a partir de classes existentes.
*   C) Uma maneira de definir novos operadores em Dart.
*   D) Uma maneira de criar novas variáveis em Dart.

## Próxima lição

Na próxima lição, você aprenderá como melhorar ainda mais o
pacote `command_runner` polindo o `HelpCommand`, completando a
classe `CommandRunner`, adicionando o argumento `onOutput` e fornecendo um
exemplo completo.

[ANSI escape codes]: https://en.wikipedia.org/wiki/ANSI_escape_code
