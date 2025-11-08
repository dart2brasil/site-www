---
ia-translate: true
title: unnecessary_late
description: >-
  Detalhes sobre o diagnóstico unnecessary_late
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_late"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Modificador 'late' desnecessário._

## Description

O analisador produz este diagnóstico quando uma variável de nível superior ou campo
estático com um inicializador é marcado como `late`. Variáveis de nível superior e
campos estáticos são implicitamente late, então não precisam ser explicitamente
marcados.

## Example

O código a seguir produz este diagnóstico porque o campo estático `c`
tem o modificador `late` mesmo tendo um inicializador:

```dart
class C {
  static [!late!] String c = '';
}
```

## Common fixes

Remova a keyword `late`:

```dart
class C {
  static String c = '';
}
```
