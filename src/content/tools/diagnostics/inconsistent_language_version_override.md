---
ia-translate: true
title: inconsistent_language_version_override
description: >-
  Detalhes sobre o diagnóstico inconsistent_language_version_override
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Parts devem ter exatamente a mesma sobrescrita de versão de linguagem que a biblioteca._

## Descrição

O analisador produz este diagnóstico quando um [arquivo part][part file] tem um comentário de
sobrescrita de versão de linguagem que especifica uma versão de linguagem diferente da
que está sendo usada para a biblioteca à qual o part pertence.

## Exemplo

Dado um [arquivo part][part file] chamado `part.dart` que contém o seguinte:

```dart
// @dart = 2.14
part of 'test.dart';
```

O código a seguir produz este diagnóstico porque os parts de uma biblioteca
devem ter a mesma versão de linguagem que a unidade de compilação definidora:

```dart
// @dart = 2.15
part [!'part.dart'!];
```

## Correções comuns

Remova a sobrescrita de versão de linguagem do [arquivo part][part file], para que ele
use implicitamente a mesma versão que a unidade de compilação definidora:

```dart
part of 'test.dart';
```

Se necessário, ajuste a sobrescrita de versão de linguagem na unidade de
compilação definidora para ser apropriada para o código no part, ou migre
o código no [arquivo part][part file] para ser consistente com a nova versão de
linguagem.

[part file]: /resources/glossary#part-file
