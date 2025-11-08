---
ia-translate: true
title: sized_box_for_whitespace
description: "Detalhes sobre o diagnóstico sized_box_for_whitespace produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/sized_box_for_whitespace"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use um 'SizedBox' para adicionar espaço em branco a um layout._

## Descrição

O analisador produz este diagnóstico quando um `Container` é criado usando
apenas os argumentos `height` e/ou `width`.

## Exemplo

O código a seguir produz este diagnóstico porque o `Container` tem
apenas o argumento `width`:

```dart
import 'package:flutter/material.dart';

Widget buildRow() {
  return Row(
    children: <Widget>[
      const Text('...'),
      [!Container!](
        width: 4,
        child: Text('...'),
      ),
      const Expanded(
        child: Text('...'),
      ),
    ],
  );
}
```

## Correções comuns

Substitua o `Container` por um `SizedBox` das mesmas dimensões:

```dart
import 'package:flutter/material.dart';

Widget buildRow() {
  return Row(
    children: <Widget>[
      Text('...'),
      SizedBox(
        width: 4,
        child: Text('...'),
      ),
      Expanded(
        child: Text('...'),
      ),
    ],
  );
}
```
