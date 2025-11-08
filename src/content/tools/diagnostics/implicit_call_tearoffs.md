---
title: implicit_call_tearoffs
description: >-
  Details about the implicit_call_tearoffs
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/implicit_call_tearoffs"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Implicit tear-off of the 'call' method._

## Descrição

O analisador produz este diagnóstico quando an object with a `call` method
is assigned to a function-typed variable, implicitly tearing off the
`call` method.

## Exemplo

O código a seguir produz este diagnóstico porque an instance of
`Callable` is passed to a function expecting a `Function`:

```dart
class Callable {
  void call() {}
}

void callIt(void Function() f) {
  f();
}

void f() {
  callIt([!Callable()!]);
}
```

## Correções comuns

Explicitly tear off the `call` method:

```dart
class Callable {
  void call() {}
}

void callIt(void Function() f) {
  f();
}

void f() {
  callIt(Callable().call);
}
```
