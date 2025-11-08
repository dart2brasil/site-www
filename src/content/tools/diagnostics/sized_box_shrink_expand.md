---
title: sized_box_shrink_expand
description: >-
  Details about the sized_box_shrink_expand
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/sized_box_shrink_expand"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use 'SizedBox.{0}' to avoid needing to specify the 'height' and 'width'._

## Descrição

O analisador produz este diagnóstico quando a `SizedBox` constructor
invocation specifies the values of both `height` and `width` as either
`0.0` or `double.infinity`.

## Exemplos

O código a seguir produz este diagnóstico porque both the `height` and
`width` are `0.0`:

```dart
import 'package:flutter/material.dart';

Widget build() {
  return [!SizedBox!](
    height: 0.0,
    width: 0.0,
    child: const Text(''),
  );
}
```

O código a seguir produz este diagnóstico porque both the `height` and
`width` are `double.infinity`:

```dart
import 'package:flutter/material.dart';

Widget build() {
  return [!SizedBox!](
    height: double.infinity,
    width: double.infinity,
    child: const Text(''),
  );
}
```

## Correções comuns

If both are `0.0`, then use `SizedBox.shrink`:

```dart
import 'package:flutter/material.dart';

Widget build() {
  return SizedBox.shrink(
    child: const Text(''),
  );
}
```

If both are `double.infinity`, then use `SizedBox.expand`:

```dart
import 'package:flutter/material.dart';

Widget build() {
  return SizedBox.expand(
    child: const Text(''),
  );
}
```
