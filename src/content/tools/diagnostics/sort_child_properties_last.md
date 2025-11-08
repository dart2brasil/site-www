---
ia-translate: true
title: sort_child_properties_last
description: "Detalhes sobre o diagnóstico sort_child_properties_last produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/sort_child_properties_last"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_O argumento '{0}' deve ser o último nas invocações de construtores de widgets._

## Descrição

O analisador produz este diagnóstico quando o argumento `child` ou `children`
não é o último argumento em uma invocação de um construtor de classe de widget.
Uma exceção é feita se todos os argumentos após o
argumento `child` ou `children` forem expressões de função.

## Exemplo

O código a seguir produz este diagnóstico porque o argumento `child`
não é o último argumento na invocação do construtor `Center`:

```dart
import 'package:flutter/material.dart';

Widget createWidget() {
  return Center(
    [!child: Text('...')!],
    widthFactor: 0.5,
  );
}
```

## Correções comuns

Mova o argumento `child` ou `children` para ser o último:

```dart
import 'package:flutter/material.dart';

Widget createWidget() {
  return Center(
    widthFactor: 0.5,
    child: Text('...'),
  );
}
```
