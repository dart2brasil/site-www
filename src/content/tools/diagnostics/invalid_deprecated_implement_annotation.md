---
ia-translate: true
title: invalid_deprecated_implement_annotation
description: "Detalhes sobre o diagnóstico invalid_deprecated_implement_annotation produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A annotation '@Deprecated.implement' só pode ser aplicada a classes implementáveis._

## Description

O analisador produz este diagnóstico quando a annotation
`@Deprecated.implement` é aplicada a uma declaração que não é uma classe ou
mixin implementável. Uma classe ou mixin implementável é aquele que não é
declarado com as keywords base, final ou sealed.

## Example

O código a seguir produz este diagnóstico porque a annotation está em uma
classe sealed:

```dart
@[!Deprecated.implement!]()
sealed class C {}
```

## Common fixes

Remova a annotation:

```dart
sealed class C {}
```
