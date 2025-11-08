---
ia-translate: true
title: part_of_unnamed_library
description: "Detalhes sobre o diagnóstico part_of_unnamed_library produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A biblioteca não tem nome. Uma URI é esperada, não um nome de biblioteca '{0}', na diretiva part-of._

## Description

O analisador produz este diagnóstico quando uma biblioteca que não possui uma
diretiva `library` (e portanto não tem nome) contém uma diretiva `part`
e a diretiva `part of` no [part file][] usa um nome para especificar
a biblioteca da qual faz parte.

## Example

Dado um [part file][] chamado `part_file.dart` contendo o seguinte
código:

```dart
part of lib;
```

O código a seguir produz este diagnóstico porque a biblioteca incluindo
o [part file][] não tem um nome mesmo que o [part file][] use um
nome para especificar de qual biblioteca faz parte:

```dart
part [!'part_file.dart'!];
```

## Common fixes

Altere a diretiva `part of` no [part file][] para especificar sua biblioteca
por URI:

```dart
part of 'test.dart';
```

[part file]: /resources/glossary#part-file
