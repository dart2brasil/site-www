---
ia-translate: true
title: nullable_type_in_catch_clause
description: >-
  Detalhes sobre o diagnóstico nullable_type_in_catch_clause
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Um tipo potencialmente nulo não pode ser usado em uma cláusula 'on' porque não é válido lançar uma expressão nula._

## Descrição

O analisador produz este diagnóstico quando o tipo seguindo `on` em uma
cláusula `catch` é um tipo nulo. Não é válido especificar um tipo nulo
porque não é possível capturar `null` (porque é um erro em tempo de execução
lançar `null`).

## Exemplo

O código a seguir produz este diagnóstico porque o tipo de exceção é
especificado para permitir `null` quando `null` não pode ser lançado:

```dart
void f() {
  try {
    // ...
  } on [!FormatException?!] {
  }
}
```

## Correções comuns

Remova o ponto de interrogação do tipo:

```dart
void f() {
  try {
    // ...
  } on FormatException {
  }
}
```
