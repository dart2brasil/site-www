---
ia-translate: true
title: switch_on_type
description: >-
  Detalhes sobre o diagnóstico switch_on_type
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/switch_on_type"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Evite instruções switch em um 'Type'._

## Descrição

O analisador produz este diagnóstico quando uma instrução switch ou uma expressão
switch é usada no valor de um `Type` ou em uma chamada `toString`
em um `Type`.

## Exemplo

O código a seguir produz este diagnóstico porque a instrução switch
é usada em um `Type`:

```dart
void f(Object o) {
  switch ([!o.runtimeType!]) {
    case const (int):
      print('int');
    case const (String):
      print('String');
  }
}
```

## Correções comuns

Use correspondência de padrões na variável em vez disso:

```dart
void f(Object o) {
  switch (o) {
    case int():
      print('int');
    case String():
      print('String');
  }
}
```
