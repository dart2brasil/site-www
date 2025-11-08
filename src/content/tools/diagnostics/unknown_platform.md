---
title: unknown_platform
description: >-
  Details about the unknown_platform
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The platform '{0}' is not a recognized platform._

## Descrição

O analisador produz este diagnóstico quando an unknown platform name is
used as a key in the `platforms` map.
To learn more about specifying your package's supported platforms,
check out the [documentation on platform declarations](https://dart.dev/tools/pub/pubspec#platforms).

## Exemplo

The following `pubspec.yaml` produces this diagnostic because the platform
`browser` is unknown.

```yaml
name: example
platforms:
  [!browser:!]
```

## Correções comuns

If you can rely on automatic platform detection, then omit the
top-level `platforms` key.

```yaml
name: example
```

If you need to manually specify the list of supported platforms, then
write the `platforms` field as a map with known platform names as keys.

```yaml
name: example
platforms:
  # These are the known platforms
  android:
  ios:
  linux:
  macos:
  web:
  windows:
```
