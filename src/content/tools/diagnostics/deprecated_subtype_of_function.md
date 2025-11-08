---
ia-translate: true
title: deprecated_subtype_of_function
description: "Detalhes sobre o diagnóstico deprecated_subtype_of_function produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Estender 'Function' está deprecated._

_Implementar 'Function' não tem efeito._

_Misturar 'Function' está deprecated._

## Description

O analisador produz este diagnóstico quando a classe `Function` é usada em
uma das cláusulas `extends`, `implements` ou `with` de uma classe ou mixin.
Usar a classe `Function` desta forma não tem valor semântico, então é
efetivamente dead code.

## Example

O código a seguir produz este diagnóstico porque `Function` é usada como
a superclasse de `F`:

```dart
class F extends [!Function!] {}
```

## Common fixes

Remova a classe `Function` de qualquer cláusula em que esteja, e remova a
cláusula inteira se `Function` for o único tipo na cláusula:

```dart
class F {}
```
