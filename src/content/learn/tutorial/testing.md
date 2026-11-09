---
ia-translate: true
title: Teste seu app e seu código
shortTitle: Testes
description: >-
  Aprenda a escrever testes para o seu código Dart
  usando a biblioteca `package:test`.
layout: learn
---

Neste capítulo, você vai aprender a escrever testes para o seu código Dart.
Testar é fundamental para garantir que a sua aplicação se comporte
como esperado e continue estável conforme você faz mudanças.
Você vai usar a biblioteca `package:test`, um framework de testes popular
para Dart, para escrever testes unitários dos modelos de dados
que você criou no capítulo anterior.

<SummaryCard>
title: O que você vai realizar
items:
  - title: Adicione o pacote test como dependência de desenvolvimento
    icon: experiment
  - title: Escreva testes estruturados com o pacote test e matchers
    icon: lab_panel
  - title: Teste a lógica de desserialização de JSON
    icon: fact_check
</SummaryCard>

## Pré-requisitos {:#prerequisites}

Antes de começar este capítulo, certifique-se de que você:

-   Concluiu o Capítulo 10 e tem um ambiente de desenvolvimento Dart
    funcionando com o projeto `dartpedia`.
-   Está familiarizado com conceitos básicos de programação,
    como variáveis, funções e controle de fluxo.
-   Entende o propósito dos testes no desenvolvimento de software.

## Tarefas {:#tasks}

Neste capítulo, você vai adicionar testes ao pacote `wikipedia`,
garantindo que a lógica de desserialização de JSON
dos seus modelos de dados esteja funcionando corretamente.

### Tarefa 1: Adicione a dependência test {:#task-1-add-the-test-dependency}

Primeiro, confirme que o pacote `test` já é uma dependência de desenvolvimento
do seu projeto.

1.  Abra o arquivo `wikipedia/pubspec.yaml` dentro do seu projeto.
1.  Localize a seção `dev_dependencies`.
1.  Verifique se `test: ^1.24.0` (ou a versão estável mais recente) está
    presente em `dev_dependencies`.

    ```yaml title="wikipedia/pubspec.yaml" highlightLines=3
    dev_dependencies:
      lints: ^5.0.0
      test: ^1.24.0
    ```

    Se a dependência `test` estiver ausente, adicione-a ao seu arquivo `pubspec.yaml`.
    O símbolo `^` permite o uso de versões compatíveis.

1.  Se você fez alguma alteração no arquivo, salve o `pubspec.yaml` e
    execute `dart pub get` no seu terminal, a partir do diretório `wikipedia`.
    Esse comando baixa as dependências recém-adicionadas e
    as deixa disponíveis para uso no seu projeto.

    Você deve ver uma saída parecida com esta:

    ```bash
    Resolving dependencies...
    Downloading packages...
    + test 1.25.1
    Changed 2 dependencies!
    ```

### Tarefa 2: Crie um arquivo de teste e adicione as importações {:#task-2-create-a-test-file-and-add-imports}

Em seguida, crie um arquivo de teste para os seus modelos de dados e
adicione as importações necessárias a ele.

1.  Acesse o diretório `wikipedia/test`.
1.  Crie um novo arquivo chamado `model_test.dart` nesse diretório.
1.  Abra o arquivo `wikipedia/test/model_test.dart` e
    adicione as seguintes instruções `import` no topo do arquivo:

    ```dart title="wikipedia/test/model_test.dart"
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

    Essas linhas importam o pacote `test`, que fornece
    o framework de testes, e os arquivos de modelo de dados que você quer testar.
    As constantes de texto declaram a localização dos seus dados de exemplo.

### Tarefa 3: Crie os arquivos de dados de teste {:#task-3-create-the-test-data-files}

Os testes que você precisa escrever dependem de arquivos JSON locais que
imitam as respostas da API da Wikipédia.
Você precisa criar um diretório `test_data` e
preenchê-lo com três arquivos.

1.  Acesse o diretório `wikipedia/test`.

1.  Crie um novo diretório chamado `test_data`.

1.  Dentro do diretório `test_data`,
    crie um novo arquivo chamado `dart_lang_summary.json` e
    cole nele o conteúdo a seguir:

    ```json title="wikipedia/test/test_data/dart_lang_summary.json"
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

1.  Em seguida, crie um arquivo chamado `cat_extract.json`.
    Esse arquivo é bem longo, então copie o conteúdo deste link:
    https://github.com/ericwindmill/dash_getting_started/blob/main/dart_step_by_step/step_10/wikipedia/test/test_data/cat_extract.json

1.  Por fim, crie um arquivo chamado `open_search_response.json` e
    cole nele o conteúdo a seguir:

    ```json title="wikipedia/test/test_data/open_search_response.json"
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

Com esses arquivos no lugar, você está pronto para escrever os testes que
vão verificar os seus modelos de dados.

### Tarefa 4: Escreva testes para a desserialização de JSON {:#task-4-write-tests-for-json-deserialization}

Agora, você vai escrever testes para a lógica de desserialização de JSON
dos seus modelos de dados.
Você vai usar as funções `group`, `test` e `expect` do pacote `test`.

1.  Use a função `group` para agrupar testes relacionados.
    Adicione o seguinte ao seu arquivo `wikipedia/test/model_test.dart`:

    ```dart title="wikipedia/test/model_test.dart"
    void main() {
      group('deserialize example JSON responses from wikipedia API', () {
        // Tests will go here
      });
    }
    ```

    A função `group` recebe uma descrição do grupo e uma
    função de callback que contém os testes.

1.  Crie um teste para o modelo `Summary`.
    Adicione a seguinte função `test` dentro da função `group`:

    ```dart title="wikipedia/test/model_test.dart"
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

    -   Lê o conteúdo do arquivo `dart_lang_summary.json`.
    -   Decodifica a string JSON para um `Map<String, Object?>`.
    -   Cria um objeto `Summary` a partir do mapa, usando
        o construtor `Summary.fromJson`.
    -   Usa a função `expect` para verificar se a propriedade
        `canonical` do objeto `titles` é igual a `'Dart_(programming_language)'`.

    A função `expect` recebe um valor e um matcher.
    O matcher é usado para verificar se o valor atende a determinados critérios.
    Neste caso, o matcher `equals` é usado para verificar se o valor
    é igual a uma string específica.

1.  Crie um teste para o modelo `Article`.
    Adicione a seguinte função `test` dentro
    da função `group`, depois do teste anterior:

    ```dart title="wikipedia/test/model_test.dart"
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
          final List<Article> articles = Article.listFromJson(articleMap);
          expect(articles.first.title.toLowerCase(), 'cat');
        });
      });
    }
    ```

    Esta função `test` faz o seguinte:

    -   Lê o conteúdo do arquivo `cat_extract.json`.
    -   Decodifica a string JSON para um `Map<String, Object?>`.
    -   Cria o objeto `List<Article>` a partir do mapa, usando
        o método estático `Article.listFromJson`.
    -   Usa a função `expect` para verificar se a propriedade
        `title` do primeiro artigo é igual a `'cat'`.

1.  Crie um teste para o modelo `SearchResults`.
    Adicione a seguinte função `test` dentro da função `group`,
    depois do teste anterior:

    ```dart title="wikipedia/test/model_test.dart"
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
          final List<Article> articles = Article.listFromJson(articleMap);
          expect(articles.first.title.toLowerCase(), 'cat');
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

    -   Lê o conteúdo do arquivo `open_search_response.json`.
    -   Decodifica a string JSON para um `List<Object?>` (diferente das respostas
        de resumo e de artigo, que são objetos JSON decodificados como mapas,
        a resposta OpenSearch de nível superior é um array JSON).
    -   Cria um objeto `SearchResults` a partir da lista, usando
        o construtor `SearchResults.fromJson`.
    -   Usa a função `expect` para verificar se a lista `results`
        tem tamanho maior que `1`.

### Tarefa 5: Execute os testes {:#task-5-run-the-tests}

Agora que você escreveu os testes, pode executá-los para verificar se eles passam.

1.  Abra o terminal e acesse o diretório `wikipedia`.
1.  Execute o comando `dart test`.

    Você deve ver uma saída parecida com esta:

    ```bash
    00:02 +4: All tests passed!
    ```

    Isso confirma que os três testes estão passando.

## Revisão {:#review}

<SummaryCard>
title: O que você realizou
subtitle: Aqui está um resumo do que você construiu e aprendeu nesta lição.
completed: true
items:
  - title: Adicionou o pacote test como dependência de desenvolvimento
    icon: experiment
    details: >-
      Você adicionou `test` como dependência de desenvolvimento no `pubspec.yaml` e
      criou arquivos de teste no diretório `test/`.
      Dependências de desenvolvimento do pub são destinadas ao uso durante
      o desenvolvimento e os testes, não em produção.
      Por isso, elas não podem ser usadas no diretório `lib`.
  - title: Escreveu testes estruturados com o pacote test e matchers
    icon: lab_panel
    details: >-
      Você usou `group()` para organizar testes relacionados,
      `test()` para definir casos de teste individuais e `expect()` com
      matchers como `equals` e `greaterThan` para verificar o comportamento esperado.
      Executar `dart test` roda todos os testes declarados no seu pacote.
  - title: Testou a lógica de desserialização de JSON
    icon: fact_check
    details: >-
      Você criou arquivos de dados de teste com JSON de exemplo e escreveu testes para
      verificar se os seus métodos `fromJson` convertem corretamente os dados
      em objetos Dart.
      Isso garante que os seus modelos lidem corretamente com respostas reais da API.
</SummaryCard>

## Quiz {:#quiz}

<Quiz title="Check your understanding" id="testing" />

## Próxima lição {:#next-lesson}

Na próxima lição, você vai implementar as chamadas à API da Wikipédia
na sua aplicação `dartpedia`.
Você vai usar o pacote `http` para buscar dados da API da Wikipédia e
exibi-los ao usuário.
