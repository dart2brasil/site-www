---
ia-translate: true
title: invalid_widget_preview_private_argument
description: >-
  Detalhes sobre o diagnóstico invalid_widget_preview_private_argument
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'@Preview(...)' só pode aceitar argumentos que consistem de literais e símbolos públicos._

## Description

O analisador produz este diagnóstico quando o construtor `Preview` é
invocado com argumentos que contêm referências a símbolos privados.

## Example

O código a seguir produz este diagnóstico porque a variável constante
`_name` é privada para a biblioteca atual:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter/widget_previews.dart';

const String _name = 'My Foo Preview';

@Preview([!name: _name!])
Widget myPreview() => Text('Foo');
```

## Common fixes

Se apropriado, o símbolo privado deve ser tornado público:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter/widget_previews.dart';

const String name = 'My Foo Preview';

@Preview(name: name)
Widget myPreview() => Text('Foo');
```

Caso contrário, um símbolo constante público diferente deve ser usado:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter/widget_previews.dart';

@Preview(name: 'My Foo Preview')
Widget myPreview() => Text('Foo');
```
