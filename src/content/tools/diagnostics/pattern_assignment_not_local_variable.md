---
ia-translate: true
title: pattern_assignment_not_local_variable
description: "Detalhes sobre o diagnóstico pattern_assignment_not_local_variable produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Apenas variáveis locais podem ser atribuídas em atribuições de padrões._

## Description

O analisador produz este diagnóstico quando uma atribuição de padrão atribui um
valor a algo diferente de uma variável local. Padrões não podem atribuir a
campos ou variáveis de nível superior.

## Example

Se o código for mais limpo ao desestruturar com um padrão, então reescreva o
código para atribuir o valor a uma variável local em uma declaração de padrão,
atribuindo a variável não-local separadamente:

```dart
class C {
  var x = 0;

  void f((int, int) r) {
    ([!x!], _) = r;
  }
}
```

## Common fixes

Se o código for mais limpo ao usar uma atribuição de padrão, então reescreva o
código para atribuir o valor a uma variável local, atribuindo a variável
não-local separadamente:

```dart
class C {
  var x = 0;

  void f((int, int) r) {
    var (a, _) = r;
    x = a;
  }
}
```

Se o código for mais limpo sem usar uma atribuição de padrão, então reescreva
o código para não usar uma atribuição de padrão:

```dart
class C {
  var x = 0;

  void f((int, int) r) {
    x = r.$1;
  }
}
```
