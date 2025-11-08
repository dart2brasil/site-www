---
ia-translate: true
title: deprecated_extend
description: >-
  Detalhes sobre o diagnóstico deprecated_extend
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Estender '{0}' está deprecated._

## Description

O analisador produz este diagnóstico quando uma classe anotada com
`@Deprecated.extend` é usada na cláusula `extends` de uma declaração de classe.

Esta anotação indica que a capacidade de estender a classe anotada
está deprecated e será removida em breve. Esta mudança provavelmente será
aplicada marcando a classe com `interface`, `final` ou `sealed`.

## Example

Se a biblioteca `p` define uma classe anotada com `@Deprecated.extend`:

```dart
@Deprecated.extend()
class C {}
```

Então, em qualquer biblioteca diferente de `p`, o código a seguir produz este
diagnóstico:

```dart
import 'package:p/p.dart';

class D extends [!C!] {}
```

## Common fixes

Siga quaisquer direções encontradas na anotação `Deprecation.extend`.
Caso contrário, remova a cláusula `extends`.

```dart
class D {}
```
