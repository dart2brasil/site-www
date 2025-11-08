---
title: use_build_context_synchronously
description: >-
  Details about the use_build_context_synchronously
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_build_context_synchronously"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check._

_Don't use 'BuildContext's across async gaps._

## Descrição

O analisador produz este diagnóstico quando a `BuildContext` is referenced
by a `StatefulWidget` after an asynchronous gap without first checking the
`mounted` property.

Storing a `BuildContext` for later use can lead to difficult-to-diagnose
crashes. Asynchronous gaps implicitly store a `BuildContext`, making them
easy to overlook for diagnosis.

## Exemplo

O código a seguir produz este diagnóstico porque the `context` is
passed to a constructor after the `await`:

```dart
import 'package:flutter/material.dart';

class MyWidget extends Widget {
  void onButtonTapped(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
    Navigator.of([!context!]).pop();
  }
}
```

## Correções comuns

If you can remove the asynchronous gap, do so:

```dart
import 'package:flutter/material.dart';

class MyWidget extends Widget {
  void onButtonTapped(BuildContext context) {
    Navigator.of(context).pop();
  }
}
```

If you can't remove the asynchronous gap, then use `mounted` to guard the
use of the `context`:

```dart
import 'package:flutter/material.dart';

class MyWidget extends Widget {
  void onButtonTapped(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
```
