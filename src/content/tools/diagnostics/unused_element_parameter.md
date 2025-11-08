---
ia-translate: true
title: unused_element_parameter
description: >-
  Detalhes sobre o diagnóstico unused_element_parameter
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Um valor para o parâmetro opcional '{0}' nunca é fornecido._

## Descrição

O analisador produz este diagnóstico quando um valor nunca é passado para um
parâmetro opcional declarado dentro de uma declaração privada.

## Exemplo

Assumindo que nenhum código na biblioteca passa um valor para `y` em qualquer
invocação de `_m`, o código a seguir produz este diagnóstico:

```dart
class C {
  void _m(int x, [int? [!y!]]) {}

  void n() => _m(0);
}
```

## Correções comuns

Se a declaração não é necessária, então remova-a:

```dart
class C {
  void _m(int x) {}

  void n() => _m(0);
}
```

Se a declaração pretende ser usada, então adicione o código para usá-la.
