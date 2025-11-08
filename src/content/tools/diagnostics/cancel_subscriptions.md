---
title: cancel_subscriptions
description: >-
  Details about the cancel_subscriptions
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/cancel_subscriptions"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Uncancelled instance of 'StreamSubscription'._

## Descrição

O analisador produz este diagnóstico quando an instance of
`StreamSubscription` is created but the method `cancel` isn't invoked.

## Exemplo

O código a seguir produz este diagnóstico porque the `subscription`
isn't canceled:

```dart
import 'dart:async';

void f(Stream stream) {
  // ignore: unused_local_variable
  var [!subscription = stream.listen((_) {})!];
}
```

## Correções comuns

Cancel the subscription:

```dart
import 'dart:async';

void f(Stream stream) {
  var subscription = stream.listen((_) {});
  subscription.cancel();
}
```
