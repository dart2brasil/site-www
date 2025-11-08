---
ia-translate: true
title: deprecated_implement
description: >-
  Detalhes sobre o diagnóstico deprecated_implement
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Implementar '{0}' está deprecated._

## Description

O analisador produz este diagnóstico quando uma classe anotada com
`@Deprecated.implement` é usada na cláusula `implements` de uma declaração de classe ou
enum. Esta anotação indica que a capacidade de implementar a classe anotada
está deprecated e será removida em breve. Esta mudança provavelmente será
aplicada marcando a classe com `interface`, `final` ou `sealed`.

## Example

Se a biblioteca `p` define uma classe anotada com `@Deprecated.implement`:

```dart
@Deprecated.implement()
class C {}
```

Então, em qualquer biblioteca diferente de `p`, o código a seguir produz este
diagnóstico:

```dart
import 'package:p/p.dart';

class D implements [!C!] {}
```

## Common fixes

Siga quaisquer direções encontradas na anotação `Deprecation.implement`.
Caso contrário, remova a cláusula `implements`.

```dart
class D {}
```
