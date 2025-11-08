---
ia-translate: true
title: concrete_class_with_abstract_member
description: "Detalhes sobre o diagnóstico concrete_class_with_abstract_member produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' deve ter um corpo de método porque '{1}' não é abstract._

## Description

O analisador produz este diagnóstico quando um membro de uma classe concreta é
encontrado que não possui uma implementação concreta. Classes concretas não são
permitidas conter membros abstract.

## Example

O código a seguir produz este diagnóstico porque `m` é um método abstract
mas `C` não é uma classe abstract:

```dart
class C {
  [!void m();!]
}
```

## Common fixes

Se é válido criar instâncias da classe, forneça uma implementação
para o membro:

```dart
class C {
  void m() {}
}
```

Se não é válido criar instâncias da classe, marque a classe como sendo
abstract:

```dart
abstract class C {
  void m();
}
```
