---
ia-translate: true
title: enum_constant_same_name_as_enclosing
description: "Detalhes sobre o diagnóstico enum_constant_same_name_as_enclosing produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O nome do valor do enum não pode ser o mesmo que o nome do enum._

## Descrição

O analisador produz este diagnóstico quando um valor de enum tem o mesmo nome
que o enum no qual é declarado.

## Exemplo

O código a seguir produz este diagnóstico porque o valor do enum `E` tem
o mesmo nome que o enum que o contém `E`:

```dart
enum E {
  [!E!]
}
```

## Correções comuns

Se o nome do enum estiver correto, então renomeie a constante:

```dart
enum E {
  e
}
```

Se o nome da constante estiver correto, então renomeie o enum:

```dart
enum F {
  E
}
```
