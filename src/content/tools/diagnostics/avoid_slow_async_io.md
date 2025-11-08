---
ia-translate: true
title: avoid_slow_async_io
description: "Detalhes sobre o diagnóstico avoid_slow_async_io produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_slow_async_io"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Uso de um método async 'dart:io'._

## Description

O analisador produz este diagnóstico quando um método assíncrono de I/O de arquivo
com um equivalente síncrono é usado.

Os seguintes são os métodos assíncronos específicos sinalizados:

- `Directory.exists`
- `Directory.stat`
- `File.lastModified`
- `File.exists`
- `File.stat`
- `FileSystemEntity.isDirectory`
- `FileSystemEntity.isFile`
- `FileSystemEntity.isLink`
- `FileSystemEntity.type`

## Example

O código a seguir produz este diagnóstico porque o método async
`exists` é invocado:

```dart
import 'dart:io';

Future<void> g(File f) async {
  await [!f.exists()!];
}
```

## Common fixes

Use a versão síncrona do método:

```dart
import 'dart:io';

void g(File f) {
  f.existsSync();
}
```
