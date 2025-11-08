---
ia-translate: true
title: unawaited_futures
description: "Detalhes sobre o diagnóstico unawaited_futures produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unawaited_futures"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Falta um 'await' para o 'Future' calculado por esta expressão._

## Description

O analisador produz este diagnóstico em uma expressão com tipo `Future`,
apenas em alguns casos específicos:

* quando a expressão é em si uma instrução (como `f();`),
* quando a expressão é parte de um cascade (como `C()..f()`),
* quando a expressão é uma interpolação de String (como `'${f()}'`).

O analisador só produz este diagnóstico em expressões dentro de uma
função `async` ou `async*`.

As duas correções comuns são fazer 'await' da expressão, ou envolver a
expressão em uma chamada para `unawaited()`.

## Example

O código a seguir produz este diagnóstico porque a função `g`
retorna um future, mas o future não é aguardado:

```dart
Future<void> f() async {
  [!g!]();
}

Future<int> g() => Future.value(0);
```

## Common fixes

Se o future precisa ser completado antes que o código seguinte seja executado,
então adicione um `await` antes da invocação:

```dart
Future<void> f() async {
  await g();
}

Future<int> g() => Future.value(0);
```

Se o future não precisa ser completado antes que o código seguinte seja
executado, então envolva a invocação que retorna `Future` em uma invocação da
função `unawaited`:

```dart
import 'dart:async';

Future<void> f() async {
  unawaited(g());
}

Future<int> g() => Future.value(0);
```
