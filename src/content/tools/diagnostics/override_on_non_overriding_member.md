---
ia-translate: true
title: override_on_non_overriding_member
description: "Detalhes sobre o diagnóstico override_on_non_overriding_member produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O campo não sobrescreve um getter ou setter herdado._

_O getter não sobrescreve um getter herdado._

_O método não sobrescreve um método herdado._

_O setter não sobrescreve um setter herdado._

## Description

O analisador produz este diagnóstico quando um membro de classe é anotado com
a anotação `@override`, mas o membro não está declarado em nenhum dos
supertipos da classe.

## Example

O código a seguir produz este diagnóstico porque `m` não está declarado em
nenhum dos supertipos de `C`:

```dart
class C {
  @override
  String [!m!]() => '';
}
```

## Common fixes

Se o membro tem a intenção de sobrescrever um membro com um nome diferente, então
atualize o membro para ter o mesmo nome:

```dart
class C {
  @override
  String toString() => '';
}
```

Se o membro tem a intenção de sobrescrever um membro que foi removido da
superclasse, então considere remover o membro da subclasse.

Se o membro não pode ser removido, então remova a anotação.
