---
ia-translate: true
title: const_deferred_class
description: "Detalhes sobre o diagnóstico const_deferred_class produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Classes deferred não podem ser criadas com 'const'._

## Description

O analisador produz este diagnóstico quando uma classe de uma biblioteca que é
importada usando um import deferred é usada para criar um objeto `const`.
Constantes são avaliadas em tempo de compilação, e classes de bibliotecas
deferred não estão disponíveis em tempo de compilação.

Para mais informações, consulte
[Lazily loading a library](https://dart.dev/language/libraries#lazily-loading-a-library).

## Example

O código a seguir produz este diagnóstico porque tenta criar uma
instância `const` de uma classe de uma biblioteca deferred:

```dart
import 'dart:convert' deferred as convert;

const json2 = [!convert.JsonCodec()!];
```

## Common fixes

Se o objeto não precisa ser uma constante, então mude o código para que
uma instância não-constante seja criada:

```dart
import 'dart:convert' deferred as convert;

final json2 = convert.JsonCodec();
```

Se o objeto deve ser uma constante, então remova `deferred` da diretiva
import:

```dart
import 'dart:convert' as convert;

const json2 = convert.JsonCodec();
```
