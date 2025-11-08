---
ia-translate: true
title: sized_box_shrink_expand
description: >-
  Detalhes sobre o diagnóstico sized_box_shrink_expand
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
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

_Use 'SizedBox.{0}' para evitar ter que especificar 'height' e 'width'._

## Descrição

O analisador produz este diagnóstico quando uma invocação do construtor `SizedBox`
especifica os valores de `height` e `width` como
`0.0` ou `double.infinity`.

## Exemplos

O código a seguir produz este diagnóstico porque tanto `height` quanto
`width` são `0.0`:

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

O código a seguir produz este diagnóstico porque tanto `height` quanto
`width` são `double.infinity`:

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

Se ambos forem `0.0`, então use `SizedBox.shrink`:

```dart
import 'package:flutter/material.dart';

Widget build() {
  return SizedBox.shrink(
    child: const Text(''),
  );
}
```

Se ambos forem `double.infinity`, então use `SizedBox.expand`:

```dart
import 'package:flutter/material.dart';

Widget build() {
  return SizedBox.expand(
    child: const Text(''),
  );
}
```
