---
ia-translate: true
title: use_colored_box
description: "Detalhes sobre o diagnóstico use_colored_box produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_colored_box"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use um 'ColoredBox' em vez de um 'Container' com apenas uma 'Color'._

## Descrição

O analisador produz este diagnóstico quando um `Container` é criado que
apenas define a cor.

## Exemplo

O código a seguir produz este diagnóstico porque o único atributo do
container que é definido é a `color`:

```dart
import 'package:flutter/material.dart';

Widget build() {
  return [!Container!](
    color: Colors.red,
    child: const Text('hello'),
  );
}
```

## Correções comuns

Substitua o `Container` por um `ColoredBox`:

```dart
import 'package:flutter/material.dart';

Widget build() {
  return ColoredBox(
    color: Colors.red,
    child: const Text('hello'),
  );
}
```
