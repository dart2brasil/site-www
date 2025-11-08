---
title: uri_has_not_been_generated
description: >-
  Details about the uri_has_not_been_generated
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Target of URI hasn't been generated: '{0}'._

## Descrição

O analisador produz este diagnóstico quando an import, export, or part
directive is found where the URI refers to a file that doesn't exist and
the name of the file ends with a pattern that's commonly produced by code
generators, such as one of the following:
- `.g.dart`
- `.pb.dart`
- `.pbenum.dart`
- `.pbserver.dart`
- `.pbjson.dart`
- `.template.dart`

## Exemplo

If the file `lib.g.dart` doesn't exist, the following code produces this
diagnostic:

```dart
import [!'lib.g.dart'!];
```

## Correções comuns

If the file is a generated file, then run the generator that generates the
file.

If the file isn't a generated file, then check the spelling of the URI or
create the file.
