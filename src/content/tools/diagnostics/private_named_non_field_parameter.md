---
ia-translate: true
title: private_named_non_field_parameter
description: >-
  Detalhes sobre o diagnóstico private_named_non_field_parameter
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Parâmetros nomeados que não se referem a variáveis de instância não podem começar com underscore._

## Description

O analisador produz este diagnóstico quando um parâmetro nomeado começa com
um underscore, a menos que seja um parâmetro formal inicializador ou parâmetro de campo.

## Example

O código a seguir produz este diagnóstico porque o parâmetro nomeado
`_x` começa com um underscore:

```dart
class C {
  C({int [!_x!] = 0});
}
```

## Common fixes

Se o parâmetro é destinado a se referir a um campo, adicione o campo
faltante:

```dart
class C {
  final int _x;
  C({this._x = 0});
  int get x => _x;
}
```

Se o parâmetro não é destinado a se referir a um campo, remova o
underscore:

```dart
class C {
  C({int x = 0});
}
```
