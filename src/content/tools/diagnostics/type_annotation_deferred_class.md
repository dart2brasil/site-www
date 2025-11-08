---
ia-translate: true
title: type_annotation_deferred_class
description: >-
  Detalhes sobre o diagnóstico type_annotation_deferred_class
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O tipo deferred '{0}' não pode ser usado em uma declaração, cast ou teste de tipo._

## Description

O analisador produz este diagnóstico quando a anotação de tipo está em uma
declaração de variável, ou o tipo usado em um cast (`as`) ou teste de tipo (`is`)
é um tipo declarado em uma biblioteca que é importada usando um import deferred.
Esses tipos precisam estar disponíveis em tempo de compilação, mas não estão.

Para mais informações, consulte
[Lazily loading a library](https://dart.dev/language/libraries#lazily-loading-a-library).

## Example

O código a seguir produz este diagnóstico porque o tipo do
parâmetro `f` é importado de uma biblioteca deferred:

```dart
import 'dart:io' deferred as io;

void f([!io.File!] f) {}
```

## Common fixes

Se você precisa referenciar o tipo importado, então remova a keyword `deferred`:

```dart
import 'dart:io' as io;

void f(io.File f) {}
```

Se o import precisa ser deferred e há outro tipo que é
apropriado, então use esse tipo no lugar do tipo da biblioteca deferred.
