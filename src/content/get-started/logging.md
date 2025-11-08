---
ia-translate: true
title: Logging
short-title: Logging
description: >-
  Aprenda como adicionar logging ao seu aplicativo Dart para ajudar na depuração e
  monitoramento.
sitemap: false
noindex: true
layout: learn
prevpage:
  url: /get-started/http
  title: Http
nextpage:
  url: /get-started
  title: Next chapter
---

{% render 'fwe-wip-warning.md', site: site %}

Neste capítulo, você aprenderá como adicionar logging ao seu aplicativo Dart.
Logging é uma ferramenta crítica para depuração, monitoramento e compreensão do
comportamento do seu aplicativo em diferentes ambientes.

:::secondary O que você aprenderá

*  Adicionar o package `logging` ao seu projeto.
*  Entender diferentes níveis de log e como usá-los.
*  Criar uma instância `Logger` e configurá-la para escrever em um arquivo.
*  Registrar erros e avisos em um arquivo para inspeção posterior.

:::

## Pré-requisitos

Antes de começar este capítulo, certifique-se de:

*  Ter completado o Capítulo 11 e ter um ambiente de desenvolvimento Dart funcional
   com o projeto `dartpedia`.
*  Entender o básico de depuração e por que é importante rastrear erros e
   eventos no seu aplicativo.

## Tarefas

Neste capítulo, você adicionará logging ao aplicativo CLI `dartpedia` para ajudar
a rastrear erros e monitorar seu comportamento. Isso envolverá adicionar o package `logging`,
criar uma instância `Logger` e escrever mensagens de log em um arquivo.

### Tarefa 1: Adicionar o package `logging`

Primeiro, adicione o package `logging` às dependências do seu projeto.

1.  Abra o arquivo `cli/pubspec.yaml`.

2.  Localize a seção `dependencies`.

3.  Adicione o package `logging` às suas dependências:

    ```yaml
    dependencies:
      http: ^1.3.0
      command_runner:
        path: ../command_runner
      wikipedia:
        path: ../wikipedia
      # Add the following line
      logging: ^1.2.0
    ```

4.  Execute `dart pub get` no diretório `cli` para buscar a nova dependência.

### Tarefa 2: Criar um logger

Em seguida, crie uma instância `Logger` e configure-a para escrever mensagens de log
em um arquivo. Isso envolve criar um novo arquivo para o logger e configurar as
importações necessárias.

1.  Crie um novo arquivo chamado `cli/lib/src/logger.dart`.

1.  Adicione as importações necessárias e defina a função `initFileLogger`.

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

1.  Adicione o código para encontrar o diretório raiz do projeto, criar um diretório `logs`
    se não existir, e criar um arquivo de log único.

    ```dart
    Logger initFileLogger(String name) {
      hierarchicalLoggingEnabled = true;
      final logger = Logger(name);
      final now = DateTime.now();

      // Get the path to the project directory from the current script.
      final segments = Platform.script.path.split('/');
      final projectDir = segments.sublist(0, segments.length - 2).join('/');

      // Create a 'logs' directory if it doesn't exist.
      final dir = Directory('$projectDir/logs');
      if (!dir.existsSync()) dir.createSync();

      // Create a log file with a unique name based on the current date and logger name.
      final logFile = File(
        '${dir.path}/${now.year}_${now.month}_${now.day}_$name.txt',
      );

      // The rest of the function will be added below.
      // ...

      return logger;
    }
    ```

1.  Configure o nível do logger e configure um listener para escrever mensagens de log
    no arquivo.

    ```dart
    Logger initFileLogger(String name) {
      hierarchicalLoggingEnabled = true;
      final logger = Logger(name);
      final now = DateTime.now();

      final segments = Platform.script.path.split('/');
      final projectDir = segments.sublist(0, segments.length - 2).join('/');
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

    Este código faz o seguinte:

    *  Ele habilita logging hierárquico usando `hierarchicalLoggingEnabled = true`.
    *  Ele cria uma instância `Logger` com o nome fornecido.
    *  Ele obtém o diretório do projeto a partir de `Platform.script.path`.
    *  Ele cria um diretório `logs` se não existir.
    *  Ele cria um arquivo de log com a data atual e o nome do logger.
    *  Ele define o nível do logger como `Level.ALL`, o que significa que ele registrará todas as mensagens.
       Isso é útil para desenvolvimento e depuração, mas você provavelmente desejará usar
       um nível mais restritivo como `Level.INFO` ou `Level.WARNING` em
       produção.
    *  Ele escuta registros de log e os escreve no arquivo de log.

1. Crie um novo arquivo chamado `cli/lib/cli.dart` e exporte `logger.dart`.
   Isso torna o `initFileLogger` disponível para outras partes do seu aplicativo.

   ```dart title="cli/lib/cli.dart"
    export 'src/commands/get_article.dart';
    export 'src/commands/search.dart';
    export 'src/logger.dart';
   ```

### Tarefa 3: Usar o logger em `cli.dart`

Agora, use a função `initFileLogger` em `cli/bin/cli.dart` para criar uma
instância do logger e registrar mensagens em um arquivo.

1.  Abra o arquivo `cli/bin/cli.dart`.

2.  Adicione a importação para o logger:

    ```dart title="cli/bin/cli.dart"
    import 'package:cli/cli.dart';
    import 'package:command_runner/command_runner.dart';
    ```

3.  Modifique a função `main` para inicializar o logger e passá-lo aos
    comandos:

    ```dart title="cli/bin/cli.dart"
    import 'package:cli/cli.dart';
    import 'package:command_runner/command_runner.dart';

    void main(List<String> arguments) async {
      final errorLogger = initFileLogger('errors');
      final app =
          CommandRunner<String>(
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
                }
              },
            )
            ..addCommand(HelpCommand())
            ..addCommand(SearchCommand(logger: errorLogger))
            ..addCommand(GetArticleCommand(logger: errorLogger));

      app.run(arguments);
    }
    ```

    Este código faz o seguinte:

    *  Ele inicializa uma instância `Logger` usando `initFileLogger('errors')`.
    *  Ele passa a instância `logger` para `CommandRunner` e
       comandos individuais.

### Tarefa 4: Criar o comando SearchCommand

A funcionalidade principal do CLI reside em seus comandos. Crie os
arquivos `SearchCommand` e `GetArticleCommand` e adicione o código necessário,
incluindo o logging e o tratamento de erros.

1.  Crie um novo arquivo chamado `/cli/lib/src/commands/search.dart`.

1.  Adicione as importações e uma estrutura de classe básica. Esta classe `SearchCommand`
    estende `Command<String>`, e seu construtor aceita uma instância `Logger`.
    Aceitar o logger no construtor é um padrão comum chamado
    injeção de dependência, que permite que o comando registre eventos sem precisar
    criar seu próprio logger.

    ```dart
    import 'dart:async';
    import 'dart:io';

    import 'package:command_runner/command_runner.dart';
    import 'package:logging/logging.dart';
    import 'package:wikipedia/wikipedia.dart';

    class SearchCommand extends Command<String> {
      SearchCommand({required this.logger});

      final Logger logger;

      @override
      String get description => 'Search for Wikipedia articles.';

      @override
      String get name => 'search';

      @override
      String get valueHelp => 'STRING';

      @override
      String get help =>
          'Prints a list of links to Wikipedia articles that match the given term.';

      @override
      FutureOr<String> run(ArgResults args) async {
        // The rest of the function will be added below.
        // ...
      }
    }
    ```

1.  Agora, adicione a lógica principal ao método `run`. Este código verifica se há um
    argumento válido, chama a função `search()` do package `wikipedia`,
    formata os resultados e retorna os resultados como uma string.

    ```dart
    import 'dart:async';
    import 'dart:io';

    import 'package:command_runner/command_runner.dart';
    import 'package:logging/logging.dart';
    import 'package:wikipedia/wikipedia.dart';

    class SearchCommand extends Command<String> {
      SearchCommand({required this.logger});

      final Logger logger;

      @override
      String get description => 'Search for Wikipedia articles.';

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
          return 'Please include a search term';
        }

        final buffer = StringBuffer('Search results:');
        final SearchResults results = await search(args.commandArg!);

        for (var result in results.results) {
          buffer.writeln('${result.title} - ${result.url}');
        }
        return buffer.toString();
      }
    }
    ```

1.  Em seguida, adicione o recurso "Estou com sorte" adicionando uma flag ao
    construtor. Então, no método `run`, adicione a lógica para verificar se a flag
    está definida e, em caso afirmativo, obter o resumo do resultado de pesquisa principal.

    ```dart
    import 'dart:async';
    import 'dart:io';

    import 'package:command_runner/command_runner.dart';
    import 'package:logging/logging.dart';
    import 'package:wikipedia/wikipedia.dart';

    class SearchCommand extends Command<String> {
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
          return 'Please include a search term';
        }

        final buffer = StringBuffer('Search results:');
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
    }
    ```

1.  Por fim, envolva a lógica principal em um bloco `try/catch`. Isso permite que você
    trate exceções potenciais que podem surgir de problemas de rede ou dados
    problemas de formatação. Você usará o `logger` injetado para registrar esses erros
    no arquivo de log.

    ```dart
    import 'dart:async';
    import 'dart:io';

    import 'package:command_runner/command_runner.dart';
    import 'package:logging/logging.dart';
    import 'package:wikipedia/wikipedia.dart';

    class SearchCommand extends Command<String> {
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
          return 'Please include a search term';
        }

        final buffer = StringBuffer('Search results:');
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

### Tarefa 5: Criar o comando GetArticleCommand

Agora, crie o arquivo `GetArticleCommand` e adicione o código necessário. O código é
semelhante ao `SearchCommand` anterior, pois também usa um bloco `try/catch` para lidar
com possíveis erros de rede ou dados.

1.  Crie um novo arquivo chamado cli/lib/src/commands/get_article.dart.

2.  Adicione o seguinte código a `get_article.dart`.

    ```dart
    import 'dart:async';
    import 'dart:io';

    import 'package:command_runner/command_runner.dart';
    import 'package:logging/logging.dart';
    import 'package:wikipedia/wikipedia.dart';

    class GetArticleCommand extends Command<String> {
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

    Revise o código que você acabou de adicionar. O `SearchCommand` e
    `GetArticleCommand` agora:

    * Importam os packages necessários como `command_runner`, `logging` e
      `wikipedia` para usar suas classes e funções.
    * Aceitam uma instância `Logger` através de seu construtor. Este é um
      padrão comum chamado injeção de dependência, que permite que o comando registre
      eventos sem precisar criar seu próprio logger.
    * Implementam um método `run` que define a lógica do comando. Este método
      chama a API do wikipedia apropriada e formata a saída.
    * Incluem blocos `try/catch` para lidar com erros de rede
      (`HttpException`) e erros de análise de dados (`FormatException`) de forma graciosa, registrando-os
      para depuração.


### Tarefa 6: Executar o aplicativo e verificar os logs

Agora que você adicionou logging ao seu aplicativo, execute-o e verifique o arquivo de
log para ver os resultados.

1.  Execute o aplicativo com um comando que possa produzir um erro. Por exemplo,
    tente pesquisar por um artigo que não existe ou que causa um
    `FormatException`.

    ```bash
    dart run bin/cli.dart search blahblahblahblah
    ```

2.  Verifique o diretório `logs` no seu projeto. Você deve ver um arquivo com a
    data atual e o nome `errors.txt`.

3.  Abra o arquivo de log e verifique se a mensagem de erro está registrada.

    ```text
    [2025-02-20 16:23:45.678 - errors] WARNING: HttpException: HttpException: , uri = https://en.wikipedia.org/w/api.php?action=opensearch&format=json&search=blahblahblahblah
    [2025-02-20 16:23:45.678 - errors] INFO: Usage: dart bin/cli.dart <command> [commandArg?] [...options?]
    ```

## Revisão

Nesta lição, você aprendeu:

*  Como adicionar o package `logging` ao seu projeto.
*  Como criar uma instância `Logger` e configurá-la para escrever em um arquivo.
*  Como registrar erros e avisos em um arquivo para inspeção posterior.
*  A importância do logging para depuração e monitoramento do seu aplicativo.

## Quiz

**Pergunta 1:** Qual é o propósito do package `logging` no Dart?

*  A) Para lidar com requisições HTTP.
*  B) Para gerenciar dependências no seu projeto.
*  C) Para fornecer uma maneira de registrar eventos e erros no seu aplicativo.
*  D) Para criar uma interface de linha de comando.

**Pergunta 2:** O que a linha `hierarchicalLoggingEnabled = true;` faz?

*  A) Ela habilita logging para um sistema de arquivos hierárquico.
*  B) Ela habilita um logger para capturar eventos de loggers filhos.
*  C) Ela desabilita logging para o console.
*  D) Ela habilita logging de requisições HTTP.

**Pergunta 3:** Quais são alguns benefícios do logging?

*  A) Ajuda a prevenir falhas em tempo de execução
*  B) Ajuda na depuração, monitoramento e compreensão do comportamento do seu
      aplicativo.
*  C) Melhora o desempenho
*  D) Reduz o número de dependências.

## Próxima lição

Parabéns! Você concluiu todos os capítulos principais do tutorial Introdução ao Dart. Como bônus, você pode aprender como transformar seu aplicativo em um
servidor usando `package:shelf` no próximo capítulo.
