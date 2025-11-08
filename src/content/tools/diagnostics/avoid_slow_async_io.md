---
title: avoid_slow_async_io
description: >-
  Details about the avoid_slow_async_io
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
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

_Use of an async 'dart:io' method._

## Descrição

O analisador produz este diagnóstico quando an asynchronous file I/O method
with a synchronous equivalent is used.

The following are the specific flagged asynchronous methods:

- `Directory.exists`
- `Directory.stat`
- `File.lastModified`
- `File.exists`
- `File.stat`
- `FileSystemEntity.isDirectory`
- `FileSystemEntity.isFile`
- `FileSystemEntity.isLink`
- `FileSystemEntity.type`

## Exemplo

O código a seguir produz este diagnóstico porque the async method
`exists` is invoked:

```dart
import 'dart:io';

Future<void> g(File f) async {
  await [!f.exists()!];
}
```

## Correções comuns

Use the synchronous version of the method:

```dart
import 'dart:io';

void g(File f) {
  f.existsSync();
}
```
