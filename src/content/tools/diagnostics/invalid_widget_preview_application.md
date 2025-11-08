---
ia-translate: true
title: invalid_widget_preview_application
description: >-
  Detalhes sobre o diagnóstico invalid_widget_preview_application
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A anotação '@Preview(...)' só pode ser aplicada a construtores e funções públicos e acessíveis estaticamente._

## Description

O analisador produz este diagnóstico quando uma anotação `@Preview(...)` é
aplicada a um alvo de preview de widget inválido. Previews de widget só podem
ser aplicados a construtores e funções públicos, acessíveis estaticamente e
definidos explicitamente.

## Examples

O código a seguir produz este diagnóstico porque `_myPrivatePreview`
é privado:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter/widget_previews.dart';

// Aplicação inválida a uma função de nível superior privada.
@[!Preview!]()
// ignore: unused_element
Widget _myPrivatePreview() => Text('Foo');
```

O código a seguir produz este diagnóstico porque `myExternalPreview`
é `external`:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter/widget_previews.dart';


// Aplicação inválida a uma função external.
@[!Preview!]()
external Widget myExternalPreview();
```

O código a seguir produz este diagnóstico porque `PublicWidget._()` é
privado:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter/widget_previews.dart';

class PublicWidget extends StatelessWidget {
  // Aplicação inválida a um construtor privado.
  @[!Preview!]()
  PublicWidget._();

  @override
  Widget build(BuildContext) => Text('Foo');
}
```

O código a seguir produz este diagnóstico porque `instancePreview` é
um método de instância:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter/widget_previews.dart';

class PublicWidget extends StatelessWidget {
  // Aplicação inválida a um membro de instância.
  @[!Preview!]()
  Widget instancePreview() => PublicWidget();

  @override
  Widget build(BuildContext context) => Text('Foo');
}
```

O código a seguir produz este diagnóstico porque `_PrivateWidget` é
privado:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter/widget_previews.dart';

// ignore: unused_element
class _PrivateWidget extends StatelessWidget {
  // Aplicação inválida a um construtor de uma classe privada.
  @[!Preview!]()
  _PrivateWidget();

  @override
  Widget build(BuildContext context) => Text('Foo');
}
```

O código a seguir produz este diagnóstico porque `_PrivateWidget` é
privado:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter/widget_previews.dart';

// ignore: unused_element
class _PrivateWidget extends StatelessWidget {
  // Aplicação inválida a um método static de uma classe privada.
  @[!Preview!]()
  Widget privateStatic() => _PrivateWidget();

  @override
  Widget build(BuildContext context) => Text('Foo');
}
```

O código a seguir produz este diagnóstico porque `AbstractWidget` é
uma classe `abstract`:

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter/widget_previews.dart';

abstract class AbstractWidget extends StatelessWidget {
  // Aplicação inválida a um construtor de uma classe abstract.
  @[!Preview!]()
  AbstractWidget();

  @override
  Widget build(BuildContext context) => Text('Foo');
}
```

## Common fixes

Crie um construtor, função de nível superior ou membro de classe dedicado, público,
acessível estaticamente e definido explicitamente para uso como um preview:
