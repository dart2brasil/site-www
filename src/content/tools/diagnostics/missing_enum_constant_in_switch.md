---
title: missing_enum_constant_in_switch
description: "Detalhes sobre o diagnóstico missing_enum_constant_in_switch produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Cláusula case missing para '{0}'._

## Description

O analisador produz este diagnóstico quando uma instrução `switch` para um enum
não inclui uma opção para um dos valores do enum.

Note que `null` é sempre um valor possível para um enum e, portanto, também
deve ser tratado.

## Example

O código a seguir produz este diagnóstico porque o valor do enum `e2`
não é tratado:

```dart
enum E { e1, e2 }

void f(E e) {
  [!switch (e)!] {
    case E.e1:
      break;
  }
}
```

## Common fixes

Se há tratamento especial para os valores missing, então adicione uma cláusula `case`
para cada um dos valores missing:

```dart
enum E { e1, e2 }

void f(E e) {
  switch (e) {
    case E.e1:
      break;
    case E.e2:
      break;
  }
}
```

Se os valores missing devem ser tratados da mesma forma, então adicione uma cláusula `default`:

```dart
enum E { e1, e2 }

void f(E e) {
  switch (e) {
    case E.e1:
      break;
    default:
      break;
  }
}
```
