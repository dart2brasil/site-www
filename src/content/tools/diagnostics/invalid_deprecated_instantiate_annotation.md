---
ia-translate: true
title: invalid_deprecated_instantiate_annotation
description: "Detalhes sobre o diagnóstico invalid_deprecated_instantiate_annotation produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A annotation '@Deprecated.instantiate' só pode ser aplicada a classes._

## Description

O analisador produz este diagnóstico quando a annotation
`@Deprecated.instantiate` é aplicada a uma declaração que não é uma classe
instanciável. Uma classe instanciável é aquela que não é declarada com as
keywords `abstract` ou `sealed` e tem pelo menos um construtor público e
generativo.

## Example

O código a seguir produz este diagnóstico porque a annotation está em uma
classe sealed:

```dart
@[!Deprecated.instantiate!]()
sealed class C {}
```

## Common fixes

Remova a annotation:

```dart
sealed class C {}
```
