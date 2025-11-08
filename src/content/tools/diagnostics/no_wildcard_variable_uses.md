---
ia-translate: true
title: no_wildcard_variable_uses
description: >-
  Detalhes sobre o diagnóstico no_wildcard_variable_uses
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/no_wildcard_variable_uses"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The referenced identifier is a wildcard._

## Description

O analisador produz este diagnóstico quando um parâmetro ou variável local
cujo nome consiste apenas de underscores é referenciado. Tais
nomes se tornarão não vinculantes em uma versão futura da linguagem Dart,
tornando a referência ilegal.

## Example

O código a seguir produz este diagnóstico porque o nome do
parâmetro consiste em dois underscores:

```dart
// @dart = 3.6
void f(int __) {
  print([!__!]);
}
```

O código a seguir produz este diagnóstico porque o nome da
variável local consiste em um único underscore:

```dart
// @dart = 3.6
void f() {
  int _ = 0;
  print([!_!]);
}
```

## Common fixes

Se a variável ou parâmetro é destinado a ser referenciado, então dê a ele um
nome que tenha pelo menos um caractere que não seja underscore:

```dart
void f(int p) {
  print(p);
}
```

Se a variável ou parâmetro não é destinado a ser referenciado, então
substitua a referência por uma expressão diferente:

```dart
void f() {
  print(0);
}
```
