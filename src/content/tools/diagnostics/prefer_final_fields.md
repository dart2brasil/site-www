---
ia-translate: true
title: prefer_final_fields
description: "Detalhes sobre o diagnóstico prefer_final_fields produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_final_fields"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_O campo private {0} poderia ser 'final'._

## Description

O analisador produz este diagnóstico quando um campo private é apenas
atribuído uma vez. O campo pode ser inicializado em múltiplos construtores
e ainda ser sinalizado porque apenas um desses construtores pode ser executado.

## Example

O código a seguir produz este diagnóstico porque o campo `_f` é apenas
atribuído uma vez, no inicializador do campo:

```dart
class C {
  int [!_f = 1!];

  int get f => _f;
}
```

## Common fixes

Marque o campo como `final`:

```dart
class C {
  final int _f = 1;

  int get f => _f;
}
```
