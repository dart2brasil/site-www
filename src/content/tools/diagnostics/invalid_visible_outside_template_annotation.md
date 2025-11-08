---
ia-translate: true
title: invalid_visible_outside_template_annotation
description: "Detalhes sobre o diagnóstico invalid_visible_outside_template_annotation produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A anotação 'visibleOutsideTemplate' só pode ser aplicada a um membro de uma classe, enum ou mixin que está anotado com 'visibleForTemplate'._

## Description

O analisador produz este diagnóstico quando a anotação `@visibleOutsideTemplate`
é usada incorretamente. Esta anotação serve apenas para anotar
membros de uma classe, enum ou mixin que possui a anotação `@visibleForTemplate`,
para excluir esses membros das restrições de visibilidade que
`@visibleForTemplate` impõe.

## Examples

O código a seguir produz este diagnóstico porque não há
anotação `@visibleForTemplate` no nível da classe:

```dart
import 'package:angular_meta/angular_meta.dart';

class C {
  @[!visibleOutsideTemplate!]
  int m() {
    return 1;
  }
}
```

O código a seguir produz este diagnóstico porque a anotação está em
uma declaração de classe, não em um membro de uma classe, enum ou mixin:

```dart
import 'package:angular_meta/angular_meta.dart';

@[!visibleOutsideTemplate!]
class C {}
```

## Common fixes

Se a classe é visível apenas para que templates possam referenciá-la, então adicione
a anotação `@visibleForTemplate` à classe:

```dart
import 'package:angular_meta/angular_meta.dart';

@visibleForTemplate
class C {
  @visibleOutsideTemplate
  int m() {
    return 1;
  }
}
```

Se a anotação `@visibleOutsideTemplate` está em algo diferente de um
membro de uma classe, enum ou mixin com a anotação `@visibleForTemplate`,
remova a anotação:

```dart
class C {}
```
