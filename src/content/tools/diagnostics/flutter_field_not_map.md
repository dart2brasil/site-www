---
ia-translate: true
title: flutter_field_not_map
description: "Detalhes sobre o diagnóstico flutter_field_not_map produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O valor do campo 'flutter' é esperado ser um map._

## Description

O analisador produz este diagnóstico quando o valor da chave `flutter`
não é um map.

## Example

O código a seguir produz este diagnóstico porque o valor da
chave `flutter` de nível superior é uma string:

```yaml
name: example
flutter: [!true!]
```

## Common fixes

Se você precisa especificar opções específicas do Flutter, então altere o valor para
ser um map:

```yaml
name: example
flutter:
  uses-material-design: true
```

Se você não precisa especificar opções específicas do Flutter, então remova a
chave `flutter`:

```yaml
name: example
```
