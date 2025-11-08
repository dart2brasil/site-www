---
ia-translate: true
title: avoid_print
description: >-
  Detalhes sobre o diagnóstico avoid_print
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_print"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Não invoque 'print' em código de produção._

## Description

O analisador produz este diagnóstico quando a função `print` é invocada
em código de produção.

## Example

O código a seguir produz este diagnóstico porque a função `print`
não pode ser invocada em produção:

```dart
void f(int x) {
  [!print!]('x = $x');
}
```

## Common fixes

Se você está escrevendo código que usa Flutter, então use a função
[`debugPrint`][debugPrint], protegida por um teste
usando [`kDebugMode`][kDebugMode]:

```dart
import 'package:flutter/foundation.dart';

void f(int x) {
  if (kDebugMode) {
    debugPrint('x = $x');
  }
}
```

Se você está escrevendo código que não usa Flutter, então use um serviço
de logging, como [`package:logging`][package-logging], para escrever as
informações.

[debugPrint]: https://api.flutter.dev/flutter/foundation/debugPrint.html
[kDebugMode]: https://api.flutter.dev/flutter/foundation/kDebugMode-constant.html
[package-logging]: https://pub.dev/packages/logging
