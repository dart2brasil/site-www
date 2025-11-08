---
title: prefer_const_declarations
description: >-
  Details about the prefer_const_declarations
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_const_declarations"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use 'const' for final variables initialized to a constant value._

## Descrição

O analisador produz este diagnóstico quando a top-level variable, static
field, or local variable está marcado como `final` and is initialized to a
constant value.

## Exemplos

O código a seguir produz este diagnóstico porque the top-level variable
`v` is both `final` and initialized to a constant value:

```dart
[!final v = const <int>[]!];
```

O código a seguir produz este diagnóstico porque the static field `f`
is both `final` and initialized to a constant value:

```dart
class C {
  static [!final f = const <int>[]!];
}
```

O código a seguir produz este diagnóstico porque the local variable `v`
is both `final` and initialized to a constant value:

```dart
void f() {
  [!final v = const <int>[]!];
  print(v);
}
```

## Correções comuns

Replace the keyword `final` with `const` and remove `const` from the
initializer:

```dart
class C {
  static const f = <int>[];
}
```
