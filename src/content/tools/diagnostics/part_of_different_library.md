---
ia-translate: true
title: part_of_different_library
description: >-
  Detalhes sobre o diagnóstico part_of_different_library
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Esperava-se que esta biblioteca fosse parte de '{0}', não '{1}'._

## Description

O analisador produz este diagnóstico quando uma biblioteca tenta incluir um
arquivo como parte de si mesma quando o outro arquivo é parte de uma
biblioteca diferente.

## Example

Dado um arquivo `part.dart` contendo

```dart
part of 'library.dart';
```

O código a seguir, em qualquer arquivo diferente de `library.dart`, produz este
diagnóstico porque tenta incluir `part.dart` como parte de si mesmo
quando `part.dart` é parte de uma biblioteca diferente:

```dart
part [!'package:a/part.dart'!];
```

## Common fixes

Se a biblioteca deveria estar usando um arquivo diferente como parte, então altere a
URI na diretiva part para ser a URI do outro arquivo.

Se o [part file][] deveria ser parte desta biblioteca, então atualize a URI
(ou nome da biblioteca) na diretiva part-of para ser a URI (ou nome) da
biblioteca correta.

[part file]: /resources/glossary#part-file
