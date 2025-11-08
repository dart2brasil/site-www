---
ia-translate: true
title: unnecessary_statements
description: "Detalhes sobre o diagnóstico unnecessary_statements produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_statements"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Declaração desnecessária._

## Description

O analisador produz este diagnóstico quando uma declaração de expressão não tem
efeito claro.

## Example

O código a seguir produz este diagnóstico porque a adição dos
valores retornados das duas invocações não tem efeito claro:

```dart
void f(int Function() first, int Function() second) {
  [!first() + second()!];
}
```

## Common fixes

Se a expressão não precisa ser computada, então remova-a:

```dart
void f(int Function() first, int Function() second) {
}
```

Se o valor da expressão é necessário, então use-o, possivelmente
atribuindo-o a uma variável local primeiro:

```dart
void f(int Function() first, int Function() second) {
  print(first() + second());
}
```

Se porções da expressão precisam ser executadas, então remova as
porções desnecessárias:

```dart
void f(int Function() first, int Function() second) {
  first();
  second();
}
```
