---
title: hash_and_equals
description: >-
  Details about the hash_and_equals
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/hash_and_equals"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Missing a corresponding override of '{0}'._

## Descrição

O analisador produz este diagnóstico quando a class or mixin either
overrides the definition of `==` but doesn't override the definition of
`hashCode`, or conversely overrides the definition of `hashCode` but
doesn't override the definition of `==`.

Both the `==` operator and the `hashCode` property of objects must be
consistent for a common hash map implementation to function properly. As a
result, when overriding either method, both should be overridden.

## Exemplo

O código a seguir produz este diagnóstico porque a classe `C`
overrides the `==` operator but doesn't override the getter `hashCode`:

```dart
class C {
  final int value;

  C(this.value);

  @override
  bool operator [!==!](Object other) =>
      other is C &&
      other.runtimeType == runtimeType &&
      other.value == value;
}
```

## Correções comuns

If you need to override one of the members, then add an override of the
other:

```dart
class C {
  final int value;

  C(this.value);

  @override
  bool operator ==(Object other) =>
      other is C &&
      other.runtimeType == runtimeType &&
      other.value == value;

  @override
  int get hashCode => value.hashCode;
}
```

If you don't need to override either of the members, then remove the
unnecessary override:

```dart
class C {
  final int value;

  C(this.value);
}
```
