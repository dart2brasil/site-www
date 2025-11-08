---
ia-translate: true
title: prefer_const_declarations
description: >-
  Detalhes sobre o diagnóstico prefer_const_declarations
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
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

_Use 'const' para variáveis final inicializadas com um valor constante._

## Description

O analisador produz este diagnóstico quando uma variável de nível superior, campo static
ou variável local é marcada como `final` e é inicializada com um
valor constante.

## Examples

O código a seguir produz este diagnóstico porque a variável de nível superior
`v` é tanto `final` quanto inicializada com um valor constante:

```dart
[!final v = const <int>[]!];
```

O código a seguir produz este diagnóstico porque o campo static `f`
é tanto `final` quanto inicializado com um valor constante:

```dart
class C {
  static [!final f = const <int>[]!];
}
```

O código a seguir produz este diagnóstico porque a variável local `v`
é tanto `final` quanto inicializada com um valor constante:

```dart
void f() {
  [!final v = const <int>[]!];
  print(v);
}
```

## Common fixes

Substitua a keyword `final` por `const` e remova `const` do
inicializador:

```dart
class C {
  static const f = <int>[];
}
```
