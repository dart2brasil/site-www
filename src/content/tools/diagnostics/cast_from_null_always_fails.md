---
ia-translate: true
title: cast_from_null_always_fails
description: "Detalhes sobre o diagnóstico cast_from_null_always_fails produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Este cast sempre lança uma exceção porque a expressão sempre avalia para 'null'._

## Description

O analisador produz este diagnóstico quando uma expressão cujo type é
`Null` está sendo convertida (cast) para um type não-nullable.

## Example

O código a seguir produz este diagnóstico porque `n` é conhecido por sempre
ser `null`, mas está sendo convertido (cast) para um type não-nullable:

```dart
void f(Null n) {
  [!n as int!];
}
```

## Common fixes

Remova o cast desnecessário:

```dart
void f(Null n) {
  n;
}
```
