---
ia-translate: true
title: unknown_platform
description: "Detalhes sobre o diagnóstico unknown_platform produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A plataforma '{0}' não é uma plataforma reconhecida._

## Description

O analisador produz este diagnóstico quando um nome de plataforma desconhecido é
usado como chave no mapa `platforms`.
Para saber mais sobre como especificar as plataformas suportadas do seu pacote,
confira a [documentação sobre declarações de plataforma](https://dart.dev/tools/pub/pubspec#platforms).

## Example

O seguinte `pubspec.yaml` produz este diagnóstico porque a plataforma
`browser` é desconhecida.

```yaml
name: example
platforms:
  [!browser:!]
```

## Common fixes

Se você pode confiar na detecção automática de plataforma, então omita a
chave `platforms` de nível superior.

```yaml
name: example
```

Se você precisa especificar manualmente a lista de plataformas suportadas, então
escreva o campo `platforms` como um mapa com nomes de plataformas conhecidos como chaves.

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
