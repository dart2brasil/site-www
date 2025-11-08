---
title: sized_box_for_whitespace
description: >-
  Details about the sized_box_for_whitespace
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
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

_Use a 'SizedBox' to add whitespace to a layout._

## Descrição

O analisador produz este diagnóstico quando a `Container` is created using
only the `height` and/or `width` arguments.

## Exemplo

O código a seguir produz este diagnóstico porque the `Container` has
only the `width` argument:

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

Replace the `Container` with a `SizedBox` of the same dimensions:

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
