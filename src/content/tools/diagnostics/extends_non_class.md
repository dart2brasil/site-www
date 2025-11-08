---
ia-translate: true
title: extends_non_class
description: >-
  Detalhes sobre o diagnóstico extends_non_class
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Classes só podem estender outras classes._

## Descrição

O analisador produz este diagnóstico quando uma cláusula `extends` contém um
nome que foi declarado como algo diferente de uma classe.

## Exemplo

O código a seguir produz este diagnóstico porque `f` foi declarado como uma
função:

```dart
void f() {}

class C extends [!f!] {}
```

## Correções comuns

Se você deseja que a classe estenda uma classe diferente de `Object`, então substitua
o nome na cláusula `extends` pelo nome dessa classe:

```dart
void f() {}

class C extends B {}

class B {}
```

Se você deseja que a classe estenda `Object`, então remova a cláusula `extends`:

```dart
void f() {}

class C {}
```
