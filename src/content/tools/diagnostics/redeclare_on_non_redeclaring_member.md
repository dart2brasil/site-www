---
ia-translate: true
title: redeclare_on_non_redeclaring_member
description: >-
  Detalhes sobre o diagnóstico redeclare_on_non_redeclaring_member
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O {0} não redeclara um {0} declarado em uma superinterface._

## Description

O analisador produz este diagnóstico quando um membro de um extension type
é anotado com `@redeclare`, mas nenhuma das interfaces implementadas
possui um membro com o mesmo nome.

## Example

O código a seguir produz este diagnóstico porque o membro `n`
declarado pelo extension type `E` é anotado com `@redeclare`, mas `C`
não possui um membro chamado `n`:

```dart
import 'package:meta/meta.dart';

class C {
  void m() {}
}

extension type E(C c) implements C {
  @redeclare
  void [!n!]() {}
}
```

## Common fixes

Se o membro anotado tem o nome correto, então remova a anotação:

```dart
class C {
  void m() {}
}

extension type E(C c) implements C {
  void n() {}
}
```

Se o membro anotado deve substituir um membro das
interfaces implementadas, então altere o nome do membro anotado para
corresponder ao membro sendo substituído:

```dart
import 'package:meta/meta.dart';

class C {
  void m() {}
}

extension type E(C c) implements C {
  @redeclare
  void m() {}
}
```
