---
ia-translate: true
title: "Explorando coleções em Dart"
description: "Se você já chamou add(), addAll(), map() ou toList() para montar uma lista ou um map, talvez queira conhecer collection if, collection for e spreads…"
publishDate: 2020-09-15
author: johnpryan
image: images/1NLasdGsxG6bBzWYfe_9UJA.webp
category: deep-dive
layout: blog
---


<DashImage src="images/1NLasdGsxG6bBzWYfe_9UJA.webp" alt="Person pointing at a pineapple on a produce stand." />


Se você já chamou `add()`, `addAll()`, `map()` ou `toList()` para montar uma lista ou um map, talvez queira conhecer *collection if*, *collection for* e *spreads*. No ano passado, o Dart [adicionou esses recursos na versão 2.3](/blog/announcing-dart-2-3-optimized-for-building-user-interfaces).

Neste artigo, vamos ver as coleções, explorar esses novos recursos e conferir alguns exemplos interessantes. Ao dominar esses recursos, você pode deixar seu código mais sucinto e mais fácil de ler.

## Coleções {:#collections}

Primeiro, precisamos entender o que é uma coleção. Uma [coleção](https://api.dart.dev/stable/dart-core/dart-core-library.html#collections) é um objeto que contém outros objetos. Por exemplo:

* **List**: uma coleção ordenada de objetos com um tamanho (também chamada de *array*)

* **Set**: uma coleção não ordenada de objetos únicos

* **Map**: uma coleção não ordenada de pares chave-valor

* **Queue**: uma coleção ordenada que pode adicionar/remover objetos em ambas as extremidades

* **SplayTreeMap**: uma coleção ordenada de pares chave-valor baseada em uma árvore binária autobalanceada

Esses tipos estão disponíveis no pacote [dart:collection](https://api.dart.dev/stable/dart-collection/dart-collection-library.html). Para ainda mais tipos de coleção, confira o [package:collection](https://pub.dev/packages/collection) no pub.dev.

Cada um desses tipos de coleção implementa o [Iterable](https://api.dart.dev/stable/dart-core/Iterable-class.html), que oferece comportamentos comuns, como executar uma função em cada objeto da coleção, obter o primeiro objeto, determinar o tamanho da coleção e muito mais.

## Literais de coleção {:#collection-literals}

O Dart oferece sintaxe para construir três tipos de coleção: literais de lista (`[]`), literais de map (`{}`) e literais de set (também `{}`).

Aqui está um literal de lista:

```
List<String> getArtists() {
  return [
    'Picasso',
    'Warhol',
    'Monet',
  ];
}
```


Aqui está um literal de map:

```
Map<String, String> getArtistsByPainting {
  return {
    'The Old Guitarist': 'Picasso',
    'Orange Prince': 'Warhol',
    'The Water Lily Pond': 'Monet',
  };
}
```


E aqui está um literal de set, adicionado no Dart 2.3:

```
Set<String> getArtistsSet() {
  return {
    'Picasso',
    'Warhol',
    'Monet',
  };
}
```


Se você está se perguntando por que maps e sets podem usar a mesma sintaxe `{}`, é porque o Dart usa [inferência de tipos](https://dart.dev/guides/language/type-system#type-inference) para diferenciá-los. O sistema de tipos determina o tipo com base no tipo dos parâmetros `a` e `b`. Geralmente, ele consegue determinar isso com base no conteúdo — por exemplo, `{1}` é claramente um `Set`, e `{1: 2}` é claramente um `Map`.
> **Nota:** Usar `{}` constrói um map por padrão. Para criar um set, você pode usar uma anotação de tipo genérico: `&lt;String&gt;{}`. Usando dois parâmetros de tipo genérico, cria-se um map: `&lt;String, String&gt;{}`.

## Tipos de elementos {:#types-of-elements}

Cada item em um literal de coleção geralmente é um valor ou uma expressão, mas também pode ser um destes novos recursos: um *collection if*, um *collection for* ou um *spread*. Todos eles são chamados de *elementos*.

Cada elemento desempacota zero ou mais itens e os coloca na coleção que o envolve. Por exemplo, um literal de string (digamos, `"oatmeal"`) resulta em um item, mas um *collection for* desempacota 0 ou mais itens. Esses recursos também podem ser combinados de formas interessantes, como vamos explorar a seguir.

### Spreads {:#spreads}

Um *spread* pega uma coleção (por exemplo, uma lista) e coloca o conteúdo dela na coleção que o envolve:

```
List<String> combineLists(List<String> a, List<String> b) {
  return [
    ...a,
    ...b,
  ];
}
```


O código anterior é equivalente a este:

```
List<String> combineLists(List<String> a, List<String> b) {
  var list = [];
  list.addAll(a);
  list.addAll(b);
  return list;
}
```


Você também pode usar spreads em literais de map e de set:

```
Map<String, String> combineMaps(Map<String, String> a, Map<String, String> b) {
  return {
    ...a,
    ...b,
  };
}

Set<String> combineSets(Set<String> a, Set<String> b) {
  return {
    ...a,
    ...b,
  };
}
```


Tanto em maps quanto em sets, o conteúdo de `b` sobrescreve o conteúdo de `a` quando há conflito. Por exemplo, chamar `combineMaps({'foo': 'bar'}, {'foo': 'baz'})` resulta em um map contendo `{'foo': 'baz'}`.

### Spreads com verificação de null (`…?`) {:#null-aware-spreads}

Um *spread com verificação de null* adiciona o conteúdo à coleção somente se a expressão depois do operador não for null:

```
List<String> combineIfExists(List<String> a, List<String> b) {
  return [
    ...?a,
    ...?b,
  ];
}

void main() {
  var result = combineIfExists(['foo'], null);
  print(result); // [foo]
}
```


### Collection if {:#collection-if}

Use as palavras-chave `if`, `else` e `else if` para adicionar algo a uma coleção com base em uma condição. Aqui está um exemplo de *collection if*:

```
class Article {
  String title;
  DateTime date;

  Article(this.title, this.date);

  String toString() {
    return [
      if (title != null) title,
      date.toString(),
    ].join(', ');
  }
}
```


A palavra-chave `else` pode ser adicionada no fim:

```
String toString() {
  return [
     if (title != null) title else '(no title)',
  ].join(', ');
}
```


Repare onde está a vírgula. A vírgula não pode ficar depois de `title`, porque o `else` faz parte do mesmo elemento. Manter o `if` e o `else` juntos antes da vírgula é o que os mantém separados do próximo elemento da coleção.

Adicionar um `else if` também funciona:

```
String toString() {
  return [
    if (title != null) title else '(no title)',
    if (date == null)
      '(no date)'
    else if (date.year == DateTime.now().year)
      'this year'
    else
      '${date.year}',
  ].join(', ');
}
```


### Collection for {:#collection-for}

Por fim, use a palavra-chave `for` para inserir uma sequência na coleção:

```
class Article {
  String title;
  DateTime date;
  List<String> tags;

  Article(this.title, this.date, this.tags);

  String toString() {
    return [
      title,
      date.toString(),
      for (var tag in tags) 'tag: $tag'
    ].join(', ');
  }
}
```


Neste exemplo, a expressão `for` adiciona uma string para cada item da lista `tags`. Assim como um `for` normal em Dart, a expressão `tags` pode ser qualquer `Iterable`.

## Coleções em código Flutter {:#collections-in-flutter-code}

Se você usa Dart, há uma boa chance de estar [usando-o para construir apps Flutter](https://www.zdnet.com/article/googles-flutter-2-million-developers-uptick-in-enterprise-use-new-release-model-revealed/). Como os recursos descritos aqui foram [projetados pensando no Flutter](https://github.com/munificent/ui-as-code/blob/master/Motivation.md), vamos dar uma olhada em código Flutter.

### Refatorando um método build() {:#refactoring-a-build-method}

No Flutter, é comum montar uma lista de widgets em um método `build()`:

```
[@override](http://twitter.com/override)
Widget build(BuildContext context) {
  var articleWidgets = articles
      .map<Widget>((article) => ArticleWidget(article: article))
      .toList();

  return ListView(
    children: articleWidgets,
  );
}
```


Isso poderia ser reescrito com um spread:

```
Widget build(BuildContext context) {

  return ListView(
    children: [
      ...articles.map((article) => ArticleWidget(article:article))
    ],
  );
}
```


Ou com um *collection for*:

```
Widget build(BuildContext context) {
  return ListView(
    children: [
      for (var article in articles)
        ArticleWidget(article: article)
    ],
  );
}
```


O primeiro trecho converte a lista de `Article` em uma coleção de objetos `ArticleWidget` usando `map()` e, em seguida, aplica o operador spread para expandi-los na lista que os envolve. No segundo exemplo, o operador *collection for* permite expressar isso de forma um pouco mais sucinta.

### Um método build() maior {:#a-larger-build-method}

Aqui está um exemplo mais complexo:

```
Widget build(BuildContext context) {
  var headerStyle = Theme.of(context).textTheme.headline4;

  return Column(
    children: [
      if (article.title != null)
        Text(article.title, style: headerStyle),
      if (article.date != null)
        Text(article.date.toString()),
      Text('Tags:'),
      for (var tag in article.tags)
        Text(tag),
    ],
  );
}
```


A lógica para posicionar os widgets na `Column` fica exatamente onde o leitor esperaria, e economiza muito código. Antes desses recursos, a forma mais comum de obter o mesmo comportamento era criar uma variável e usar `if` normais que chamavam `add()`.

## Combinando esses recursos {:#combining-these-features}

Esses recursos podem ser combinados de formas interessantes, como mostram os exemplos desta seção. Aqui estão alguns pontos a ter em mente:

* Sintaticamente, um *collection if*, um *collection for* ou um *spread* é um *único elemento*, mesmo que acabe criando vários objetos.

* Qualquer expressão pode estar no corpo de um *collection if* ou de um *collection for*.

* Qualquer *elemento* pode estar no corpo de um *collection if* ou de um *collection for*.

### Usando if e for juntos {:#using-if-and-for-together}

Aqui está um código que cria uma lista usando um *collection if* dentro de um *collection for*. Aqui, cada artigo é adicionado à lista se for posterior a uma certa data:

```
List<Article> recentArticles(List<Article> allArticles) {
  var ninetyDaysAgo = DateTime.now().subtract(Duration(days: 90));
  return [
    for (var article in allArticles)
      if (article.date.isAfter(ninetyDaysAgo))
        article
  ];
}
```


Se você preferir spreads, o valor de retorno poderia, em vez disso, ser escrito como `...allArticles.where((article) =&gt; article.date.isAfter(ninetyDaysAgo))`.

### Usando collection if e spreads juntos {:#using-collection-if-and-spreads-together}

Um *collection if* recebe um único elemento, mas, se você quiser incluir mais de um, pode usar um spread:

```
Widget build(BuildContext context) {
  return Column(
    children: [
      if (article.date != null) ...[
        Icon(Icons.calendar_today),
        Text('${article.date}'),
      ],
    ],
  );
}
```


### Usando recursos de coleção com async-await {:#using-collection-features-with-async-await}

Você também pode combinar chamadas assíncronas com literais de coleção. Por exemplo, um padrão comum é usar `Future.wait()` para disparar um grupo de chamadas assíncronas:

```
Future<Article> fetchArticle(String id);

Future<List<Article>> fetchArticles() async {
  return Future.wait([
    fetchArticle('1'),
    fetchArticle('2'),
    fetchArticle('3'),
  ]);
}
```


Esse código pode ser melhorado usando um *collection for*:

```
Future<List<Article>> fetchArticles(List<String> ids) async {
  return Future.wait([
    for (var id in ids)
      fetchArticle(id),
  ]);
}
```


Também é possível colocar um `await` em um literal de coleção, embora ele vá esperar cada future em sequência:

```
Future<List<Article>> fetchArticles(List<String> ids) async {
  return [
    // fetches one at a time
    for (var id in ids)
      await fetchArticle(id),
  ];
}
```


O código anterior espera em sequência porque é equivalente ao seguinte:

```
Future<List<Article>> fetchArticles() async {
  return <Article>[
    // fetches one at a time
    await fetchArticle('1'),
    await fetchArticle('2'),
    await fetchArticle('3'),
  ];
}
```


Você também pode expandir um Stream usando `await for`:

```
Stream<String> get idStream => Stream.fromIterable(['1','2','3']);
Future<List<String>> gatherIds(Stream<String> ids) async {
  return [
    await for (var id in ids)
      id
  ];
}

void main() async {
  print(await gatherIds(idStream)); // [1, 2, 3]
}
```


Este é mais um exemplo de como *collection if*, *collection for* e spreads funcionam com outras partes da linguagem. Se você já usou uma instrução `await for`, pode conseguir adivinhar o comportamento: ela escuta o stream em busca de novos valores e coloca o corpo na lista que a envolve.

## Explorando mais {:#exploring-further}

Espero que estas dicas ajudem você a escrever um código Dart mais limpo. Há ainda mais formas de usar esses recursos do que as mencionadas aqui. Se você encontrar uma técnica legal, [compartilhe com a comunidade](https://dart.dev/community) ou [mencione *@dart_lang* no Twitter](https://twitter.com/dart_lang). Para mais detalhes, confira [Tornando o Dart uma linguagem melhor para UI](/blog/making-dart-a-better-language-for-ui) ou a [proposta inicial de linguagem no GitHub](https://github.com/dart-lang/language/blob/master/accepted/2.3/unified-collections/feature-specification.md).
