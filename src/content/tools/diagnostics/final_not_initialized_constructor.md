---
ia-translate: true
title: final_not_initialized_constructor
description: >-
  Detalhes sobre o diagnóstico final_not_initialized_constructor
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Todas as variáveis final devem ser inicializadas, mas '{0}' e '{1}' não estão._

_Todas as variáveis final devem ser inicializadas, mas '{0}' não está._

_Todas as variáveis final devem ser inicializadas, mas '{0}', '{1}' e {2} outras não estão._

## Descrição

O analisador produz este diagnóstico quando uma classe define um ou mais
campos de instância final sem inicializadores e tem pelo menos um construtor
que não inicializa esses campos. Todos os campos de instância final devem ser
inicializados quando a instância é criada, seja pelo inicializador do campo
ou pelo construtor.

## Exemplo

O código a seguir produz este diagnóstico:

```dart
class C {
  final String value;

  [!C!]();
}
```

## Correções comuns

Se o valor deve ser passado diretamente ao construtor, então use um
parâmetro formal inicializador para inicializar o campo `value`:

```dart
class C {
  final String value;

  C(this.value);
}
```

Se o valor deve ser computado indiretamente a partir de um valor fornecido pelo
chamador, então adicione um parâmetro e inclua um inicializador:

```dart
class C {
  final String value;

  C(Object o) : value = o.toString();
}
```

Se o valor do campo não depende de valores que podem ser passados ao
construtor, então adicione um inicializador para o campo como parte da declaração
do campo:

```dart
class C {
  final String value = '';

  C();
}
```

Se o valor do campo não depende de valores que podem ser passados ao
construtor mas construtores diferentes precisam inicializá-lo com
valores diferentes, então adicione um inicializador para o campo na lista de
inicializadores:

```dart
class C {
  final String value;

  C() : value = '';

  C.named() : value = 'c';
}
```

No entanto, se o valor é o mesmo para todas as instâncias, então considere usar um
campo static ao invés de um campo de instância:

```dart
class C {
  static const String value = '';

  C();
}
```
