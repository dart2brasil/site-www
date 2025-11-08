---
title: prefer_const_constructors_in_immutables
description: >-
  Details about the prefer_const_constructors_in_immutables
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_const_constructors_in_immutables"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Constructors in '@immutable' classes should be declared as 'const'._

## Descrição

O analisador produz este diagnóstico quando a non-`const` constructor is
found in a class that has the `@immutable` annotation.

## Exemplo

O código a seguir produz este diagnóstico porque the constructor in `C`
isn't declared as `const` even though `C` has the `@immutable` annotation:

```dart
import 'package:meta/meta.dart';

@immutable
class C {
  final f;

  [!C!](this.f);
}
```

## Correções comuns

If the class really is intended to be immutable, then add the `const`
modifier to the construtor:

```dart
import 'package:meta/meta.dart';

@immutable
class C {
  final f;

  const C(this.f);
}
```

If the class is mutable, then remove the `@immutable` annotation:

```dart
class C {
  final f;

  C(this.f);
}
```
