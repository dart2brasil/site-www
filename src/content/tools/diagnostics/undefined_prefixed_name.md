---
ia-translate: true
title: undefined_prefixed_name
description: >-
  Detalhes sobre o diagnóstico undefined_prefixed_name
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O nome '{0}' está sendo referenciado através do prefixo '{1}', mas não está definido em nenhuma das bibliotecas importadas usando esse prefixo._

## Descrição

O analisador produz este diagnóstico quando um identificador prefixado é encontrado
onde o prefixo é válido, mas o identificador não está declarado em nenhuma das
bibliotecas importadas usando esse prefixo.

## Exemplo

O código a seguir produz este diagnóstico porque `dart:core` não
define nada chamado `a`:

```dart
import 'dart:core' as p;

void f() {
  p.[!a!];
}
```

## Correções comuns

Se a biblioteca na qual o nome está declarado ainda não foi importada, adicione um
import para a biblioteca.

Se o nome está errado, então mude-o para um dos nomes que estão declarados nas
bibliotecas importadas.
