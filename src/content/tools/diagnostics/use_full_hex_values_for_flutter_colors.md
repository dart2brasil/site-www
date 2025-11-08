---
title: use_full_hex_values_for_flutter_colors
description: >-
  Details about the use_full_hex_values_for_flutter_colors
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_full_hex_values_for_flutter_colors"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Instances of 'Color' should be created using an 8-digit hexadecimal integer (such as '0xFFFFFFFF')._

## Descrição

O analisador produz este diagnóstico quando the argument to the constructor
of the `Color` class is a literal integer that isn't represented as an
8-digit hexadecimal integer.

## Exemplo

O código a seguir produz este diagnóstico porque the argument (`1`)
isn't represented as an 8-digit hexadecimal integer:

```dart
import 'package:flutter/material.dart';

Color c = Color([!1!]);
```

## Correções comuns

Convert the representation to be an 8-digit hexadecimal integer:

```dart
import 'package:flutter/material.dart';

Color c = Color(0x00000001);
```
