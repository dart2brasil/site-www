---
ia-translate: true
title: use_build_context_synchronously
description: "Detalhes sobre o diagnóstico use_build_context_synchronously produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_build_context_synchronously"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Não use 'BuildContext's através de gaps assíncronos, protegido por uma verificação 'mounted' não relacionada._

_Não use 'BuildContext's através de gaps assíncronos._

## Descrição

O analisador produz este diagnóstico quando um `BuildContext` é referenciado
por um `StatefulWidget` após um gap assíncrono sem primeiro verificar a
propriedade `mounted`.

Armazenar um `BuildContext` para uso posterior pode levar a falhas difíceis de diagnosticar.
Gaps assíncronos implicitamente armazenam um `BuildContext`, tornando-os
fáceis de ignorar para diagnóstico.

## Exemplo

O código a seguir produz este diagnóstico porque o `context` é
passado para um construtor após o `await`:

```dart
import 'package:flutter/material.dart';

class MyWidget extends Widget {
  void onButtonTapped(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
    Navigator.of([!context!]).pop();
  }
}
```

## Correções comuns

Se você pode remover o gap assíncrono, faça isso:

```dart
import 'package:flutter/material.dart';

class MyWidget extends Widget {
  void onButtonTapped(BuildContext context) {
    Navigator.of(context).pop();
  }
}
```

Se você não pode remover o gap assíncrono, então use `mounted` para proteger o
uso do `context`:

```dart
import 'package:flutter/material.dart';

class MyWidget extends Widget {
  void onButtonTapped(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
```
