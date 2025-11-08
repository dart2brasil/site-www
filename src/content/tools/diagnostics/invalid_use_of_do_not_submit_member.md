---
ia-translate: true
title: invalid_use_of_do_not_submit_member
description: >-
  Detalhes sobre o diagnóstico invalid_use_of_do_not_submit_member
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Usos de '{0}' não devem ser submetidos ao controle de versão._

## Description

O analisador produz este diagnóstico quando um membro que está anotado com
[`@doNotSubmit`][meta-doNotSubmit] é referenciado fora de uma declaração de membro
que também está anotada com `@doNotSubmit`.

## Example

Dado um arquivo `a.dart` contendo a seguinte declaração:

```dart
import 'package:meta/meta.dart';

@doNotSubmit
void emulateCrash() { /* ... */ }
```

O código a seguir produz este diagnóstico porque a declaração está
sendo referenciada fora de um membro que também está anotado com
`@doNotSubmit`:

```dart
import 'a.dart';

void f() {
  [!emulateCrash!]();
}
```

## Common fixes

Mais comumente, quando completo os testes locais, a referência ao
membro deve ser removida.

Se estiver construindo funcionalidade adicional sobre o membro, anote o
membro recém-adicionado com `@doNotSubmit` também:

```dart
import 'package:meta/meta.dart';

import 'a.dart';

@doNotSubmit
void emulateCrashWithOtherFunctionality() {
  emulateCrash();
  // do other things.
}
```

[meta-doNotSubmit]: https://pub.dev/documentation/meta/latest/meta/doNotSubmit-constant.html
