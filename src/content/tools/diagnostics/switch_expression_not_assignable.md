---
ia-translate: true
title: switch_expression_not_assignable
description: "Detalhes sobre o diagnóstico switch_expression_not_assignable produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O type '{0}' da expressão switch não é atribuível ao type '{1}' das expressões case._

## Descrição

O analisador produz este diagnóstico quando o tipo da expressão em uma
instrução `switch` não é atribuível ao tipo das expressões nas
cláusulas `case`.

## Exemplo

O código a seguir produz este diagnóstico porque o tipo de `s`
(`String`) não é atribuível ao tipo de `0` (`int`):

```dart
void f(String s) {
  switch ([!s!]) {
    case 0:
      break;
  }
}
```

## Correções comuns

Se o tipo das expressões `case` estiver correto, então altere a
expressão na instrução `switch` para ter o tipo correto:

```dart
void f(String s) {
  switch (int.parse(s)) {
    case 0:
      break;
  }
}
```

Se o tipo da expressão `switch` estiver correto, então altere as expressões
`case` para ter o tipo correto:

```dart
void f(String s) {
  switch (s) {
    case '0':
      break;
  }
}
```
