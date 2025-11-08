---
ia-translate: true
title: no_combined_super_signature
description: >-
  Detalhes sobre o diagnóstico no_combined_super_signature
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Can't infer missing types in '{0}' from overridden methods: {1}._

## Description

O analisador produz este diagnóstico quando há uma declaração de método
para a qual um ou mais tipos precisam ser inferidos, e esses tipos não podem ser
inferidos porque nenhum dos métodos sobrescritos possui um tipo de função que é
um supertipo de todos os outros métodos sobrescritos, conforme especificado por
[override inference][].

## Example

O código a seguir produz este diagnóstico porque o método `m` declarado
na classe `C` está sem o tipo de retorno e o tipo do
parâmetro `a`, e nenhum dos tipos faltantes pode ser inferido para ele:

```dart
abstract class A {
  A m(String a);
}

abstract class B {
  B m(int a);
}

abstract class C implements A, B {
  [!m!](a);
}
```

Neste exemplo, override inference não pode ser realizado porque os
métodos sobrescritos são incompatíveis destas maneiras:
- Nenhum tipo de parâmetro (`String` e `int`) é um supertipo do outro.
- Nenhum tipo de retorno é um subtipo do outro.

## Common fixes

Se possível, adicione tipos ao método na subclasse que sejam consistentes
com os tipos de todos os métodos sobrescritos:

```dart
abstract class A {
  A m(String a);
}

abstract class B {
  B m(int a);
}

abstract class C implements A, B {
  C m(Object a);
}
```

[override inference]: /resources/glossary#override-inference
