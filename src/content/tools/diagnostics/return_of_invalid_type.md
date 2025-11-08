---
ia-translate: true
title: return_of_invalid_type
description: "Detalhes sobre o diagnóstico return_of_invalid_type produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Um valor do tipo '{0}' não pode ser retornado do construtor '{1}' porque ele tem um tipo de retorno '{2}'._

_Um valor do tipo '{0}' não pode ser retornado da função '{1}' porque ela tem um tipo de retorno '{2}'._

_Um valor do tipo '{0}' não pode ser retornado do método '{1}' porque ele tem um tipo de retorno '{2}'._

## Description

O analisador produz este diagnóstico quando um método ou função retorna um
valor cujo tipo não é atribuível ao tipo de retorno declarado.

## Example

O código a seguir produz este diagnóstico porque `f` tem um tipo de retorno
de `String` mas está retornando um `int`:

```dart
String f() => [!3!];
```

## Common fixes

Se o tipo de retorno está correto, substitua o valor sendo retornado por um
valor do tipo correto, possivelmente convertendo o valor existente:

```dart
String f() => 3.toString();
```

Se o valor está correto, altere o tipo de retorno para corresponder:

```dart
int f() => 3;
```
