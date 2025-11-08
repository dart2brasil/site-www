---
ia-translate: true
title: Dados e JSON
description: "Aprenda sobre desserialização de JSON em Dart, incluindo como usar `dart:convert`, `jsonDecode` e pattern matching para trabalhar com dados JSON da API do Wikipedia."
sitemap: false
noindex: true
layout: learn
prevpage:
  url: /get-started/command-runner-polish
  title: Command runner polish
nextpage:
  url: /get-started/testing
  title: Testing
---

{% render 'fwe-wip-warning.md', site: site %}

Neste capítulo, você aprenderá como trabalhar com
dados [JSON (JavaScript Object Notation)][] em Dart.
JSON é um formato comum para troca de dados na web, e
você frequentemente o encontrará ao trabalhar com APIs.
Você aprenderá como converter dados JSON em objetos Dart,
facilitando o trabalho com eles em sua aplicação.
Você usará a [biblioteca `dart:convert`][`dart:convert` library],
a função `jsonDecode` e pattern matching.

:::secondary O que você aprenderá

*  Desserializar dados JSON em objetos Dart.
*  Usar a biblioteca `dart:convert` para trabalhar com JSON.
*  Usar a função `jsonDecode` para analisar strings JSON.
*  Usar pattern matching para extrair dados de objetos JSON.
*  Criar classes Dart para representar estruturas de dados JSON.

:::

[JSON (JavaScript Object Notation)]:  https://en.wikipedia.org/wiki/JSON
[`dart:convert` library]: {{site.dart-api}}/dart-convert

## Pré-requisitos

Antes de começar este capítulo, certifique-se de:

* Ter completado o Capítulo 8 e ter um
  ambiente de desenvolvimento Dart funcionando com o projeto `dartpedia`.
* Entender a sintaxe básica do Dart, incluindo [classes][] e tipos de dados.

[classes]: /language/classes

## Tarefas

Neste capítulo, você criará classes Dart para
representar os dados JSON retornados pela API do Wikipedia.
Isso permitirá que você acesse e use facilmente os dados em sua aplicação.

### Tarefa 1: Criar o pacote Wikipedia

Primeiro, crie um novo pacote Dart para armazenar os modelos de dados.

1.  Navegue até o diretório raiz do seu projeto (`/dartpedia`).
1.  Execute o seguinte comando no seu terminal:

    ```bash
    dart create wikipedia
    ```

    Este comando cria um novo diretório chamado `wikipedia` com a estrutura básica
    de um pacote Dart. Você deverá agora ver uma nova pasta
    `wikipedia` na raiz do seu projeto, ao lado de `cli` e `command_runner`.

### Tarefa 2: Configurar um workspace Dart

Workspaces Dart permitem que você
gerencie múltiplos pacotes relacionados dentro de um único projeto,
simplificando o gerenciamento de dependências e o desenvolvimento local.
Agora que você está adicionando seu terceiro pacote,
é um bom momento para configurar seu projeto para usar um workspace Dart.

1.  **Crie o arquivo `pubspec.yaml` raiz.**

    Navegue até o diretório raiz do seu projeto (`/dartpedia`) e crie um
    novo arquivo chamado `pubspec.yaml` com o seguinte conteúdo:

    ```yaml
    name: _
    publish_to: none

    environment:
      sdk: ^3.8.1 # IMPORTANT: Adjust this to match your Dart SDK version or a compatible range
    workspace:
      - cli
      - command_runner
      - wikipedia
    ```

1.  **Adicione resolução de workspace aos sub-pacotes.**

    Para cada um dos seus sub-pacotes (`cli`, `command_runner` e `wikipedia`),
    abra seus respectivos arquivos `pubspec.yaml` e
    adicione `resolution: workspace` ao `pubspec.yaml`.
    Isso instrui o Dart a resolver dependências dentro do workspace.

    *   Para `cli/pubspec.yaml`:

        ```yaml highlightLines=5
        # ... (existing content) ...
        name: cli
        description: A sample command-line application.
        version: 1.0.0
        resolution: workspace # Add this line
        # ... (existing content) ...
        ```

    *   For `command_runner/pubspec.yaml`:

        ```yaml highlightLines=5
        # ... (existing content) ...
        name: command_runner
        description: A starting point for Dart libraries or applications.
        version: 1.0.0
        resolution: workspace # Add this line
        # ... (existing content) ...
        ```

    *   For `wikipedia/pubspec.yaml`:

        ```yaml highlightLines=5
        # ... (existing content) ...
        name: wikipedia
        description: A sample command-line application.
        version: 1.0.0
        resolution: workspace # Add this line
        # ... (existing content) ...
        ```

### Tarefa 3: Criar a classe Summary

A API do Wikipedia retorna um objeto JSON contendo um resumo de um artigo.
Vamos criar uma classe Dart para representar este resumo.

1.  Crie o diretório `wikipedia/lib/src/model`.

    ```bash
    mkdir -p wikipedia/lib/src/model
    ```

1.  Crie o arquivo `wikipedia/lib/src/model/summary.dart`.

1.  Adicione o seguinte código a `wikipedia/lib/src/model/summary.dart`:

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

      /// Returns a new [Summary] instance
      static Summary fromJson(Map<String, Object?> json) {
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

    Este código define uma classe `Summary` com propriedades que correspondem aos
    campos na resposta JSON da API do Wikipedia.
    O método `fromJson` usa [pattern matching][] para
    extrair os dados do objeto JSON e criar uma nova instância de `Summary`.
    O método `toString` fornece uma maneira conveniente de
    imprimir o conteúdo do objeto `Summary`.
    Note que a classe `TitlesSet` é usada na classe `Summary`,
    então você precisará criá-la em seguida.

[pattern matching]: /language/patterns

### Tarefa 4: Criar a classe TitleSet

A classe `Summary` usa uma classe `TitlesSet` para representar as informações do título.
Vamos criar essa classe agora.

1.  Crie o arquivo `wikipedia/lib/src/model/title_set.dart`.

1.  Adicione o seguinte código a `wikipedia/lib/src/model/title_set.dart`:

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

      /// Returns a new [TitlesSet] instance and imports its values from a JSON map
      static TitlesSet fromJson(Map<String, Object?> json) {
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

    Este código define uma classe `TitlesSet` com propriedades que correspondem às
    informações de título na resposta JSON da API do Wikipedia.
    O método `fromJson` usa pattern matching para
    extrair os dados do objeto JSON e criar uma nova instância de `TitlesSet`.
    O método `toString` fornece uma maneira conveniente de
    imprimir o conteúdo do objeto `TitlesSet`.

### Tarefa 5: Criar a classe Article

A API do Wikipedia também retorna uma lista de artigos em um resultado de busca.
Vamos criar uma classe Dart para representar um artigo.

1.  Crie o arquivo `wikipedia/lib/src/model/article.dart`.

1.  Adicione o seguinte código a `wikipedia/lib/src/model/article.dart`:

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

    Este código define uma classe `Article` com propriedades para
    o título e extrato de um artigo.
    O método `listFromJson` usa pattern matching para
    extrair os dados do objeto JSON e
    criar uma lista de instâncias de `Article`.
    O método `toJson` converte o objeto `Article` de volta em um objeto JSON.
    O método `toString` fornece uma maneira conveniente de
    imprimir o conteúdo do objeto `Article`.

### Tarefa 6: Criar a classe SearchResults

Por fim, vamos criar uma classe para representar os
resultados de busca da API do Wikipedia.

1.  Crie o arquivo `wikipedia/lib/src/model/search_results.dart`.
2.  Adicione o seguinte código a `wikipedia/lib/src/model/search_results.dart`:

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

      static SearchResults fromJson(List<Object?> json) {
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

    Este código define uma classe `SearchResults` com uma
    lista de objetos `SearchResult` e um termo de busca.
    O método `fromJson` usa pattern matching para extrair os dados do
    objeto JSON e criar uma nova instância de `SearchResults`.
    O método `toString` fornece uma maneira conveniente de
    imprimir o conteúdo do objeto `SearchResults`.

Neste ponto, você criou modelos de dados para representar estruturas JSON.
Não há nada para testar neste momento.
Você adicionará a lógica da aplicação nas próximas seções,
o que permitirá testar como os dados são desserializados da API do Wikipedia.

## Revisão

Nesta lição, você aprendeu sobre:

*   Desserializar dados JSON em objetos Dart.
*   Usar a biblioteca `dart:convert` para trabalhar com JSON.
*   Usar a função `jsonDecode` para analisar strings JSON.
*   Usar pattern matching para extrair dados de objetos JSON.
*   Criar classes Dart para representar estruturas de dados JSON.

## Quiz

**Questão 1:** O que é JSON?

* A) Uma linguagem de programação.
* B) Um formato de serialização de dados.
* C) Um tipo de banco de dados.
* D) Um servidor web.

**Questão 2:** Qual biblioteca Dart é usada para trabalhar com dados JSON?

* A) `dart:html`
* B) `dart:json`
* C) `dart:convert`
* D) `dart:io`

**Questão 3:** Qual é o propósito do método `fromJson` na classe `Summary`?

* A) Converter um objeto `Summary` em um objeto JSON.
* B) Criar um novo objeto `Summary` a partir de um objeto JSON.
* C) Imprimir o conteúdo de um objeto `Summary`.
* D) Validar os dados em um objeto `Summary`.

## Próxima lição

Na próxima lição, você aprenderá como
testar seu código Dart usando a biblioteca `package:test`.
Você escreverá testes para garantir que sua
lógica de desserialização JSON esteja funcionando corretamente.
