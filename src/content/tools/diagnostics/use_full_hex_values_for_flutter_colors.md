---
ia-translate: true
title: use_full_hex_values_for_flutter_colors
description: >-
  Detalhes sobre o diagnóstico use_full_hex_values_for_flutter_colors
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
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

_Instâncias de 'Color' devem ser criadas usando um inteiro hexadecimal de 8 dígitos (como '0xFFFFFFFF')._

## Descrição

O analisador produz este diagnóstico quando o argumento para o construtor
da classe `Color` é um inteiro literal que não está representado como um
inteiro hexadecimal de 8 dígitos.

## Exemplo

O código a seguir produz este diagnóstico porque o argumento (`1`)
não está representado como um inteiro hexadecimal de 8 dígitos:

```dart
import 'package:flutter/material.dart';

Color c = Color([!1!]);
```

## Correções comuns

Converta a representação para ser um inteiro hexadecimal de 8 dígitos:

```dart
import 'package:flutter/material.dart';

Color c = Color(0x00000001);
```
