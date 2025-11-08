---
title: await_only_futures
description: >-
  Detalhes sobre o diagnóstico await_only_futures
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/await_only_futures"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Usa 'await' em uma instância de '{0}', que não é um subtipo de 'Future'._

## Description

O analisador produz este diagnóstico quando a expressão após `await`
tem qualquer type diferente de `Future<T>`, `FutureOr<T>`, `Future<T>?`,
`FutureOr<T>?` ou `dynamic`.

Uma exceção é feita para a expressão `await null` porque é uma
maneira comum de introduzir um atraso de microtask.

A menos que a expressão possa produzir um `Future`, o `await` é desnecessário
e pode levar um leitor a assumir um nível de assincronia que não existe.

## Example

O código a seguir produz este diagnóstico porque a expressão após
`await` tem o type `int`:

```dart
void f() async {
  [!await!] 23;
}
```

## Common fixes

Remova o `await`:

```dart
void f() async {
  23;
}
```
