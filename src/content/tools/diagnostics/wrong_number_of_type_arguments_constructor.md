---
ia-translate: true
title: wrong_number_of_type_arguments_constructor
description: "Detalhes sobre o diagnóstico wrong_number_of_type_arguments_constructor produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O construtor '{0}.{1}' não tem parâmetros de tipo._

_O construtor '{0}.{1}` não tem parâmetros de tipo._

## Descrição

O analisador produz este diagnóstico quando argumentos de tipo são fornecidos
após o nome de um construtor nomeado. Construtores não podem declarar parâmetros de
tipo, então invocações só podem fornecer os argumentos de tipo associados
com a classe, e esses argumentos de tipo devem seguir o nome da
classe em vez do nome do construtor.

## Exemplo

O código a seguir produz este diagnóstico porque os parâmetros de tipo
(`<String>`) seguem o nome do construtor em vez do nome da
classe:

```dart
class C<T> {
  C.named();
}
C f() => C.named[!<String>!]();
```

## Correções comuns

Se os argumentos de tipo são para os parâmetros de tipo da classe, então mova os
argumentos de tipo para seguir o nome da classe:

```dart
class C<T> {
  C.named();
}
C f() => C<String>.named();
```

Se os argumentos de tipo não são para os parâmetros de tipo da classe, então remova-
os:

```dart
class C<T> {
  C.named();
}
C f() => C.named();
```
