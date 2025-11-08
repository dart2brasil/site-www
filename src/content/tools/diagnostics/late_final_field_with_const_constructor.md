---
title: late_final_field_with_const_constructor
description: "Detalhes sobre o diagnóstico late_final_field_with_const_constructor produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Não é possível ter um campo late final em uma classe com um construtor const generativo._

## Descrição

O analisador produz este diagnóstico quando uma classe que tem pelo menos um
construtor `const` também tem um campo marcado como `late` e `final`.

## Exemplo

O código a seguir produz este diagnóstico porque a classe `A` tem um
construtor `const` e o campo `final` `f` está marcado como `late`:

```dart
class A {
  [!late!] final int f;

  const A();
}
```

## Correções comuns

Se o campo não precisa ser marcado como `late`, então remova o modificador `late`
do campo:

```dart
class A {
  final int f = 0;

  const A();
}
```

Se o campo deve ser marcado como `late`, então remova o modificador `const` dos
construtores:

```dart
class A {
  late final int f;

  A();
}
```
