---
ia-translate: true
title: wrong_number_of_type_arguments
description: >-
  Detalhes sobre o diagnóstico wrong_number_of_type_arguments
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O tipo '{0}' é declarado com {1} parâmetros de tipo, mas {2} argumentos de tipo foram fornecidos._

## Descrição

O analisador produz este diagnóstico quando um tipo que tem parâmetros de tipo
é usado e argumentos de tipo são fornecidos, mas o número de argumentos de tipo
não é o mesmo que o número de parâmetros de tipo.

O analisador também produz este diagnóstico quando um construtor é invocado
e o número de argumentos de tipo não corresponde ao número de parâmetros de tipo
declarados para a classe.

## Exemplos

O código a seguir produz este diagnóstico porque `C` tem um parâmetro de tipo
mas dois argumentos de tipo são fornecidos quando é usado como uma anotação de
tipo:

```dart
class C<E> {}

void f([!C<int, int>!] x) {}
```

O código a seguir produz este diagnóstico porque `C` declara um parâmetro de
tipo, mas dois argumentos de tipo são fornecidos ao criar uma instância:

```dart
class C<E> {}

var c = [!C<int, int>!]();
```

## Correções comuns

Adicione ou remova argumentos de tipo, conforme necessário, para corresponder ao número de parâmetros de tipo
definidos para o tipo:

```dart
class C<E> {}

void f(C<int> x) {}
```
