---
ia-translate: true
title: deprecated_mixin
description: "Detalhes sobre o diagnóstico deprecated_mixin produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Misturar '{0}' está deprecated._

## Description

O analisador produz este diagnóstico quando uma classe mixin anotada com
`@Deprecated.mixin` é usada na cláusula `with` de uma declaração de classe ou enum.
Esta anotação indica que usar o mixin anotado está deprecated
e será removido em breve. Esta mudança provavelmente será aplicada
removendo o modificador de classe `mixin`.

## Example

Se a biblioteca `p` define uma classe anotada com `@Deprecated.mixin`:

```dart
@Deprecated.mixin()
mixin class C {}
```

Então, em qualquer biblioteca diferente de `p`, o código a seguir produz este
diagnóstico:

```dart
import 'package:p/p.dart';

class D with [!C!] {}
```

## Common fixes

Siga quaisquer direções encontradas na anotação `Deprecation.mixin`.
Caso contrário, remova o nome da classe mixin da cláusula `with`.

```dart
class D {}
```
