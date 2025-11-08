---
ia-translate: true
title: name_not_string
description: "Detalhes sobre o diagnóstico name_not_string produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O valor do campo 'name' é obrigatório ser uma string._

## Description

O analisador produz este diagnóstico quando a chave `name` de nível superior tem um
valor que não é uma string.

## Example

O código a seguir produz este diagnóstico porque o valor seguindo a
chave `name` é uma lista:

```yaml
name:
  [!- example!]
```

## Common fixes

Substitua o valor por uma string:

```yaml
name: example
```
