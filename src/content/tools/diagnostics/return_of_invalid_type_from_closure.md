---
ia-translate: true
title: return_of_invalid_type_from_closure
description: >-
  Detalhes sobre o diagnóstico return_of_invalid_type_from_closure
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O tipo retornado '{0}' não é retornável de uma função '{1}', conforme requerido pelo contexto do closure._

## Description

O analisador produz este diagnóstico quando o tipo estático de uma expressão
retornada não é atribuível ao tipo de retorno que o closure é obrigado
a ter.

## Example

O código a seguir produz este diagnóstico porque `f` é definido como uma
função que retorna uma `String`, mas o closure atribuído a ele retorna um
`int`:

```dart
String Function(String) f = (s) => [!3!];
```

## Common fixes

Se o tipo de retorno está correto, substitua o valor retornado por um valor
do tipo correto, possivelmente convertendo o valor existente:

```dart
String Function(String) f = (s) => 3.toString();
```
