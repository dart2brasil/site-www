---
ia-translate: true
title: initializer_for_static_field
description: "Detalhes sobre o diagnóstico initializer_for_static_field produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' é um campo static na classe envolvente. Campos inicializados em um construtor não podem ser static._

## Description

O analisador produz este diagnóstico quando um campo static é inicializado
em um construtor usando um parâmetro formal inicializador ou uma
atribuição na lista de inicializadores.

## Example

O código a seguir produz este diagnóstico porque o campo static `a`
está sendo inicializado pelo parâmetro formal inicializador `this.a`:

```dart
class C {
  static int? a;
  C([!this.a!]);
}
```

## Common fixes

Se o campo deve ser um campo de instância, então remova a keyword `static`:

```dart
class C {
  int? a;
  C(this.a);
}
```

Se você pretendia inicializar um campo de instância e digitou o nome errado,
então corrija o nome do campo sendo inicializado:

```dart
class C {
  static int? a;
  int? b;
  C(this.b);
}
```

Se você realmente quer inicializar o campo static, então mova a
inicialização para o corpo do construtor:

```dart
class C {
  static int? a;
  C(int? c) {
    a = c;
  }
}
```
