---
ia-translate: true
title: unnecessary_unawaited
description: >-
  Detalhes sobre o diagnóstico unnecessary_unawaited
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_unawaited"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Uso desnecessário de 'unawaited'._

## Description

O analisador produz este diagnóstico quando `unawaited` é usado para marcar uma
chamada a uma função, método, ou operador, ou uma referência a um campo,
getter, ou variável de nível superior como seguramente não sendo esperado, mas o membro
chamado também está anotado com `@awaitNotRequired`. Esta anotação em si
sinaliza que envolver com `unawaited` é desnecessário em qualquer local de chamada.

## Example

O código a seguir produz este diagnóstico porque `unawaited` é invocado
em uma chamada a uma função que está anotada com `@awaitNotRequired`:

```dart
import 'dart:async';
import 'package:meta/meta.dart';

@awaitNotRequired
Future<bool> log(String message) async => true;

void f() {
  [!unawaited!](log('Message.'));
}
```

## Common fixes

Remova a invocação de `unawaited`:

```dart
import 'package:meta/meta.dart';

@awaitNotRequired
Future<bool> log(String message) async => true;

void f() {
  log('Message.');
}
```
