---
ia-translate: true
title: throw_of_invalid_type
description: >-
  Detalhes sobre o diagnóstico throw_of_invalid_type
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O type '{0}' da expressão lançada deve ser atribuível a 'Object'._

## Descrição

O analisador produz este diagnóstico quando o tipo da expressão em uma
expressão throw não é atribuível a `Object`. Não é válido lançar
`null`, então não é válido usar uma expressão que possa ser avaliada como
`null`.

## Exemplo

O código a seguir produz este diagnóstico porque `s` pode ser `null`:

```dart
void f(String? s) {
  throw [!s!];
}
```

## Correções comuns

Adicione uma verificação explícita de null à expressão:

```dart
void f(String? s) {
  throw s!;
}
```
