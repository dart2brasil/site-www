---
ia-translate: true
title: prefer_inlined_adds
description: "Detalhes sobre o diagnóstico prefer_inlined_adds produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_inlined_adds"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_A adição de um item de lista poderia ser embutida._

_A adição de múltiplos itens de lista poderia ser embutida._

## Description

O analisador produz este diagnóstico quando os métodos `add` e `addAll`
são invocados em um literal de lista onde os elementos sendo adicionados poderiam ser
incluídos no literal de lista.

## Example

O código a seguir produz este diagnóstico porque o método `add` está
sendo usado para adicionar `b`, quando poderia ter sido incluído diretamente no
literal de lista:

```dart
List<String> f(String a, String b) {
  return [a]..[!add!](b);
}
```

O código a seguir produz este diagnóstico porque o método `addAll` está
sendo usado para adicionar os elementos de `b`, quando poderiam ter sido incluídos
diretamente no literal de lista:

```dart
List<String> f(String a, List<String> b) {
  return [a]..[!addAll!](b);
}
```

## Common fixes

Se o método `add` está sendo usado, torne o argumento um elemento da
lista e remova a invocação:

```dart
List<String> f(String a, String b) {
  return [a, b];
}
```

Se o método `addAll` está sendo usado, use o operador spread no
argumento para adicionar seus elementos à lista e remova a invocação:

```dart
List<String> f(String a, List<String> b) {
  return [a, ...b];
}
```
