---
ia-translate: true
title: Testing
shortTitle: Testing
description: >-
  Aprenda como escrever testes para seu código Dart usando a biblioteca `package:test`.
sitemap: false
noindex: true
layout: learn
prevpage:
  url: /get-started/data-json
  title: Data and JSON
nextpage:
  url: /get-started/http
  title: Http
---

{% render 'fwe-wip-warning.md', site: site %}

Neste capítulo, você aprenderá como escrever testes para seu código Dart. Testing é
crucial para garantir que sua aplicação se comporte conforme esperado e permaneça
estável conforme você faz mudanças. Você usará a biblioteca `package:test`, um framework
de testes popular para Dart, para escrever testes unitários para os modelos de dados que você criou
no capítulo anterior.

:::secondary O que você aprenderá

*   Instalar e importar a biblioteca `package:test`.
*   Escrever testes usando `group`, `test`, `expect` e matchers.
*   Criar arquivos de teste e organizar testes.
*   Escrever testes para lógica de deserialização JSON.

:::

## Pré-requisitos

Antes de começar este capítulo, certifique-se de:

*   Ter completado o Capítulo 9 e ter um ambiente de desenvolvimento Dart funcionando com
    o projeto `dartpedia`.
*   Estar familiarizado com conceitos básicos de programação como variáveis, funções e
    fluxo de controle.
*   Entender o propósito de testing no desenvolvimento de software.

## Tarefas

Neste capítulo, você adicionará testes ao pacote `wikipedia`, garantindo que
a lógica de deserialização JSON para seus modelos de dados esteja funcionando corretamente.

### Tarefa 1: Adicionar a dependência de teste

Primeiro, você precisa confirmar que o pacote `test` já é uma dependência de
desenvolvimento em seu projeto.

1.  Abra o arquivo `wikipedia/pubspec.yaml` dentro do seu projeto.
1.  Localize a seção `dev_dependencies`.
1.  Verifique se `test: ^1.24.0` (ou a versão estável mais recente) está presente em
    `dev_dependencies`.

    ```yaml
    dev_dependencies:
      lints: ^5.0.0
      test: ^1.24.0
    ```

    Se a dependência `test` estiver faltando, adicione-a ao seu arquivo `pubspec.yaml`. O
    símbolo `^` permite que versões compatíveis sejam usadas.

1.  Se você fez alguma alteração no arquivo, salve `pubspec.yaml` e execute
    `dart pub get` no seu terminal a partir do diretório `wikipedia`. Este comando
    busca quaisquer dependências recém-adicionadas e as torna disponíveis para uso em
    seu projeto.

    Você deverá ver uma saída similar a esta:

    ```bash
    Resolving dependencies...
    Downloading packages...
    + test 1.25.1
    Changed 2 dependencies!
    ```

### Tarefa 2: Criar um arquivo de teste e adicionar imports

Em seguida, crie um arquivo de teste para seus modelos de dados e adicione os imports necessários a
ele.

1.  Navegue até o diretório `wikipedia/test`.
1.  Crie um novo arquivo chamado `model_test.dart` neste diretório.
1.  Abra o arquivo `wikipedia/test/model_test.dart` e adicione as seguintes
    declarações `import` no topo do arquivo:

    ```dart
    import 'dart:convert';
    import 'dart:io';

    import 'package:test/test.dart';
    import 'package:wikipedia/src/model/article.dart';
    import 'package:wikipedia/src/model/search_results.dart';
    import 'package:wikipedia/src/model/summary.dart';

    const String dartLangSummaryJson = './test/test_data/dart_lang_summary.json';
    const String catExtractJson = './test/test_data/cat_extract.json';
    const String openSearchResponse = './test/test_data/open_search_response.json';
    ```

    Essas linhas importam o pacote `test`, que fornece o framework
    de testes, e os arquivos de modelo de dados que você quer testar. As strings constantes
    declaram a localização dos seus dados de exemplo.

### Tarefa 3: Criar os arquivos de dados de teste

Os testes que você precisa escrever dependem de arquivos JSON locais que imitam as
respostas da API da Wikipedia. Você precisa criar um
diretório `test_data` e populá-lo com três arquivos.

1.  Navegue até o diretório `wikipedia/test`.

1.  Crie um novo diretório chamado `test_data`.

1.  Dentro do diretório `test_data`, crie um novo arquivo chamado
    `dart_lang_summary.json` e cole o seguinte conteúdo nele:

    ```json
    {
    "type": "standard",
    "title": "Dart (programming language)",
    "displaytitle": "<span class=\"mw-page-title-main\">Dart (programming language)</span>",
    "namespace": {
        "id": 0,
        "text": ""
    },
    "wikibase_item": "Q406009",
    "titles": {
        "canonical": "Dart_(programming_language)",
        "normalized": "Dart (programming language)",
        "display": "<span class=\"mw-page-title-main\">Dart (programming language)</span>"
    },
    "pageid": 33033735,
    "lang": "en",
    "dir": "ltr",
    "revision": "1259309990",
    "tid": "671bc7c6-aa67-11ef-aa2a-7c1da4fbe8fb",
    "timestamp": "2024-11-24T13:24:16Z",
    "description": "Programming language",
    "description_source": "local",
    "content_urls": {
        "desktop": {
        "page": "https://en.wikipedia.org/wiki/Dart_(programming_language)",
        "revisions": "https://en.wikipedia.org/wiki/Dart_(programming_language)?action=history",
        "edit": "https://en.wikipedia.org/wiki/Dart_(programming_language)?action=edit",
        "talk": "https://en.wikipedia.org/wiki/Talk:Dart_(programming_language)"
        },
        "mobile": {
        "page": "https://en.m.wikipedia.org/wiki/Dart_(programming_language)",
        "revisions": "https://en.m.wikipedia.org/wiki/Special:History/Dart_(programming_language)",
        "edit": "https://en.m.wikipedia.org/wiki/Dart_(programming_language)?action=edit",
        "talk": "https://en.m.wikipedia.org/wiki/Talk:Dart_(programming_language)"
        }
    },
    "extract": "Dart is a programming language designed by Lars Bak and Kasper Lund and developed by Google. It can be used to develop web and mobile apps as well as server and desktop applications.",
    "extract_html": "<p><b>Dart</b> is a programming language designed by Lars Bak and Kasper Lund and developed by Google. It can be used to develop web and mobile apps as well as server and desktop applications.</p>"
    }
    ```

1.  Em seguida, crie um arquivo chamado `cat_extract.json`. Este arquivo é muito longo, então copie
    o conteúdo deste link: https://github.com/ericwindmill/dash_getting_started/blob/main/dart_step_by_step/step_10/wikipedia/test/test_data/cat_extract.json

1.  Em seguida, crie um arquivo chamado `open_search_response.json` e cole este conteúdo
    nele:

    ```json
    [
        "dart",
        [
            "Dart",
            "Darth Vader",
            "Dartmouth College",
            "Darts",
            "Darth Maul",
            "Dartford Crossing",
            "Dart (programming language)",
            "Dartmouth College fraternities and sororities",
            "Dartmoor",
            "Dartmouth, Massachusetts"
        ],
        [
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            ""
        ],
        [
            "https://en.wikipedia.org/wiki/Dart",
            "https://en.wikipedia.org/wiki/Darth_Vader",
            "https://en.wikipedia.org/wiki/Dartmouth_College",
            "https://en.wikipedia.org/wiki/Darts",
            "https://en.wikipedia.org/wiki/Darth_Maul",
            "https://en.wikipedia.org/wiki/Dartford_Crossing",
            "https://en.wikipedia.org/wiki/Dart_(programming_language)",
            "https://en.wikipedia.org/wiki/Dartmouth_College_fraternities_and_sororities",
            "https://en.wikipedia.org/wiki/Dartmoor",
            "https://en.wikipedia.org/wiki/Dartmouth,_Massachusetts"
        ]
    ]
    ```

Com esses arquivos em vigor, você está pronto para escrever os testes que verificarão seus
modelos de dados.

### Tarefa 4: Escrever testes para deserialização JSON

Agora, você escreverá testes para a lógica de deserialização JSON em seus modelos de dados.
Você usará as funções `group`, `test` e `expect` do pacote `test`.

1.  Use a função `group` para agrupar testes relacionados.
    Adicione o seguinte ao seu arquivo `wikipedia/test/model_test.dart`:

    ```dart
    void main() {
      group('deserialize example JSON responses from wikipedia API', () {
        // Tests will go here
      });
    }
    ```

    A função `group` recebe uma descrição do grupo e uma função callback
    que contém os testes.

1.  Crie um teste para o modelo `Summary`.
    Adicione a seguinte função `test` dentro da função `group`:

    ```dart
    void main() {
      group('deserialize example JSON responses from wikipedia API', () {
        test('deserialize Dart Programming Language page summary example data from '
            'json file into a Summary object', () async {
          final String pageSummaryInput =
              await File(dartLangSummaryJson).readAsString();
          final Map<String, Object?> pageSummaryMap =
              jsonDecode(pageSummaryInput) as Map<String, Object?>;
          final Summary summary = Summary.fromJson(pageSummaryMap);
          expect(summary.titles.canonical, 'Dart_(programming_language)');
        });
      });
    }
    ```

    Esta função `test` faz o seguinte:

    *   Lê o conteúdo do arquivo `dart_lang_summary.json`.
    *   Decodifica a string JSON em um `Map<String, Object?>`.
    *   Cria um objeto `Summary` a partir do map usando o construtor
        `Summary.fromJson`.
    *   Usa a função `expect` para afirmar que a propriedade `canonical` do
        objeto `titles` é igual a `'Dart_(programming_language)'`.

    A função `expect` recebe um valor e um matcher. O matcher é usado para
    afirmar que o valor atende a certos critérios. Neste caso, o
    matcher `equals` é usado para afirmar que o valor é igual a uma string
    específica.

1.  Crie um teste para o modelo `Article`. Adicione a seguinte função `test`
    dentro da função `group`, após o teste anterior:

    ```dart
    void main() {
      group('deserialize example JSON responses from wikipedia API', () {
        test('deserialize Dart Programming Language page summary example data from '
            'json file into a Summary object', () async {
          final String pageSummaryInput =
              await File(dartLangSummaryJson).readAsString();
          final Map<String, Object?> pageSummaryMap =
              jsonDecode(pageSummaryInput) as Map<String, Object?>;
          final Summary summary = Summary.fromJson(pageSummaryMap);
          expect(summary.titles.canonical, 'Dart_(programming_language)');
        });

        test('deserialize Cat article example data from json file into '
            'an Article object', () async {
        final String articleJson = await File(catExtractJson).readAsString();
        final Map<String, Object?> articleMap =
            jsonDecode(articleJson) as Map<String, Object?>;

        final Map<String, Object?> pagesMap =
            (articleMap['query'] as Map)['pages'] as Map<String, Object?>;

        // The 'pagesMap' contains a single key (e.g., '6678').
        // We get the first (and only) value from that map.
        final Map<String, Object?> catArticleMap =
            pagesMap.values.first as Map<String, Object?>;

        final Article article = Article(
            title: catArticleMap['title'] as String,
            extract: catArticleMap['extract'] as String,
        );

        expect(article.title.toLowerCase(), 'cat');
        });
      });
    }
    ```

    Esta função `test` faz o seguinte:

    *   Lê o conteúdo do arquivo `cat_extract.json`.
    *   Decodifica a string JSON em uma `List<Object?>`.
    *   Cria o objeto `Article` a partir da lista usando o
        construtor `Article.listFromJson`.
    *   Usa a função `expect` para afirmar que a propriedade `title` do
        primeiro artigo é igual a `'cat'`.

1.  Crie um teste para o modelo `SearchResults`.
    Adicione a seguinte função `test` dentro da função `group`, após o
    teste anterior:

    ```dart
    void main() {
    group('deserialize example JSON responses from wikipedia API', () {
        test('deserialize Dart Programming Language page summary example data from '
            'json file into a Summary object', () async {
        final String pageSummaryInput =
            await File(dartLangSummaryJson).readAsString();
        final Map<String, Object?> pageSummaryMap =
            jsonDecode(pageSummaryInput) as Map<String, Object?>;
        final Summary summary = Summary.fromJson(pageSummaryMap);
        expect(summary.titles.canonical, 'Dart_(programming_language)');
        });

        test('deserialize Cat article example data from json file into '
            'an Article object', () async {
        final String articleJson = await File(catExtractJson).readAsString();
        final Map<String, Object?> articleMap =
            jsonDecode(articleJson) as Map<String, Object?>;

        final Map<String, Object?> pagesMap =
            (articleMap['query'] as Map)['pages'] as Map<String, Object?>;

        // The 'pagesMap' contains a single key (e.g., '6678').
        // We get the first (and only) value from that map.
        final Map<String, Object?> catArticleMap =
            pagesMap.values.first as Map<String, Object?>;

        final Article article = Article(
            title: catArticleMap['title'] as String,
            extract: catArticleMap['extract'] as String,
        );

        expect(article.title.toLowerCase(), 'cat');
        });

        test('deserialize Open Search results example data from json file '
            'into an SearchResults object', () async {
        final String resultsString =
            await File(openSearchResponse).readAsString();
        final List<Object?> resultsAsList =
            jsonDecode(resultsString) as List<Object?>;
        final SearchResults results = SearchResults.fromJson(resultsAsList);
        expect(results.results.length, greaterThan(1));
        });
    });
    }
    ```

    Esta função `test` faz o seguinte:

    *   Lê o conteúdo do arquivo `open_search_response.json`.
    *   Decodifica a string JSON em uma `List<Object?>`.
    *   Cria um objeto `SearchResults` a partir da lista usando o
        construtor `SearchResults.fromJson`.
    *   Usa a função `expect` para afirmar que a lista `results` tem um
        comprimento maior que `1`.

### Tarefa 5: Executar os testes

Agora que você escreveu os testes, pode executá-los para verificar se eles passam.

1.  Abra seu terminal e navegue até o diretório `wikipedia`.
1.  Execute o comando `dart test`.

    Você deverá ver uma saída similar a esta:

    ```bash
    00:02 +4: All tests passed!
    ```

    Isso confirma que todos os três testes estão passando.

## Revisão

Neste capítulo, você aprendeu sobre:

*   Instalar a biblioteca `package:test`.
*   Escrever testes usando `group`, `test` e `expect`.
*   Criar arquivos de teste e organizar testes.
*   Escrever testes para lógica de deserialização JSON.
*   Usar matchers para afirmar que valores atendem a certos critérios.

## Quiz

**Questão 1:** Qual é o propósito da função `group` na
biblioteca `package:test`?

*   A) Executar todos os testes em um projeto.
*   B) Agrupar testes relacionados.
*   C) Definir um novo caso de teste.
*   D) Afirmar que um valor atende a certos critérios.

**Questão 2:** Qual é o propósito da função `expect` na
biblioteca `package:test`?

*   A) Definir um novo caso de teste.
*   B) Agrupar testes relacionados.
*   C) Afirmar que um valor atende a certos critérios.
*   D) Executar todos os testes em um projeto.

## Próxima lição

Na próxima lição, você implementará as chamadas da API da Wikipedia em sua
aplicação `dartpedia`. Você usará o pacote `http` para buscar dados da
API da Wikipedia e exibi-los ao usuário.
