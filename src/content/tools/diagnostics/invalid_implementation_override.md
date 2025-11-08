---
ia-translate: true
title: invalid_implementation_override
description: >-
  Detalhes sobre o diagnóstico invalid_implementation_override
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}.{1}' ('{2}') não é uma implementação concreta válida de '{3}.{1}' ('{4}')._

_O setter '{0}.{1}' ('{2}') não é uma implementação concreta válida de '{3}.{1}' ('{4}')._

## Description

O analisador produz este diagnóstico quando todas as seguintes condições são
verdadeiras:

- Uma classe define um membro abstrato.
- Há uma implementação concreta desse membro em uma superclasse.
- A implementação concreta não é uma implementação válida do método
  abstrato.

A implementação concreta pode ser inválida devido a incompatibilidades no
tipo de retorno, nos tipos dos parâmetros do método ou nos parâmetros de
tipo.

## Example

O código a seguir produz este diagnóstico porque o método `A.add` tem um
parâmetro do tipo `int`, e o método sobrescrito `B.add` tem um parâmetro
correspondente do tipo `num`:

```dart
class A {
  int add(int a) => a;
}
class [!B!] extends A {
  int add(num a);
}
```

Isso é um problema porque em uma invocação de `B.add` como a seguinte:

```dart
void f(B b) {
  b.add(3.4);
}
```

`B.add` está esperando poder receber, por exemplo, um `double`, mas quando o
método `A.add` é executado (porque é a única implementação concreta de
`add`), uma exceção em tempo de execução será lançada porque um `double` não
pode ser atribuído a um parâmetro do tipo `int`.

## Common fixes

Se o método na subclasse pode se conformar à implementação na superclasse,
altere a declaração na subclasse (ou remova-a se for igual):

```dart
class A {
  int add(int a) => a;
}
class B	extends A {
  int add(int a);
}
```

Se o método na superclasse pode ser generalizado para ser uma implementação
válida do método na subclasse, altere o método da superclasse:

```dart
class A {
  int add(num a) => a.floor();
}
class B	extends A {
  int add(num a);
}
```

Se nem o método na superclasse nem o método na subclasse podem ser alterados,
forneça uma implementação concreta do método na subclasse:

```dart
class A {
  int add(int a) => a;
}
class B	extends A {
  int add(num a) => a.floor();
}
```
