---
ia-translate: true
title: no_logic_in_create_state
description: "Detalhes sobre o diagnóstico no_logic_in_create_state produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/no_logic_in_create_state"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Don't put any logic in 'createState'._

## Description

O analisador produz este diagnóstico quando uma implementação de
`createState` em uma subclasse de `StatefulWidget` contém qualquer lógica além
do retorno do resultado da invocação de um construtor sem argumentos.

## Examples

O código a seguir produz este diagnóstico porque a invocação do construtor
possui argumentos:

```dart
import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  @override
  MyState createState() => [!MyState(0)!];
}

class MyState extends State {
  int x;

  MyState(this.x);
}
```

## Common fixes

Reescreva o código para que `createState` não contenha nenhuma lógica:

```dart
import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  @override
  MyState createState() => MyState();
}

class MyState extends State {
  int x = 0;

  MyState();
}
```
