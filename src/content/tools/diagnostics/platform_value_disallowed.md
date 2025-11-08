---
title: platform_value_disallowed
description: >-
  Details about the platform_value_disallowed
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Keys in the `platforms` field can't have values._

## Descrição

O analisador produz este diagnóstico quando a key in the `platforms` map
has a value.
To learn more about specifying your package's supported platforms,
check out the [documentation on platform declarations](https://dart.dev/tools/pub/pubspec#platforms).

## Exemplo

The following `pubspec.yaml` produces this diagnostic because the key
`web` has a value.

```yaml
name: example
platforms:
  web: [!"chrome"!]
```

## Correções comuns

Omit the value and leave the key without a value:

```yaml
name: example
platforms:
  web:
```

Values for keys in the `platforms` field are currently reserved for
potential future behavior.
