---
ia-translate: true
title: assignment_to_final_no_setter
description: >-
  Detalhes sobre o diagnóstico assignment_to_final_no_setter
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Não há um setter chamado '{0}' na classe '{1}'._

## Description

O analisador produz este diagnóstico quando uma referência a um setter é
encontrada; não há setter definido para o tipo; mas há um getter
definido com o mesmo nome.

## Example

O código a seguir produz este diagnóstico porque não há setter
chamado `x` em `C`, mas há um getter chamado `x`:

```dart
class C {
  int get x => 0;
  set y(int p) {}
}

void f(C c) {
  c.[!x!] = 1;
}
```

## Common fixes

Se você quer invocar um setter existente, então corrija o nome:

```dart
class C {
  int get x => 0;
  set y(int p) {}
}

void f(C c) {
  c.y = 1;
}
```

Se você quer invocar o setter mas ele ainda não existe, então
declare-o:

```dart
class C {
  int get x => 0;
  set x(int p) {}
  set y(int p) {}
}

void f(C c) {
  c.x = 1;
}
```
