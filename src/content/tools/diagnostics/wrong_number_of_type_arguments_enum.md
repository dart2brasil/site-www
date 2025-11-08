---
ia-translate: true
title: wrong_number_of_type_arguments_enum
description: "Detalhes sobre o diagnóstico wrong_number_of_type_arguments_enum produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O enum é declarado com {0} parâmetros de tipo, mas {1} argumentos de tipo foram fornecidos._

## Descrição

O analisador produz este diagnóstico quando um valor de enum em um enum que
tem parâmetros de tipo é instanciado e argumentos de tipo são fornecidos, mas
o número de argumentos de tipo não é o mesmo que o número de parâmetros de
tipo.

## Exemplo

O código a seguir produz este diagnóstico porque o valor de enum `c`
fornece um argumento de tipo mesmo que o enum `E` seja declarado com
dois parâmetros de tipo:

```dart
enum E<T, U> {
  c[!<int>!]()
}
```

## Correções comuns

Se o número de parâmetros de tipo está correto, então mude o número de
argumentos de tipo para corresponder ao número de parâmetros de tipo:

```dart
enum E<T, U> {
  c<int, String>()
}
```

Se o número de argumentos de tipo está correto, então mude o número de parâmetros de
tipo para corresponder ao número de argumentos de tipo:

```dart
enum E<T> {
  c<int>()
}
```
