---
ia-translate: true
title: close_sinks
description: >-
  Detalhes sobre o diagnóstico close_sinks
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/close_sinks"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Instância não fechada de 'Sink'._

## Description

O analisador produz este diagnóstico quando uma instância de `Sink` é
criada mas o método `close` não é invocado.

## Example

O código a seguir produz este diagnóstico porque o `sink` não é
fechado:

```dart
import 'dart:io';

void g(File f) {
  var [!sink = f.openWrite()!];
  sink.write('x');
}
```

## Common fixes

Feche o sink:

```dart
import 'dart:io';

void g(File f) {
  var sink = f.openWrite();
  sink.write('x');
  sink.close();
}
```
