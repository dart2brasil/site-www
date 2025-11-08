---
title: invalid_widget_preview_private_argument
description: >-
  Details about the invalid_widget_preview_private_argument
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_'@Preview(...)' can only accept arguments that consist of literals and public symbols._

## Descrição

O analisador produz este diagnóstico quando the `Preview` constructor is
invoked with arguments that contain references to private symbols.

## Exemplo

O código a seguir produz este diagnóstico porque the constant variable
`_name` is private to the current library:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter/widget_previews.dart';

const String _name = 'My Foo Preview';

@Preview([!name: _name!])
Widget myPreview() => Text('Foo');
```

## Correções comuns

If appropriate, the private symbol should be made public:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter/widget_previews.dart';

const String name = 'My Foo Preview';

@Preview(name: name)
Widget myPreview() => Text('Foo');
```

Otherwise, a different public constant symbol should be used:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter/widget_previews.dart';

@Preview(name: 'My Foo Preview')
Widget myPreview() => Text('Foo');
```
