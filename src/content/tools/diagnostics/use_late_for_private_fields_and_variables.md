---
ia-translate: true
title: use_late_for_private_fields_and_variables
description: >-
  Detalhes sobre o diagnóstico use_late_for_private_fields_and_variables
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_late_for_private_fields_and_variables"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use 'late' para membros privados com um tipo não-nullable._

## Descrição

O analisador produz este diagnóstico quando um campo ou variável privado é
marcado como sendo nullable, mas toda referência assume que a variável nunca
é `null`.

## Exemplo

O código a seguir produz este diagnóstico porque a variável privada de nível superior
`_i` é nullable, mas toda referência assume que não será
`null`:

```dart
void f() {
  _i!.abs();
}

int? [!_i!];
```

## Correções comuns

Marque a variável ou campo como sendo tanto não-nullable quanto `late` para
indicar que sempre terá um valor não-null atribuído:

```dart
void f() {
  _i.abs();
}

late int _i;
```
