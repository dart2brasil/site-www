---
title: continue_label_invalid
description: >-
  Details about the continue_label_invalid
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
canonical: https://dart.dev/tools/diagnostics/continue_label_invalid
redirectTo: /tools/diagnostics/continue_label_invalid
sitemap: false
noindex: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_(Previously known as `continue_label_on_switch`)_

_The label used in a 'continue' statement must be defined on either a loop or a switch member._

## Descrição

O analisador produz este diagnóstico quando the label in a `continue`
statement resolves to a label on a `switch` statement.

## Exemplo

O código a seguir produz este diagnóstico porque the label `l`, used to
label a `switch` statement, is used in the `continue` statement:

```dart
void f(int i) {
  l: switch (i) {
    case 0:
      [!continue l;!]
  }
}
```

## Correções comuns

Find a different way to achieve the control flow you need; for example, by
introducing a loop that re-executes the `switch` statement.
