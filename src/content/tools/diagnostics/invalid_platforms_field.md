---
ia-translate: true
title: invalid_platforms_field
description: >-
  Detalhes sobre o diagnóstico invalid_platforms_field
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O campo 'platforms' deve ser um map com plataformas como chaves._

## Description

O analisador produz este diagnóstico quando um campo `platforms`
de nível superior é especificado, mas seu valor não é um map com chaves.
Para saber mais sobre como especificar as plataformas suportadas pelo seu pacote,
consulte a [documentação sobre declarações de plataforma](https://dart.dev/tools/pub/pubspec#platforms).

## Example

O seguinte `pubspec.yaml` produz este diagnóstico porque `platforms`
deve ser um map.

```yaml
name: example
platforms:
  [!- android!]
  [!- web!]
  [!- ios!]
```

## Common fixes

Se você pode confiar na detecção automática de plataforma, então omita o
campo `platforms` de nível superior.

```yaml
name: example
```

Se você precisa especificar manualmente a lista de plataformas suportadas, então
escreva o campo `platforms` como um map com nomes de plataforma como chaves.

```yaml
name: example
platforms:
  android:
  web:
  ios:
```
