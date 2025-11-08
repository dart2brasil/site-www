---
ia-translate: true
title: Http
shortTitle: Http
description: >-
  Implementar chamadas à API da Wikipedia para completar a funcionalidade principal da
  CLI da Wikipedia.
sitemap: false
noindex: true
layout: learn
prevpage:
  url: /get-started/testing
  title: Testing
nextpage:
  url: /get-started/logging
  title: Logging
---

{% render 'fwe-wip-warning.md', site: site %}

Neste capítulo, você implementará a funcionalidade principal da CLI da Wikipedia fazendo
chamadas à API para recuperar dados. Você adicionará o pacote `http` como uma
dependência, criará funções de API e então exportará essas funções para que possam ser
usadas pelo pacote `cli`.

:::secondary O que você aprenderá

*   Construir objetos `Uri` para requisições de API.
*   Fazer requisições HTTP GET usando o pacote `http`.
*   Lidar com respostas de API e decodificar dados JSON.
*   Exportar funções e modelos de uma biblioteca Dart.

:::

## Pré-requisitos

Antes de começar este capítulo, certifique-se de:

*   Ter completado o Capítulo 10 e ter um ambiente de desenvolvimento Dart funcionando
    com o projeto `dartpedia`.
*   Entender conceitos básicos de networking (como APIs e requisições HTTP).
*   Entender formatos básicos de serialização de dados como JSON.

## Tarefas

Neste capítulo, você adicionará a funcionalidade principal da CLI da Wikipedia
fazendo chamadas à API para recuperar dados. Você trabalhará dentro do pacote `wikipedia` para
implementar a lógica do cliente de API.

### Tarefa 1: Adicionar a dependência http ao pacote wikipedia

Para fazer requisições HTTP, você precisa adicionar o pacote `http` como uma dependência ao
pacote `wikipedia`.

1.  Abra o arquivo `wikipedia/pubspec.yaml` dentro do seu projeto.

1.  Localize a seção `dependencies`.

1.  Adicione `http: ^1.3.0` (ou a versão estável mais recente) sob `dependencies`.

    ```yaml
    dependencies:
      http: ^1.3.0
    ```

1.  Salve o arquivo `pubspec.yaml`.

1.  Execute `dart pub get` no seu terminal a partir do diretório `wikipedia`.

### Tarefa 2: Implementar chamadas à API da Wikipedia

A seguir, você criará as funções de API para buscar dados da Wikipedia. Você
criará três arquivos:

* `summary.dart`: Este arquivo conterá funções para recuperar resumos de
  artigos.
* `search.dart`: Este arquivo lidará com consultas de busca para encontrar artigos.
* `get_article.dart`: Este arquivo conterá funções para buscar o conteúdo completo
  de um artigo.

1.  Crie o diretório `wikipedia/lib/src/api`.

1.  Crie o arquivo `wikipedia/lib/src/api/summary.dart`.

1.  Adicione o seguinte código ao `wikipedia/lib/src/api/summary.dart`:

    ```dart
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
            '[WikipediaDart.getRandomArticle] '
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
            '[WikipediaDart.getArticleSummary] '
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

    Este código define duas funções: `getRandomArticleSummary` e
    `getArticleSummaryByTitle`. Ambas as funções usam o pacote `http` para fazer
    requisições GET à API da Wikipedia e retornar um objeto `Summary`.
    `getRandomArticleSummary` busca um resumo de um artigo aleatório, enquanto
    `getArticleSummaryByTitle` busca um resumo de um título de artigo específico.

1.  A seguir, crie o arquivo `wikipedia/lib/src/api/search.dart`.

1.  Adicione o seguinte código ao `wikipedia/lib/src/api/search.dart`:

    ```dart

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
            '[WikimediaApiClient.getArticleByTitle] '
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

    Este código define a função `search`, que usa o
    pacote `http` para fazer uma requisição GET ao endpoint
    `opensearch` da API da Wikipedia e retorna um objeto `SearchResults`.
    O endpoint `opensearch` é usado para buscar
    artigos da Wikipedia baseado em um termo de busca.

1.  Crie o arquivo `wikipedia/lib/src/api/get_article.dart`.

1.  Adicione o seguinte código ao `wikipedia/lib/src/api/get_article.dart`:

    ```dart
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
            '[ApiClient.getArticleByTitle] '
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
    objeto `List<Article>`. Esta função recupera o conteúdo de um artigo da Wikipedia
    baseado em seu título.

### Tarefa 3: Exportar as funções de API

Agora que você criou as funções de API, você precisa exportá-las da
biblioteca `wikipedia` para que possam ser usadas pelo pacote `cli`. Você também exportará
os modelos existentes.

1.  Abra o arquivo `wikipedia/lib/wikipedia.dart`.

1.  Adicione as seguintes declarações `export` ao arquivo:

    ```dart
    export 'src/api/get_article.dart';
    export 'src/api/search.dart';
    export 'src/api/summary.dart';
    export 'src/model/article.dart';
    export 'src/model/search_results.dart';
    export 'src/model/summary.dart';
    export 'src/model/title_set.dart';
    ```

    Essas declarações `export` tornam as funções de API e modelos disponíveis para
    outros pacotes que dependem do pacote `wikipedia`.


## Tarefa 4: Verificar com testes

Agora que você implementou as funções de API e atualizou as
dependências do pacote, é uma boa prática executar os testes que você criou no capítulo
anterior. Isso confirmará que suas mudanças não quebraram a funcionalidade
existente do pacote `wikipedia`.

1.  Abra seu terminal e navegue até o diretório `wikipedia/test`.

1.  Remova o arquivo de teste padrão executando o comando `rm wikipedia_test.dart`
    (no macOS ou Linux) ou `del wikipedia_test.dart` (no Windows). Este arquivo foi
    gerado automaticamente mas não é usado no nosso projeto.

1.  Abra seu terminal e navegue até o diretório `wikipedia`.

1.  Execute o comando `dart test`.

    Você deve ver uma saída similar a esta, confirmando que todos os seus testes existentes
    ainda passam:

    ```bash
    00:02 +3: All tests passed!
    This confirms that the wikipedia package is still working as expected.
    ```

## Revisão

Neste capítulo, você aprendeu como:

*   Adicionar uma dependência de pacote ao `pubspec.yaml`.
*   Construir objetos `Uri` para requisições de API.
*   Fazer requisições HTTP GET usando o pacote `http`.
*   Lidar com respostas de API e decodificar dados JSON.
*   Exportar funções e modelos de uma biblioteca Dart.

## Quiz

**Questão 1:** Qual arquivo é usado para gerenciar dependências em um projeto Dart?

*   A) `main.dart`
*   B) `pubspec.yaml`
*   C) `README.md`
*   D) `LICENSE`

**Questão 2:** Qual biblioteca Dart é usada para fazer requisições HTTP?

*   A) `dart:io`
*   B) `dart:convert`
*   C) `package:http`
*   D) `package:async`

**Questão 3:** Qual é o propósito da declaração `export` em uma biblioteca Dart?

*   A) Para ocultar declarações de outras bibliotecas.
*   B) Para tornar declarações disponíveis para outras bibliotecas.
*   C) Para especificar a versão do Dart SDK requerida pela biblioteca.
*   D) Para definir o ponto de entrada da biblioteca.

## Próxima lição

Na próxima lição, você completará a CLI integrando o pacote `wikipedia`
com o pacote `cli`. Você implementará a lógica de comando e exibirá
os resultados para o usuário.
