---
ia-translate: true
title: void_checks
description: "Detalhes sobre o diagnóstico void_checks produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/void_checks"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Atribuição a uma variável de tipo 'void'._

## Descrição

O analisador produz este diagnóstico quando um valor é atribuído a uma
variável de tipo `void`.

Não é possível acessar o valor de tal variável, então a
atribuição não tem valor.

## Exemplo

O código a seguir produz este diagnóstico porque o campo `value` tem
o tipo `void`, mas um valor está sendo atribuído a ele:

```dart
class A<T> {
  T? value;
}

void f(A<void> a) {
  [!a.value = 1!];
}
```

O código a seguir produz este diagnóstico porque o tipo do
parâmetro `p` no método `m` é `void`, mas um valor está sendo atribuído
a ele na invocação:

```dart
class A<T> {
  void m(T p) { }
}

void f(A<void> a) {
  a.m([!1!]);
}
```

## Correções comuns

Se o tipo da variável está incorreto, então mude o tipo da
variável:

```dart
class A<T> {
  T? value;
}

void f(A<int> a) {
  a.value = 1;
}
```

Se o tipo da variável está correto, então remova a atribuição:

```dart
class A<T> {
  T? value;
}

void f(A<void> a) {}
```
