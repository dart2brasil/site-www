---
ia-translate: true
title: avoid_unnecessary_containers
description: "Detalhes sobre o diagnóstico avoid_unnecessary_containers produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_unnecessary_containers"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Instância desnecessária de 'Container'._

## Description

O analisador produz este diagnóstico quando uma árvore de widgets contém uma
instância de `Container` e o único argumento para o construtor é
`child:`.

## Example

O código a seguir produz este diagnóstico porque a invocação do
construtor `Container` só tem um argumento `child:`:

```dart
import 'package:flutter/material.dart';

Widget buildRow() {
  return [!Container!](
    child: Row(
      children: [
        Text('a'),
        Text('b'),
      ],
    )
  );
}
```

## Common fixes

Se você pretendia fornecer outros argumentos para o construtor, então adicione-os:

```dart
import 'package:flutter/material.dart';

Widget buildRow() {
  return Container(
    color: Colors.red.shade100,
    child: Row(
      children: [
        Text('a'),
        Text('b'),
      ],
    )
  );
}
```

Se não há outros argumentos necessários, então desembrulhe o widget filho:

```dart
import 'package:flutter/material.dart';

Widget buildRow() {
  return Row(
    children: [
      Text('a'),
      Text('b'),
    ],
  );
}
```
