---
ia-translate: true
title: avoid_empty_else
description: "Detalhes sobre o diagnóstico avoid_empty_else produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_empty_else"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Declarações vazias não são permitidas em uma cláusula 'else'._

## Description

O analisador produz este diagnóstico quando a declaração após um `else`
é uma declaração vazia (um ponto e vírgula).

Para mais informações, veja a documentação para
[`avoid_empty_else`](https://dart.dev/diagnostics/avoid_empty_else).

## Example

O código a seguir produz este diagnóstico porque a declaração
após o `else` é uma declaração vazia:

```dart
void f(int x, int y) {
  if (x > y)
    print("1");
  else [!;!]
    print("2");
}
```

## Common fixes

Se a declaração após a declaração vazia deve ser executada apenas
quando a condição é `false`, então remova a declaração vazia:

```dart
void f(int x, int y) {
  if (x > y)
    print("1");
  else
    print("2");
}
```

Se não há código que deve ser executado apenas quando a
condição é `false`, então remova toda a cláusula `else`:

```dart
void f(int x, int y) {
  if (x > y)
    print("1");
  print("2");
}
```
