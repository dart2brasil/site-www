---
ia-translate: true
title: unused_import
description: "Detalhes sobre o diagnóstico unused_import produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Import não usado: '{0}'._

## Descrição

O analisador produz este diagnóstico quando um import não é necessário porque
nenhum dos nomes que são importados são referenciados dentro da biblioteca
importadora.

## Exemplo

O código a seguir produz este diagnóstico porque nada definido em
`dart:async` é referenciado na biblioteca:

```dart
import [!'dart:async'!];

void main() {}
```

## Correções comuns

Se o import não é necessário, então remova-o.

Se alguns dos nomes importados devem ser usados, então adicione o código
faltante.
