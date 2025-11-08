---
ia-translate: true
title: prefer_const_constructors_in_immutables
description: >-
  Detalhes sobre o diagnóstico prefer_const_constructors_in_immutables
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
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

_Construtores em classes '@immutable' devem ser declarados como 'const'._

## Description

O analisador produz este diagnóstico quando um construtor não-`const` é
encontrado em uma classe que tem a anotação `@immutable`.

## Example

O código a seguir produz este diagnóstico porque o construtor em `C`
não está declarado como `const` mesmo que `C` tenha a anotação `@immutable`:

```dart
import 'package:meta/meta.dart';

@immutable
class C {
  final f;

  [!C!](this.f);
}
```

## Common fixes

Se a classe realmente é imutável, adicione o modificador `const`
ao construtor:

```dart
import 'package:meta/meta.dart';

@immutable
class C {
  final f;

  const C(this.f);
}
```

Se a classe é mutável, remova a anotação `@immutable`:

```dart
class C {
  final f;

  C(this.f);
}
```
