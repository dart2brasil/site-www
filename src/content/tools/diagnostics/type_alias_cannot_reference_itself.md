---
ia-translate: true
title: type_alias_cannot_reference_itself
description: >-
  Detalhes sobre o diagnóstico type_alias_cannot_reference_itself
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Typedefs não podem referenciar a si mesmos diretamente ou recursivamente por meio de outro typedef._

## Descrição

O analisador produz este diagnóstico quando um typedef se refere a si mesmo,
seja direta ou indiretamente.

## Exemplo

O código a seguir produz este diagnóstico porque `F` depende de si mesmo
indiretamente através de `G`:

```dart
typedef [!F!] = void Function(G);
typedef G = void Function(F);
```

## Correções comuns

Altere um ou mais dos typedefs no ciclo para que nenhum deles se refira
a si mesmo:

```dart
typedef F = void Function(G);
typedef G = void Function(int);
```
