---
ia-translate: true
title: invalid_deprecated_extend_annotation
description: "Detalhes sobre o diagnóstico invalid_deprecated_extend_annotation produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A annotation '@Deprecated.extend' só pode ser aplicada a classes extensíveis._

## Description

O analisador produz este diagnóstico quando a annotation `@Deprecated.extend`
é aplicada a uma declaração que não é uma classe extensível. Uma classe
extensível é aquela que não é declarada com as keywords `interface`,
`final` ou `sealed` e tem pelo menos um construtor público e generativo.

## Example

O código a seguir produz este diagnóstico porque a annotation está em uma
classe sealed:

```dart
@[!Deprecated.extend!]()
sealed class C {}
```

## Common fixes

Remova a annotation:

```dart
sealed class C {}
```
