---
title: missing_name
description: >-
  Detalhes sobre o diagnóstico missing_name
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_O campo 'name' é required mas está missing._

## Description

O analisador produz este diagnóstico quando não há uma chave `name` de nível superior.
A chave `name` fornece o nome do pacote, que é required.

## Example

O código a seguir produz este diagnóstico porque o pacote não tem
um nome:

```yaml
dependencies:
  meta: ^1.0.2
```

## Common fixes

Adicione a chave de nível superior `name` com um valor que seja o nome do pacote:

```yaml
name: example
dependencies:
  meta: ^1.0.2
```
