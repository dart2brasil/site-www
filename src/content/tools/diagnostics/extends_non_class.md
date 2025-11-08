---
ia-translate: true
title: extends_non_class
description: "Detalhes sobre o diagnóstico extends_non_class produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Classes só podem estender outras classes._

## Description

O analisador produz este diagnóstico quando uma cláusula `extends` contém um
nome que é declarado como algo diferente de uma classe.

## Example

O código a seguir produz este diagnóstico porque `f` é declarado como uma
função:

```dart
void f() {}

class C extends [!f!] {}
```

## Common fixes

Se você quer que a classe estenda uma classe diferente de `Object`, então substitua
o nome na cláusula `extends` pelo nome dessa classe:

```dart
void f() {}

class C extends B {}

class B {}
```

Se você quer que a classe estenda `Object`, então remova a cláusula `extends`:

```dart
void f() {}

class C {}
```
