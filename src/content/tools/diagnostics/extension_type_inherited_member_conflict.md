---
ia-translate: true
title: extension_type_inherited_member_conflict
description: "Detalhes sobre o diagnóstico extension_type_inherited_member_conflict produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O extension type '{0}' tem mais de um membro distinto chamado '{1}' de tipos implementados._

## Descrição

O analisador produz este diagnóstico quando um extension type implementa
dois ou mais outros tipos, e pelo menos dois desses tipos declaram um membro
com o mesmo nome.

## Exemplo

O código a seguir produz este diagnóstico porque o extension type `C`
implementa tanto `A` quanto `B`, e ambos declaram um membro chamado `m`:

```dart
class A {
  void m() {}
}

extension type B(A a) {
  void m() {}
}

extension type [!C!](A a) implements A, B {}
```

## Correções comuns

Se o extension type não precisa implementar todos os tipos listados,
então remova todos exceto um dos tipos que introduzem os membros conflitantes:

```dart
class A {
  void m() {}
}

extension type B(A a) {
  void m() {}
}

extension type C(A a) implements A {}
```

Se o extension type precisa implementar todos os tipos listados mas você
pode renomear os membros nesses tipos, então dê aos membros conflitantes
nomes únicos:

```dart
class A {
  void m() {}
}

extension type B(A a) {
  void n() {}
}

extension type C(A a) implements A, B {}
```
