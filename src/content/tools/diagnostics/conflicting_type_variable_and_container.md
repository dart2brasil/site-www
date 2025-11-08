---
ia-translate: true
title: conflicting_type_variable_and_container
description: "Detalhes sobre o diagnóstico conflicting_type_variable_and_container produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' não pode ser usado para nomear tanto um parâmetro de tipo quanto a classe na qual o parâmetro de tipo é definido._

_'{0}' não pode ser usado para nomear tanto um parâmetro de tipo quanto o enum no qual o parâmetro de tipo é definido._

_'{0}' não pode ser usado para nomear tanto um parâmetro de tipo quanto a extension na qual o parâmetro de tipo é definido._

_'{0}' não pode ser usado para nomear tanto um parâmetro de tipo quanto o extension type no qual o parâmetro de tipo é definido._

_'{0}' não pode ser usado para nomear tanto um parâmetro de tipo quanto o mixin no qual o parâmetro de tipo é definido._

## Descrição

O analisador produz este diagnóstico quando uma declaração de classe, mixin ou extension
declara um parâmetro de tipo com o mesmo nome da classe,
mixin ou extension que o declara.

## Exemplo

O código a seguir produz este diagnóstico porque o parâmetro de tipo `C`
tem o mesmo nome da classe `C` da qual faz parte:

```dart
class C<[!C!]> {}
```

## Correções comuns

Renomeie o parâmetro de tipo ou a classe, mixin ou extension:

```dart
class C<T> {}
```
