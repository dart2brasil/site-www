---
ia-translate: true
title: multiple_combinators
description: "Detalhes sobre o diagnóstico multiple_combinators produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Usar múltiplos combinators 'hide' ou 'show' nunca é necessário e frequentemente produz resultados surpreendentes._

## Description

O analisador produz este diagnóstico quando uma diretiva import ou export
contém mais de um combinator.

## Examples

O código a seguir produz este diagnóstico porque o segundo combinator `show`
oculta `List` e `int`:

```dart
import 'dart:core' [!show Future, List, int show Future!];

var x = Future.value(1);
```

O código a seguir produz este diagnóstico porque
o segundo combinator `hide` é redundante:

```dart
import 'dart:math' [!hide Random, max, min hide min!];

var x = pi;
```

Os códigos a seguir produzem este diagnóstico porque
o combinator `hide` é redundante:

```dart
import 'dart:math' [!show Random, max hide min!];

var x = max(0, 1);
var r = Random();
```

O código a seguir produz este diagnóstico porque
o combinator `show` já oculta `Random` e `max`,
então o combinator `hide` é redundante:

```dart
import 'dart:math' [!hide Random, max show min!];

var x = min(0, 1);
```

## Common fixes

Se você prefere listar os nomes que devem ser visíveis,
então use um único combinator `show`:

```dart
import 'dart:math' show min;

var x = min(0, 1);
```

Se você prefere listar os nomes que devem ser ocultados,
então use um único combinator `hide`:

```dart
import 'dart:math' hide Random, max, min;

var x = pi;
```
