---
ia-translate: true
title: Trabalhe com dados JSON
shortTitle: Dados e JSON
description: >-
  Aprenda sobre desserialização de JSON em Dart, incluindo como usar
  `dart:convert`, `jsonDecode` e pattern matching para trabalhar com
  dados JSON da API da Wikipedia.
layout: learn
---

Neste capítulo, você vai aprender como trabalhar com dados
[JSON (JavaScript Object Notation)][JSON (JavaScript Object Notation)] em Dart.
Crie modelos de dados para representar as respostas da API da Wikipedia,
use `dart:convert` para decodificar texto JSON em coleções Dart e
use pattern matching para extrair e validar os dados.

<SummaryCard>
title: O que você vai realizar
items:
  - title: Aprender sobre o tratamento de JSON em Dart
    icon: convert_to_text
  - title: Configurar um workspace com vários pacotes
    icon: workspaces
  - title: Criar classes de modelo de dados para JSON
    icon: data_object
  - title: Usar pattern matching em construtores fromJson
    icon: bento
</SummaryCard>

[JSON (JavaScript Object Notation)]:  https://en.wikipedia.org/wiki/JSON
[`dart:convert` library]: {{site.dart-api}}/dart-convert

## Pré-requisitos {:#prerequisites}

Antes de começar este capítulo, certifique-se de:

- Ter concluído o Capítulo 9 e ter um
  ambiente de desenvolvimento Dart funcionando com o projeto `dartpedia`.
- Entender a sintaxe básica do Dart, incluindo [classes][classes] e tipos de dados.

[classes]: /language/classes

## Como o Dart trata JSON {:#how-dart-handles-json}

JSON é um formato baseado em texto para
representar dados estruturados, como objetos, arrays, números e strings.
Quando você interage com APIs web, as respostas chegam como strings JSON.

No Dart, converter uma string JSON em um modelo de dados fortemente tipado
envolve duas etapas:

1.  **Decodifique a string JSON em coleções Dart.**
    A [biblioteca `dart:convert`][`dart:convert` library] fornece a função `jsonDecode()`,
    que transforma uma string JSON bruta em uma coleção Dart padrão:
    - Um objeto JSON (`{...}`) vira um `Map<String, dynamic>`.
    - Um array JSON (`[...]`) vira uma `List<dynamic>`.

    ```dart
    import 'dart:convert';

    const String jsonString = '{"title": "Dart", "pageid": 12345}';

    // jsonDecode parses the string, cast to a Map<String, Object?>
    final Map<String, Object?> jsonMap =
        jsonDecode(jsonString) as Map<String, Object?>;
    ```

1.  **Converta as coleções decodificadas em objetos de modelo personalizados.**
    Embora você possa ler valores diretamente de um `Map` (como `jsonMap['title']`),
    usar mapas brutos em toda a aplicação não oferece segurança de tipos,
    favorece erros de digitação e não tem autocompletar na IDE.

    Para resolver isso, aplicações Dart definem classes de modelo de dados com
    construtores `factory`, convencionalmente chamados de `fromJson`, que
    instanciam objetos tipados a partir de mapas decodificados:

    ```dart
    class ArticleSummary {
      final String title;
      final int pageid;

      ArticleSummary({required this.title, required this.pageid});

      factory ArticleSummary.fromJson(Map<String, Object?> json) {
        return ArticleSummary(
          title: json['title'] as String,
          pageid: json['pageid'] as int,
        );
      }
    }
    ```

O Dart também suporta [pattern matching][pattern matching] em construtores `fromJson`,
permitindo validar a estrutura do mapa JSON e
extrair valores em uma única etapa concisa.

## Tarefas {:#tasks}

As tarefas a seguir configuram um workspace com vários pacotes e
criam as classes de modelo de dados para as respostas da API da Wikipedia.

### Tarefa 1: Crie o pacote Wikipedia {:#task-1-create-the-wikipedia-package}

Primeiro, crie um novo pacote Dart para abrigar os modelos de dados.

1.  Navegue até o diretório raiz do seu projeto (`/dartpedia`).
1.  Execute o seguinte comando no terminal:

    ```bash
    dart create wikipedia
    ```

    Esse comando cria um novo diretório chamado `wikipedia` com
    a estrutura básica de um pacote Dart.
    Agora você deve ver uma nova pasta `wikipedia` na raiz do projeto,
    ao lado de `cli` e `command_runner`.

### Tarefa 2: Configure um workspace Dart {:#task-2-configure-a-dart-workspace}

Workspaces Dart permitem
gerenciar vários pacotes relacionados dentro de um único projeto,
simplificando o gerenciamento de dependências e o desenvolvimento local.
Agora que você está adicionando seu terceiro pacote,
é um bom momento para configurar o projeto para usar um workspace Dart.

1.  **Crie o arquivo `pubspec.yaml` raiz.**

    Navegue até o diretório raiz do projeto (`/dartpedia`) e
    crie um novo arquivo chamado `pubspec.yaml` com o seguinte conteúdo:

    ```yaml title="pubspec.yaml"
    name: _
    publish_to: none

    environment:
      sdk: ^3.8.1 # IMPORTANT: Adjust this to match your Dart SDK version or a compatible range
    workspace:
      - cli
      - command_runner
      - wikipedia
    ```

1.  **Adicione a resolução de workspace aos sub-pacotes.**

    Para cada um dos seus sub-pacotes (`cli`, `command_runner` e `wikipedia`),
    abra os respectivos arquivos `pubspec.yaml` e
    adicione `resolution: workspace` em `pubspec.yaml`.
    Isso diz ao Dart para resolver as dependências dentro do workspace.

    -   Para `cli/pubspec.yaml`:

        ```yaml title="cli/pubspec.yaml" highlightLines=5
        # ... (existing content) ...
        name: cli
        description: A sample command-line application.
        version: 1.0.0
        resolution: workspace # Add this line
        # ... (existing content) ...
        ```

    -   Para `command_runner/pubspec.yaml`:

        ```yaml title="command_runner/pubspec.yaml" highlightLines=5
        # ... (existing content) ...
        name: command_runner
        description: A starting point for Dart libraries or applications.
        version: 1.0.0
        resolution: workspace # Add this line
        # ... (existing content) ...
        ```

    -   Para `wikipedia/pubspec.yaml`:

        ```yaml title="wikipedia/pubspec.yaml" highlightLines=5
        # ... (existing content) ...
        name: wikipedia
        description: A sample command-line application.
        version: 1.0.0
        resolution: workspace # Add this line
        # ... (existing content) ...
        ```

1.  **Resolva as dependências do workspace.**

    Execute `dart pub get` na raiz do projeto para
    resolver as dependências de todos os pacotes do workspace:

    ```bash
    dart pub get
    ```

### Tarefa 3: Crie a classe Summary {:#task-3-create-the-summary-class}

A API da Wikipedia retorna um objeto JSON contendo um resumo de um artigo.
Uma resposta típica do endpoint de resumo de página tem este formato:

```json
{
  "titles": {
    "canonical": "Dart_(programming_language)",
    "normalized": "Dart (programming language)",
    "display": "Dart (programming language)"
  },
  "pageid": 37194605,
  "extract": "Dart is a client-optimized language for fast apps...",
  "extract_html": "<p><b>Dart</b> is a client-optimized language...</p>",
  "lang": "en",
  "dir": "ltr",
  "content_urls": {
    "desktop": {
      "page": "https://en.wikipedia.org/wiki/Dart_(programming_language)"
    },
    "mobile": {
      "page": "https://en.m.wikipedia.org/wiki/Dart_(programming_language)"
    }
  },
  "description": "Programming language"
}
```

Crie uma classe Dart para representar esse resumo.

1.  Crie o diretório `wikipedia/lib/src/model`.

    ```bash
    mkdir -p wikipedia/lib/src/model
    ```

1.  Crie o arquivo `wikipedia/lib/src/model/summary.dart`.

1.  Adicione o seguinte código em `wikipedia/lib/src/model/summary.dart`:

    ```dart title="wikipedia/lib/src/model/summary.dart"
    import 'title_set.dart';

    class Summary {
      /// Returns a new [Summary] instance.
      Summary({
        required this.titles,
        required this.pageid,
        required this.extract,
        required this.extractHtml,
        required this.lang,
        required this.dir,
        this.url,
        this.description,
      });

      ///
      TitlesSet titles;

      /// The page ID
      int pageid;

      /// First several sentences of an article in plain text
      String extract;

      /// First several sentences of an article in simple HTML format
      String extractHtml;

      /// Url to the article on Wikipedia
      String? url;

      /// The page language code
      String lang;

      /// The page language direction code
      String dir;

      /// Wikidata description for the page
      String? description;

      /// Creates a [Summary] instance from a JSON map.
      factory Summary.fromJson(Map<String, Object?> json) {
        return switch (json) {
          {
            'titles': final Map<String, Object?> titles,
            'pageid': final int pageid,
            'extract': final String extract,
            'extract_html': final String extractHtml,
            'lang': final String lang,
            'dir': final String dir,
            'content_urls': {
              'desktop': {'page': final String url},
              'mobile': {'page': String _},
            },
            'description': final String description,
          } =>
            Summary(
              titles: TitlesSet.fromJson(titles),
              pageid: pageid,
              extract: extract,
              extractHtml: extractHtml,
              lang: lang,
              dir: dir,
              url: url,
              description: description,
            ),
          {
            'titles': final Map<String, Object?> titles,
            'pageid': final int pageid,
            'extract': final String extract,
            'extract_html': final String extractHtml,
            'lang': final String lang,
            'dir': final String dir,
            'content_urls': {
              'desktop': {'page': final String url},
              'mobile': {'page': String _},
            },
          } =>
            Summary(
              titles: TitlesSet.fromJson(titles),
              pageid: pageid,
              extract: extract,
              extractHtml: extractHtml,
              lang: lang,
              dir: dir,
              url: url,
            ),
          _ => throw FormatException('Could not deserialize Summary, json=$json'),
        };
      }

      @override
      String toString() =>
          'Summary['
          'titles=$titles, '
          'pageid=$pageid, '
          'extract=$extract, '
          'extractHtml=$extractHtml, '
          'lang=$lang, '
          'dir=$dir, '
          'description=$description'
          ']';
    }
    ```

    Este código define uma classe `Summary` para representar os campos
    retornados pelo endpoint de resumo da Wikipedia:

    * **Pattern matching no `fromJson`:** Embora você possa acessar as chaves do mapa
      individualmente com cast manual (como `json['pageid'] as int`),
      o construtor factory `fromJson` usa [pattern matching][pattern matching] para
      validar a estrutura, confirmar os tipos e extrair os valores em uma única
      expressão declarativa.
    * **Expressão `switch`:** Oferece dois casos para tratar o campo opcional
      `description` da Wikipedia: um que o extrai quando está presente
      e um caso alternativo que corresponde quando ele é omitido.
    * **`toString`:** Fornece uma representação em string legível do
      objeto `Summary` para depuração.

    :::note
    Seu editor pode marcar `import 'title_set.dart'` e `TitlesSet`
    como referências não resolvidas até que você crie `TitlesSet` na Tarefa 4.
    :::

[pattern matching]: /language/patterns

### Tarefa 4: Crie a classe TitleSet {:#task-4-create-the-titleset-class}

A classe `Summary` usa uma classe `TitlesSet` para representar as informações de título.
Crie essa classe a seguir.

1.  Crie o arquivo `wikipedia/lib/src/model/title_set.dart`.

1.  Adicione o seguinte código em `wikipedia/lib/src/model/title_set.dart`:

    ```dart title="wikipedia/lib/src/model/title_set.dart"
    class TitlesSet {
      /// Returns a new [TitlesSet] instance.
      TitlesSet({
        required this.canonical,
        required this.normalized,
        required this.display,
      });

      /// the DB key (non-prefixed), e.g. may have _ instead of spaces,
      /// best for making request URIs, still requires Percent-encoding
      String canonical;

      /// the normalized title (https://www.mediawiki.org/wiki/API:Query#Example_2:_Title_normalization),
      /// e.g. may have spaces instead of _
      String normalized;

      /// the title as it should be displayed to the user
      String display;

      /// Creates a [TitlesSet] instance from a JSON map.
      factory TitlesSet.fromJson(Map<String, Object?> json) {
        if (json case {
          'canonical': final String canonical,
          'normalized': final String normalized,
          'display': final String display,
        }) {
          return TitlesSet(
            canonical: canonical,
            normalized: normalized,
            display: display,
          );
        }
        throw FormatException('Could not deserialize TitleSet, json=$json');
      }

      @override
      String toString() =>
          'TitlesSet['
          'canonical=$canonical, '
          'normalized=$normalized, '
          'display=$display'
          ']';
    }
    ```

    Este código define uma classe `TitlesSet` para armazenar as variantes de título
    retornadas pela API da Wikipedia.
    Diferente de `Summary`, que usa uma expressão `switch` para campos opcionais,
    `TitlesSet` tem uma estrutura fixa e valida os três campos de uma vez
    usando uma instrução `if case`.
    Se o mapa JSON não corresponder ao padrão, ele lança uma
    `FormatException`.

### Tarefa 5: Crie a classe Article {:#task-5-create-the-article-class}

A API da Wikipedia também retorna uma lista de artigos em um resultado de busca.
Crie uma classe Dart para representar um artigo.

1.  Crie o arquivo `wikipedia/lib/src/model/article.dart`.

1.  Adicione o seguinte código em `wikipedia/lib/src/model/article.dart`:

    ```dart title="wikipedia/lib/src/model/article.dart"
    class Article {
      Article({required this.title, required this.extract});

      final String title;
      final String extract;

      static List<Article> listFromJson(Map<String, Object?> json) {
        final List<Article> articles = <Article>[];
        if (json case {'query': {'pages': final Map<String, Object?> pages}}) {
          for (final MapEntry<String, Object?>(:Object? value) in pages.entries) {
            if (value case {
              'title': final String title,
              'extract': final String extract,
            }) {
              articles.add(Article(title: title, extract: extract));
            }
          }
          return articles;
        }
        throw FormatException('Could not deserialize Article, json=$json');
      }

      Map<String, Object?> toJson() => <String, Object?>{
        'title': title,
        'extract': extract,
      };

      @override
      String toString() {
        return 'Article{title: $title, extract: $extract}';
      }
    }
    ```

    Este código define uma classe `Article` para representar o título e
    o extrato de um artigo:

    * **`listFromJson`:** Diferente dos modelos anteriores, que criam uma única instância,
      o endpoint de busca da Wikipedia retorna vários artigos em um mapa.
      Construtores Dart retornam apenas uma instância, então `Article` usa
      um método `static` chamado `listFromJson` para retornar uma `List<Article>`.
    * **Desestruturação com object pattern:** O laço `for` usa
      `final MapEntry(:value)` para extrair o valor de cada entrada diretamente,
      sem acesso manual às propriedades.
    * **`toJson`:** Converte uma instância de `Article` de volta para um mapa JSON.
      Pela convenção do Dart, `toJson()` retorna um `Map<String, Object?>`
      que você pode passar para `jsonEncode()`, de `dart:convert`,
      ao serializar um objeto para uma string JSON.

### Tarefa 6: Crie a classe SearchResults {:#task-6-create-the-searchresults-class}

Por fim, crie uma classe para representar os resultados de busca da API da Wikipedia.
O endpoint de busca da Wikipedia retorna um array contendo o termo buscado,
os títulos dos artigos, as descrições (que são ignoradas) e as URLs:

```json
[
  "dart",
  ["Dart (programming language)", "Dart"],
  ["", ""],
  [
    "https://en.wikipedia.org/wiki/Dart_(programming_language)",
    "https://en.wikipedia.org/wiki/Dart"
  ]
]
```

1.  Crie o arquivo `wikipedia/lib/src/model/search_results.dart`.
1.  Adicione o seguinte código em `wikipedia/lib/src/model/search_results.dart`:

    ```dart title="wikipedia/lib/src/model/search_results.dart"
    class SearchResult {
      SearchResult({required this.title, required this.url});
      final String title;
      final String url;
    }

    class SearchResults {
      SearchResults(this.results, {this.searchTerm});
      final List<SearchResult> results;
      final String? searchTerm;

      /// Creates a [SearchResults] instance from a JSON list.
      factory SearchResults.fromJson(List<Object?> json) {
        final List<SearchResult> results = <SearchResult>[];
        if (json case [
          String searchTerm,
          Iterable articleTitles,
          Iterable _,
          Iterable urls,
        ]) {
          final List titlesList = articleTitles.toList();
          final List urlList = urls.toList();
          for (int i = 0; i < articleTitles.length; i++) {
            results.add(SearchResult(title: titlesList[i], url: urlList[i]));
          }
          return SearchResults(results, searchTerm: searchTerm);
        }
        throw FormatException('Could not deserialize SearchResults, json=$json');
      }

      @override
      String toString() {
        final StringBuffer pretty = StringBuffer();
        for (final SearchResult result in results) {
          pretty.write('${result.url} \n');
        }
        return '\nSearchResults for $searchTerm: \n$pretty';
      }
    }
    ```

    Este código define duas classes: `SearchResult`, para armazenar o título e a URL
    de um artigo individual, e `SearchResults`, para armazenar a lista de
    resultados junto com a consulta de busca:

    * **`fromJson` com `List<Object?>`:** O construtor aceita
      uma `List<Object?>`, em vez de um `Map<String, Object?>`, para corresponder
      ao array JSON de nível superior retornado pela API de busca da Wikipedia.
    * **Pattern matching de lista:** A instrução `if case` usa um padrão de lista
      `[...]` para corresponder ao array por posição e extrair cada seção.
    * **Padrão curinga (`_`):** O padrão `Iterable _` corresponde e descarta
      o array de descrições, que a aplicação não precisa.

Agora você tem modelos de dados tipados para representar as respostas da API da Wikipedia.
Nos próximos capítulos, você vai usar o `package:test` para testar
como os dados são desserializados e o `package:http` para buscar
dados JSON ao vivo da API.

## Revisão {:#review}

<SummaryCard>
title: O que você realizou
subtitle: Veja um resumo do que você construiu e aprendeu nesta lição.
completed: true
items:
  - title: Aprendeu sobre o tratamento de JSON em Dart
    icon: convert_to_text
    details: >-
      Você explorou como `dart:convert` e `jsonDecode()`
      transformam strings JSON em coleções Dart (`Map` e `List`), e
      por que modelos tipados com construtores factory `fromJson`
      são preferidos em vez de mapas brutos.
  - title: Configurou um workspace pub
    icon: workspaces
    details: >-
      Para simplificar o gerenciamento de dependências do seu projeto com vários pacotes,
      você criou um novo workspace pub.
      Para isso, criou um arquivo `pubspec.yaml` raiz com
      uma seção `workspace:` listando seus pacotes e, depois,
      adicionou `resolution: workspace` a cada sub-pacote.
  - title: Criou classes de modelo de dados para JSON
    icon: data_object
    details: >-
      Você criou as classes `Summary`, `TitlesSet`, `Article` e `SearchResults`
      para representar as respostas da API da Wikipedia.
      Esses modelos tipados oferecem segurança em tempo de compilação e
      suporte da IDE ao trabalhar com dados da API.
  - title: Usou pattern matching em construtores factory fromJson
    icon: bento
    details: >-
      Você implementou construtores factory `fromJson` usando o pattern
      matching do Dart, com expressões `switch` e instruções `if case`.
      Essa estrutura valida o formato do JSON e
      extrai valores em expressões concisas e legíveis.
</SummaryCard>

## Quiz {:#quiz}

<Quiz title="Confira seu entendimento" id="data-and-json" />

## Próxima lição {:#next-lesson}

Na próxima lição, você vai aprender como
testar seu código Dart usando a biblioteca `package:test`.
Escreva testes para verificar se a lógica de
desserialização JSON funciona corretamente.
