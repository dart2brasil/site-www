---
ia-translate: true
title: avoid_types_as_parameter_names
description: "Detalhes sobre o diagnóstico avoid_types_as_parameter_names produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_types_as_parameter_names"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_O nome do parâmetro '{0}' corresponde a um nome de tipo visível._

_O nome do parâmetro de tipo '{0}' corresponde a um nome de tipo visível._

## Description

O analisador produz este diagnóstico quando o nome de um parâmetro em uma
lista de parâmetros é o mesmo de um tipo visível (um tipo cujo nome está no
escopo).

Isso frequentemente indica que o nome pretendido do parâmetro está faltando,
fazendo com que o nome do tipo seja usado como o nome do parâmetro
em vez do tipo do parâmetro. Mesmo quando não é o caso (o
nome do parâmetro é intencional), o nome do parâmetro
ofuscará o tipo existente, o que pode levar a bugs que são difíceis de
diagnosticar.

O analisador também produz este diagnóstico quando o nome de um parâmetro
de tipo em uma lista de parâmetros de tipo é o mesmo de um tipo cujo nome está
no escopo. É novamente recomendado que o parâmetro de tipo seja renomeado
de modo que o ofuscamento propenso a erros seja evitado.

## Example

O código a seguir produz este diagnóstico porque a função `f` tem um
parâmetro chamado `int`, que oculta o tipo `int` de `dart:core`:

```dart
void f([!int!]) {}
```

## Common fixes

Se o nome do parâmetro está faltando, então adicione um nome para o parâmetro:

```dart
void f(int x) {}
```

Se o parâmetro deve ter um tipo implícito de `dynamic`, então
renomeie o parâmetro para que ele não oculte o nome de nenhum tipo visível:

```dart
void f(int_) {}
```
