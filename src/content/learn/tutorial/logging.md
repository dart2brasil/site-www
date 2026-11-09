---
ia-translate: true
title: Adicione logs para depuração e monitoramento
short-title: Logs
description: >-
  Aprenda como adicionar logs à sua aplicação Dart para
  ajudar na depuração e no monitoramento.
layout: learn
---

Neste capítulo, você vai aprender como adicionar logs à sua aplicação Dart.
Logs são uma ferramenta essencial para depurar, monitorar e
entender o comportamento da aplicação em diferentes ambientes.

<SummaryCard>
title: O que você vai realizar
items:
  - title: Adicionar e conhecer o pacote logging
    icon: note_stack
  - title: Configurar níveis de log e saída em arquivo
    icon: tune
  - title: Integrar logs aos seus comandos de CLI
    icon: terminal
</SummaryCard>

## Pré-requisitos {:#prerequisites}

Antes de começar este capítulo, certifique-se de:

- Ter concluído o Capítulo 12 e ter um
  ambiente de desenvolvimento Dart funcionando com o projeto `dartpedia`.
- Entender o básico de depuração e por que é
  importante registrar erros e eventos da aplicação.

## Tarefas {:#tasks}

Neste capítulo, você vai concluir a aplicação de CLI `dartpedia` integrando
os comandos do pacote `wikipedia` e adicionando logs para
ajudar a registrar erros e monitorar o comportamento da aplicação.
Isso envolve adicionar dependências de pacotes,
criar os comandos de CLI, configurar uma instância de `Logger`
e executar a aplicação completa.

### Tarefa 1: Adicione dependências ao pacote `cli` {:#task-1-add-dependencies-to-the-cli-package}

Primeiro, adicione o pacote `wikipedia` (que você construiu nos capítulos anteriores)
e o pacote `logging` às dependências do projeto da CLI.

1.  Abra o arquivo `cli/pubspec.yaml`.

1.  Localize a seção `dependencies`.

1.  Adicione os pacotes `wikipedia` e `logging` às suas dependências:

    ```yaml title="cli/pubspec.yaml"
    dependencies:
      http: ^1.3.0
      command_runner:
        path: ../command_runner
      # Add the following lines
      wikipedia:
        path: ../wikipedia
      logging: ^1.2.0
    ```

1.  Execute `dart pub get` no diretório `cli` para buscar as novas dependências.

### Tarefa 2: Crie um logger {:#task-2-create-a-logger}

Em seguida, crie uma instância de `Logger` e configure-a para
gravar mensagens de log em um arquivo. Isso envolve
criar um novo arquivo para o logger e configurar os imports necessários.

1.  Crie um novo arquivo chamado `cli/lib/src/logger.dart`.

1.  Adicione os imports necessários e defina a função `initFileLogger`.

    ```dart title="cli/lib/src/logger.dart"
    import 'dart:io';
    import 'package:logging/logging.dart';

    Logger initFileLogger(String name) {
      // Enables logging from child loggers.
      hierarchicalLoggingEnabled = true;

      // Create a logger instance with the provided name.
      final logger = Logger(name);
      final now = DateTime.now();

      // The rest of the function will be added below.
      // ...

      return logger;
    }
    ```

1.  Adicione o código para encontrar o diretório raiz do projeto,
    criar um diretório `logs` caso ele não exista e
    criar um arquivo de log com um nome único.

    ```dart title="cli/lib/src/logger.dart"
    Logger initFileLogger(String name) {
      hierarchicalLoggingEnabled = true;
      final logger = Logger(name);
      final now = DateTime.now();

      // Get the path to the project directory from the current script.
      final scriptFile = File(Platform.script.toFilePath());
      final projectDir = scriptFile.parent.parent.path;

      // Create a 'logs' directory if it doesn't exist.
      final dir = Directory('$projectDir/logs');
      if (!dir.existsSync()) dir.createSync();

      // Create a log file with a unique name based on
      // the current date and logger name.
      final logFile = File(
        '${dir.path}/${now.year}_${now.month}_${now.day}_$name.txt',
      );

      // The rest of the function will be added below.
      // ...

      return logger;
    }
    ```

1.  Configure o nível do logger e configure um listener para
    gravar as mensagens de log no arquivo.

    ```dart title="cli/lib/src/logger.dart"
    Logger initFileLogger(String name) {
      hierarchicalLoggingEnabled = true;
      final logger = Logger(name);
      final now = DateTime.now();

      final scriptFile = File(Platform.script.toFilePath());
      final projectDir = scriptFile.parent.parent.path;
      final dir = Directory('$projectDir/logs');
      if (!dir.existsSync()) dir.createSync();
      final logFile = File(
        '${dir.path}/${now.year}_${now.month}_${now.day}_$name.txt',
      );

      // Set the logger level to ALL, so it logs all messages regardless of severity.
      // Level.ALL is useful for development and debugging, but you'll likely want to
      // use a more restrictive level like Level.INFO or Level.WARNING in production.
      logger.level = Level.ALL;

      // Listen for log records and write each one to the log file.
      logger.onRecord.listen((record) {
        final msg =
            '[${record.time} - ${record.loggerName}] ${record.level.name}: ${record.message}';
        logFile.writeAsStringSync('$msg \n', mode: FileMode.append);
      });

      return logger;
    }
    ```

    A função `initFileLogger` retorna uma instância de `Logger` configurada
    que acrescenta registros com data e hora em um arquivo no diretório `logs/`:

    - **`logger.level = Level.ALL`**:
      Captura todas as mensagens, independentemente da severidade, durante o desenvolvimento.
      Aplicações em produção normalmente usam limites mais altos, como
      `Level.INFO` ou `Level.WARNING`.
    - **`logger.onRecord.listen(...)`**:
      Assina o stream de eventos de log, formatando cada entrada com
      seu horário, o nome do logger e o nível de severidade antes de gravá-la no disco.

### Tarefa 3: Crie o comando SearchCommand {:#task-3-create-the-searchcommand-command}

A funcionalidade principal da CLI está nos seus comandos.
Crie os arquivos `SearchCommand` e `GetArticleCommand` e
adicione o código necessário, incluindo logs e tratamento de erros.

1.  Crie um novo arquivo chamado `cli/lib/src/commands/search.dart`.

1.  Adicione os imports e uma estrutura básica de classe.
    Esta classe `SearchCommand` estende `Command`, e
    o construtor dela recebe uma instância de `Logger`.
    Receber o logger pelo construtor é um
    padrão comum chamado injeção de dependência,
    que permite ao comando registrar eventos sem
    precisar criar o próprio logger.

    ```dart title="cli/lib/src/commands/search.dart"
    import 'dart:async';
    import 'dart:io';

    import 'package:command_runner/command_runner.dart';
    import 'package:logging/logging.dart';
    import 'package:wikipedia/wikipedia.dart';

    class SearchCommand extends Command {
      SearchCommand({required this.logger}) {
        addFlag(
          'im-feeling-lucky',
          help:
              'If true, prints the summary of the top article that the search returns.',
        );
      }

      final Logger logger;

      @override
      String get description => 'Search for Wikipedia articles.';

      @override
      bool get requiresArgument => true;

      @override
      String get name => 'search';

      @override
      String get valueHelp => 'STRING';

      @override
      String get help =>
          'Prints a list of links to Wikipedia articles that match the given term.';

      @override
      FutureOr<String> run(ArgResults args) async {
        // Command logic will be added below.
        // ...
        return '';
      }
    }
    ```

1.  Implemente a lógica do comando para buscar na Wikipedia e formatar os resultados.

    ```dart title="cli/lib/src/commands/search.dart"
    // ...
      @override
      FutureOr<String> run(ArgResults args) async {
        if (requiresArgument &&
            (args.commandArg == null || args.commandArg!.isEmpty)) {
          throw ArgumentException('Please include a search term', name);
        }

        final buffer = StringBuffer('Search results:\n');
        final SearchResults results = await search(args.commandArg!);

        if (args.flag('im-feeling-lucky')) {
          final title = results.results.first.title;
          final Summary article = await getArticleSummaryByTitle(title);
          buffer.writeln('Lucky you!');
          buffer.writeln(article.titles.normalized.titleText);
          if (article.description != null) {
            buffer.writeln(article.description);
          }
          buffer.writeln(article.extract);
          buffer.writeln();
          buffer.writeln('All results:');
        }

        for (var result in results.results) {
          buffer.writeln('${result.title} - ${result.url}');
        }
        return buffer.toString();
      }
    // ...
    ```

1.  Por fim, envolva a lógica principal em um bloco `try/catch`.
    Isso permite tratar possíveis exceções que
    podem surgir de problemas de rede ou de formatação dos dados.
    Você vai usar o `logger` injetado para registrar esses erros no arquivo de log.

    ```dart title="cli/lib/src/commands/search.dart"
    import 'dart:async';
    import 'dart:io';

    import 'package:command_runner/command_runner.dart';
    import 'package:logging/logging.dart';
    import 'package:wikipedia/wikipedia.dart';

    class SearchCommand extends Command {
      SearchCommand({required this.logger}) {
        addFlag(
          'im-feeling-lucky',
          help:
              'If true, prints the summary of the top article that the search returns.',
        );
      }

      final Logger logger;

      @override
      String get description => 'Search for Wikipedia articles.';

      @override
      bool get requiresArgument => true;

      @override
      String get name => 'search';

      @override
      String get valueHelp => 'STRING';

      @override
      String get help =>
          'Prints a list of links to Wikipedia articles that match the given term.';

      @override
      FutureOr<String> run(ArgResults args) async {
        if (requiresArgument &&
            (args.commandArg == null || args.commandArg!.isEmpty)) {
          throw ArgumentException('Please include a search term', name);
        }

        final buffer = StringBuffer('Search results:\n');
        try {
          final SearchResults results = await search(args.commandArg!);

          if (args.flag('im-feeling-lucky')) {
            final title = results.results.first.title;
            final Summary article = await getArticleSummaryByTitle(title);
            buffer.writeln('Lucky you!');
            buffer.writeln(article.titles.normalized.titleText);
            if (article.description != null) {
              buffer.writeln(article.description);
            }
            buffer.writeln(article.extract);
            buffer.writeln();
            buffer.writeln('All results:');
          }

          for (var result in results.results) {
            buffer.writeln('${result.title} - ${result.url}');
          }
          return buffer.toString();
        } on HttpException catch (e) {
          logger
            ..warning(e.message)
            ..warning(e.uri)
            ..info(usage);
          return e.message;
        } on FormatException catch (e) {
          logger
            ..warning(e.message)
            ..warning(e.source)
            ..info(usage);
          return e.message;
        }
      }
    }
    ```

### Tarefa 4: Crie o comando GetArticleCommand {:#task-4-create-the-getarticlecommand-command}

Agora, crie o arquivo `GetArticleCommand` e adicione o código necessário.
O código é parecido com o do `SearchCommand` anterior, pois também
usa um bloco `try/catch` para tratar possíveis erros de rede ou de dados.

1.  Crie um novo arquivo chamado `cli/lib/src/commands/get_article.dart`.

1.  Adicione o seguinte código em `get_article.dart`:

    ```dart title="cli/lib/src/commands/get_article.dart"
    import 'dart:async';
    import 'dart:io';

    import 'package:command_runner/command_runner.dart';
    import 'package:logging/logging.dart';
    import 'package:wikipedia/wikipedia.dart';

    class GetArticleCommand extends Command {
      GetArticleCommand({required this.logger});

      final Logger logger;

      @override
      String get description => 'Read an article from Wikipedia';

      @override
      String get name => 'article';

      @override
      String get help => 'Gets an article by exact canonical wikipedia title.';

      @override
      String get defaultValue => 'cat';

      @override
      String get valueHelp => 'STRING';

      @override
      FutureOr<String> run(ArgResults args) async {
        try {
          var title = args.commandArg ?? defaultValue;
          final List<Article> articles = await getArticleByTitle(title);
          // API returns a list of articles, but we only care about the closest hit.
          final article = articles.first;
          final buffer = StringBuffer('\n=== ${article.title.titleText} ===\n\n');
          buffer.write(article.extract.split(' ').take(500).join(' '));
          return buffer.toString();
        } on HttpException catch (e) {
          logger
            ..warning(e.message)
            ..warning(e.uri)
            ..info(usage);
          return e.message;
        } on FormatException catch (e) {
          logger
            ..warning(e.message)
            ..warning(e.source)
            ..info(usage);
          return e.message;
        }
      }
    }
    ```

    Revise o código que você acabou de adicionar.
    Os comandos `SearchCommand` e `GetArticleCommand` agora:

    - Importam os pacotes necessários, como `command_runner`, `logging` e
      `wikipedia`, para usar suas classes e funções.
    - Recebem uma instância de `Logger` pelo construtor.
      Esse é um padrão comum chamado injeção de dependência,
      que permite ao comando registrar eventos sem
      precisar criar o próprio logger.
    - Implementam um método `run` que define a lógica do comando.
      Esse método chama a API apropriada da Wikipedia e formata a saída.
    - Incluem blocos `try/catch` para tratar com elegância
      erros de rede (`HttpException`) e
      erros de análise de dados (`FormatException`), registrando-os para depuração.

### Tarefa 5: Exporte os comandos e conecte tudo no `cli.dart` {:#task-5-export-commands-and-wire-up-cli-dart}

Agora, exporte o logger e os comandos da biblioteca `cli`
e, em seguida, conecte-os em `cli/bin/cli.dart` para
criar a aplicação de CLI completa.

1.  Abra o arquivo `cli/lib/cli.dart`.
    Substitua o conteúdo provisório pelas exportações do seu logger e dos seus comandos:

    ```dart title="cli/lib/cli.dart"
    export 'src/commands/get_article.dart';
    export 'src/commands/search.dart';
    export 'src/logger.dart';
    ```

    Esse arquivo funciona como a interface pública da biblioteca,
    exportando `initFileLogger`, `SearchCommand` e `GetArticleCommand`
    para que `cli/bin/cli.dart` possa importá-los de `package:cli/cli.dart`.

1.  Abra o arquivo `cli/bin/cli.dart`.

1.  Adicione os imports de `cli` e `command_runner`:

    ```dart title="cli/bin/cli.dart"
    import 'package:cli/cli.dart';
    import 'package:command_runner/command_runner.dart';
    ```

1.  Modifique a função `main` para inicializar o logger e
    registrar os comandos no `CommandRunner`:

    ```dart title="cli/bin/cli.dart"
    import 'package:cli/cli.dart';
    import 'package:command_runner/command_runner.dart';

    void main(List<String> arguments) async {
      final errorLogger = initFileLogger('errors');
      final app =
          CommandRunner(
              onOutput: (String output) async {
                await write(output);
              },
              onError: (Object error) {
                if (error is Error) {
                  errorLogger.severe(
                    '[Error] ${error.toString()}\n${error.stackTrace}',
                  );
                  throw error;
                }
                if (error is Exception) {
                  errorLogger.warning(error);
                  print(error);
                }
              },
            )
            ..addCommand(HelpCommand())
            ..addCommand(SearchCommand(logger: errorLogger))
            ..addCommand(GetArticleCommand(logger: errorLogger));

      app.run(arguments);
    }
    ```

    Essa configuração inicializa um logger de arquivo `errors`, passa-o para
    `SearchCommand` e `GetArticleCommand`, e registra todos os comandos
    no `CommandRunner`.

### Tarefa 6: Execute a aplicação e verifique os logs {:#task-6-run-the-application-and-check-the-logs}

Agora que você implementou os comandos de CLI,
conectou o `CommandRunner` em `bin/cli.dart` e configurou o logging,
teste a aplicação pelo terminal.
Certifique-se de executar estes comandos a partir do diretório `cli`
(`/dartpedia/cli`).

1.  Execute a aplicação de CLI para buscar um artigo:

    ```bash
    dart run bin/cli.dart search "Dart programming"
    ```

    Você deve ver no terminal uma lista de artigos da Wikipedia
    que correspondem ao seu termo de busca.

1.  Tente executar o comando com a flag `--im-feeling-lucky`:

    ```bash
    dart run bin/cli.dart search "Dart" --im-feeling-lucky
    ```

1.  Execute a aplicação sem o argumento de busca obrigatório para testar
    o log de erros:

    ```bash
    dart run bin/cli.dart search
    ```

    Você deve ver o erro impresso no terminal:

    ```console
    ArgumentException: Please include a search term
    ```

1.  Verifique o diretório `cli/logs` do seu projeto.
    Você deve ver um arquivo com a data atual no nome,
    como `<ano>_<mês>_<dia>_errors.txt`.

1.  Abra o arquivo de log e verifique se a mensagem de erro foi registrada:

    ```text
    [2025-02-20 16:23:45.678 - errors] WARNING: ArgumentException: Please include a search term
    ```

    :::note
    Erros de rede capturados por `SearchCommand` ou `GetArticleCommand`
    (por exemplo, quando seu dispositivo está offline ou a Wikipedia está inacessível)
    também são registrados nesse arquivo como entradas de nível `WARNING`,
    seguidas de uma entrada `INFO` com o uso do comando.
    :::

1.  Verifique se a estrutura do seu workspace corresponde ao projeto concluído:

    ```text
    dartpedia/
    ├── pubspec.yaml               # Workspace root configuration
    ├── cli/
    │   ├── bin/
    │   │   └── cli.dart           # Application entrypoint
    │   ├── lib/
    │   │   ├── cli.dart           # Library exports
    │   │   └── src/
    │   │       ├── commands/
    │   │       │   ├── get_article.dart
    │   │       │   └── search.dart
    │   │       └── logger.dart    # Logging configuration
    │   ├── logs/
    │   │   └── <date>_errors.txt  # Generated error logs
    │   └── pubspec.yaml
    ├── command_runner/
    │   ├── lib/
    │   │   ├── command_runner.dart
    │   │   └── src/
    │   │       ├── arguments.dart
    │   │       ├── command_runner_base.dart
    │   │       ├── console.dart
    │   │       ├── exceptions.dart
    │   │       └── help_command.dart
    │   └── pubspec.yaml
    └── wikipedia/
        ├── lib/
        │   ├── wikipedia.dart
        │   └── src/
        │       ├── api/
        │       │   ├── get_article.dart
        │       │   ├── search.dart
        │       │   └── summary.dart
        │       └── model/
        │           ├── article.dart
        │           ├── search_results.dart
        │           ├── summary.dart
        │           └── title_set.dart
        └── pubspec.yaml
    ```

## Revisão {:#review}

<SummaryCard>
title: O que você realizou
subtitle: Veja um resumo do que você construiu e aprendeu nesta lição.
completed: true
items:
  - title: Adicionou e conheceu o pacote logging
    icon: note_stack
    details: >-
      Você adicionou `logging` às suas dependências e o importou na CLI.
      O pacote oferece as classes `Logger`, `Level` e `LogRecord` para
      logs estruturados com níveis de severidade configuráveis.
  - title: Configurou níveis de log e saída em arquivo
    icon: tune
    details: >-
      Você criou `initFileLogger()` para configurar logs hierárquicos
      em arquivos com data e hora no diretório `logs/`.
      Isso permite revisar o comportamento da aplicação depois que os fatos acontecem.
  - title: Integrou logs aos seus comandos de CLI
    icon: terminal
    details: >-
      Você passou o logger para os comandos usando injeção de dependência,
      e depois usou `logger.warning()`, `logger.severe()` e `logger.info()` para
      registrar erros de diferentes níveis junto com o contexto relevante.
      Essa configuração ajuda a depurar e filtrar problemas com mais facilidade,
      tanto no desenvolvimento quanto em produção.
</SummaryCard>

## Quiz {:#quiz}

<Quiz title="Confira seu entendimento" id="logging" />

## Próxima lição {:#next-lesson}

Parabéns! Você concluiu todos os
capítulos principais do tutorial de introdução ao Dart.
Quer continuar aprendendo?
Confira o próximo passo na
[trilha de aprendizado de Dart e Flutter][Dart and Flutter learning pathway] no site do Flutter.

[Dart and Flutter learning pathway]: {{site.flutter-docs}}/learn/pathway
