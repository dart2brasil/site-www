---
ia-translate: true
title: cancel_subscriptions
description: "Detalhes sobre o diagnóstico cancel_subscriptions produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
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

_Instância não cancelada de 'StreamSubscription'._

## Description

O analisador produz este diagnóstico quando uma instância de
`StreamSubscription` é criada mas o método `cancel` não é invocado.

## Example

O código a seguir produz este diagnóstico porque a `subscription`
não foi cancelada:

```dart
import 'dart:async';

void f(Stream stream) {
  // ignore: unused_local_variable
  var [!subscription = stream.listen((_) {})!];
}
```

## Common fixes

Cancele a subscription:

```dart
import 'dart:async';

void f(Stream stream) {
  var subscription = stream.listen((_) {});
  subscription.cancel();
}
```
