---
ia-translate: true
title: use_decorated_box
description: "Detalhes sobre o diagnóstico use_decorated_box produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_decorated_box"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use 'DecoratedBox' em vez de um 'Container' com apenas uma 'Decoration'._

## Descrição

O analisador produz este diagnóstico quando um `Container` é criado que
apenas define a decoração.

## Exemplo

O código a seguir produz este diagnóstico porque o único atributo do
container que é definido é a `decoration`:

```dart
import 'package:flutter/material.dart';

Widget buildArea() {
  return [!Container!](
    decoration: const BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
    ),
    child: const Text('...'),
  );
}
```

## Correções comuns

Substitua o `Container` por um `DecoratedBox`:

```dart
import 'package:flutter/material.dart';

Widget buildArea() {
  return DecoratedBox(
    decoration: const BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
    ),
    child: const Text('...'),
  );
}
```
