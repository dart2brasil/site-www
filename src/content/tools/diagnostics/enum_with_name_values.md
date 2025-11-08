---
ia-translate: true
title: enum_with_name_values
description: "Detalhes sobre o diagnóstico enum_with_name_values produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O nome 'values' não é um nome válido para um enum._

## Descrição

O analisador produz este diagnóstico quando um enum é declarado com o
nome `values`. Isso não é permitido porque o enum tem um campo estático
implícito chamado `values`, e os dois entrariam em conflito.

## Exemplo

O código a seguir produz este diagnóstico porque há uma declaração de enum
que tem o nome `values`:

```dart
enum [!values!] {
  c
}
```

## Correções comuns

Renomeie o enum para algo diferente de `values`.
