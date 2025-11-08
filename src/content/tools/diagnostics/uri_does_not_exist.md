---
ia-translate: true
title: uri_does_not_exist
description: >-
  Detalhes sobre o diagnóstico uri_does_not_exist
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O destino do URI não existe: '{0}'._

## Descrição

O analisador produz este diagnóstico quando uma diretiva import, export ou part
é encontrada onde o URI se refere a um arquivo que não existe.

## Exemplos

Se o arquivo `lib.dart` não existe, o código a seguir produz este
diagnóstico:

```dart
import [!'lib.dart'!];
```

## Correções comuns

Se o URI foi digitado incorretamente ou é inválido, então corrija o URI.

Se o URI está correto, então crie o arquivo.
