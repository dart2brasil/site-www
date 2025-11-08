---
ia-translate: true
title: invalid_deprecated_subclass_annotation
description: "Detalhes sobre o diagnóstico invalid_deprecated_subclass_annotation produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A anotação '@Deprecated.subclass' só pode ser aplicada a classes e mixins que podem ter subclasses._

## Description

O analisador produz este diagnóstico quando algo diferente de uma
classe ou mixin que pode ter subclasses é anotado com
`@Deprecated.subclass`. Uma classe que pode ter subclasses é uma classe não declarada com as keywords `final` ou `sealed`. Um
mixin que pode ter subclasses é um mixin não declarado com a keyword `base`.

## Example

O código a seguir produz este diagnóstico porque a anotação está em uma
classe sealed:

```dart
@[!Deprecated.subclass!]()
sealed class C {}
```

## Common fixes

Remova a anotação:

```dart
sealed class C {}
```
