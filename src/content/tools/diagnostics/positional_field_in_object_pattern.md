---
ia-translate: true
title: positional_field_in_object_pattern
description: "Detalhes sobre o diagnóstico positional_field_in_object_pattern produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Object patterns só podem usar campos nomeados._

## Description

O analisador produz este diagnóstico quando um object pattern contém um
campo sem especificar o nome do getter. Campos de object pattern correspondem
a valores que os getters do objeto retornam. Sem um nome de getter
especificado, o campo do pattern não pode acessar um valor para tentar corresponder.

## Example

O código a seguir produz este diagnóstico porque o object pattern
`String(1)` não especifica qual getter de `String` acessar e comparar
com o valor `1`:

```dart
void f(Object o) {
  if (o case String([!1!])) {}
}
```

## Common fixes

Adicione o nome do getter para acessar o valor, seguido
de dois-pontos antes do pattern a corresponder:

```dart
void f(Object o) {
  if (o case String(length: 1)) {}
}
```
