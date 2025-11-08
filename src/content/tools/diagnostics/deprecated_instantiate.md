---
ia-translate: true
title: deprecated_instantiate
description: >-
  Detalhes sobre o diagnóstico deprecated_instantiate
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Instanciar '{0}' está deprecated._

## Description

O analisador produz este diagnóstico quando uma classe anotada com
`@Deprecated.instantiate` é instanciada. Esta anotação indica que
instanciar a classe está deprecated e será removido em breve. Esta
mudança provavelmente será aplicada marcando a classe como `abstract` ou
`sealed`.

## Example

Se a biblioteca `p` define uma classe anotada com
`@Deprecated.instantiate`:

```dart
@Deprecated.instantiate()
class C {}
```

Então, em qualquer biblioteca diferente de `p`, o código a seguir produz este
diagnóstico:

```dart
import 'package:p/p.dart';

var c = [!C!]();
```

## Common fixes

Siga quaisquer direções encontradas na anotação `Deprecation.instantiate`.
