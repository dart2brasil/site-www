---
ia-translate: true
title: non_constant_annotation_constructor
description: >-
  Detalhes sobre o diagnóstico non_constant_annotation_constructor
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Annotation creation can only call a const constructor._

## Description

O analisador produz este diagnóstico quando uma annotation é a invocação
de um construtor existente, embora o construtor invocado não seja um
construtor const.

## Example

O código a seguir produz este diagnóstico porque o construtor de `C`
não é um construtor const:

```dart
[!@C()!]
void f() {
}

class C {
  C();
}
```

## Common fixes

Se é válido para a classe ter um construtor const, então crie um
construtor const que possa ser usado para a annotation:

```dart
@C()
void f() {
}

class C {
  const C();
}
```

Se não é válido para a classe ter um construtor const, então
remova a annotation ou use uma classe diferente para a annotation.
