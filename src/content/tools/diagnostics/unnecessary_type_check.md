---
ia-translate: true
title: unnecessary_type_check
description: "Detalhes sobre o diagnóstico unnecessary_type_check produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Verificação de tipo desnecessária; o resultado é sempre 'false'._

_Verificação de tipo desnecessária; o resultado é sempre 'true'._

## Description

O analisador produz este diagnóstico quando o valor de uma verificação de tipo (usando
`is` ou `is!`) é conhecido em tempo de compilação.

## Example

O código a seguir produz este diagnóstico porque o teste `a is Object?`
é sempre `true`:

```dart
bool f<T>(T a) => [!a is Object?!];
```

## Common fixes

Se a verificação de tipo não verifica o que você pretendia verificar, então altere o
teste:

```dart
bool f<T>(T a) => a is Object;
```

Se a verificação de tipo verifica o que você pretendia verificar, então substitua a
verificação de tipo pelo seu valor conhecido ou remova-a completamente:

```dart
bool f<T>(T a) => true;
```
