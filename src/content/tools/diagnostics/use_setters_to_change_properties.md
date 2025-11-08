---
ia-translate: true
title: use_setters_to_change_properties
description: "Detalhes sobre o diagnóstico use_setters_to_change_properties produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_setters_to_change_properties"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_O método é usado para alterar uma propriedade._

## Descrição

O analisador produz este diagnóstico quando um método é usado para definir o
valor de um campo, ou uma função é usada para definir o valor de uma variável
de nível superior, e nada mais.

## Exemplo

O código a seguir produz este diagnóstico porque o método `setF` é
usado para definir o valor do campo `_f` e não faz nenhum outro trabalho:

```dart
class C {
  int _f = 0;

  void [!setF!](int value) => _f = value;
}
```

## Correções comuns

Converta o método em um setter:

```dart
class C {
  int _f = 0;

  set f(int value) => _f = value;
}
```
