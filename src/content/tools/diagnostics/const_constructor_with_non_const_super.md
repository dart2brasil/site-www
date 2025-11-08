---
ia-translate: true
title: const_constructor_with_non_const_super
description: "Detalhes sobre o diagnóstico const_constructor_with_non_const_super produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A constant constructor can't call a non-constant super constructor of '{0}'._

## Descrição

O analisador produz este diagnóstico quando um constructor marcado como
`const` invoca um constructor de sua superclasse que não está marcado como
`const`.

## Exemplo

O código a seguir produz este diagnóstico porque o constructor `const`
em `B` invoca o constructor `nonConst` da classe `A`, e o
constructor da superclasse não é um constructor `const`:

```dart
class A {
  const A();
  A.nonConst();
}

class B extends A {
  const B() : [!super.nonConst()!];
}
```

## Correções comuns

Se não é essencial invocar o constructor da superclasse que está
sendo atualmente invocado, então invoque um constructor constante da
superclasse:

```dart
class A {
  const A();
  A.nonConst();
}

class B extends A {
  const B() : super();
}
```

Se é essencial que o constructor atual seja invocado e você pode
modificá-lo, então adicione `const` ao constructor na superclasse:

```dart
class A {
  const A();
  const A.nonConst();
}

class B extends A {
  const B() : super.nonConst();
}
```

Se é essencial que o constructor atual seja invocado e você não pode
modificá-lo, então remova `const` do constructor na subclasse:

```dart
class A {
  const A();
  A.nonConst();
}

class B extends A {
  B() : super.nonConst();
}
```
