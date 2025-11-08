---
ia-translate: true
title: unnecessary_final
description: >-
  Detalhes sobre o diagnóstico unnecessary_final
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_final"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Variáveis locais não devem ser marcadas como 'final'._

## Description

O analisador produz este diagnóstico quando uma variável local é marcada como
sendo `final`.

## Example

O código a seguir produz este diagnóstico porque a variável local `c`
está marcada como sendo `final`:

```dart
void f(int a, int b) {
  [!final!] c = a + b;
  print(c);
}
```

## Common fixes

Se a variável não tiver uma anotação de tipo, então substitua o `final`
por `var`:

```dart
void f(int a, int b) {
  var c = a + b;
  print(c);
}
```

Se a variável tiver uma anotação de tipo, então remova o modificador `final`:

```dart
void f(int a, int b) {
  int c = a + b;
  print(c);
}
```
