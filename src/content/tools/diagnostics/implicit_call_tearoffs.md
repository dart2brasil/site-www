---
ia-translate: true
title: implicit_call_tearoffs
description: "Detalhes sobre o diagnóstico implicit_call_tearoffs produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
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

_Tear-off implícito do método 'call'._

## Descrição

O analisador produz este diagnóstico quando um objeto com um método `call`
é atribuído a uma variável do tipo função, fazendo um tear-off implícito do
método `call`.

## Exemplo

O código a seguir produz este diagnóstico porque uma instância de
`Callable` é passada para uma função esperando uma `Function`:

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

Faça o tear-off explicitamente do método `call`:

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
