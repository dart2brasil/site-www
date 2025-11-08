---
ia-translate: true
title: case_expression_type_is_not_switch_expression_subtype
description: "Detalhes sobre o diagnóstico case_expression_type_is_not_switch_expression_subtype produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O tipo '{0}' da expressão do case do switch deve ser um subtipo do tipo '{1}' da expressão do switch._

## Descrição

O analisador produz este diagnóstico quando a expressão que segue `case`
em uma instrução `switch` tem um tipo estático que não é um subtipo do
tipo estático da expressão que segue `switch`.

## Exemplo

O código a seguir produz este diagnóstico porque `1` é um `int`, que
não é um subtipo de `String` (o tipo de `s`):

```dart
void f(String s) {
  switch (s) {
    case [!1!]:
      break;
  }
}
```

## Correções comuns

Se o valor da expressão `case` estiver errado, então altere a expressão
`case` para que ela tenha o tipo necessário:

```dart
void f(String s) {
  switch (s) {
    case '1':
      break;
  }
}
```

Se o valor da expressão `case` estiver correto, então altere a expressão
`switch` para ter o tipo necessário:

```dart
void f(int s) {
  switch (s) {
    case 1:
      break;
  }
}
```
