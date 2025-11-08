---
ia-translate: true
title: for_in_of_invalid_element_type
description: "Detalhes sobre o diagnóstico for_in_of_invalid_element_type produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O tipo '{0}' usado no loop 'for' deve implementar '{1}' com um argumento de tipo que possa ser atribuído a '{2}'._

## Descrição

O analisador produz este diagnóstico quando o `Iterable` ou `Stream` em um
loop for-in tem um tipo de elemento que não pode ser atribuído à variável
do loop.

## Exemplo

O código a seguir produz este diagnóstico porque `<String>[]` tem um
tipo de elemento `String`, e `String` não pode ser atribuído ao tipo de `e`
(`int`):

```dart
void f() {
  for (int e in [!<String>[]!]) {
    print(e);
  }
}
```

## Correções comuns

Se o tipo da variável do loop está correto, então atualize o tipo do
iterável:

```dart
void f() {
  for (int e in <int>[]) {
    print(e);
  }
}
```

Se o tipo do iterável está correto, então atualize o tipo da variável
do loop:

```dart
void f() {
  for (String e in <String>[]) {
    print(e);
  }
}
```
