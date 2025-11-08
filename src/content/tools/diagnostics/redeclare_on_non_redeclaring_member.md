---
title: redeclare_on_non_redeclaring_member
description: >-
  Details about the redeclare_on_non_redeclaring_member
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The {0} doesn't redeclare a {0} declared in a superinterface._

## Descrição

O analisador produz este diagnóstico quando a member of an extension type
is annotated with `@redeclare`, but none of the implemented interfaces
has a member with the same name.

## Exemplo

O código a seguir produz este diagnóstico porque the member `n`
declared by the extension type `E` is annotated with `@redeclare`, but `C`
doesn't have a member named `n`:

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

## Correções comuns

If the annotated member has the right name, then remove the annotation:

```dart
class C {
  void m() {}
}

extension type E(C c) implements C {
  void n() {}
}
```

If the annotated member is suppose to replace a member from the
implemented interfaces, then change the name of the annotated member to
match the member being replaced:

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
