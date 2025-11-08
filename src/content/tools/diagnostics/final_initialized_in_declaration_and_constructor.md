---
ia-translate: true
title: final_initialized_in_declaration_and_constructor
description: "Detalhes sobre o diagnóstico final_initialized_in_declaration_and_constructor produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' é final e recebeu um valor quando foi declarado, então não pode receber um novo valor._

## Descrição

O analisador produz este diagnóstico quando um campo final é inicializado
duas vezes: uma vez onde foi declarado e uma vez por um parâmetro do construtor.

## Exemplo

O código a seguir produz este diagnóstico porque o campo `f` é
inicializado duas vezes:

```dart
class C {
  final int f = 0;

  C(this.[!f!]);
}
```

## Correções comuns

Se o campo deve ter o mesmo valor para todas as instâncias, então remova a
inicialização na lista de parâmetros:

```dart
class C {
  final int f = 0;

  C();
}
```

Se o campo pode ter valores diferentes em diferentes instâncias, então remova
a inicialização na declaração:

```dart
class C {
  final int f;

  C(this.f);
}
```
