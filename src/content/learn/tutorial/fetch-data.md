---
ia-translate: true
title: Busque dados da internet
shortTitle: Requisições HTTP
description: >-
  Refatore seu aplicativo para usar um cliente de API robusto e pronto
  para produção no CLI da Wikipedia.
layout: learn
---

No Capítulo 3, você usou o pacote `http` para fazer uma requisição simples.
Agora, você vai revisitar o HTTP para
construir um cliente de API robusto e pronto para produção dentro do pacote `wikipedia`.
Você vai aprender como lidar com parâmetros de consulta,
mapear respostas JSON para seus modelos de dados e
exportar essas funções para uso na sua CLI.

<SummaryCard>
title: O que você vai realizar
items:
  - title: Construir URIs complexas com parâmetros de consulta
    icon: link
  - title: Criar um cliente de API HTTP pronto para produção
    icon: cloud_download
  - title: Exportar funções e tipos para reutilização
    icon: export_notes
</SummaryCard>

## Pré-requisitos {:#prerequisites}

Antes de começar este capítulo, certifique-se de:

-   Ter concluído o Capítulo 11 e ter um
    ambiente de desenvolvimento Dart funcionando com o projeto `dartpedia`.
-   Entender conceitos básicos de redes (como APIs e requisições HTTP).
-   Entender formatos básicos de serialização de dados, como JSON.

## Tarefas {:#tasks}

Neste capítulo, você vai deixar de lado os scripts simples e
implementar uma camada de API adequada.
Você vai trabalhar dentro do pacote `wikipedia` para
implementar a lógica do cliente de API, o que
melhora a escalabilidade e a manutenibilidade do seu aplicativo.

### Tarefa 1: Adicione a dependência http ao pacote wikipedia {:#task-1-add-the-http-dependency-to-the-wikipedia-package}

Para fazer requisições HTTP, você precisa
adicionar o pacote `http` como dependência do pacote `wikipedia`.

1.  Abra o arquivo `wikipedia/pubspec.yaml` no seu projeto.

1.  Localize a seção `dependencies`.

1.  Adicione `http: ^1.3.0` (ou a versão estável mais recente) em `dependencies`.

    ```yaml title="wikipedia/pubspec.yaml"
    dependencies:
      http: ^1.3.0
    ```

1.  Salve o arquivo `pubspec.yaml`.

1.  Execute `dart pub get` no terminal, a partir do diretório `wikipedia`.

### Tarefa 2: Implemente as chamadas à API da Wikipedia {:#task-2-implement-wikipedia-api-calls}

Em seguida, você vai criar as funções de API para buscar dados da Wikipedia.
Você vai criar três arquivos:

- `summary.dart`:
  este arquivo vai conter funções para recuperar resumos de artigos.
- `search.dart`:
  este arquivo vai tratar as consultas de busca para encontrar artigos.
- `get_article.dart`:
  este arquivo vai conter funções para buscar o conteúdo completo de um artigo.

1.  Crie o diretório `wikipedia/lib/src/api`.

1.  Crie o arquivo `wikipedia/lib/src/api/summary.dart`.

1.  Adicione o seguinte código em `wikipedia/lib/src/api/summary.dart`:

    ```dart title="wikipedia/lib/src/api/summary.dart"
    import 'dart:convert';
    import 'dart:io';

    import 'package:http/http.dart' as http;

    import '../model/summary.dart';

    Future<Summary> getRandomArticleSummary() async {
      final http.Client client = http.Client();
      try {
        final Uri url = Uri.https(
          'en.wikipedia.org',
          '/api/rest_v1/page/random/summary',
        );
        final http.Response response = await client.get(url);
        if (response.statusCode == 200) {
          final Map<String, Object?> jsonData =
              jsonDecode(response.body) as Map<String, Object?>;
          return Summary.fromJson(jsonData);
        } else {
          throw HttpException(
            '[WikipediaApiClient.getRandomArticleSummary] '
            'statusCode=${response.statusCode}, body=${response.body}',
          );
        }
      } on FormatException {
        // todo: log exceptions
        rethrow;
      } finally {
        client.close();
      }
    }

    Future<Summary> getArticleSummaryByTitle(String articleTitle) async {
      final http.Client client = http.Client();
      try {
        final Uri url = Uri.https(
          'en.wikipedia.org',
          '/api/rest_v1/page/summary/$articleTitle',
        );
        final http.Response response = await client.get(url);
        if (response.statusCode == 200) {
          final Map<String, Object?> jsonData =
              jsonDecode(response.body) as Map<String, Object?>;
          return Summary.fromJson(jsonData);
        } else {
          throw HttpException(
            '[WikipediaApiClient.getArticleSummaryByTitle] '
            'statusCode=${response.statusCode}, body=${response.body}',
          );
        }
      } on FormatException {
        // todo: log exceptions
        rethrow;
      } finally {
        client.close();
      }
    }
    ```

    Este código define duas funções:
    `getRandomArticleSummary` e `getArticleSummaryByTitle`.
    Ambas usam o pacote `http` para
    fazer requisições GET à API da Wikipedia e retornar um objeto `Summary`.
    `getRandomArticleSummary` busca o resumo de um artigo aleatório, enquanto
    `getArticleSummaryByTitle` busca o resumo de um título de artigo específico.

1.  Em seguida, crie o arquivo `wikipedia/lib/src/api/search.dart`.

1.  Adicione o seguinte código em `wikipedia/lib/src/api/search.dart`:

    ```dart title="wikipedia/lib/src/api/search.dart"

    import 'dart:convert';
    import 'dart:io';

    import 'package:http/http.dart' as http;

    import '../model/search_results.dart';

    Future<SearchResults> search(String searchTerm) async {
      final http.Client client = http.Client();
      try {
        final Uri url = Uri.https(
          'en.wikipedia.org',
          '/w/api.php',
          <String, Object?>{
            'action': 'opensearch',
            'format': 'json',
            'search': searchTerm,
          },
        );
        final http.Response response = await client.get(url);
        if (response.statusCode == 200) {
          final List<Object?> jsonData = jsonDecode(response.body) as List<Object?>;
          return SearchResults.fromJson(jsonData);
        } else {
          throw HttpException(
            '[WikipediaApiClient.search] '
            'statusCode=${response.statusCode}, '
            'body=${response.body}',
          );
        }
      } on FormatException {
        rethrow;
      } finally {
        client.close();
      }
    }
    ```

    Este código define a função `search`, que
    usa o pacote `http` para fazer uma requisição GET ao endpoint
    `opensearch` da API da Wikipedia e retorna um objeto `SearchResults`.
    O endpoint `opensearch` é usado para buscar
    artigos da Wikipedia com base em um termo de busca.

1.  Crie o arquivo `wikipedia/lib/src/api/get_article.dart`.

1.  Adicione o seguinte código em `wikipedia/lib/src/api/get_article.dart`:

    ```dart title="wikipedia/lib/src/api/get_article.dart"
    import 'dart:convert';
    import 'dart:io';

    import 'package:http/http.dart' as http;

    import '../model/article.dart';

    Future<List<Article>> getArticleByTitle(String title) async {
      final http.Client client = http.Client();
      try {
        final Uri url = Uri.https(
          'en.wikipedia.org',
          '/w/api.php',
          <String, Object?>{
            // order matters - explaintext must come after prop
            'action': 'query',
            'format': 'json',
            'titles': title.trim(),
            'prop': 'extracts',
            'explaintext': '',
          },
        );
        final http.Response response = await client.get(url);
        if (response.statusCode == 200) {
          final Map<String, Object?> jsonData =
              jsonDecode(response.body) as Map<String, Object?>;
          return Article.listFromJson(jsonData);
        } else {
          throw HttpException(
            '[WikipediaApiClient.getArticleByTitle] '
            'statusCode=${response.statusCode}, '
            'body=${response.body}',
          );
        }
      } on FormatException {
        // TODO: log
        rethrow;
      } finally {
        client.close();
      }
    }
    ```

    Este código define a função `getArticleByTitle`, que usa o pacote `http`
    para fazer uma requisição GET à API da Wikipedia e retorna um
    objeto `List<Article>`. Essa função recupera o conteúdo de um
    artigo da Wikipedia com base no seu título.

### Tarefa 3: Exporte as funções de API {:#task-3-export-the-api-functions}

Agora que você criou as funções de API,
precisa exportá-las da biblioteca `wikipedia` para que
possam ser usadas pelo pacote `cli`.
Você também vai exportar os modelos existentes.

1.  Abra o arquivo `wikipedia/lib/wikipedia.dart`.

1.  Adicione as seguintes declarações `export` ao arquivo:

    ```dart title="wikipedia/lib/wikipedia.dart"
    export 'src/api/get_article.dart';
    export 'src/api/search.dart';
    export 'src/api/summary.dart';
    export 'src/model/article.dart';
    export 'src/model/search_results.dart';
    export 'src/model/summary.dart';
    export 'src/model/title_set.dart';
    ```

    Essas declarações `export` tornam as funções de API e os modelos disponíveis para
    outros pacotes que dependem do pacote `wikipedia`.


## Tarefa 4: Verifique com testes {:#task-4-verify-with-tests}

Agora que você implementou as funções de API e atualizou as
dependências do pacote, é uma boa prática executar os testes que você criou no capítulo
anterior. Isso confirma que suas mudanças não quebraram a funcionalidade
existente do pacote `wikipedia`.

1.  Abra o terminal e navegue até o diretório `wikipedia/test`.

1.  Remova o arquivo de teste padrão executando o comando `rm wikipedia_test.dart`
    (no macOS ou Linux) ou `del wikipedia_test.dart` (no Windows).
    Esse arquivo foi gerado automaticamente, mas não é usado no nosso projeto.

1.  Abra o terminal e navegue até o diretório `wikipedia`.

1.  Execute o comando `dart test`.

    Você deve ver uma saída parecida com esta,
    confirmando que todos os seus testes existentes continuam passando:

    ```bash
    00:02 +3: All tests passed!
    This confirms that the wikipedia package is still working as expected.
    ```

## Revisão {:#review}

<SummaryCard>
title: O que você realizou
subtitle: Veja um resumo do que você construiu e aprendeu nesta lição.
completed: true
items:
  - title: Construiu URIs complexas com parâmetros de consulta
    icon: link
    details: >-
      Você usou `Uri.https()` com um mapa de parâmetros de consulta para montar
      as URLs da API. Essa abordagem codifica corretamente os caracteres especiais e
      lida com combinações complexas de parâmetros.
  - title: Criou um cliente de API pronto para produção
    icon: cloud_download
    details: >-
      Você implementou várias funções que gerenciam corretamente o ciclo de vida
      do cliente HTTP com `try` e `finally`, e
      mapeia as respostas JSON brutas para objetos Dart tipados.
  - title: Exportou funções e tipos para reutilização
    icon: export_notes
    details: >-
      Você adicionou declarações export em `wikipedia.dart` para
      expor tanto as funções de API quanto os tipos de modelo de dados.
      Isso cria uma biblioteca pública que o seu
      pacote `cli` pode importar e usar diretamente.
</SummaryCard>

## Quiz {:#quiz}

<Quiz title="Confira seu entendimento" id="fetch-data" />

## Próxima lição {:#next-lesson}

Na próxima lição, você vai concluir sua CLI integrando os comandos do pacote `wikipedia`
com o pacote `cli` e adicionando logging para depuração e monitoramento de erros.
