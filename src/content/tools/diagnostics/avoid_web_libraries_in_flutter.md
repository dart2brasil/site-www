---
ia-translate: true
title: avoid_web_libraries_in_flutter
description: "Detalhes sobre o diagnóstico avoid_web_libraries_in_flutter produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_web_libraries_in_flutter"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Não use bibliotecas exclusivas para web fora de plugins web do Flutter._

## Description

O analisador produz este diagnóstico quando uma biblioteca em um pacote que
não é um plugin web contém um import de uma biblioteca exclusiva para web:
- `dart:html`
- `dart:js`
- `dart:js_util`
- `dart:js_interop`
- `dart:js_interop_unsafe`
- `package:js`
- `package:web`

## Example

Quando encontrado em um pacote que não é um plugin web, o código a seguir
produz este diagnóstico porque importa `dart:html`:

```dart
import [!'dart:html'!];

import 'package:flutter/material.dart';

class C {}
```

## Common fixes

Se o pacote não é destinado a ser um plugin web, então remova o import:

```dart
import 'package:flutter/material.dart';

class C {}
```

Se o pacote é destinado a ser um plugin web, então adicione as seguintes
linhas ao arquivo `pubspec.yaml` do pacote:

```yaml
flutter:
  plugin:
    platforms:
      web:
        pluginClass: HelloPlugin
        fileName: hello_web.dart
```

Veja [Developing packages & plugins](https://flutter.dev/to/develop-packages)
para mais informações.
