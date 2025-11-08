---
ia-translate: true
title: field_initialized_in_initializer_and_declaration
description: "Detalhes sobre o diagnóstico field_initialized_in_initializer_and_declaration produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Campos não podem ser inicializados no construtor se forem final e já foram inicializados em sua declaração._

## Descrição

O analisador produz este diagnóstico quando um campo final é inicializado
tanto na declaração do campo quanto em um inicializador em um construtor.
Campos final podem ser atribuídos apenas uma vez, então não pode ser inicializado
em ambos os lugares.

## Exemplo

O código a seguir produz este diagnóstico porque `f` é:

```dart
class C {
  final int f = 0;
  C() : [!f!] = 1;
}
```

## Correções comuns

Se a inicialização não depende de nenhum valor passado para o
construtor, e se todos os construtores precisam inicializar o campo com o
mesmo valor, remova o inicializador do construtor:

```dart
class C {
  final int f = 0;
  C();
}
```

Se a inicialização depende de um valor passado para o construtor, ou se
construtores diferentes precisam inicializar o campo de forma diferente,
remova o inicializador na declaração do campo:

```dart
class C {
  final int f;
  C() : f = 1;
}
```
