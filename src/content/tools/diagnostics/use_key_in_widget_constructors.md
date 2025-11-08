---
ia-translate: true
title: use_key_in_widget_constructors
description: >-
  Detalhes sobre o diagnóstico use_key_in_widget_constructors
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_key_in_widget_constructors"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Construtores para widgets públicos devem ter um parâmetro nomeado 'key'._

## Descrição

O analisador produz este diagnóstico quando um construtor em uma subclasse de
`Widget` que não é privada à sua biblioteca não tem um parâmetro chamado
`key`.

## Exemplo

O código a seguir produz este diagnóstico porque o construtor para
a classe `MyWidget` não tem um parâmetro chamado `key`:

```dart
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  [!MyWidget!]({required int height});
}
```

O código a seguir produz este diagnóstico porque o construtor padrão
para a classe `MyWidget` não tem um parâmetro chamado `key`:

```dart
import 'package:flutter/material.dart';

class [!MyWidget!] extends StatelessWidget {}
```

## Correções comuns

Adicione um parâmetro chamado `key` ao construtor, declarando explicitamente o
construtor se necessário:

```dart
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  MyWidget({super.key, required int height});
}
```
