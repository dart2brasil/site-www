---
ia-translate: true
title: collection_methods_unrelated_type
description: "Detalhes sobre o diagnóstico collection_methods_unrelated_type produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/collection_methods_unrelated_type"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_O tipo do argumento '{0}' não está relacionado a '{1}'._

## Description

O analisador produz este diagnóstico quando qualquer um dos vários métodos nas
bibliotecas principais são invocados com argumentos de um tipo inadequado.
Esses métodos são aqueles que não fornecem um tipo específico o suficiente para o
parâmetro para permitir que a verificação de tipo normal detecte o erro.

Os argumentos que são verificados são:
- um argumento para `Iterable<E>.contains` deve estar relacionado a `E`
- um argumento para `List<E>.remove` deve estar relacionado a `E`
- um argumento para `Map<K, V>.containsKey` deve estar relacionado a `K`
- um argumento para `Map<K, V>.containsValue` deve estar relacionado a `V`
- um argumento para `Map<K, V>.remove` deve estar relacionado a `K`
- um argumento para `Map<K, V>.[]` deve estar relacionado a `K`
- um argumento para `Queue<E>.remove` deve estar relacionado a `E`
- um argumento para `Set<E>.lookup` deve estar relacionado a `E`
- um argumento para `Set<E>.remove` deve estar relacionado a `E`

## Example

O código a seguir produz este diagnóstico porque o argumento para
`contains` é uma `String`, que não é atribuível a `int`, o tipo de elemento
da list `l`:

```dart
bool f(List<int> l)  => l.contains([!'1'!]);
```

## Common fixes

Se o tipo do elemento está correto, então altere o argumento para ter o mesmo
tipo:

```dart
bool f(List<int> l)  => l.contains(1);
```

Se o tipo do argumento está correto, então altere o tipo do elemento:

```dart
bool f(List<String> l)  => l.contains('1');
```
